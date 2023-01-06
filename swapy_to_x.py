from pytezos import pytezos
from decouple import config
import json
import time

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
def swap_ytox(cfmm_address, wallet_address):
    cfmm = pytezos.contract(cfmm_address)
    ytox = cfmm.y_to_x({
            "deadline": 1704398681,
            "dy": int(0.005*decimals),
            "min_dx": int(0.0009*decimals),
            "to_dx": wallet_address
 }
    )

    ytox.send()
    return ytox


#Get users token balance
def token_balances(wallet_address, tokenx_address, tokeny_address):
    tokenx = pytezos.contract(tokenx_address)
    tokeny = pytezos.contract(tokeny_address)
    balance_x = tokenx.balance_of(
        requests= [{'owner': wallet_address, 
        'token_id': 0}],
        callback=None
    ).callback_view()
    balanceX = int(balance_x[0]['balance'])

    balance_y = tokeny.balance_of(
        requests= [{'owner': wallet_address, 
        'token_id': 0}],
        callback=None
    ).callback_view()
    balanceY = int(balance_y[0]['balance'])

    return balanceX, balanceY



'''
Main
'''
print('\n --------------- \n Swap y to x:\n --------------- \n' )
(balanceX_before, balanceY_before) = token_balances(wallet_address, tokenx_address, tokeny_address)
print('The balance of the wallet address', wallet_address, 'is', balanceX_before)
print('The balance of the wallet address', wallet_address, 'is', balanceY_before)

swap_ytox(cfmm_address, wallet_address)
time.sleep(30)

(balanceX_after, balanceY_after) = token_balances(wallet_address, tokenx_address, tokeny_address)
print('The balance of the wallet address', wallet_address, 'is', balanceX_after)
print('The balance of the wallet address', wallet_address, 'is', balanceY_after)
print('Change in X token balance:',(balanceX_before - balanceX_after)/(10**18))
print('Change in Y token balance:',(balanceY_before - balanceY_after)/(10**18))
print('Y/X=',((balanceY_before - balanceY_after)/(balanceX_before - balanceX_after)))

