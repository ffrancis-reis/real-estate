// Test if a new solution can be added for contract - SolnSquareVerifier
// Test if an ERC721 token can be minted for contract - SolnSquareVerifier
const expect = require("chai").expect;
const truffleAssert = require("truffle-assertions");

const Verifier = artifacts.require("Verifier");
const SolnSquareVerifier = artifacts.require("SolnSquareVerifier");
const proof = require("../../zokrates/code/square/proof.json");

contract("SolnSquareVerifier", (accounts) => {
  proofAsInt = {
    proof: {
      A: [
        web3.utils.toBN(proof.proof.A[0]).toString(),
        web3.utils.toBN(proof.proof.A[1]).toString(),
      ],
      A_p: [
        web3.utils.toBN(proof.proof.A_p[0]).toString(),
        web3.utils.toBN(proof.proof.A_p[1]).toString(),
      ],
      B: [
        [
          web3.utils.toBN(proof.proof.B[0][0]).toString(),
          web3.utils.toBN(proof.proof.B[0][1]).toString(),
        ],
        [
          web3.utils.toBN(proof.proof.B[1][0]).toString(),
          web3.utils.toBN(proof.proof.B[1][1]).toString(),
        ],
      ],
      B_p: [
        web3.utils.toBN(proof.proof.B_p[0]).toString(),
        web3.utils.toBN(proof.proof.B_p[1]).toString(),
      ],
      C: [
        web3.utils.toBN(proof.proof.C[0]).toString(),
        web3.utils.toBN(proof.proof.C[1]).toString(),
      ],
      C_p: [
        web3.utils.toBN(proof.proof.C_p[0]).toString(),
        web3.utils.toBN(proof.proof.C_p[1]).toString(),
      ],
      H: [
        web3.utils.toBN(proof.proof.H[0]).toString(),
        web3.utils.toBN(proof.proof.H[1]).toString(),
      ],
      K: [
        web3.utils.toBN(proof.proof.K[0]).toString(),
        web3.utils.toBN(proof.proof.K[1]).toString(),
      ],
    },
    input: proof.input,
  };

  describe("test addSolution", () => {
    before(async () => {
      this.VerifierContract = await Verifier.new({ from: accounts[0] });
      this.solnSquareVerifierContract = await SolnSquareVerifier.new(
        this.VerifierContract.address,
        "Polaris",
        "POL",
        { from: accounts[0] }
      );
    });

    it("should test if a new solution can be added for contract", async () => {
      let transaction = await this.solnSquareVerifierContract.addSolution(
        proofAsInt.proof.A,
        proofAsInt.proof.A_p,
        proofAsInt.proof.B,
        proofAsInt.proof.B_p,
        proofAsInt.proof.C,
        proofAsInt.proof.C_p,
        proofAsInt.proof.H,
        proofAsInt.proof.K,
        proofAsInt.input,
        { from: accounts[0] }
      );

      truffleAssert.eventEmitted(transaction, "SolutionAdded", (event) => {
        return (
          expect(Number(event._solutionIndex)).to.equal(0) &&
          expect(event._solutionAddress).to.equal(accounts[0])
        );
      });
    });
  });

  describe("test mintNewNft", () => {
    before(async () => {
      this.VerifierContract = await Verifier.new({ from: accounts[0] });
      this.solnSquareVerifierContract = await SolnSquareVerifier.new(
        this.VerifierContract.address,
        "Polaris",
        "POL",
        { from: accounts[0] }
      );
    });

    it("should test if an ERC721 token can be minted for contract", async () => {
      await this.solnSquareVerifierContract.addSolution(
        proofAsInt.proof.A,
        proofAsInt.proof.A_p,
        proofAsInt.proof.B,
        proofAsInt.proof.B_p,
        proofAsInt.proof.C,
        proofAsInt.proof.C_p,
        proofAsInt.proof.H,
        proofAsInt.proof.K,
        proofAsInt.input,
        { from: accounts[0] }
      );

      let transaction = await this.solnSquareVerifierContract.mintNewNft(
        proofAsInt.input[0],
        proofAsInt.input[1],
        accounts[2],
        {
          from: accounts[0],
        }
      );

      truffleAssert.eventEmitted(transaction, "Transfer", (event) => {
        return (
          expect(event.from).to.deep.equal(
            "0x0000000000000000000000000000000000000000"
          ) &&
          expect(event.to).to.equal(accounts[2]) &&
          expect(Number(event.tokenId)).to.equal(0)
        );
      });

      expect(await this.solnSquareVerifierContract.ownerOf(0)).to.equal(
        accounts[2]
      );
      expect(
        Number(await this.solnSquareVerifierContract.balanceOf(accounts[2]))
      ).to.equal(1);
      expect(await this.solnSquareVerifierContract.tokenURI(0)).to.deep.equal(
        "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/0"
      );
    });
  });
});
