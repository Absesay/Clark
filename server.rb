require 'socket'

module Clark
    class Server
        def initialize(port)
            @server = TCPServer.new(port)
            puts "Listening on port #{@server.local_address.ip_port}"
            @storage = {}
        end

        def start
            Socket.accept_loop(@server) do |connection|
                handle(connection)
                connection.close
            end
        end

        def handle(connection)
            request = connection.read
            connection.write process(request)
        end

        def process(request)
            command, key, value = request.split

            case command.upcase
            when 'GET'
                @storage[key]

            when 'SET'
                @storage[key] = value
            end
        end
    end
end

# Try out the server
# 
# $ ruby server.rb
server = Clark::Server.new(4481)
server.start