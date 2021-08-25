// migrating the appropriate contracts
var ERC721MintableComplete = artifacts.require("./ERC721MintableComplete.sol");
// var Verifier = artifacts.require("./verifier.sol");
// var SolnSquareVerifier = artifacts.require("./SolnSquareVerifier.sol");

module.exports = async (deployer) => {
  await deployer.deploy(ERC721MintableComplete, "Polaris", "POL");
  // await deployer.deploy(Verifier);
  // await deployer.deploy(
  //   SolnSquareVerifier,
  //   Verifier.address,
  //   "SS_ERC721MintableToken",
  //   "SS_721M"
  // );
};
