#basis is a basis (list of vectors) for the lattice; w is the vector whose CVP is to be sovled
def babai_cv(basis, w):
	basis_matrix = Matrix(basis)
	t = w * basis_matrix.inverse()
	for i in range(len(t)):
		t[i] = round(t[i])
	return t * basis_matrix

#Note on keys:
#V is a list of "good" basis vectors for a lattice (i.e. a high Hadamard ratio)
#W is a list of "bad" basis vectors for the same lattice (i.e. a low Hadamard ratio)
#Public Key: (W); Private Key: (V)

#d is a vector
def sign(pubkey, privkey, d):
	W = matrix(pubkey)
	V = matrix(privkey)
	s = babai_cv(V, d)
	a = s * W.inverse()
	return a

#a is the signature; tolerance is the tolerable vector distance for the underlying CVP
def verify(pubkey, d, a, tolerance):
	W = matrix(pubkey)
	s = a * W
	if (s - d).norm() <= tolerance:
		return True
	else:
		return False




#Test 1
v1 = vector([-97, 19, 19])
v2 = vector([-36, 30, 86])
v3 = vector([-184, -64, 78])
V = [v1, v2, v3]
w1 = vector([-4179163, -1882253, 583183])
w2 = vector([-3184353, -1434201, 444361])
w3 = vector([-5277320, -2376852, 736426])
W = [w1, w2, w3]
d = vector([678846, 651685, 160467])
a = sign(W, V, d)
assert a == vector([1531010, -553385, -878508])

assert verify(W, d, a, 34.88) == False
assert verify(W, d, a, 34.90) == True