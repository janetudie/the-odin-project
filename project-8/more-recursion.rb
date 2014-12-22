def reverse(str)
	if str.length > 1
		str[0], str[-1] = str[-1], str[0]
		str[1..-2] = reverse(str[1..-2])
	end
	str
end

str = 'appalapachia'
puts reverse(str)

def palindrome(str)
	if str.empty? || str.size == 1 
		return true
	else
		return str[0] == str[-1] && palindrome(str[1..-2])
	end
end

pal = 'i amma i'
notpal = 'i amna i'
puts palindrome(notpal)