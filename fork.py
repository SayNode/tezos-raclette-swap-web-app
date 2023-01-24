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

#Swap y to x
def fork(cfmm_address):
    cfmm = pytezos.contract(cfmm_address)
    initial_storage = cfmm.storage()

    tx = pytezos.origination(cfmm.script(initial_storage)).send()
    print(tx)
fork(cfmm_address)