# tezos_swap_frontend

A tezos Swap

## Guide to testing

Tests have to be done manually as there is no practical way to test interactions with the Blockchain, since we do all signing of transactions with the Temnple wallet extension.

### Requirements
Flutter and a way to run flutter in chrome.
Temple Wallet extension.
Import this Private key into the wallet: edskS1TVJqsCXgYSEEiNrv8GDwpresD4FL49ipZErZ1mH9itZNSXfEnykvzLWyQVpVLsU69KvgtBTteCXfc9ZUpuAJg61zoUTW
This wallet has some tezos for fees as well as 2 test tokens, Token X and Token Y, which are used by the contract.

Make sure in the main file that home leads to TestWalletInteraction().

After runing the application in the chrome emulator you will have to copy the url in a real chrome browser, as the emulator does not have the extensions


### Test page

On the test page youz are presented with 4 Buttons.

First is Connect wallet, you have to be connected for any other button to work.

Second is set_position. This sets a position with range 1-20 with 100 x and 100 y.

Third and forth is swap x to y and swap y to x respectively
