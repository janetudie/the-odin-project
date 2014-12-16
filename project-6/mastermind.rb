class Pattern

	COLORS = ["A", "B", "C", "D", "E", "F"]

	attr_reader :pattern
	def initialize(pattern = [])
		@pattern = []
		set_random_pattern
	end

	def set_fixed_pattern #for testing
		@pattern = ['A', 'B', 'A', 'C']
	end

	def set_random_pattern
		4.times do |position|
			color = COLORS.sample
			@pattern << color
		end
	end
end

class AI

	COLORS = ["A", "B", "C", "D", "E", "F"]

	def initialize(game)
		@pattern_to_guess = game.pattern_to_guess
		@game = game
		@turns = 12
		
	end

	def random_guess

		@guess = Pattern.new.pattern
		#4.times do
		#	@guess << COLORS.sample
		#end

		puts "#{@turns} turn(s) left."
		puts
		puts "The computer's guess is:"
		puts @guess.join('')

		check_guess(@guess)
	end

	def corr?(guess)
		guess == @pattern_to_guess
	end

	def check_guess(guess)

		puts "Checking guess..."

		@key_pegs = Array.new(4)

		@pattern_dup = @pattern_to_guess.dup
		@guess_dup = guess.dup

		@pattern_to_guess.each_with_index do |color, i|
			if color == guess[i]
				@key_pegs[i] = 'b'
				@pattern_dup[i] = nil
				@guess_dup[i] = nil
			end
		end

		@guess_dup.each_with_index do |color, i|
			if !color.nil? && @pattern_dup.include?(color)
				@key_pegs[i] = 'w'
				@guess_dup[i] = nil
				@pattern_dup.delete_at(@pattern_dup.index(color) || @pattern_dup.length)
			elsif @key_pegs[i].nil?
				@key_pegs[i] = '.'
			end
		end

		puts "The clues are:"
		puts @key_pegs.join('')
		puts
		puts "-------------------------"
		

		if @game.selection == '1'
			new_guess
		else
			new_try
		end



	end

	def new_guess
		@old_guess = @guess.dup

		@turns -= 1
		@guess = Array.new(4)
		@white_colors = []

		@key_pegs.each_with_index do |peg, i|
			if peg == 'b'
				@guess[i] = @old_guess[i]
			elsif peg == 'w'
				@white_colors << @old_guess[i]
			end
		end

		@guess.each_with_index do |color, i|
			if !@white_colors.empty? && color.nil?
				@guess[i] = @white_colors.shuffle.pop
			elsif color.nil?
				@guess[i] = COLORS.sample
			end
		end

		puts "#{@turns} turn(s) left."
		puts
		puts "The computer's guess is:"
		puts @guess.join('')
		puts

		if !corr?(@guess) && @turns > 0
			check_guess(@guess)
		elsif corr?(@guess)
			puts "The computer cracked your code! It is '#{@guess.join()}'."
			game_over
		else
			puts "No more turns left. The computer failed!"
			game_over
		end

	end

	def new_try

		if corr?(@guess)
			puts "You cracked the code!"
			game_over
		elsif @turns > 0
			puts "There are #{@turns} turn(s) left."
			puts
			puts "Input your guess. Your guess is:"
			@guess = gets.chomp.upcase.split('')
			@turns -= 1
			puts
			check_guess(@guess)
		else
			puts "You have no more tries remaining."
			game_over
		end

	end

	def game_over
		puts
		puts "GAME OVER"
		puts
		puts "Restart? (Y/N)"
		restart = gets.chomp.upcase
		if restart == 'Y'
			puts
			puts "_____________________________________________________________________________"
			Game.new
		end
	end

end



class Game

	attr_reader :pattern_to_guess, :selection
	def initialize

		puts "Select '1' if you want to the the code creator and '2' if you want to be the codebreaker."
		@selection = gets.chomp
		if @selection == '1'
			puts "Enter your secret code here. It must be random arrangement of four letters from A-F:"
			@pattern_to_guess = gets.chomp.split('')
			@ai = AI.new(self)
			@ai.random_guess
		else
			@pattern_to_guess = Pattern.new.pattern
			@ai = AI.new(self)
			puts "The secret code is a random arrangement of four letters from A-F (e.g. 'ABCD', 'EFAD')."
			puts "Your task is to guess the code."
			puts
			puts "------------------------------"
			@ai.new_try

		end
	end

=begin
	def new_try

		if @ai.corr?(@guess)
			puts "You cracked the code!"
		elsif @turns > 0
			puts "There are #{@turns} turn(s) left."
			puts
			puts "Input your guess. Your guess is:"
			@guess = gets.chomp.upcase.split('')
			@turns -= 1

			puts

			@ai.check_guess(@guess)
		else
			puts "You have no more tries remaining."
			puts
			puts "GAME OVER"
			puts

		end

	end


=begin
	def compare_pegs

		@key_pegs = []

		@player_guess.uniq.each do |color, index|
			if @pattern_to_guess.include?(color)
				[@player_guess.count(color), @pattern_to_guess.count(color)].min.times {@key_pegs << 'w'}
			end
		end

		@pattern_to_guess.each_with_index do |color, index|
			if color == @player_guess[index]
				@key_pegs << 'b'
				@key_pegs.delete_at(@key_pegs.index('w') || @key_pegs.length)
			end
		end

		if guessed?
			puts "You cracked the code!"
		elsif  @turns > 0
			puts "Your clues are:"
			print_pegs(@key_pegs)
			puts
			puts "Try again. You have #{@turns} more turn(s)."
			puts
			guess
		else
			guess
		end

	end

=end

end

Game.new


