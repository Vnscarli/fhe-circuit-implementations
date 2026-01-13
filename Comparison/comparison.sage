load('DGHV.sage')


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
        print("Success")
    else:
        print("Error")

comparison(dghv, n=3)