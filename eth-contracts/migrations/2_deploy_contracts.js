// migrating the appropriate contracts
var ERC721MintableComplete = artifacts.require("./ERC721MintableComplete.sol");
var verifier = artifacts.require("./verifier.sol");
// var SolnSquareVerifier = artifacts.require("./SolnSquareVerifier.sol");

module.exports = async (deployer) => {
  await deployer.deploy(ERC721MintableComplete, "Polaris", "POL");
  await deployer.deploy(verifier);
  // await deployer.deploy(SolnSquareVerifier, verifier.address, "Polaris", "POL");
};
