def fibs(number)
	curr_fib = 0
	next_fib = 1
	while number > 1 do
		temp = curr_fib + next_fib
		curr_fib = next_fib
		next_fib = temp
		number -= 1
	end
	return next_fib
end


def fibs_rec(number)
	if number <= 2
		return number - 1
	else
		return fibs_rec(number - 1) + fibs_rec(number - 2)
	end
end



def merge(left, right, sorted = [])
	while left.size > 0 && right.size > 0
		if left[0] < right[0]
			sorted << left.shift
		else
			sorted << right.shift
		end
	end

	sorted.concat(left).concat(right)
end

def merge_sort(arr)
	if arr.size <= 1
		return arr
	else
		left, right = merge_sort(arr[0..arr.size/2-1]), merge_sort(arr[arr.size/2..-1])
		return merge(left, right)
	end
end


arr = [3, 1, 23, 15]
puts merge_sort(arr)

# puts merge_sort([3, 1, 23, 15])