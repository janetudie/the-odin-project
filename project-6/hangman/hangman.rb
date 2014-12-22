require "yaml"


class Hangman

	attr_reader :word_to_guess, :guess, :lives
	def initialize
		@word_to_guess = ''
		@solved = false

		@lives = 20	

		#@guess = guess_display(guess)
	end

	def word_to_guess
		File.open("5desk.txt", 'r').readlines.select {|word| word.strip.length >= 5 && word.length <= 12}.sample.strip.downcase
	end

	def start_play

		puts "Do you want to load an existing game? (Y/N)"
		load = gets.chomp.downcase

		if load == 'y'
			load_game

			guess_display
			guess_char
		else
			new_game
		end
	end

	def new_game
			puts "New game started! You can save your game anytime by typing 'save'."
			puts "The word to guess is:"

			@word_to_guess = word_to_guess

			@guess = @word_to_guess.split('').collect {|x| "_"}
			puts @guess.join(' ')

			puts @word_to_guess

			guess_char
		end
=begin

	def set_lives
		puts "How many tries do you want to have?"
		lives = gets.chomp
		lives
	end

=end

	def guess_char

		begin
			puts "Input your guess or save:"
			char = gets.chomp.downcase
		
		raise puts "Wrong input!" unless (char.length == 1 && ('a'..'z').include?(char)) || char == 'save'

		rescue
			retry
		
		else

			if char == 'save'
				save_game
				puts "Game saved!"

				@lives += 1 # because this is counted as a turn? :S
			end
		
		end



		guess_check(char)
		turn
	end

	def guess_check(char)

		@word_to_guess.split('').each_with_index do |ch, i|
			if ch == char
				@guess[i] = char
			end
		end

		guess_display

		
	end

	def guess_display
		puts "The word to guess is:"
		puts @guess.join(' ')
	end

	def turn

		@lives -= 1


		if @guess.join('') == @word_to_guess
			puts "You won!"
			puts "The word is '#{@word_to_guess}'"
		elsif @lives > 0
			puts "You have #{@lives} turn(s) left!"
			guess_char
		else
			puts "You ran out of lives."
			puts "GAME OVER."
		end
	end


	def save_game
		Dir.mkdir('saved') unless Dir.exist? 'saved'
		File.open('saved/saved.yaml', 'w') {|file| file.write YAML.dump(self)}
    end


	def load_game

  		game_file = YAML::load(File.read('saved/saved.yaml'))
  		@lives = game_file.lives
  		@word_to_guess = game_file.word_to_guess
  		@guess = game_file.guess

	end

end

game = Hangman.new
game.start_play

