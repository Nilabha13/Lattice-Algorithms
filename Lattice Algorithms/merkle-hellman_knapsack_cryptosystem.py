from Crypto.Util.number import *

#Note on keys:
#A superincreasing sequence r is defined as <r1, r2, r3, ..., rn> where r(i+1) >= 2*ri
#gcd(A, B) = 1; B > 2*rn
#Mi = A*ri (mod B); M = <M1, M2, ..., Mn>
#Public Key: M; Private Key: r, A, B
#Public Key: (M); Private Key: (r, A, B)

def gen_pubkey(privkey):
	r, A, B = privkey
	M = []
	for i in range(len(r)):
		M.append((A * r[i])%B)
	return M

#Plaintext: x
def encrypt(pubkey, x):
	M = pubkey
	S = 0
	x = [int(c) for c in bin(x)[2:]][::-1]
	for i in range(min(len(M), len(x))):
		S += x[i]*M[i]
	return S

def decrypt(pubkey, privkey, S):
	M = pubkey
	r, A, B = privkey
	S_prime = (inverse(A, B) * S)%B
	x = [0]*len(r)
	for i in range(len(r)-1, -1, -1):
		if S_prime >= r[i]:
			x[i] = 1
			S_prime -= r[i]
	return int(''.join(map(str, x))[::-1], 2)



#Test 1
r = [3, 11, 24, 50, 115]
A = 113
B = 250
privkey = (r, A, B)
pubkey = gen_pubkey(privkey)
assert pubkey == [89, 243, 212, 150, 245]

x = 21
assert decrypt(pubkey, privkey, encrypt(pubkey, x)) == x