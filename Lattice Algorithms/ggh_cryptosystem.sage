import random

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

#m is a vector; perturbation vector r's coordinates would be chosen strictly between -delta and +delta
def encrypt(pubkey, m, delta=10):
	W = matrix(pubkey)
	r = vector([random.randrange(-delta+1, delta) for _ in range(W.nrows())])
	return m * W + r

#e is a vector
def decrypt(pubkey, privkey, e):
	W, V = matrix(pubkey), matrix(privkey)
	v = babai_cv(V, e)
	return v * W.inverse()




#Test 1
v1 = vector([-97, 19, 19])
v2 = vector([-36, 30, 86])
v3 = vector([-184, -64, 78])
V = [v1, v2, v3]
w1 = vector([-4179163, -1882253, 583183])
w2 = vector([-3184353, -1434201, 444361])
w3 = vector([-5277320, -2376852, 736426])
W = [w1, w2, w3]
m = vector([86, -35, -32])
r = vector([-4, -3, 2])
e = m * matrix(W) + r
assert e == vector([-79081427, -35617462, 11035473])

assert decrypt(W, V, e) == m