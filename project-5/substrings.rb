def substrings(word, dictionary)
	histogram = Hash.new(0)

	dictionary.each do |subs|
		if word.downcase.include? subs
			histogram[subs] += word.downcase.scan(subs).size 
		end
	end
	puts histogram.inspect
end

substrings("Howdy partner, sit down! How's it going?", ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"])
