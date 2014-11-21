def vowel? c
  vowels = ['a','e','i','o','u','y']
  vowels.include? c
end

def translate(s)
  s.split.map do |word|
    i = 0
    
    while not vowel? word[i,1]
      if ( word[i,2] == 'qu')
        i += 2
      else
        i += 1
      end
    end

    word[i..-1] + word[0,i] + 'ay'
  
  end.join(' ')

end