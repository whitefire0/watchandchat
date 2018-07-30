require_relative 'game_state_abbreviations'
require_relative 'messages'
require_relative 'socketing'

# UserInterface will eventually shield the entire inner application, exposing only accepted commands
class UserInterface
  include GameStateAbbreviations
  include Messages
  attr_accessor :delays_off, :game_instance, :socket

  def initialize(game, name)
    @game_instance = game
    @play_again = nil
    @name = name
    @conn = Socketing::get
  end
  
  def manager
    while @game_instance.on do
      game_setup
      get_player_action
      run_player_action

      if @game_instance.player_char.is_dead
        exit_game?
      end

      # return true/false to outer game creation loop in main.rb
      if @play_again
        return true
      else
        return false unless @game_instance.on
      end
    end
  end

  def game_setup
    get_player_name unless @game_instance.player_created
    create_character unless @game_instance.character_chosen
    @game_instance.on = true if @game_instance.player_created && @game_instance.character_chosen
  end

  def get_player_name
      # render_message(msg: 'get name')
      # player_name = @conn.gets.chomp
      # *** FOR TESTING ***
      # player_name = @name
      @game_instance.create_player(@name)
  end

  def create_character
    while player_class == NilClass do
      render_message(msg: 'choose class')
      chosen_class = @conn.gets.chomp
      # *** FOR TESTING ***
      # chosen_class = 'v'
      case chosen_class
      when /^v|V/
        @game_instance.set_player_class('Viking')
      when /^b|B/
        @game_instance.set_player_class('Barbarian')
      when /^w|W/
        @game_instance.set_player_class('Wizard')
      when /^r|R/
        @game_instance.set_player_class('Rogue')
      when /^c|C/
        @game_instance.set_player_class('Cleric')
      when /^g|G/
        @game_instance.set_player_class('Gimp')
      else
        @conn.puts "Invalid choice, please choose again.".colorize(:light_black)
      end
    end
    welcome_player
    render_message(msg: 'walk into dungeon')
  end

  def welcome_player
    render_message(msg: 'welcome player')
    render_message(msg: 'character stats')
    sleep(1.5) unless dev_mode
  end

  def get_player_action
    # *** FOR TESTING ***
    # @chosen_action = 'attack'
    sleep(1.25) unless dev_mode
    while @game_instance.chosen_action == nil
      render_message(msg: 'choose action')
      response = @conn.gets.chomp
      response = response.length == 1 ? response : 'z - invalid action'
      puts "\n"
      case response
      when /^w/
        @game_instance.chosen_action = 'walk'
      when /^a/
        @game_instance.chosen_action = 'attack'
      when /^r/
        @game_instance.chosen_action = 'rest'
      when /^i/
        @game_instance.chosen_action = 'inspect'
      when /^u/
        @game_instance.chosen_action = 'use item'
      when /^c/
        @game_instance.chosen_action = 'check stats'
      # when /^d/
      #   @game_instance.chosen_action = 'dance'
      # when /^e/
      #   @game_instance.chosen_action = 'retreat'
      # when /^s/
      #   @game_instance.chosen_action = 'save and exit'
      when /^x/
        @game_instance.chosen_action = 'exit'
      else
        render_message(msg: 'invalid action')
      end
    end
  end

  def run_player_action
    case @game_instance.chosen_action
      when "walk"
        @game_instance.walk
      when "attack"
        @game_instance.attack
      when "rest"
        @game_instance.rest
      when "inspect"
        @game_instance.inspect        
      when "use item"
        @game_instance.use_item
      when "check stats"
        render_message(msg: 'character stats')
        @game_instance.reset_player_action
      when "dance"
      when "retreat"
      when "save and exit"
      when "exit"
        @play_again = false
        @game_instance.on = false             
      else
    end
  end

  def present_tile
    # binding.pry
    sleep(1) unless dev_mode
    render_message(msg: 'step forward')
    sleep(1) unless dev_mode
    render_message(msg: 'tile description')
    sleep(1.5) unless dev_mode
    if @game_instance.current_tile.enemy_present
      render_message(msg: 'enemy appears')
      sleep(1.5) unless dev_mode
      render_message(msg: 'inspect enemy')
    end
  end

  def select_inventory
    inventory = @game_instance.player_char.inventory
    render_message(msg: 'select item', items: inventory)
    chosen_item = @conn.gets.chomp
  end

  def exit_game?
    # do we need this nil?
    # @play_again = nil
    while @play_again == nil do
      render_message(msg: 'play again?')
      response = @conn.gets.chomp
      case response
      when /^y|Y/
        @play_again = true
      when /^n|N/
        @play_again = false
      else
        render_message(msg: 'invalid action')
      end
    end

    @game_instance.on = false if @play_again == false
  end

  def dev_mode
     @game_instance.delays_off
  end
end