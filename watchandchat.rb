require 'socket'
require 'rainbow/refinement'

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
    @chatters.each do |socket|
      socket.print msg
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
        name = welcome(socket)
        broadcast("#{name} has joined the channel".magenta)
        @chatters << socket
        @id_counter += 1
        @records << {name: name, id: @id_counter}
        begin
          loop do
            conn.print "> "
            line = get_input(conn)
            case line
            when "/help"
              help(conn)
            when "/list"
              list(conn)
            when "/exit"
              close(conn)
            else
              broadcast("\n#{name}: #{line}\n".yellow)
            end
          end
        rescue EOFError
          close(conn)
        end
      end
    end
  end

  def help(conn)
    conn.print "\nHelp menu: \n"
    conn.print "1. Type /list to see all chatters\n"
    conn.print "2. Go fuck yourself\n"
  end

  def list(conn)
    @records.each_with_index { |record, index| conn.print "#{index + 1}: #{record[:name]} - id: #{record[:id]}\n".magenta}
  end

  def close(conn)
    conn.close
    @chatters.delete(conn)
    @name.delete(name)
    broadcast("#{name} has left the channel".magenta)
  end

  def get_input(conn)
    conn.readline.chomp
  end

end

watchandchat = TelChat.new(PORT)

