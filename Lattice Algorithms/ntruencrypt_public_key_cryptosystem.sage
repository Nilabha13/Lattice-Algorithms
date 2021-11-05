import random

#Notes on keys:
#Public Parameters: N, p, q, d
#R is Z[x]/(x^N - 1); Rp = (Z/pZ)[x]/(x^N - 1); T(d1, d2) are ternary polynomials in R which have d1 coeffs equal to 1, d2 coeffs equal to -1, and all other coeffs equal to 0
#N, p, 1 are primes; gcd(p, q) = 1; gcd(N, q) = 1; q > (6d + 1)p
#f is an element of T(d+1, d) and invertible in both Rq and Rp
#g is an element of T(d, d)
#Fq = inverse(f, Rq); Fp = inverse(f, Rp)
#h = Fq * g in Rq
#Public Key: (h); Private Key: (f)

def gen_T(N, d1, d2):
	l = [1]*d1 + [-1]*d2 + [0]*(N-d1-d2)
	random.shuffle(l)
	
	P.<x> = ZZ[]
	R.<x> = P.quotient(x^N - 1)
	return R(l)

#Returns (pubkey, privkey)
def keygen(N, p, q, d):
	while True:
		f = gen_T(d+1, d)
		try:	
			P.<x> = GF(p)[]
			Rp.<x> = P.quotient(x^N - 1)
			Fp = Rp(f)^(-1)

			P.<x> = GF(q)[]
			Rq.<x> = P.quotient(x^N - 1)
			Fq = Rq(f)^(-1)
			break
		except:
			pass

	g = gen_T(d, d)
	
	P.<x> = GF(q)[]
	Rq.<x> = P.quotient(x^N - 1)
	h = Fq * Rq(g)

	return (h, f)

#m is the center-lift of a polynomial in Rp to R
#Returns a polynomial in Rq
def encrypt(N, p, q, d, pubkey, m):
	h = pubkey
	r = gen_T(d, d)

	P.<x> = GF(q)[]
	Rq.<x> = P.quotient(x^N - 1)
	return p * Rq(r) * Rq(h) + Rq(m)

#e is the ciphertext polynomial in Rq
def decrypt(N, p, q, d, pubkey, privkey, e):
	h = pubkey
	f = privkey

	P.<x> = GF(p)[]
	Rp.<x> = P.quotient(x^N - 1)
	Fp = Rp(f)^(-1)

	P.<x> = GF(q)[]
	Rq.<x> = P.quotient(x^N - 1)
	a = Rq(f) * e

	P.<x> = ZZ[]
	R.<x> = P.quotient(x^N - 1)
	a = R(ZZ['x']([coeff.lift_centered() for coeff in a.lift()]))
		
	P.<x> = GF(p)[]
	Rp.<x> = P.quotient(x^N - 1)
	m = Fp * Rp(a)

	P.<x> = ZZ[]
	R.<x> = P.quotient(x^N - 1)
	m = R(ZZ['x']([coeff.lift_centered() for coeff in m.lift()]))

	return m




#Test 1
N, p, q, d = 7, 3, 41, 2

P.<x> = ZZ[]
R.<x> = P.quotient(x^N - 1)
f = R(x^6 - x^4 + x^3 + x^2 - 1)
g = R(x^6 + x^4 - x^2 - x)

P.<x> = GF(p)[]
Rp.<x> = P.quotient(x^N - 1)
Fp = Rp(f)^(-1)

P.<x> = GF(q)[]
Rq.<x> = P.quotient(x^N - 1)
Fq = Rq(f)^(-1)
h = Fq * Rq(g)

P.<x> = ZZ[]
R.<x> = P.quotient(x^N - 1)
m = R(-x^5 + x^3 + x^2 - x + 1)
r = R(x^6 - x^5 + x - 1)

P.<x> = GF(q)[]
Rq.<x> = P.quotient(x^N - 1)
e = p * Rq(r) * Rq(h) + Rq(m)
assert e == Rq(31*x^6 + 19*x^5 + 4*x^4 + 2*x^3 + 40*x^2 + 3*x + 25)

assert decrypt(N, p, q, d, h, f, e) == m