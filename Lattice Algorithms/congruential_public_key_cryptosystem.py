from Crypto.Util.number import *
import random
from math import sqrt

#Returns (PublicKey(q, h), PrivateKey(f, g))
def key_gen():
	q = getPrime(512)
	while True:
		f = random.randrange(2, int(sqrt(q/2)))
		g = random.randrange(int(sqrt(q/4))+1, int(sqrt(q/2)))
		if GCD(f, q*g) == 1:
			break
	h = (inverse(f, q) * g)%q
	return ((q, h), (f, g))

#Returns ciphertext
def encrypt(pubkey, m):
	try:
		assert m < int(sqrt(q/4))
	except:
		raise Exception("Message too big!")
	q, h = pubkey
	r = random.randrange(1, int(sqrt(q/2)))
	e = (r * h + m)%q
	return e

#Returns plaintext
def decrypt(pubkey, privkey, e):
	q, h = pubkey
	f, g = privkey
	a = (f * e)%q
	b = (inverse(f, g) * a)%g
	return b



#Test 1
q = 122430513841
f = 231231
g = 195698
h = (inverse(f, q) * g)%q
assert (q, h) == (122430513841, 39245579300)

m = 123456
r = 101010
e = (r * h + m)%q
assert decrypt((q,h), (f, g), e) == m