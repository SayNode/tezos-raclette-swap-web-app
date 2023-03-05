# Using the Website
There are 3 different sections of the web app:
1. The swap area: allows the user to choose two tokens (red) and trade between them;

2. The manage positions area: where the user can check the all the positions he currently has (green) and even remove them (blue). He can also set a new position (red);
3. The new position zone: where the user can choose two tokens (red), the pool fee tier he wants, if it exists (green), and the price range in which he whishes to deposit liquidity (purple)

 
# Tezos_swap_frontend

A V3 style swap on Tezos

## Guide to testing

Tests have to be done manually as there is no practical way to test interactions with the blockchain, since we do all signing of transactions with the Temple wallet extension.

### Requirements
1. Flutter and a way to run flutter in chrome.
2. Temple Wallet extension.

Import this private key into the wallet: edskS1TVJqsCXgYSEEiNrv8GDwpresD4FL49ipZErZ1mH9itZNSXfEnykvzLWyQVpVLsU69KvgtBTteCXfc9ZUpuAJg61zoUTW
This wallet has some tezos for fees as well as 2 test tokens, Token X and Token Y, which are used by the contract.

Make sure in the main file that home leads to TestWalletInteraction().

After runing the application in the chrome emulator you will have to copy the url in a real chrome browser, as the emulator does not have the required extensions


### Test page

On the test page you are presented with 4 buttons.

First is Connect wallet, you have to be connected for any other button to work.

Second is set_position. This sets a position with range 1-20 with 100 x and 100 y.

Third and forth is swap x to y and swap y to x respectively

# Tezos_swap_contracts

## Compile and deploy the contract
## To start:
- To compile to Michelson the contract code and/or its storage, you'll need to have the [ligo executable](https://ligolang.org/docs/intro/installation/?lang=jsligo) installed;
- You'll need the [stack tool](https://docs.haskellstack.org/en/stable/) installed, see The Haskell Tool Stack tutorial for instructions on how to obtain it;
- For deployment and contract interaction, you'll need the [smartpy-cli](https://smartpy.io/docs/cli/) for deployment;

## Compile variables

- `x_token_type`: contract type of the `x` token, can be either [`FA1.2`][fa1.2] or [`FA2`][fa2].
- `y_token_type`: contract type of the `y` token, can be either [`FA1.2`][fa1.2], [`FA2`][fa2], or [`CTEZ`][ctez].
- `fee_bps`, a fraction determining how much of the tokens sent in a swap will
  be subtracted beforehand, see [fees](#fees) for more info.
- `ctez_burn_fee_bps`, a percentage to be subtracted from the `CTEZ` tokens being
  deposited/withdrawn on every swap.
  See [fees](#fees) for more info.
  This option is only valid when the `y_token_type` is `CTEZ`.
- `x_token_address` the `address` of the contract holding the `x` token.
- `y_token_address` the `address` of the contract holding the `y` token.
- `x_token_id` the [`FA2`][fa2] `token_id` for the `x` token.
  This option is only valid when the `x_token_type` is `CTEZ` or `FA2`.
- `y_token_id` the [`FA2`][fa2] `token_id` for the `y` token.
  This option is only valid when the `y_token_type` is `CTEZ` or `FA2`
## Compile:
1. Here you should replace the FA2 for FA1 or other types depending on the token in case:
```
make out/segmented_cfmm_default.tz \
  x_token_type=FA2 \
  y_token_type=FA2
```
2. Replace with the correct token names and decimals.
```
make out/metadata_map \
  x_token_symbol=TX \
  x_token_name="TokenX" \
  x_token_decimals=18 \
  y_token_symbol=TY \
  y_token_name="TokenY" \
  y_token_decimals=18
```
3. Replace correct token addresses and the other contract details as you like
```
make out/storage_default.tz \
  fee_bps=3 \
  ctez_burn_fee_bps=3 \
  x_token_id=0 \
  y_token_id=0 \
  x_token_address=KT1NproXvHrDfc7NHyzGJhHVLf4ZMGz8pkae \
  y_token_address=KT18suWgCHADCLkywTKD3pXg6ARHiw1YxWBq \
  tick_spacing=1 \
  init_cumulatives_buffer_extra_slots=0 \
  metadata_map="$(cat out/metadata_map)"
```
## Deploy:
- Deploying to the testnet (ghostnet):
```
smartpy originate-contract --code out/segmented_cfmm_default.tz --storage out/storage_default.tz --rpc https://ghostnet.tezos.marigold.dev/
```
