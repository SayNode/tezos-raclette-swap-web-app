## Backend/Deployment
- Read and understand the Uniswap V3 whitepaper and the Segmented CFMM specification;
- Understand the parallels between the previous two in terms of implementation;
- Understand the compilation process of this specific contract;
- Learn the basics of the Ligo language (more specifically the CameLIGO variant) in order to understand the code;
- Changed the mligo files to the update versions of the Tezos native commands (https://ligolang.org/docs/language-basics/tezos-specific/);
- Understand the different code files in the "ligo" folder and the variable types and entrypoints within them;
- Understand and install the SmartPy CLI for easy deployment;
- Deploy two tokens (FA2) to test the contract;
- Initial basic testing of the entrypoints using Better Call Dev;
- Get the errors provided in the temple wallet "details", see what the identifying int is, look it up in the error.mligo file and then search where that error occurred in the other files in order to understand what is being done incorrectly;
- Understand how/where the different values are stored in the contract storage; 
- Understand what values are valuable to display in the front-end to the users;
- Understand how to retrieve those values from storage to be used in the front-end;
- Understand how to use those values in user friendly front-end (for example, how to allow the user to specify the price interval he wants instead of the ticks, and then convert that price range to tick range and feed it to the contract call);


## Frontend
- Read and understand how to communicate with temple wallet, as there is no flutter library for it;
- Understand the inputs needed for the entrypoints so i can provide the correct inputs;
- Learn how to retirieve data needed for the frontend from smart contract storage;
- Get the errors provided in the temple wallet "details", see what the identifying int is, look it up in the error.mligo file and then search where that error occurred in the other files in order to understand what is being done incorrectly;