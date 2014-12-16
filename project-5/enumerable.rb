module Enumerable
    def my_each
        for i in (0...self.length)
        	yield(self[i])
        end
    end

    def my_each_with_index
        for i in (0...self.length)
        	yield(self[i], i)
        end
    end

    def my_select
    	new_array = []
    	self.my_each do |x|
    		if yield(x)
    			new_array << x
    		end
    	end

    	new_array
    end

    def my_all?
    	self.my_each do |x|
    		unless yield(x)
    			return false
    		end
    	end
    	true
    end

    def my_none?
    	self.my_each do |x|
    		if yield(x)
    			return false
    		end
    	end
    	true
    end

    def my_count
    	count = 0
    	self.my_each do |x|
    		if yield(x)
    			count += 1
    		end
    	end
    	count
    end

	def my_map(proc = nil)
    	new_array = []

    	if block_given? && proc
    		self.my_each do |x|
    			new_array << proc.call(yield(x))
    		end
    	elsif proc
    		self.my_each do |x|
    			new_array << proc.call(x)
    		end
    	else
    		self.my_each do |x|
    			new_array << yield(x)
    		end
    	end
    	new_array
	end

	def my_inject
		result = self[0]
		for i in (0...self.length - 1) do
			result = yield(result, self[i+1])
		end
		result
	end

end

