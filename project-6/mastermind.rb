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


class Game
	def initialize
		@pattern = Pattern.new.pattern
		@turns = 12

		puts "The secret code is a random arrangement of four letters from A-F (e.g. 'ABCD', 'EFAD')."
		puts "Your task is to guess the code."
		puts
		guess
	end

	def guess
		@player_guess = []

		if @turns > 0
			puts "Your guess is:"
			@player_guess = gets.chomp.upcase.split('')
			@turns -= 1
		##
		#'''
		#4.times do |position|
		#	puts "Input letter from A-F at position #{position.to_i + 1}:"
		#	color = gets.chomp.upcase
		#	@player_guess << color
		#end
		

			puts

			compare_pegs
		else
			puts "You have no more tries remaining. Game over!"
		end

	end

	def compare_pegs

		@key_pegs = []

		@player_guess.uniq.each do |color, index|
			if @pattern.include?(color)
				[@player_guess.count(color), @pattern.count(color)].min.times {@key_pegs << 'w'}
			end
		end

		@pattern.each_with_index do |color, index|
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

	def print_pegs(pegs)
		pegs.each {|peg| print "#{peg}"}
		puts
	end


	def guessed?
		@key_pegs == ['b', 'b', 'b', 'b']
	end


end

Game.new