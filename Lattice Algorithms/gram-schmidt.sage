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

#Test
v = [vector([1, 3, 2]), vector([4, 1, -2]), vector([-2, 1, 3])]
u = gram_schmidt(v)
assert u == [vector([1, 3, 2]), vector([53/14, 5/14, -17/7]), vector([56/285, -14/57, 77/285])]