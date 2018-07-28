require_relative 'base_attributes'

class Viking < Character
  attr_reader :name, :base_health
  attr_accessor :health, :unique_skills

  def roll_attribute_modifiers
    @health += 200
    @base_health = @health
    @strength = (@strength * 1.5).round
    @constitution = (@constitution * 1.5).round
    @intelligence = (@intelligence * 0.33).round
    @dexterity = (@dexterity * 0.75).round
  end

  def add_unique_skills
    @unique_skills = {
      blocks: 5
    }
  end
end

class Barbarian < Character
  def roll_attribute_modifiers
    @health += 50
    @strength = (@strength * 2).round
    @constitution = (@constitution * 2).round
    @intelligence = (@intelligence * 0.31).round
    @dexterity = (@dexterity * 2).round
    @rests_per_turn = @rests_per_turn * 3
    @rests_remaining = @rests_remaining * 3
  end

  def add_unique_skills
    @unique_skills = {
      triple_smash: 5
    }
  end
end

class Wizard < Character
  def roll_attribute_modifiers
    @health -= 100 unless @health < 125
    @strength = (@strength * 0.5).round
    @constitution = (@constitution * 0.5).round
    @intelligence = (@intelligence * 3).round
    @dexterity = (@dexterity * 1.25).round
    @rests_per_turn = 1
    @rests_remaining = 1
  end

  def add_unique_skills
    @unique_skills = {
      cast_fireball: 5
    }
  end
end

class Rogue < Character
  def roll_attribute_modifiers
    @health += 100
    @strength = (@strength * 1.1).round
    @constitution = (@constitution * 1.1).round
    @intelligence = (@intelligence * 0.75).round
    @dexterity = (@dexterity * 1.5).round
    @rests_per_turn = @rests_per_turn * 2
    @rests_remaining = @rests_remaining * 2
  end

  def add_unique_skills
    @unique_skills = {
      hide: 5
    }
  end
end

class Cleric < Character
  def roll_attribute_modifiers
    @health -= 150 unless @health < 125
    @strength = (@strength * 0.6).round
    @constitution = (@constitution * 0.9).round
    @intelligence = (@intelligence * 2).round
    @dexterity = (@dexterity * 1.5).round
    @rests_per_turn = @rests_per_turn * 2
    @rests_remaining = @rests_remaining * 2
  end

  def add_unique_skills
    @unique_skills = {
      pray: 5
    }
  end
end

class Gimp < Character
  def roll_attribute_modifiers
    @health += 1000
    @strength = (@strength * 0.1).round
    @constitution = (@constitution * 3).round
    @intelligence = (@intelligence * 0.25).round
    @dexterity = (@dexterity * 0.5).round
    @rests_per_turn = 0
    @rests_remaining = 0
  end

  def add_unique_skills
    @unique_skills = {
      submit: 5
    }
  end
end

class SwagLord < Character
  def roll_attribute_modifiers
    @health += 9999
    @strength = (@strength * 9999).round
    @constitution = (@constitution * 9999).round
    @intelligence = (@intelligence * 9999).round
    @dexterity = (@dexterity * 9999).round
    @rests_per_turn = 0
    @rests_remaining = -1 # rest is for the weak
  end

  def add_unique_skills
    # no need for hide, pray or submit
    # everything else has to be over 9000
    @unique_skills = {
      blocks: 9999,
      cast_fireball: 9999,
      triple_smash: 9999
    }
  end
end
