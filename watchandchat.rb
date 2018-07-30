require 'socket'
require 'logger'
require 'rainbow/refinement'
require 'pry'
require_relative 'game_root'

require_relative 'src/tel_chat/server'
require_relative 'src/tel_chat/client_connection'

using Rainbow

PORT = ARGV[0]
ALLOW_SIMULTANEOUS_IP_CONNECTIONS = ARGV[1]


watchandchat = TelChat::Server.new(PORT)

