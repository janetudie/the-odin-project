require "./vector"

class Board

	# displays the chessboard and controls the pieces' movements

	attr_accessor :board, :taken_pieces, :successful_move, :in_check

	def initialize
		@board = Array.new(8) {|i| Array.new(8)}
		@taken_pieces = []
		@in_check = {'w' => false, 'b' => false}

		fill_board

		print_board(@board)
	end


	# SETUP AND HELPER METHODS
	def fill_board
		fill_row_pieces(0, 'b')
		fill_row_pawn(1, 'b')
		fill_row_pieces(7, 'w')
		fill_row_pawn(6, 'w')

		@board[4][0] = King.new('b')
		@board[7][3] = King.new('w')
	end

	def fill_row_pieces(row, color)
		@board[row] = [Rook.new(color), Knight.new(color), Bishop.new(color), Bishop.new(color),
					Queen.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)]
	end

	def fill_row_pawn(row, color)
		@board[row].each_with_index {|content, i| @board[row][i] = Pawn.new(color)}
	end

	def content(coordinates)
		@board[coordinates[0]][coordinates[1]]
	end

	def get_opponent(player)
		player == 'w' ? 'b' : 'w'
	end

	def find_king(player)
		@board.each_with_index do |content, row|
			content.each_with_index do |piece, col|
				if piece.class.to_s == 'King' && piece.color == player
					return [row, col]
				end
			end
		end
	end

	def create_snapshot(original)
		Marshal.load(Marshal.dump(original))
	end


	# METHODS TO MOVE PIECES AND REMEMBER TAKEN PIECES
	def move_piece(curr_pos, dest, player)
		@successful_move = false

		board_snapshot = create_snapshot(@board)
		taken_pieces_snapshot = create_snapshot(@taken_pieces)

		content(curr_pos).class.to_s == 'Pawn' ? pawn_cond = check_pawn_condition(curr_pos, dest, player) : pawn_cond = nil

		message = generate_message(curr_pos, dest, pawn_cond, player)

		if !message
			update_taken_pieces(dest) if taking_opponent_piece?(curr_pos, dest, player) # order is important here :(
			move_action(curr_pos, dest)

			self_in_check?(player)

			if @in_check[player]
				puts "Invalid move. You must not still be in check."
				@board = board_snapshot
				@taken_pieces = taken_pieces_snapshot
			else
				@successful_move = true
				print_board
				self_in_check?(get_opponent(player))
			end
		else
			puts message
		end

	def generate_message(curr_pos, dest, pawn_cond, player)
		if content(curr_pos).nil?
			"The square you selected is empty. Try again."
		elsif content(curr_pos).color != player
			"This is not your piece. Try again."
		else
			if content(curr_pos).is_valid_destination(curr_pos, dest, pawn_cond, player)
				if !content(dest).nil? && content(dest).color == content(curr_pos).color
					"You already have a piece at that destination. Try again."
				else
					if free_to_move?(curr_pos, dest)
						false
					else
						"You can't jump over other pieces. Try again."
					end
				end
			else
				"Move is not allowed. Try again."
			end

		end
	end


	def update_taken_pieces(dest)
		@taken_pieces << content(dest)
	end

	def move_action(curr_pos, dest)
		@board[dest[0]][dest[1]] = content(curr_pos)
		@board[curr_pos[0]][curr_pos[1]] = nil
	end


	# METHODS TO CHECK VALIDITY OF MOVES
	def self_in_check?(player)

		@in_check[player] = false

		opponent = get_opponent(player)

		king_location = find_king(player)

		@board.each_with_index do |content, row|
			content.each_with_index do |piece, col|
				if !piece.nil? && piece.color != player
					if piece.is_valid_destination([row, col], king_location, 'taking', opponent) && free_to_move?([row, col], king_location)
						@in_check[player] = true
					end
				end
			end
		end

	end

	def free_path?(curr_pos, dest)
		# checks if squares between curr_pos and dest has a piece between it
		# TODO : separate finding increment

		diff = vector_operation(dest, curr_pos, -1)
		abs_diff = diff.map {|x| x.abs}
		increment = diff.collect {|x| abs_diff.max != 0 ? x / abs_diff.max : x}
		curr_pos = vector_operation(curr_pos, increment)

		while curr_pos != dest
			return false if !content(curr_pos).nil?
			curr_pos = vector_operation(curr_pos, increment)
		end

		true
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

	# METHODS TO DISPLAY BOARD ON TERMINAL
	def print_board(board = @board)
		puts '.  a b c d e f g h'
		board.each_with_index do |row, ri|
			print "#{ri + 1}  "
			row.each_with_index do |col, ci|
				(col.nil? ? (ri.even? ? (ci.even? ? whitesq : blacksq) : (ci.even? ? blacksq : whitesq)) : (print col))
				print ' '
			end
			puts
		end

		puts "Taken pieces: " 
		print_taken_pieces
		puts

	end

	def print_taken_pieces
		@taken_pieces.each {|piece| print piece}
	end

	def whitesq
		print "\u25FB".encode('utf-8')
	end

	def blacksq
		print "\u25FC".encode('utf-8') 
	end

end