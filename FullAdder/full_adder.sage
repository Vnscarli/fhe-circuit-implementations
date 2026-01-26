load('DGHV.sage')



def full_adder(dghv, bit_a, bit_b, carry):
    ca = dghv.enc(bit_a)
    cb = dghv.enc(bit_b)
    carryenc = dghv.enc(carry)

    # Sum the numberes
    axorb = dghv.add(ca, cb)
    soma = dghv.add(axorb, carryenc)

    # Carry out of the sum
    # Carryout = (A AND B) XOR (Carryin AND (A XOR B))
    a_and_b = dghv.mult(ca, cb)
    carry_and_axorb = dghv.mult(carryenc, axorb)
    carry_out = dghv.add(a_and_b, carry_and_axorb)
    return soma, carry_out

