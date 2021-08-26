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
7. Mint tokens using [MyEtherWallet](https://www.myetherwallet.com/) and verify the tokens on [OpenSea](https://testnets.opensea.io/) marketplace.

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

![image](https://user-images.githubusercontent.com/29313947/131018797-65162a1c-d062-4e4c-bb23-d428e52207e9.png)

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

![image](https://user-images.githubusercontent.com/29313947/131013258-fff46af0-ce64-4150-9b65-a2bf6e4e8741.png)

![image](https://user-images.githubusercontent.com/29313947/131013461-2b65f6b2-f494-4caa-b0ea-dabc3e275144.png)

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

Here is an example of the smart contract in the blockchain and the transactions on Rinkeby. You can see the contract ABI on **./abi.json**.

Etherscan info:

- Transaction: [**0x4aa191ef9227cf254006b23e66a5c058f0418e8fcfc83e3feecea238c40b9cf6**](https://rinkeby.etherscan.io/tx/0x4aa191ef9227cf254006b23e66a5c058f0418e8fcfc83e3feecea238c40b9cf6)

![image](https://user-images.githubusercontent.com/29313947/131010995-57008276-6dd1-4993-8fbc-57b5997d4f04.png)

- Token: [**0xd17eb6e75a6a67b0d00d2572bd3b0045cf71bafa**](https://rinkeby.etherscan.io/token/0xd17eb6e75a6a67b0d00d2572bd3b0045cf71bafa?a=1)

![image](https://user-images.githubusercontent.com/29313947/131011036-650df4bc-401f-41d9-8bc5-937ee92ab4e3.png)

- Mint tokens:

![image](https://user-images.githubusercontent.com/29313947/131042428-843d6a58-3cbd-4cfd-bf4f-1a991f785ba1.png)

**OpenSea Storefront: [https://testnets.opensea.io/konig-estate-marketchain](https://testnets.opensea.io/konig-estate-marketchain)**

![image](https://user-images.githubusercontent.com/29313947/131040732-f11e8b21-3cd2-4cb7-a9e9-2a0f6c8ecde0.png)

![image](https://user-images.githubusercontent.com/29313947/131040778-1594d8a4-f1bb-41f1-9361-1c1f7cd91277.png)

**One of the estates: [https://testnets.opensea.io/assets/0x052a650b979a8515b15b74ac7de31df8ece532ed/0](https://testnets.opensea.io/assets/0x052a650b979a8515b15b74ac7de31df8ece532ed/0)**

**Selling process:**

![image](https://user-images.githubusercontent.com/29313947/131048757-c25ae87a-0813-48ec-9d09-8985645814a6.png)

![image](https://user-images.githubusercontent.com/29313947/131048765-60de4e36-6973-4cb8-a6b9-eea556db38e1.png)

![image](https://user-images.githubusercontent.com/29313947/131048778-603fdd19-009d-4759-b978-1f28828e8f29.png)

![image](https://user-images.githubusercontent.com/29313947/131048844-6e535995-77eb-411c-87b3-180f2a2c9e11.png)

![image](https://user-images.githubusercontent.com/29313947/131048867-b7aaa258-5a8c-4646-ae21-535de3951b3b.png)

![image](https://user-images.githubusercontent.com/29313947/131048896-312c1edc-0f74-44f4-9269-8c3d6c8bba2f.png)

![image](https://user-images.githubusercontent.com/29313947/131048913-dbc3dccf-0870-458a-a55c-cc5f93f6fae8.png)
