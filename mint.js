require("dotenv").config();

const CONTRACT_FILE = require("./eth-contracts/build/contracts/SolnSquareVerifier.json");
const NFT_ABI = CONTRACT_FILE.abi;

const MNEMONIC = process.env.MNEMONIC;
const INFURA_KEY = process.env.INFURA_KEY;
const OWNER_ADDRESS = process.env.OWNER_ADDRESS;
const NFT_CONTRACT_ADDRESS = process.env.NFT_CONTRACT_ADDRESS;
const NETWORK = process.env.NETWORK;

const HDWalletProvider = require("@truffle/hdwallet-provider");
const web3 = require("web3");

// const config = require("./mintConfig");

// const NETWORK = config.NETWORK;
// const NUM_TOKENS = 10;
const proof = [require("./zokrates/code/square/proof.json")];

if (!MNEMONIC || !INFURA_KEY || !OWNER_ADDRESS || !NETWORK) {
  console.error(
    "Please set a mnemonic, infura key, owner, network, and contract address."
  );
  return;
}

async function main() {
  const provider = new HDWalletProvider(
    MNEMONIC,
    `https://rinkeby.infura.io/v3/${INFURA_KEY}`
  );
  const web3Instance = new web3(provider);
  // console.log(provider);
  //if (NFT_CONTRACT_ADDRESS) {

  const nftContract = new web3Instance.eth.Contract(
    NFT_ABI,
    NFT_CONTRACT_ADDRESS,
    { gasLimit: "1000000" }
  );

  // Tokens minted directly to the owner.
  let tokenId = 0;
  //for (var i = 0; i < NUM_TOKENS; i++) {
  proof.forEach(async (proof) => {
    tokenId++;

    // await nftContract.methods
    //   .addSolution(
    //     proof.proof.A,
    //     proof.proof.A_p,
    //     proof.proof.B,
    //     proof.proof.B_p,
    //     proof.proof.C,
    //     proof.proof.C_p,
    //     proof.proof.H,
    //     proof.proof.K,
    //     proof.input
    //   )
    //   .send({ from: OWNER_ADDRESS, gas: 3000000 }, (error, result) => {
    //     if (error) {
    //       console.log(error);
    //     } else {
    //       console.log("Token added. Transaction: " + result);
    //     }
    //   });

    // await nftContract.methods
    //   .mintNewNft(proof.input[0], proof.input[1], OWNER_ADDRESS)
    //   .send({ from: OWNER_ADDRESS, gas: 3000000 }, (error, result) => {
    //     if (error) {
    //       console.log(error);
    //     } else {
    //       console.log("Minted Token. Transaction: " + result);
    //     }
    //   });

    await nftContract.methods
      .mint(OWNER_ADDRESS, tokenId)
      .send({ from: OWNER_ADDRESS, gas: 3000000 }, (error, result) => {
        if (error) {
          console.log(error);
        } else {
          console.log("Minted Token. Transaction: " + result);
        }
      });

    //}
    //}
  });
}

main();
