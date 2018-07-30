using Rainbow

Thread.abort_on_exception = true

module TelChat
  class Server
    class SocketServer < TCPServer
      def log
        @log ||= Logger.new(STDOUT)
      end

      def close_log
        @log.close
      end
    end

    attr_reader :chatters

    def initialize(port)
      @chatters = []
      @server = create_server(port)
      # @log_file = TelFile.new("log.out", "w")
      run_server
    end

    def broadcast(msg)
      @chatters.reject(&:in_game).each do |socket|
        socket.print date.cyan
        socket.print " "
        socket.print msg
        socket.puts
      end
    end

    def create_server(port)
      server = SocketServer.new(port)
      if server.respond_to?(:getsockname)
        print "Server listening on port #{port}\n".green
      else
        print "Server error. Contact administrator\n".red
        @server.log.error("Unable to create server on #{port}")
      end
      return server
    end

    def run_server
      loop do
        Thread.new(@server.accept) do |conn|
          @server.log.info "Incoming connection on #{conn.peeraddr}"
          client = TelChat::ClientConnection.new(self, conn)

          # allow_simultaneous?(client)

          client.welcome
          # client.on_message do |message|
          #   broadcast(message)
          # end
          @chatters << client

          @server.log.info("\n\nNew client joined #{date}\nName: #{client.name}\nClient ID:#{client.object_id}\nIP Address: #{client.ip_address}\nPORT: #{client.port}\n")
          broadcast("#{client.name} has joined the channel from IP: #{client.ip_address}, PORT: #{client.port}\n".magenta)

          client.run_user_interface
        end
      end
    end

    def allow_simultaneous?(client)
      unless ALLOW_SIMULTANEOUS_IP_CONNECTIONS
        if @chatters.any? { |e| e.ip_address == client.ip_address }
          conn.puts "You have already logged on from this IP address. Get lost!"
          @server.log.warn("A user attempted to create more than two sessions from #{client.ip_address} #{client.port}")
          conn.close
        end
      end
    end

    def close(client)
      @chatters.delete(client)
      @server.log.info("\n#{date} #{client.name} left the channel.\n")
      broadcast("#{client.name} has left the channel".magenta)
    end

    def date
      Time.now.utc.to_s
    end
  end
end
