# small helper method for addition or subtraction of locations

def vector_operation(a, b, sign = 1)
		[a[0] + sign * b[0], a[1] + sign * b[1]]
end
