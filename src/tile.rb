class Tile
  attr_accessor :tile_type, :item, :enemy, :enemy_present

  def initialize(classname)
    tile_type = Object.const_get(classname)
    @tile_type = tile_type.new
    enemy_chance = chance_in_3
    # binding.pry
    generate_enemy if enemy_chance
    item_chance = chance_in_3
    @item = Item.create if item_chance
    @item_present = true if @item    
  end

  def self.create
    classname = roll_tile_type
    self.new(classname)
  end

  def self.roll_tile_type
    ['Hot', 'Cold', 'Freezing',
     'Grassy', 'Damp', 'Misty',
     'Demonic', 'Quantum', 'Dungeon', 
     'Dungeon', 'Dungeon', 'Dungeon', 
     'Dungeon', 'Dungeon', 'Dungeon'
    ].sample
  end

  def chance_in_5
    [true, false, false, false, false].sample
  end

  def chance_in_3
    [true, false, false].sample
  end

  def generate_enemy
    # binding.pry
    if self.tile_type.class === Dungeon
      @enemy = Enemy.generate_from_probability(rand(0..40))
    elsif self.tile_type.class == (Misty)
      @enemy = Enemy.generate_from_probability(rand(0..85))
    elsif self.tile_type.class == (Freezing)
      @enemy = Enemy.generate_from_probability(rand(50..98))
    elsif self.tile_type.class == Demonic
      @enemy = Enemy.generate_from_probability(rand(95..100))
    else
      @enemy = Enemy.generate_from_probability(rand(100))
    end
    @enemy_present = true
  end

end

class Dungeon < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "There is nothing remarkable about this place..."
  end
end

class Hot < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "You have entered a particularly hot area. Your instincts tell you a Balrog was wandering here recently."
  end
end

class Cold < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "As you exhale, the air condenses into a distinct stream of vapour. Do Wreaths make places cold? You search for your baddy codex and realise you left it at home next to your WTF ARE YOU DOING?"
  end
end

class Freezing < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "You tighten your robes, this area is at least -20C. In a flash of horror you remember that Wreathes are well known for leaving trails of cold death behind them."
  end
end

class Grassy < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "You're not sure how, as this place is underground, but you emergy into a grassy bank. You decide to let it go for now."
  end
end

class Damp < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "This place just smells a bit. Of wet dog, weirdly."
  end
end

class Misty < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "Stumbling over a rock, a thick fog reduces how much you can see. For a minute, you feel comforted, safe even. It then dawns quite rapidly in your mind that you are only able to see a foot in front of you. You could swear you heard a rattling of chains, too."
  end
end

class Demonic < Tile
  attr_accessor :tile_description

  def initialize
    @tile_description = "You find yourself arrested by terrible visions of demons and ghoulies. No doubt about it, this place is demonic as hell. The pentagrams and blood on the walls are a bit of a giveaway."
  end
end

class Quantum < Tile
  attr_accessor :tile_description
  
  def initialize
    @tile_description = "Your belly gurgles and it is slower than usual...when you move your eyes, little pixels of light form in the corner of your eyes. In the distance you hear a cat, and you have a sudden sense that reality is thin here. You don't know what this means but you are not feeling good about it."
  end
end

