require 'socket'
require 'json'
 
host = 'localhost'     # The web server
port = 2000                          

def run(host, port)
	action = menu
	if action == 'GET'
		get
	elsif action == 'POST'
		post
	else
		puts "Exiting browser."
	end
end


def menu
	puts "Which type of request do you want to make? (GET or POST)"
	method = ' '
	until ['GET', 'POST', 'EXIT'].include?(method)
		method = gets.chomp.upcase
	end
	method
end

def get
	puts "What is the file you want?"
	path = gets.chomp

	path = path[1..-1] if path[0] == '/'

	gen_request('GET', path)
end

def post
	puts "Enter your name:"
	name = gets.chomp
	puts "Enter your email:"
	email = gets.chomp
	params = {user: {name: name, email: email}}

	path = "thanks.html"
	body = params.to_json

	headers = format_headers({ "Content-Type" => "application/x-www-form-urlencoded",
	            "Content-Length" => body.bytesize})
	
	gen_request('POST', path, headers, body)
end

def format_headers(headers)
	headers_string = ""
	headers.each do |name, value|
		headers_string += name.to_s + ": " + value.to_s + "\r\n"
	end
	headers_string
end

def gen_request(method, path, headers = nil, body = nil)
	request = "#{method} /#{path} HTTP/1.0\r\n"
	request << "#{headers}" if headers
	request << "\r\n\r\n#{body}"if body

	send_request('localhost', 2000, request)
end

def send_request(host, port, request)
	socket = TCPSocket.open(host, port)  # Connect to server
	socket.print(request)               # Send request

	read_response(socket)
end

def read_response(socket)
	response = socket.read             # Read complete response
	headers, body = response.split("\r\n\r\n", 2) 			# Split response at first blank line into headers and body
	print body    
end 

run(host, port)