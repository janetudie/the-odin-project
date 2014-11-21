def add(x, y)
	x + y
end

def subtract(x, y)
	x - y
end

def sum(array)
	if array == []
		0
	else
		array.inject(:+)
	end
end

def multiply(*numbers)
	product = 1
	numbers.each do |x|
		product *= x
	end
	product

end


def power(x, y)
	x ** y
end

def factorial(x)
	if x == 0
		factorial = 0
	else
		factorial = 1
		until x == 1
			factorial *= x
			x -= 1
		end
	end
	factorial
end
