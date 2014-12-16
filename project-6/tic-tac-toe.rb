class Player
	attr_reader :name, :symbol

	def initialize(input)
        puts "Player #{input.fetch(:number)}, enter your name:"
		@name = gets.chomp
		@symbol = input.fetch(:symbol)
	end

end


class Board

	attr_reader :board

	def initialize(game)
		@board = Array.new(3) {Array.new(3) {nil}}
		@game = game
	end

	def update(player, row, col)
		if @board[row][col].nil?
			@board[row][col] = player.symbol
			draw

			if @game.won?(player)
				@game.in_play = false
				puts "#{player.name} won!"
			else
				@game.switch_players
			end

		else
			puts "Position occupied! Try again."
			@game.get_input(player)
		end
	end

	private
	def draw
    	puts "--+-+--"
    	@board.each do |row|
    		row.each do |col|
    			print "|"
    			if col.nil?
    				print " "
    			else
    				print col
    			end
    		end
    		print "|"
    		puts
    		puts "--+-+--"
    	end

    end
end


class Game

	attr_writer :in_play

	WINS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

	def initialize(player1, player2)
		@currboard = Board.new(self)
		@player1 = player1
		@player2 = player2
		new_game
	end

	def new_game
		puts "New game started."
		@in_play = true
		@current_player = @player1
		@other_player = @player2

		turn
	end

	def turn
		while @in_play
			get_input(@current_player)
		end
	end

	def get_input(player)
		unless @currboard.board.flatten.any? {|position| position.nil?}
			puts "Board is full. Game over."
			@in_play = false
		else
			puts "#{player.name}, enter a row number (1-3):"
			row = get_num - 1

			puts

			puts "#{player.name}, enter a col number (1-3):"
			col = get_num - 1

			@currboard.update(player, row, col)
		end
	end

	def get_num
		begin
			num = gets.chomp
			raise puts "Number must be between 1 to 3" unless [1, 2, 3].include?(num.to_i)
		rescue
			# puts "Number must be between 1 to 3"
			retry
		else
			return num.to_i

		end
	end

	def won?(player)
		return WINS.any? do |line|
        	line.all? {|position| @currboard.board.flatten[position - 1] == player.symbol}
        end
    end

    def switch_players
    	@current_player, @other_player = @other_player, @current_player
    end

end


Game.new(Player.new({symbol: "o", number: 1}), Player.new({symbol: "x", number: 2}))


