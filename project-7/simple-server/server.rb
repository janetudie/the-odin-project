# STILL NEEDS REFACTORING TO MAKE IT MODULAR

require 'socket'               
require 'json'

server = TCPServer.open(2000)   
loop {                          
  Thread.start(server.accept) do |client|
    request = client.read_nonblock(256)
    # puts request # for testing purposes

    request_header, request_body = request.split("\r\n\r\n", 2)
    method, path = request_header.split(' ')[0], request_header.split(' ')[1][1..-1]

    if File.exists?(path)
        resp_body = File.read(path)

    	client.puts "HTTP/1.1 200 OK\r\nContent-Type:text/html\r\nContent-Length:#{resp_body.bytesize}\r\n\r\n"

        if method == 'GET'
            client.puts resp_body
        elsif method == 'POST'
            params = JSON.parse(request_body)
            user_data = "<li>Name: #{params['user']['name']}</li><li>Email: #{params['user']['email']}</li>"
            client.puts resp_body.gsub('<%= yield %>', user_data)
        end
    else
    	client.puts "HTTP/1.1 404 Not Found\r\n\r\n"
        client.puts "404 #{path} could not be found!"
    end
    client.close

  end
}
