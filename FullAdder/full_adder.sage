load('DGHV.sage')




def full_adder(dghv_inst, ca, cb, carryenc):
    #ca = dghv_inst.enc(bit_a)
    #cb = dghv_inst.enc(bit_b)
    #carryenc = dghv_inst.enc(carry)

    # Sum the numberes
    axorb = dghv_inst.add(ca, cb)
    soma = dghv_inst.add(axorb, carryenc)

    # Carry out of the sum
    # Carryout = (A AND B) XOR (Carryin AND (A XOR B))
    a_and_b = dghv_inst.mult(ca, cb)
    carry_and_axorb = dghv_inst.mult(carryenc, axorb)
    carry_out = dghv_inst.add(a_and_b, carry_and_axorb)
    return soma, carry_out

def ripple_carry_adder(list_a, list_b, dghv_inst):
    if len(list_a) != len(list_b):
        raise ValueError("Numbers must have the same number of digits")
    
    # Starts carry with 0
    c_carry = dghv_inst.enc(0)

    # Create a list for the answer
    ans =[]

    for a,b in zip(reversed(list_a), reversed(list_b)):
        # Sum the numbers from the LSB to MSB
        ca = dghv_inst.enc(a)
        cb = dghv_inst.enc(b)
        
        s, c_carry = full_adder(dghv_inst, ca, cb, c_carry)
        c_carry = dghv_inst.bootstrap(c_carry)
        s = dghv_inst.bootstrap(s)
        ans.append(s)

    # The result was created in reversed so need to reverse it back
    return ans[::-1]

