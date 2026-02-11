require 'socket'

module Clark
  class Client
    class << self
      attr_accessor :host, :port
    end

    def self.get(key)
      request "GET #{key}"
    end

    def self.set(key, value)
      request "SET #{key} #{value}"
    end

    def self.request(string)
      # Create a new connection for each operation.
      @client = TCPSocket.new(host, port)
      @client.write(string)

      # Send EOF after writing the request.
      @client.close_write

      # Read until EOF to get the response.
      @client.read
    end
  end
end

# Try out the client
# 
# $ ruby client.rb
Clark::Client.host = 'localhost'
Clark::Client.port = 4481

puts Clark::Client.set 'Hello', 'World'
puts Clark::Client.get 'Hello'