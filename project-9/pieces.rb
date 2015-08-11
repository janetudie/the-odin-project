class Piece

	attr_reader :color

	UNICODE = {'King' => {w: "\u2654", b: "\u265A"}, 'Knight' => {w: "\u2658", b: "\u265E"}, 
				'Rook' => {w: "\u2656", b: "\u265C"}, 'Queen' => {w: "\u2655", b: "\u265B"},
				'Bishop' => {w: "\u2657", b: "\u265D"}, 'Pawn' => {w: "\u2659", b: "\u265F"}}

	def initialize(color)
		@color = color
	end

	def to_s
		UNICODE[self.class.to_s][@color.to_sym].encode("utf-8")
	end

	def move(dest)
		@position = dest
	end
	# protected
	def die
		@inplay = false
	end


	def valid_positions(curr_pos, all_moves)
		all_moves.map {|move| [move[0] + curr_pos[0], move[1] + curr_pos[1]]}.reject {|step| step.any? {|x| x > 7 || x < 0}}
	end


	def is_valid_destination(curr_pos, dest, pawn_cond, player)

		case self.class.to_s
		when 'King'
			return legal_moves(curr_pos).include?(dest)
		when 'Knight'
			return legal_moves(curr_pos).include?(dest)
		when 'Bishop'
			return within_diagonals(curr_pos, dest)
		when 'Rook'
			return within_grid(curr_pos, dest)
		when 'Queen'
			return within_diagonals(curr_pos, dest) || within_grid(curr_pos, dest)
		when 'Pawn'
			return legal_moves(curr_pos, pawn_cond, player).include?(dest)
		end
	end

	def within_diagonals(curr_pos, dest)
		(dest[0] - curr_pos[0]).abs == (dest[1] - curr_pos[1]).abs
	end

	def within_grid(curr_pos, dest)
		(dest[0] == curr_pos[0] || dest[1] == curr_pos[1])
	end

end


class King < Piece
	
	def legal_moves(curr_pos)
		steps = [-1, 0, 1].repeated_permutation(2).to_a.reject {|move| move == [0, 0]}
		valid_positions(curr_pos, steps)
	end

end


class Knight < Piece
	def legal_moves(curr_pos)
		steps = [-2, -1, 1, 2].permutation(2).to_a.reject {|move| move[0].abs == move[1].abs}
		valid_positions(curr_pos, steps)
	end
end

class Bishop < Piece
end

class Rook < Piece
end

class Queen < Piece
end

class Pawn < Piece
	def legal_moves(curr_pos, pawn_cond, player)

		player == 'w' ? x = -1 : x = 1

		case pawn_cond
		when 'taking'
			steps = [[x, 1], [x, -1]]
		when 'en passant'
			steps = [[x, 1], [x, -1]]
		when 'starting'
			steps = [[x * 2, 0], [x, 0]]
		when 'normal'
			steps = [[x, 0]]
		end
		
		valid_positions(curr_pos, steps)
	end
end

