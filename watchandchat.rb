require 'socket'
require 'logger'
require 'rainbow/refinement'
require 'pry'
require_relative 'game_root'

using Rainbow

PORT = ARGV[0]
ALLOW_SIMULTANEOUS_IP_CONNECTIONS = ARGV[1]

class TelServer < TCPServer
  def log
    @log ||= Logger.new("log.out", "weekly")
  end

  def close_log
    @log.close
  end
end

class TelChat
  def initialize(port)
    @chatters = []
    @records = []
    @id_counter = 0
    @server = create_server(port)
    # @log_file = TelFile.new("log.out", "w")
    run_server
  end

  def welcome(socket)
    socket.print "\nWelcome to ShitChat client! Please enter your name: ".green
    name = socket.readline.chomp
    socket.print "\nType text and hit enter to broadcast.\nType /help at any time for menu commands.\nType /exit to leave.\n".green.bright
    return name
  end

  def broadcast(msg)
    @chatters.each do |socket|
      socket.print date.gray
      socket.print msg
      socket.puts
    end
  end

  def create_server(port)
    server = TelServer.new(port)
    if server.respond_to?(:getsockname)
      print "Server listening on port #{port}\n".green
    else
      print "Server error. Contact administrator\n".red
      @server.log.error("Unable to create server on #{port}")
    end
    return server
  end

  def run_server
    while (socket = @server.accept)
      Thread.new(socket) do |conn|

        allow_simultaneous?(conn)

        name = welcome(socket)
        broadcast("#{name} has joined the channel from IP: #{conn.peeraddr[3]}, PORT: #{conn.peeraddr[1]}\n".magenta)

        @chatters << socket
        @id_counter += 1
        id = @id_counter
        record = {name: name, id: @id_counter, ip: conn.peeraddr[3], port: conn.peeraddr[1]}
        @records << record
        @server.log.info("\n\nNew client joined #{date}\nName: #{record[:name]}\nClient ID:#{record[:id]}\nIP Address: #{record[:ip]}\nPORT: #{record[:port]}\n")


        loop do
        begin
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
              break
            when "/game"
              start_game_instance(conn, name)
              @server.log.warn("\n#{date} #{name} span up the game.\n")
            else
              broadcast("#{name}: #{line}\n".yellow)
              @server.log.info("\n#{date} #{name}: #{line}\n")
            end
        rescue EOFError, Errno::EPIPE
          close(conn, name, id)
          break
        end
      end
      end
    end
  end

  def allow_simultaneous?(conn)
    unless ALLOW_SIMULTANEOUS_IP_CONNECTIONS
      if @records.any? { |e| e[:ip] == conn.peeraddr[3] }
        conn.puts "You have already logged on from this IP address. Get lost!"
        @server.log.warn("A user attempted to create more than two sessions from #{conn.peeraddr[3]} #{conn.peeraddr[1]}")
        conn.close
      end
    end
  end

  def date
    Time.now.utc.to_s
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
    conn.close
    @chatters.delete(conn)
    @records.delete_if { |r| r[:id] == id}
    broadcast("#{name} has left the channel".magenta)
    @server.log.info("\n#{date} #{name} left the channel.\n")
  end

  def get_input(conn)
    conn.readline.chomp
  end
end

watchandchat = TelChat.new(PORT)

