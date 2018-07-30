using Rainbow

module TelChat
  class ClientConnection
    attr_reader :server, :socket, :connected_at, :name

    def initialize(server, socket)
      @server = server
      @socket = socket
      @connected_at = date
    end

    def welcome
      socket.print "\nWelcome to ShitChat client! Please enter your name: ".green
      @name = socket.readline.chomp
    end

    # Allow the server to set a block to me called whenever we receive input (@on_message.call)
    # def on_message(&block)
    #   @on_message = block
    # end

    def run_user_interface
      socket.print "\nType text and hit enter to broadcast.\nType /help at any time for menu commands.\nType /exit to leave.\n".green.bright

      loop do
        begin
            socket.print "> "
            line = get_input
            socket.puts
            case line
            when "/help"
              help
            when "/list"
              list
            when "/exit"
              close
              break
            when "/game"
              # start_game_instance(conn, name)
              # @server.log.warn("\n#{date} #{name} span up the game.\n")
            else
              # @on_message.call(line)
              broadcast("#{name}: #{line}\n".yellow)
            end
        rescue EOFError, Errno::EPIPE
          close(conn, name, id)
          break
        end
      end
    end

    def print(msg)
      socket.print(msg)
    end

    def puts(msg = "\n")
      socket.print(msg)
    end

    def port
      socket.peeraddr[1]
    end

    def ip_address
      socket.peeraddr[3]
    end

    private

    def broadcast(msg)
      server.broadcast(msg)
    end

    def help
      socket.print "\nHelp menu: \n"
      socket.print "1. Type /list to see all chatters\n"
      socket.print "2. Type /game to spin up an instance of RickRPG!\n"
      socket.print "3. Suggestions welcome...\n"
    end

    def list
      server.chatters.each_with_index { |record, index| socket.print "#{index + 1}: #{record.name} - id: #{record.object_id}\n".magenta}
    end

    def date
      Time.now.utc.to_s
    end

    def close
      socket.close
      server.close(self)
    end

    def get_input
      socket.readline.chomp
    end
  end
end
