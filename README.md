# Ethereum DApp for Property Claim by mint tokens on a Real Estate Marketplace

### Introduction

This project consists in a decentralized application (DApp) for property claim by mint tokens on a real estate marketplace.

**Important**: The project was made with the versions below, since Truffle v5 comes with Solidity v0.5 with many changes concerning mutability and visibility.

- Truffle v5.4.7 (core: 5.4.7)
- Solidity v0.5.16 (solc-js)
- Ganache CLI v6.12.2 (ganache-core: 2.13.2)
- Node v13.14.0
- Web3.js v1.5.2

**Important**: The project didn't use any external **libraries** worth mentioning and also didn't use **IPFS** to host the frontend part decentralized as well.

### Getting Started

1. Clone this repository.
2. Install the dependencies with [NodeJS](https://nodejs.org/en/) and NPM, and also install [Docker](https://www.docker.com/) to manage containers (needed for ZoKrates).
3. Test the application making calls to the contract on the [Rinkeby Test Network](https://rinkeby.etherscan.io/).
4. Take a look at the transactions happening on the Rinkeby Test Network at [Etherscan](https://rinkeby.etherscan.io/) explorer.

### Dependencies

1. Create an [Ethereum](https://ethereum.org/en/) account. Ethereum is a decentralized platform that runs smart contracts.
2. Create an account and install the [Metamask](https://metamask.io/) extension on your web browser.
3. Create an [Infura](https://infura.io/) account to publish the contracts into the [Rinkeby Test Network](https://rinkeby.etherscan.io/).
4. Install [Truffle](https://www.trufflesuite.com/truffle) CLI. Truffle is the most popular development framework for Ethereum.
5. Use this passphrase with [Ganache](https://www.trufflesuite.com/ganache) command as a suggestion _"candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"_. Ganache is part of the Truffle suite that you can use to run a personal Ethereum blockchain.
6. Verify the contract with [ZoKrates](https://zokrates.github.io/). ZoKrates is a toolbox for zkSNARKs on Ethereum that helps you by generating verifiable computation proofs in Solidity from your DApp.
7. Mint tokens using [MyEtherWallet](https://www.myetherwallet.com/) and verify the tokens on [OpenSea](https://opensea.io/) marketplace.

**Important**: You will need your personal passphrase from your Ethereum account to publish into the Rinkeby Test Network, hence the **.secret** file in the **truffle-config.js**, even tough being a test network.

### Instructions

1. Install the dependencies:

```powershell
  npm i
  npm i -g ganache-cli
  npm i -g truffle
```

2. Turn on the Ganache suite so that you will have pre-defined accounts to test the contracts:

```powershell
  ganache-cli -m "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"
```

3. Compile, migrate and test the contracts with truffle (on a separate console). It will use the previously up and running ganache locally blockchain. Remember that the contracts are inside **./eth-contracts**. You can either test with a specific test file or just test all of them.

**Important**: I would suggest re-running ganache-cli if you are having trouble to migrate the contracts, so that ganache reset the network, all the gas used, and else, because it does help sometimes.

```powershell
  truffle compile
  truffle migrate
  truffle test ./test/TestERC721Mintable.js
  truffle test
```

4. Implement Zokrates to verify proof. By running the command below Docker wil install ZoKrates 0.3.0 version and open it's shell to generate the proof flow:

```powershell
  docker run -v [project folder]:/home/zokrates/code -ti zokrates/zokrates:0.3.0 /bin/bash
```

Inside ZoKrates shell run the commands below. Get on the square.code folder, compile and work on the flow untill you export the verifier.

```powershell
  cd code/zokrates/code/square
  ~/zokrates compile -i square.code
  ~/zokrates setup
  ~/zokrates compute-witness -a 3 9
  ~/zokrates generate-proof
  ~/zokrates export-verifier
```

You can then test both **TestSquareVerifier.js** and **TestSolnSquareVerifier.js** files to prove ZoKrates verifiable computation.

```powershell
  truffle test ./test/TestSquareVerifier.js
  truffle test ./test/TestSolnSquareVerifier.js
  truffle test
```

![image](https://user-images.githubusercontent.com/29313947/130992978-04f2e7bf-c77d-4e50-b442-a9a2e8e23a39.png)

5. Publish the contracts into the Rinkeby Test Network with your Infura key:

```powershell
  truffle migrate --reset --network rinkeby
```

### Output

Here is an example of the smart contract in the blockchain and the transactions on Rinkeby:

Etherscan info:

- Transaction ID: [**0x55e5601258cd5949fa231a7658777baf6bd6c35906ea6ce667a08b8170be4281**](https://rinkeby.etherscan.io/tx/0x55e5601258cd5949fa231a7658777baf6bd6c35906ea6ce667a08b8170be4281)
- Contract: [**0xd17eb6e75a6A67B0D00d2572bd3b0045CF71bafa**](https://rinkeby.etherscan.io/address/0xd17eb6e75a6a67b0d00d2572bd3b0045cf71bafa)
- ABI: **./abi.json**
