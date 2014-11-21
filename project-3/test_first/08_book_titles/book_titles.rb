def title(phrase)
	words = phrase.split(' ')
	words.each do |word|
		if word in ['the', 'and', 'over']
     		word
    	else
    		word.capitalize!
    	end
    end
    words[0].capitalize!
    words.join(' ')
end