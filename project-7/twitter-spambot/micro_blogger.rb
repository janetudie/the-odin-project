require 'jumpstart_auth'
require 'bitly'
require 'klout'

Bitly.use_api_version_3

bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
puts bitly.shorten('http://jumpstartlab.com/courses/').short_url


class MicroBlogger
  	attr_reader :client

 	def initialize
    	puts "Initializing..."
    	@client = JumpstartAuth.twitter
    	Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'

  	end

 	def run
    	puts "Welcome to the JSL Twitter Client!"
    	command = ""
  		while command != "q"
      		printf "Enter command: "
      		input = gets.chomp
      		parts = input.split(" ")
      		command = parts[0]
      		case command
         		when 'q' then puts "Goodbye!"
        		when 't' then tweet(parts[1..-1].join(" "))
        		when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        		when 'spam' then spam_my_followers(parts[1..-1].join(" "))
        		when 'elt' then self.everyones_last_tweet
        		when 's' then shorten(parts[1])
        		when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
         		else
           			puts "Sorry, I don't know how to #{command}"
      		end
  		end
 	end

	def shorten(original_url)
  		# Shortening Code
  		puts "Shortening this URL: #{original_url}"
  		return bitly.shorten(original_url).short_url
	end


	def followers_list
		@client.followers.collect { |follower| @client.user(follower).screen_name }
	end

  	def friends_list
    	@client.friends.collect { |friend| @client.user(friend).screen_name }
    end
  

	def dm(target, message)
  		puts "Trying to send #{target} this direct message:"
  		puts message
  		message = "d @#{target} #{message}"
	
		if followers_list.include?(target)
  			tweet(message)
		else
			puts "You can only DM people who follow you."
		end
	end

	def tweet(message)
  		if message.length < 141
   			@client.update(message)
   		else
   			puts "Message should be less than 140 characters."
   		end
	end

	def klout_score
    	friends = @client.friends
    	friends.each do |friend|
    		identity = Klout::Identity.find_by_screen_name(@client.user(friend).screen_name)
			user = Klout::User.new(identity.id)
			puts @client.user(friend).screen_name
			puts user.score.score
      	puts ""
    	end
 	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each {|follower| dm(follower, message)}
	end


	def everyones_last_tweet
		friends = @client.friends
		friends.sort_by { | friend | @client.user(friend).screen_name.downcase }
		friends.each do | friend |
			puts "#{@client.user(friend).screen_name} said this at #{@client.user(friend).status.created_at.strftime("%A, %b %d")}:"
			puts "#{@client.user(friend).status.text}"
			puts
		end
	end
end


blogger = MicroBlogger.new