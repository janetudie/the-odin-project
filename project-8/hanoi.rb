
def move_disk(height, source, destination)
	puts "Moving disk #{height} from #{source} to #{destination}"
end


def hanoi(height, source = 'A', destination = 'C', via = 'B')
	if height >= 1
		hanoi(height-1, source, via, destination)
		move_disk(height, source, destination)
		hanoi(height-1, via, destination, source)
	end
end


hanoi(6)