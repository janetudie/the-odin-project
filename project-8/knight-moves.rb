class Board
	attr_accessor :size

	def initialize(size = 8)
		@size = size
	end

end


class Path
	attr_accessor :pos, :path

	def initialize(pos, path)
		@pos = pos
		@path = path
	end

end


class Knight
	def initialize
		@board = Board.new(8)
		@path = []
		
	end

	def possible_moves(source)
		steps = [[-2,-1],[-2,1],[-1,-2],[-1,2],[2,-1],[2,1],[1,-2],[1,2]]
		moves = steps.map {|step| [step[0] + source[0], step[1] + source[1]]}
		moves.select! {|move| valid_move?(move)}
	end


	def valid_move?(move)
		move.all? {|pos| pos >= 0 && pos < @board.size}
	end


	def knight_moves(source, destination)
		queue = [Path.new(source, [source])]
		visited = [source]

		until queue.empty?
			current = queue.shift
			moves = possible_moves(current.pos).select {|move| !visited.include?(move)}

			if moves.include?(destination)
				output(Path.new(destination, current.path << destination))
				break
			else
				moves.each do |move| 
					queue << Path.new(move, current.path << move) 
					visited << move
				end
				
			end
		end

	end

	def output(path)
		puts "You made it in #{path.path.length - 1} move(s). Your moves are:"
		path.path.each {|move| puts move.inspect}

	end

end


k = Knight.new

k.knight_moves([0,0], [3, 3])
