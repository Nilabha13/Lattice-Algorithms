#basis is a basis (list of vectors) for the lattice; w is the vector whose CVP is to be sovled
def babai_cv(basis, w):
	basis_matrix = Matrix(basis)
	t = w * basis_matrix.inverse()
	for i in range(len(t)):
		t[i] = round(t[i])
	return t * basis_matrix



#Test 1
v1 = vector([137, 312])
v2 = vector([215, -187])
w = vector([53172, 81743])
basis = [v1, v2]
assert babai_cv(basis, w) == vector([53159, 81818])


#Test 2
v1 = vector([1975, 438])
v2 = vector([7548, 1627])
w = vector([53172, 81743])
basis = [v1, v2]
assert babai_cv(basis, w) == vector([56405, 82444])