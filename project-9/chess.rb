require "./pieces"
require "./vector"
require "./board"


class Game

	# controls the mechanics of the game

	attr_accessor :board

		def initialize
			@board = Board.new
			@curr_player = Player.new('w')
			@other_player = Player.new('b')
			@turns = 0

			@state = :in_play

			menu
		end

		private
		def menu
			puts "Starting new game."
			puts
			request_input
			# select start, load, etc.
		end

		def turn
			update_opponent_status # move this somewhere else

			if @state == :in_play 
				@curr_player, @other_player = @other_player, @curr_player
				@turns += 1

				request_input
			else
				puts "The game has ended!" # end message based on winner or stalemate
			end
		end

		def self_in_check?(player)

		@in_check = false

		opponent = get_opponent(player)

		opponent_king_location = find_king(opponent)

		@board.each_with_index do |content, row|
			content.each_with_index do |piece, col|
				if !piece.nil? && piece.color == player
					if piece.is_valid_destination([row, col], opponent_king_location, 'taking', player) && free_to_move?([row, col], opponent_king_location)
						@in_check = true
					end
				end
			end
		end

		puts 'Check!' if @in_check

	end

=begin
	puts "Self in check: " + self_in_check?(player).to_s
							if !self_in_check?(player) # check if the move puts us in check
								@successful_move = true
								other_in_check?(player)
							else
								puts "Invalid move. You must get out of the check!"
								@board = temp_board.dup
							end
=end


	def find_king(player)
		@board.each_with_index do |content, row|
			content.each_with_index do |piece, col|
				if piece.class.to_s == 'King' && piece.color == player
					return [row, col]
				end
			end
		end
	end




		def opponent_check
			@board.in_check
		end

		def update_opponent_status
			@other_player.check = opponent_check
			puts "Player #{player_number(@other_player)} is in check." if @other_player.check
		end

		def player_number(player)
			player.color == 'w' ? 1 : 2
		end

		def request_input
			puts "Player #{player_number(@curr_player)}, enter your move:"
			input = gets.chomp.upcase.strip
			puts
			parse_input(input)
		end

		def parse_input(input)
			unless /^[A-H][1-8].?[A-H][1-8]$/.match(input)
				puts "Unrecognized input format. Try again."
				request_input
			else

			# if input not in required format, ask player to enter again
				curr_pos = turn_to_index(input[0..1])
				dest = turn_to_index(input[-2..-1])

				@board.move_piece(curr_pos, dest, @curr_player.color)
				@board.successful_move ? turn : request_input
				
			end
		end

		def turn_to_index(input)
			[(input[1].to_i - 1), (input[0].ord - 65)]
		end

end


class Player

	attr_reader :color
	attr_accessor :check

	def initialize(color)
		@color = color
		@check = false
	end

end

b = Game.new



