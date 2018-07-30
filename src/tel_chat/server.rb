module TelChat
  class Server
    class SocketServer < TCPServer
      def log
        @log ||= Logger.new("log.out", "weekly")
      end

      def close_log
        @log.close
      end
    end

    def initialize(port)
      @chatters = []
      @records = []
      @id_counter = 0
      @server = create_server(port)
      # @log_file = TelFile.new("log.out", "w")
      run_server
    end

    def broadcast(msg)
      @chatters.each do |socket|
        socket.print date.gray
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
      while (socket = @server.accept)
        Thread.new(socket) do |conn|
          client = TelChat::Client.new(conn)

          allow_simultaneous?(client)

          client.welcome
          broadcast("#{client.name} has joined the channel from IP: #{client.ip_address}, PORT: #{client.port}\n".magenta)

          @chatters << client
          @id_counter += 1
          id = @id_counter
          record = {name: name, id: @id_counter, ip: conn.peeraddr[3], port: conn.peeraddr[1]}
          @records << record
          @server.log.info("\n\nNew client joined #{date}\nName: #{record[:name]}\nClient ID:#{record[:id]}\nIP Address: #{record[:ip]}\nPORT: #{record[:port]}\n")
        end
      end
    end

    def allow_simultaneous?(client)
      unless ALLOW_SIMULTANEOUS_IP_CONNECTIONS
        if @records.any? { |e| e[:ip] == client.ip_address }
          conn.puts "You have already logged on from this IP address. Get lost!"
          @server.log.warn("A user attempted to create more than two sessions from #{client.ip_address} #{client.port}")
          conn.close
        end
      end
    end

    def date
      Time.now.utc.to_s
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
end
