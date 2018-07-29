require 'socket'
require 'rainbow/refinement'
require 'pry'
require_relative 'game_root'

using Rainbow

PORT = ARGV[0]

class TelChat

  def initialize(port)
    @chatters = []
    @records = []
    @id_counter = 0
    run_server(create_server(port))
  end

  def welcome(socket)
    socket.print "\nWelcome to watchandchat client! Please enter your name: ".green
    name = socket.readline.chomp
    socket.print "\nType text and hit enter to broadcast.\nType /help at any time for menu commands.\nType /exit to leave.\n".green.bright
    return name
  end
  
  def broadcast(msg)
    date = `date`.to_s.gray
    @chatters.each do |socket|
      socket.print date
      socket.print msg
      socket.puts
    end
  end
  
  def create_server(port)
      server = TCPServer.new(port)
      if server.respond_to?(:getsockname)
        print "Server listening on port #{port}\n".green
      else
        print "Server error. Contact administrator\n".red
      end 
      return server
  end

  def run_server(server)
    
    while (socket = server.accept)
      Thread.new(socket) do |conn|

        # binding.pry

        if @records.any? { |e| e[:ip] == conn.addr[3] }
          conn.puts "You have already logged on from this IP address. Get lost!"
          conn.close
          break
        end

        name = welcome(socket)
        broadcast("#{name} has joined the channel on IP: #{conn.addr[3][7..16]}\n".magenta)
        @chatters << socket
        @id_counter += 1
        id = @id_counter
        @records << {name: name, id: @id_counter, ip: conn.addr[3]}


        begin
          loop do
            conn.print "> "
            line = get_input(conn)
            conn.puts
            case line
            when "/help"
              help(conn)
            when "/list"
              list(conn)
            when "/exit"
              close(conn, name, id)
            when "/game"
              start_game_instance(conn, name)
            else
              broadcast("#{name}: #{line}\n".yellow)
            end
          end
        rescue EOFError
          close(conn, name, id)
        end
      end
    end
  end

  def help(conn)
    conn.print "\nHelp menu: \n"
    conn.print "1. Type /list to see all chatters\n"
    conn.print "2. Type /game to spin up an instance of RickRPG!\n"
    conn.print "3. Suggestions welcome...\n"
  end

  def list(conn)
    @records.each_with_index { |record, index| conn.print "#{index + 1}: #{record[:name]} - id: #{record[:id]}\n".magenta}
  end

  def close(conn, name, id)
    broadcast("#{name} has left the channel".magenta)
    conn.close
    @chatters.delete(conn)
    @records.delete_if { |r| r[:id] == id}
  end

  def get_input(conn)
    conn.readline.chomp
  end

end

watchandchat = TelChat.new(PORT)

