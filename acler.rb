#!/usr/bin/env ruby
# A script to test ACL on a connection between networks

require 'timeout'
require 'threadify'
require 'socket'

Signal.trap("INT") { 
  shut_down 
  exit
}

inuse = []

class Port
	@@array = []

	attr_accessor :port, :state, :reason

	def initialize(port, state, reason)
		@port = port
		@state = state
		@reason = reason
		@@array << self
	end

	def self.all
		@@array
	end
end

def shut_down
  puts "\nShutting down..."
  exit
end


options = '
    ___   ________    __________ 
   /   | / ____/ /   / ____/ __ \
  / /| |/ /   / /   / __/ / /_/ /
 / ___ / /___/ /___/ /___/ _, _/ 
/_/  |_\____/_____/_____/_/ |_|  

server - spawn a server and wait for connection from client
client - spawn a client to connect to server with

E.G.
./acler.rb server

./acler.rb client 10.0.0.1
'

if ARGV[0].nil?
	puts options
end

if ARGV[0] == "client"
	puts "Starting Client, please ensure the server is running first..."
	(1..65535).each do |port|

		begin 
		    Timeout.timeout(1) do
		        client = TCPSocket.new ARGV[1], port
		        got_port = client.gets.chomp
		        client.close
		        Port.new(got_port, "OPEN", nil)
		        print "Connected on port: #{got_port}\r"
		        $stdout.flush
		    end
		rescue Timeout::Error
			Port.new(port, "UNKNOWN", "TIMEOUT")
		rescue => error
			Port.new(port, "CLOSED", error)
		end
	end

	open("acler_#{Time.now.strftime('%Y-%m-%d_%H-%M')}.txt", "a") do |line|
		Port.all.each do |object|
			line << "#{object.port} : #{object.state}\n"
		end
	end
	puts "Done"

elsif ARGV[0] == "server"

	puts "Starting Server..."
	(1..65535).threadify(10) {|port|

		begin
			server = TCPServer.open(port)
			client = server.accept
			client.puts port
			client.close
			print "Got connection on port: #{port}\r"
			$stdout.flush
		rescue Errno::EADDRINUSE => error
			inuse << port
			next
		rescue => error
			error.class.to_s
		end
	}
end