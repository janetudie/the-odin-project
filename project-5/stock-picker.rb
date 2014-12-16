def stock_picker(stock)
	curr_profit = 0
	max_profit = 0
	days = []

	stock.each_with_index do |buy_price, buy_day|
		stock[buy_day...stock.length].each.with_index do |sell_price, sell_day|
			curr_profit = sell_price - buy_price
			if max_profit < curr_profit
				days[0] = buy_day
				days[1] = sell_day + buy_day
				max_profit = curr_profit
			end
			curr_profit = 0
		end
	end
	puts days.inspect
end

stock_picker([17,3,6,1,0,8,6,1,10])