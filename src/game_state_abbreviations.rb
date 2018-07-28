module GameStateAbbreviations
  def player_name
    @game_instance.player_char.name
  end

  def player_class
    @game_instance.player_char.class
  end
  
  def player_age
    @game_instance.player_char.age
  end

  def player_health
    @game_instance.player_char.health
  end

  def player_strength
    @game_instance.player_char.strength
  end

  def player_constitution
    @game_instance.player_char.constitution
  end

  def player_intelligence
    @game_instance.player_char.intelligence
  end

  def player_dexterity
    @game_instance.player_char.dexterity
  end

  def player_unique_skills
    @game_instance.player_char.unique_skills
  end

  def enemy_name
    @game_instance.current_tile.enemy.name
  end

  def enemy_class
    @game_instance.current_tile.enemy.class
  end
  
  def enemy_age
    @game_instance.current_tile.enemy.age
  end

  def enemy_health
    @game_instance.current_tile.enemy.health
  end

  def enemy_strength
    @game_instance.current_tile.enemy.strength
  end

  def enemy_constitution
    @game_instance.current_tile.enemy.constitution
  end

  def enemy_intelligence
    @game_instance.current_tile.enemy.intelligence
  end

  def enemy_dexterity
    @game_instance.current_tile.enemy.dexterity
  end

  def enemy_unique_skills
    @game_instance.current_tile.enemy.unique_skills
  end
end