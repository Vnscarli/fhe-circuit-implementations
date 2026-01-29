import pytest
from sage.all import *


load('DGHV.sage')
load('full_adder.sage') 

@pytest.fixture(scope="module")
def dghv_inst():
    # DGHV parameters
    return DGHV(3000, 250, 20)

def int_to_bits(n, width=8):
    # Convert integet o bits
    return [int(b) for b in bin(n)[2:].zfill(width)]

def bits_to_int(bits):
    # Converts bits back to integers
    return int("".join(map(str, bits)), 2)

@pytest.mark.parametrize("val_a, val_b", [
    (11, 7),    
    (255, 1),   # Tests overflow
    (0, 0),    
    (128, 127), # 255
    (32, 56),
    (88, 243)
])
def test_8bit_ripple_carry_adder(dghv_inst, val_a, val_b):
    # function to test the ripple carry adder
    bits_a = int_to_bits(val_a)
    bits_b = int_to_bits(val_b)
    expected_sum = (val_a + val_b) % 256  # makes sure the output is 8 bits long
    
    # Run the adder
    encrypted_res_bits = ripple_carry_adder(bits_a, bits_b, dghv_inst)
    
    # Verification if code is working fine
    decrypted_bits = [dghv_inst.dec(c) for c in encrypted_res_bits]
    actual_sum = bits_to_int(decrypted_bits)
    
    # Asserts the value of the decrypted sum and the actual sum of the numbers mod 256
    assert actual_sum == expected_sum, f"Sum failed! Sum expected: {expected_sum}.Sum obtained: {actual_sum}"