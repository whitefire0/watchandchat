require_relative 'before_action'

class Game
  # include Before
  attr_accessor :on, :player_created, :character_chosen, :player_name, :player_char, :menu_instance, :tile_number, :tile_type, :current_tile, :chosen_action, :npcs, :spent_tiles, :delays_off, :last_damage_dealt, :last_attacking_char, :last_defending_char, :previous_enemy, :healed, :game_speed, :victory

  def initialize
    @menu_instance = nil
    @on = true
    @victory = false
    @delays_off = false
    @player_created = false
    @player_name = nil
    @player_char = nil
    @character_chosen = false
    @tile_number = 0
    @game_speed = 1
    @spent_tiles = 0
    @tile_type = nil
    @current_tile = nil
    @chosen_action = nil
    generate_npcs
    # before(:get_new_tile) { has_won? }
  end

  def create_player(name)
    @player_name = name
    @player_created = true
  end
  
  def set_player_class(classname)
    classname = Object.const_get(classname)
    @player_char = classname.create(@player_name)
    @character_chosen = true
  end

  def get_new_tile
    @current_tile = Tile.create
    @tile_number += game_speed
  end

  def generate_npcs
    @npcs = {
      @npc_viking => Viking.create('Gimli'),
      @npc_wizard => Wizard.create('Gandalf'),
      @npc_rogue => Rogue.create('Blake'),
      @npc_cleric => Cleric.create('Archbishop of Canterbury'),
      @npc_gimp => Gimp.create('Theresa May'),
      @npc_sewer_rat => SewerRat.create('Shredder'),
      @npc_goblin => Goblin.create('Smegel'),
      @npc_wreath => Wreath.create('Casper'),
      @npc_balrog => Balrog.create('Berty')
    }
  end

  def enemy_is_present
    unless current_tile == nil
      current_tile.enemy_present
    end
  end

  def reset_player_action
    @chosen_action = nil
  end

  def walk
    if enemy_is_present
      menu_instance.render_message(msg: 'enemy blocking')
      reset_player_action
    else
      move_forward_and_act
      reset_player_action
    end
  end

  def move_forward_and_act
    reset_available_rests
    get_new_tile
    menu_instance.present_tile
    menu_instance.get_player_action
  end

  def attack
    if current_tile
      if enemy_is_present
        run_battle_sequence
      else
        menu_instance.render_message(msg: 'attacking nothing')
      end
    else
      menu_instance.render_message(msg: 'attacking nothing')
    end
    reset_player_action
  end

  def run_battle_sequence
    battle_mode
    @spent_tiles += 1
    menu_instance.exit_game? if player_char.is_dead   
  end

  def rest
    if current_tile
      @healed = player_char.rest
      if @healed
        menu_instance.render_message(msg: 'heal')
      else
        menu_instance.render_message(msg: 'no more rests')
      end
    else
      menu_instance.render_message(msg: 'outside dungeon')
    end
    reset_player_action
  end

  def reset_available_rests
    player_char.rests_remaining = player_char.rests_per_turn
  end

  def inspect
    if current_tile
      menu_instance.render_message(msg: 'checking area')
      if current_tile.item
        player_char.inventory << current_tile.item
        menu_instance.render_message(msg: 'describe item')
      else
        menu_instance.render_message(msg: 'area empty')
      end
    else
      menu_instance.render_message(msg: 'outside dungeon')
    end
    reset_player_action
  end

  def use_item
    if player_char.inventory.length > 0
      chosen_item = menu_instance.select_inventory
      unless chosen_item == 'x'
        item_instance = player_char.inventory.first { |item| item.menu_command == chosen_item}
        item_index = player_char.inventory.find_index { |item| item_instance }
        if item_instance
          if item_instance.game_effect
            item_instance.effect_game(self)
          else
            item_instance.apply_to(player_char)
          end
          menu_instance.render_message(msg: 'item used', item: item_instance)
          player_char.inventory.delete_at(item_index)
        end
      end
    else
      menu_instance.render_message(msg: 'inventory empty')
    end
    reset_player_action 
  end

  def dance
    if current_tile
      # code
    else
     
    end
    reset_player_action 
  end

  def battle_mode
    @both_alive = true
    while @both_alive do
      player_turn
      enemy_turn
    end
    who_won
  end

  def player_turn
    unless player_char.is_dead
      @last_attacking_char = player_char
      @last_damage_dealt = player_attacks
      @last_defending_char = @current_tile.enemy
      menu_instance.render_message(msg: 'hit')
    else
      @both_alive = false
    end
  end

  def enemy_turn
    unless @current_tile.enemy.is_dead
      @last_attacking_char = @current_tile.enemy
      @last_damage_dealt = enemy_attacks
      @last_defending_char = player_char
      menu_instance.render_message(msg: 'hit')
    else
      @both_alive = false
    end
  end

  def who_won
    if player_char.health <= 0
      player_char.character_dead!
    end
    if @current_tile.enemy.health <= 0
      @previous_enemy = @current_tile.enemy
      @current_tile.enemy = nil
      @current_tile.enemy_present = false
    end
    menu_instance.render_message(msg: 'died')
  end

  def player_attacks
    sleep(0.35) unless menu_instance.dev_mode
    damage = player_char.hit(current_tile.enemy)
    damage
  end

  def enemy_attacks
    sleep(0.35) unless menu_instance.dev_mode
    damage = current_tile.enemy.hit(player_char)
    damage
  end

  def has_won?
    if current_tile >= 100
      @victory = true
      end_game
    end
  end

  def end_game
    menu_instance.render_message('victory')
    menu_instance.exit_game?
  end

end