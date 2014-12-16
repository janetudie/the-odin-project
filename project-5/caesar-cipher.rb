def caesar_cipher(phrase, shift)
	shifted_phrase = ''
	phrase.split('').each_with_index do |char, index|
		case char.ord
		when 97..122
			shifted_phrase += (97 + (char.ord - 97 + shift) % 26).chr
		when 65..90
			shifted_phrase += (65 + (char.ord - 65 + shift) % 26).chr
		else
			shifted_phrase += char
		end
	end

	puts shifted_phrase

end

		
caesar_cipher("Abc Defg!", 3)