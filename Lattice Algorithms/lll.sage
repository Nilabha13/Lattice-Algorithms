#v and u are vectors; proj(v, u) returns projection of v on u
def proj(v, u):
	return (v*u)*u/(u.norm()**2)

#v is list of basis vectors
#u is list of orthogonal basis vectors
def gram_schmidt(v):
	dim = len(v)
	u = []
	for i in range(dim):
		ui = v[i]
		for j in range(i):
			ui -= proj(v[i], u[j])
		u.append(ui)
	return u

#basis is a basis (list of vectors) for the lattice
def lll(basis):
	k = 1
	while k < len(basis):
		orthogonal_basis = gram_schmidt(basis)
		for j in range(k-2, -1, -1):
			mu = basis[k] * orthogonal_basis[j] / (orthogonal_basis[j].norm()**2)
			basis[k] = basis[k] - round(mu)*basis[j] #Size Reduction
		mu = basis[k] * orthogonal_basis[k-1] / (orthogonal_basis[k-1].norm()**2)
		if orthogonal_basis[k].norm()**2 >= (0.75 - mu**2) * orthogonal_basis[k-1].norm()**2: #Lovasz Condition
			k += 1
		else:
			basis[k-1], basis[k] = basis[k], basis[k-1] #Swap step
			k = max(k-2, 1)
	return basis

#Test
M = [
vector([19, 2, 32, 46, 3, 33]),
vector([15, 42, 11, 0, 3, 24]),
vector([43, 15, 0, 24, 4, 16]),
vector([20, 44, 44, 0, 18, 15]),
vector([0, 48, 35, 16, 31, 31]),
vector([48, 33, 32, 9, 1, 29])
]
assert abs(matrix(M).determinant()) == abs(matrix(lll(M)).determinant())
