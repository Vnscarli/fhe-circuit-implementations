import pytest
from sage.all import *
import math


load('DGHV.sage')
load('full_adder.sage')

@pytest.fixture(scope="module")
def dghv_inst():
    rho = 15 
    eta = 160
    gamma = 2000
    return DGHV(gamma, eta, rho)

def get_noise_bits(dghv, ciphertext):
    noise = (ciphertext % dghv.p) 
    return float(log(noise, 2)) if noise > 0 else 0

@pytest.mark.parametrize("a, b, cin, expected_s, expected_cout", [
    (0, 0, 0, 0, 0),
    (0, 0, 1, 1, 0),
    (0, 1, 0, 1, 0),
    (0, 1, 1, 0, 1),
    (1, 0, 0, 1, 0),
    (1, 0, 1, 0, 1),
    (1, 1, 0, 0, 1),
    (1, 1, 1, 1, 1),
])
def test_full_adder_logic(dghv_inst, a, b, cin, expected_s, expected_cout):
   
    ca = dghv_inst.enc(a)
    cb = dghv_inst.enc(b)
    ccin = dghv_inst.enc(cin)
    
    s_enc, cout_enc = full_adder(dghv_inst, ca, cb, ccin)
    
    s_noise = get_noise_bits(dghv_inst, s_enc)
    c_noise = get_noise_bits(dghv_inst, cout_enc)
   
    print(f"\nCase ({a},{b},{cin}) -> Sum Noise: {s_noise:.2f} bits, Carry Noise: {c_noise:.2f} bits")
    
    assert dghv_inst.dec(s_enc) == expected_s, f"Sum failed for ({a},{b},{cin})"
    assert dghv_inst.dec(cout_enc) == expected_cout, f"Carry failed for ({a},{b},{cin})"