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

def get_vals():
    #The inputs the user places
    dy = 50*10**18
    dx = 10*10**18

    #Prices
    pu = 5.1
    sqrt_pc = 2703324232521071249517405/2**80
    pl = 4.9

    #Ticks
    iu = math.log(math.sqrt(pu),math.sqrt(1.0001))
    ic = math.log(sqrt_pc,math.sqrt(1.0001))
    il = math.log(math.sqrt(pl),math.sqrt(1.0001))

    #Liquidities
    liq1 = dx*((math.sqrt(pu)*sqrt_pc)/(math.sqrt(pu)-sqrt_pc))
    liq2 = dy/(sqrt_pc - math.sqrt(pl))
    liq3 = dx*((math.sqrt(pu)*math.sqrt(1.0001**ic))/(math.sqrt(pu)-math.sqrt(1.0001**ic)))
    liq4 = dy/(math.sqrt(1.0001**ic) - math.sqrt(pl))

    #Mean liquidities
    liq = min(liq1,liq2, liq3, liq4)*0.9999

    #THESE ARE TO BE SHOWN IN THE FRONTEND
    # front_end_dx= liq*(math.sqrt(pu)-sqrt_pc)/(math.sqrt(pu)*sqrt_pc)
    # front_end_dy= liq*(sqrt_pc - math.sqrt(pl))
    
    return round(iu), round(il), liq, dx, dy

#Set Position
def set_pos(cfmm_address, iu, il, liq, dx, dy):
    cfmm = pytezos.contract(cfmm_address)
    set_pos = cfmm.set_position({
            "deadline": 1704398681,
            "liquidity": int(liq),
            "lower_tick_index": il,
            "lower_tick_witness": -1048575,
            "maximum_tokens_contributed": (int(dx), int(dy)),
            "upper_tick_index": iu,
            "upper_tick_witness": -1048575}
    )

    set_pos.send()
    return set_pos

'''
@Dev: Beggin test

'''
print('\n --------------- \n Set Position Within Price Range:\n --------------- \n' )

#Update operators to allow token usage by the contract
# update_ops(tokenx_address, tokeny_address, cfmm_address)
# time.sleep(20)

#Get ticks and liquidity vals 
(iu, il, liq, dx, dy)=get_vals()

#Set position
set_pos(cfmm_address, iu, il, liq, dx, dy)

