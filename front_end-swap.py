from pytezos import pytezos
from decouple import config
import json
import time
import math

priv_key = config('priv_key')

pytezos = pytezos.using(shell='https://ghostnet.tezos.marigold.dev/', 
                        key=priv_key)

#Variable
decimals = 10**18
#Import contracts
tokenx_address = 'KT1AR4CSxb15uFKacgKDGmPDSSvBLZ5m1Fz7'
tokeny_address = 'KT1V6MLV1xN5yMhaF3jywm87Y4Vqi5fiPpxA'
cfmm_address=config('cfmm_address')
wallet_address='tz1eLA1kphjGGVP7iSABmEw5U7YChT88RZSW'

def price_to_tick(p):
    return math.floor(math.log(p, 1.0001))

q80 = 2**80
def price_to_sqrtp(p):
    return int(math.sqrt(p) * q80)

def liquidity0(amount, pa, pb):
    if pa > pb:
        pa, pb = pb, pa
    return (amount * (pa * pb) / q80) / (pb - pa)

def liquidity1(amount, pa, pb):
    if pa > pb:
        pa, pb = pb, pa
    return amount * q80 / (pb - pa)

def calc_amount0(liq, pa, pb):
    if pa > pb:
        pa, pb = pb, pa
    return int(liq * q80 * (pb - pa) / pa / pb)


def calc_amount1(liq, pa, pb):
    if pa > pb:
        pa, pb = pb, pa
    return int(liq * (pb - pa) / q80)

def calc_amount0(liq, pa, pb):
    if pa > pb:
        pa, pb = pb, pa
    return int(liq * q80 * (pb - pa) / pa / pb)


def calc_amount1(liq, pa, pb):
    if pa > pb:
        pa, pb = pb, pa
    return int(liq * (pb - pa) / q80)

#Swap x to y
def swap_xtoy(cfmm_address):
    cfmm = pytezos.contract(cfmm_address)

    #Fee of the swap
    fee = 0.001
    #Amout of token we are inputting
    amount_in = 1*10**18

    #Current status of the pool
    sqrtp_cur = 2703324232521071249517405
    liq = 2217758416937709731840

    print(f"\nSelling {amount_in/10**18} X")

    #Calculate the price that it will be after the swap
    price_next = int((liq * q80 * sqrtp_cur) // (liq * q80 + amount_in * sqrtp_cur))

    print("New price:", (price_next / q80) ** 2)
    print("New sqrtP:", price_next)
    print("New tick:", price_to_tick((price_next / q80) ** 2))

    #Recalculate the amount in and amount out of tokens
    amount_in = calc_amount0(liq, price_next, sqrtp_cur)
    amount_out = calc_amount1(liq, price_next, sqrtp_cur)

    print("X in:", amount_in / 10**18)
    print("Y out:", amount_out / 10**18)
    print("In/Out=",amount_in/amount_out,'which should be bigger than the price')

    xtoy = cfmm.x_to_y({
            "deadline": 1704398681,
            "dx": int(amount_in),
            "min_dy": int(amount_out-amount_out*fee),
            "to_dy": wallet_address
    })
    xtoy.send()
    return xtoy

#Swap y to x
def swap_ytox(cfmm_address):
    cfmm = pytezos.contract(cfmm_address)

    #Fee
    fee = 0.001

    #Amount of token in
    amount_in = 5*10**18

    #Current status of the pool
    sqrtp_cur = 2703324232521071249517405
    liq = 2217758416937709731840

    #Get the price after swap
    price_diff = (amount_in * q80) / liq
    price_next = sqrtp_cur + price_diff
    print("New price:", (price_next / q80) ** 2)
    print("New sqrtP:", price_next)
    print("New tick:", price_to_tick((price_next / q80) ** 2))

    #Recalculate the amount in and amount out of tokens
    amount_in = calc_amount1(liq, price_next, sqrtp_cur)
    amount_out = calc_amount0(liq, price_next, sqrtp_cur)

    print("Y in:", amount_in / 10**18)
    print("X out:", amount_out / 10**18)
    print("In/Out=",amount_in/amount_out, 'which should be bigger than 1/P')

    ytox = cfmm.y_to_x({
            "deadline": 1704398681,
            "dy": int(amount_in),
            "min_dx": int(amount_out*(1-fee)),
            "to_dx": wallet_address
    })

    ytox.send()
    return ytox

# swap_xtoy(cfmm_address)
# print('\n\n\n')

swap_ytox(cfmm_address)