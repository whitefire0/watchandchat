require 'pry'
require 'pry-byebug'
require 'awesome_print'
require 'colorize'

require_relative 'src/user_interface'
require_relative 'src/game'
require_relative 'src/tile'
require_relative 'src/item'
require_relative 'src/characters'
require_relative 'src/enemies'
require_relative 'src/socketing'

def start_game_instance(conn, name)
  Socketing::set(conn)
  play_again = true
  while play_again do
    game = Game.new
    interface = UserInterface.new(game, name)
    game.menu_instance = interface
    play_again = interface.manager
  end
  conn.puts "Welcome back to watchandchat!".colorize(:green)
end

# start_game_instance

# Application Build Tests