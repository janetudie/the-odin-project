require "./pieces"



def vector_operation(a, b, sign = 1)
		[a[0] + sign * b[0], a[1] + sign * b[1]]
end


class Board

	# displays the chessboard and controls the pieces' movements

	attr_accessor :board, :taken_pieces, :successful_move

	def initialize
		@board = Array.new(8) {|i| Array.new(8)}
		@taken_pieces = []
		fill_board

		print_board
	end

	def fill_board
		fill_row_pieces(0, 'b')
		fill_row_pawn(1, 'b')
		fill_row_pieces(7, 'w')
		fill_row_pawn(6, 'w')
	end

	def fill_row_pieces(row, color)
		@board[row] = [Rook.new(color), Knight.new(color), Bishop.new(color), King.new(color),
					Queen.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)]
	end

	def fill_row_pawn(row, color)
		@board[row].each_with_index {|content, i| @board[row][i] = Pawn.new(color)}
	end


	def content(coordinates)
		@board[coordinates[0]][coordinates[1]]
	end

	def move_piece(curr_pos, dest, player)
		@successful_move = false

		content(curr_pos).class.to_s == 'Pawn' ? pawn_cond = check_pawn_condition(curr_pos, dest, player) : pawn_cond = nil

		if content(curr_pos).nil?
			puts "The square you selected is empty. Try again."
		else
			if content(curr_pos).color == player
				if content(curr_pos).is_valid_destination(curr_pos, dest, pawn_cond, player)
					if !content(dest).nil? && content(dest).color == content(curr_pos).color # make a function
						puts "You already have a piece at that destination. Try again."
					else 
						if free_to_move?(curr_pos, dest)
							update_taken_pieces(dest) if taking_opponent_piece?(curr_pos, dest, player) # order is important here :(
							move_action(curr_pos, dest)
						else
							puts "You can't jump over other pieces. Try again."
						end
					end
				else
					puts "Invalid move. Try again."
				end
			else
				puts "This is not your piece. Try again."
			end
		end
	end

	def free_to_move?(curr_pos, dest)
		(content(curr_pos).class.to_s == "Knight" || free_path?(curr_pos, dest))
	end

	def check_pawn_condition(curr_pos, dest, player)
		if taking_opponent_piece?(curr_pos, dest, player)
			
			return 'taking'
		elsif first_pawn_move?(curr_pos, player)
			return 'starting'
		elsif pawn_at_end?(curr_pos, player)
			return 'replaceable'
		else
			puts 'normal'
			return 'normal'
		end

	end

	def pawn_at_end?(curr_pos, player)
		case player
		when 'w'
			return curr_pos[0] == 0
		when 'b'
			return curr_pos[0] == 7
		end
	end

	def taking_opponent_piece?(curr_pos, dest, player)
		content(dest).nil? ? false : (content(dest).color == player ? false : true)			
	end

	def first_pawn_move?(curr_pos, player)
		case player
		when 'b'
			return curr_pos[0] == 1
		when 'w'
			return curr_pos[0] == 6
		end
	end

	def free_path?(curr_pos, dest)
		# checks if squares between curr_pos and dest has a piece between it
		# TODO : separate finding increment

		diff = vector_operation(dest, curr_pos, -1)

		puts diff.inspect

		abs_diff = diff.map {|x| x.abs}

		increment = diff.collect {|x| abs_diff.max != 0 ? x / abs_diff.max : x}

		curr_pos = vector_operation(curr_pos, increment)

		while curr_pos != dest
			return false if !content(curr_pos).nil?
			curr_pos = vector_operation(curr_pos, increment)
		end

		true
	end

	def update_taken_pieces(dest)
		@taken_pieces << content(dest)
	end

	def move_action(curr_pos, dest)

		@board[dest[0]][dest[1]] = content(curr_pos)
		@board[curr_pos[0]][curr_pos[1]] = nil
		@successful_move = true

		print_board if @successful_move
	end

	def print_board
		puts '.  a b c d e f g h'
		@board.each_with_index do |row, ri|
			print "#{ri + 1}  "
			row.each_with_index do |col, ci|
				(col.nil? ? (ri.even? ? (ci.even? ? whitesq : blacksq) : (ci.even? ? blacksq : whitesq)) : (print col))
				print ' '
			end
			puts
		end

		puts "Taken pieces: #{@taken_pieces}"
		puts

	end

	def whitesq
		print "\u25FB".encode('utf-8')
	end

	def blacksq
		print "\u25FC".encode('utf-8') 
	end

end


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
			if @state == :in_play 
				@curr_player, @other_player = @other_player, @curr_player
				@turns += 1
				request_input
			else
				puts "The game has ended!" # end message based on winner or stalemate
			end
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

	def initialize(color)
		@color = color
	end
end

b = Game.new



