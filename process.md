git ls-files | xargs cat | wc -l

Todo
  * Refactor some of the UI methods into game itself, so that a console user could run the game with commands entirely

  * Refactor Tile so that only Tile knows what kinds of tiles exist. Calling Tile.create makes it randomly initialise one of its subclasses. This decouples it from Game.

  * introduce item effects
    complete other item effects beyond health potion
    how to get Item to message Game if it is a game event causing item?

  introduce game events

  introduce npc interactions

  (low priority) character/enemy/item balancing via simulator, create game difficulties)

  allow for player actions within battle mode
    heal
    use item
    use special skill
    taunt enemy (on character subclass)
    attempt escape

  get enemy to randomly choose enemy actions within battle mode
    heal
    use special skill
    say something funny

  * increase number of enemies
    give them random names on the classes
    have magic attacks for magic classes
    have chance of dodge based on dexterity
    have dexterity dynamically set the speed of player character
    have constitution determine ability to tank

  have tiles dynamically set enemy probabilities

  create winning conditions

  implement scoring system

  on death/victory, write game stats to a log file (as preliminary to storing stats in mysql)
    player name
    character name, type, stats
    tile reached
    enemies defeated
    items used
    events that occurred

  rails console application
    ascii graphic of characters/monsters with stats when they appear?

  integration with Telnet