## Theory

- https://tezos.b9lab.com/smart-contracts
- https://smartpy.io/docs/
- https://smartpy.io/reference.html#_tests_and_scenarios
- https://smartpy.io/docs/cli/

## Commands

- ~/smartpy-cli/SmartPy.sh test ./contract/demo.py testOut
- ~/smartpy-cli/SmartPy.sh compile ./contract/demo.py compileOut
- ~/smartpy-cli/SmartPy.sh originate-contract --code ./compileOut/demo/step_000_cont_0_contract.json --storage ./compileOut/demo/step_000_cont_0_storage.json --rpc https://ghostnet.smartpy.io

## Flags

- --purge: Empty the output directory before writting to it.
