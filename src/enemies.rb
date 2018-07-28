require_relative 'base_attributes'

class Enemy < Character
  # binding.pry
  def self.generate_from_probability(p)
    enemy = nil
    case
    when p < 40 
      enemy = SewerRat.create('Ratlet')
    when p >= 40 && p < 55
      enemy = GoblinFarmer.create('Arse Itcher')
    when p >= 55 && p <= 66
      enemy = Goblin.create('Arse Itch')
    when p > 66 && p <= 76
      enemy = GoblinFighter.create('Arse Itching')
    when p > 76 && p <= 84
      enemy = MadGoblinWizard.create('Mad Arse Itch')
    when p > 84 && p <= 90
      enemy = OrcBeserker.create('Furious Arse Itch')
    when p > 90 && p <= 95
      enemy = OrcMeatshield.create('Un-itch-able Arse Itch')
    when p > 95 && p <= 98
      enemy = Wreath.create('Headless Cleaner')
    when p > 98
      enemy = Balrog.create('Beatrice')
    end
    enemy
  end
end

class SewerRat < Enemy
  def roll_attribute_modifiers
    # BUG-01: Sewer rat health goes into minus - needs base adjustment or class adjustment
    # @health -= 200 unless @health < 30 && @health < 0
    @health = 45
    @strength = (@strength * 0.1).round
    @constitution = (@constitution * 0.1).round
    @intelligence = (@intelligence * 0.1).round
    @dexterity = (@dexterity * 2).round
  end

  def add_unique_skills
    @unique_skills = {
      die_of_disease: 1
    }
  end
end

class GoblinFarmer < Enemy
  def roll_attribute_modifiers
    @strength = (@strength * 0.8).round
    @constitution = (@constitution * 0.8).round
    @intelligence = (@intelligence * 0.1).round
    @dexterity = (@dexterity * 0.75).round
  end

  def add_unique_skills
    @unique_skills = {
      eat_potato: 5
    }
  end
end

class Goblin < Enemy
  def roll_attribute_modifiers
    @strength = (@strength * 1).round
    @constitution = (@constitution * 1).round
    @intelligence = (@intelligence * 0.25).round
    @dexterity = (@dexterity * 1).round
  end

  def add_unique_skills
    @unique_skills = {
      blocks: 5
    }
  end
end

class GoblinFighter < Enemy
  def roll_attribute_modifiers
    @strength = (@strength * 1.25).round
    @constitution = (@constitution * 1.25).round
    @intelligence = (@intelligence * 0.25).round
    @dexterity = (@dexterity * 1).round
  end

  def add_unique_skills
    @unique_skills = {
      triple_strike: 5
    }
  end
end

class MadGoblinWizard < Enemy
  def roll_attribute_modifiers
    @strength = (@strength * 0.5).round
    @constitution = (@constitution * 0.5).round
    @intelligence = (@intelligence * 0.25).round
    @dexterity = (@dexterity * 1).round
  end

  def add_unique_skills
    @unique_skills = {
      heal: 5
    }
  end
end

class OrcBeserker < Enemy
  def roll_attribute_modifiers
    @health += 200
    @strength = (@strength * 2).round
    @constitution = (@constitution * 2).round
    @intelligence = (@intelligence * 0.25).round
    @dexterity = (@dexterity * 2).round
  end

  def add_unique_skills
    @unique_skills = {
      blocks: 5
    }
  end
end

class OrcMeatshield < Enemy
  def roll_attribute_modifiers
    @strength = (@strength * 1).round
    @constitution = (@constitution * 1).round
    @intelligence = (@intelligence * 0.25).round
    @dexterity = (@dexterity * 1).round
  end

  def add_unique_skills
    @unique_skills = {
      stone_flesh: 5
    }
  end
end

class Wreath < Enemy
  def roll_attribute_modifiers
    @health += 200
    @strength = (@strength * 1).round
    @constitution = (@constitution * 1.5).round
    @intelligence = (@intelligence * 2).round
    @dexterity = (@dexterity * 3).round
  end

  def add_unique_skills
    @unique_skills = {
      drain: 5
    }
  end
end

class Balrog < Enemy
  def roll_attribute_modifiers
    @health += 2000
    @strength = (@strength * 4).round
    @constitution = (@constitution * 4).round
    @intelligence = (@intelligence * 1.25).round
    @dexterity = (@dexterity * 0.5).round
  end

  def add_unique_skills
    @unique_skills = {
      hellfire: 5
    }
  end
end