def echo(word)
	word
end

def shout(word)
	word.upcase
end

def repeat(word, times = 2)
	([word] * times).join(' ')
end

def start_of_word(word, letters = 1)
	word[0...letters]
end

def first_word(phrase)
	phrase.split(' ')[0]
end

def titleize(phrase)
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