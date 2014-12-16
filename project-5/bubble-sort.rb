def bubble_sort(array)
	t = 2

	while t < (array.length) do
		(0..(array.length - t)).each do |i|
			if array[i] > array[i+1]
				 array[i+1], array[i] = array[i], array[i+1]
			end
		end
		t += 1
	end

	puts array.inspect
end

bubble_sort([4,3,78,2,0,2])

def bubble_sort_by(array)
	t = 2

	while t < (array.length) do
		(0..(array.length - t)).each do |i|
			if yield(array[i], array[i+1]) < 0
				 array[i+1], array[i] = array[i], array[i+1]
			end
		end
		t += 1
	end

	puts array.inspect
end


bubble_sort_by(["hi","hello","hey", "howdy", "piss off"]) do |left,right|
    right.length - left.length
end
