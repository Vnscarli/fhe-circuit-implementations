# Auxiliary functions required for the DGHV scheme
def sample_q(gamma, eta):
    #Random large number
    return ZZ.random_element(0, 2^(gamma - eta))

def sample_r(rho):
    #Noise
    return ZZ.random_element(-2^rho + 1, 2^rho)

def sym_mod(c, p):
    #Guarantee that the answer is clear, with less noise
    res = c % p
    if res > p // 2:
        res -= p
    return res

class DGHV:
    def __init__(self, gamma, eta, rho, t=2, p=1):
        assert (gamma > eta)
        assert (eta > rho)
        
        if p ==1:
            #If p is not given, generate p
            p = random_prime(2^eta, lbound=2^(eta - 1))
        else: 
            #in case p is given, check if valid
            assert (eta -1 <= p.nbits () <= eta)
        self.gamma = gamma
        self.eta = eta
        self.rho = rho
        self.t = t
        self.p = p
        
        self.x0 = self.p * sample_q(gamma, eta)

        #Genarate rings
        self.Zp = ZZ. quotient (p)
        self.Zx0 = ZZ. quotient (self.x0)
        
    def enc(self, m):
        q = sample_q(self.gamma, self.eta)
        r = sample_r(self.rho)
        # c = p*q + t*r + m
        c = self.p * q + self.t * r + m
        return c % self.x0

    def dec(self, c):
        noisy_msg = sym_mod(c, self.p)
        return noisy_msg % self.t
    
    def not_gate(self, c):
        # NOT x is (1-x)
        return (self.enc(1) - c) % self.x0

    def add(self, c1, c2):
        return (c1 + c2) % self.x0

    def mult(self, c1, c2):
        return (c1 * c2) % self.x0


gamma, eta, rho = 2000, 160, 15
dghv = DGHV(gamma, eta, rho)

def comparison(dghv, n=3):
    m0 = ZZ.random_element(0, 2^n)
    m1 = ZZ.random_element(0, 2^n)
    
    print(f"m0={m0} e m1={m1}")
    
    bits0 = m0.digits(base=2, padto=n)
    bits1 = m1.digits(base=2, padto=n)
    
    c0 = [dghv.enc(bi) for bi in bits0]
    c1 = [dghv.enc(bi) for bi in bits1]

   
    c = dghv.enc(1)
    
    for i in range(n):
        # XOR if equal, dec(add) = 0. If different, dec(add) = 1.
        diff = dghv.add(c0[i], c1[i])
        # Invert to give 1 if equal and 0 if different.
        eq_i = dghv.not_gate(diff)
        # Acumulator to check if the bits are equal, 
        #If stat with 1, all bits til now are equal
        c = dghv.mult(c, eq_i)
        
    ans = dghv.dec(c)
    print(f"Result decrypted: {ans}")
    
    if (m0 == m1) == ans:
        print("Sucesso! A comparação homomórfica funcionou.")
    else:
        print("Erro: O resultado não condiz com a realidade.")

comparison(dghv, n=3)