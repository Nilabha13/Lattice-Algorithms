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


#basis is a basis (list of vectors) for the lattice; t is the vector whose CVP is to be sovled
def babai_cp(basis, t):
	ortho_basis = gram_schmidt(basis)
	w = t
	for i in range(len(t)-1, -1, -1):
		w = w - round((w * ortho_basis[i]) / (ortho_basis[i].norm())^2) * basis[i]
	return t - w




#Test 1
v1 = vector([137, 312])
v2 = vector([215, -187])
t = vector([53172, 81743])
basis = [v1, v2]
assert babai_cp(basis, t) == vector([53159, 81818])
