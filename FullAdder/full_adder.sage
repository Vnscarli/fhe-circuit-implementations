load('DGHV.sage')

dghv = DGHV(2000, 160, 15)


def full_adder(dghv, ca, cb, carryenc):
    #ca = dghv.enc(bit_a)
    #cb = dghv.enc(bit_b)
    #carryenc = dghv.enc(carry)

    # Sum the numberes
    axorb = dghv.add(ca, cb)
    soma = dghv.add(axorb, carryenc)

    # Carry out of the sum
    # Carryout = (A AND B) XOR (Carryin AND (A XOR B))
    a_and_b = dghv.mult(ca, cb)
    carry_and_axorb = dghv.mult(carryenc, axorb)
    carry_out = dghv.add(a_and_b, carry_and_axorb)
    return soma, carry_out

def ripple_carry_adder(list_a, list_b):
    if len(list_a) != len(list_b):
        raise ValueError("Numbers must have the same number of digits")
    
    # Starts carry with 0
    c_carry = dghv.enc(0)

    # Create a list for the answer
    ans =[]

    for a,b in zip(reversed(list_a), reversed(list_b)):
        # Sum the numbers from the LSB to MSB
        ca = dghv.enc(a)
        cb = dghv.enc(b)
        
        s, c_carry = full_adder(dghv, ca, cb, c_carry)
        c_carry = dghv.bootstrap(c_carry)
        bootstrap_s = dghv.bootstrap(s)
        ans.append(bootstrap_s)

    # The result was created in reversed so need to reverse it back
    return ans[::-1]

byte_a = [0,0,0,0,1,0,1,1]
byte_b = [0,0,0,0,0,1,1,1]

sum_result = ripple_carry_adder(byte_a, byte_b)

# The sum is wrong, what happened here?
decoded_result = [dghv.dec(c) for c in sum_result]
print(f"Decrypted bits: {decoded_result}")