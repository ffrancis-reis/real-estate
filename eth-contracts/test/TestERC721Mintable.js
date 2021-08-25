var ERC721MintableComplete = artifacts.require("ERC721MintableComplete");

contract("TestERC721Mintable", (accounts) => {
  const account_one = accounts[0];
  const account_two = accounts[1];
  const account_three = accounts[2];

  describe("match erc721 spec", function () {
    beforeEach(async function () {
      // this.contract = await ERC721MintableComplete.new({ from: account_one });

      // TODO: mint multiple tokens
      this.polarisContract = await ERC721MintableComplete.new(
        "Polaris",
        "POL",
        {
          from: account_two,
        }
      );

      // this.drk = await ERC721MintableComplete.new("Draco", "DRK", {
      //   from: account_two,
      // });

      await this.polarisContract.mint(account_two, 0, { from: account_two });
      await this.polarisContract.mint(account_two, 1, { from: account_two });
      await this.polarisContract.mint(account_two, 2, { from: account_two });
    });

    it("should return total supply", async function () {
      let total = await this.polarisContract.totalSupply({ from: account_two });

      assert.equal(Number(total), 3, "wrong total supply value");
    });

    it("should get token balance", async function () {
      let balance = await this.polarisContract.balanceOf(account_two);

      assert.equal(Number(balance), 3, "wrong balance value");
    });

    // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
    it("should return token uri", async function () {
      let uri = `https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/${0}`;
      let tokenUri = await this.polarisContract.tokenURI(0);

      assert.equal(tokenUri, uri, "wrong token uri");
    });

    it("should transfer token from one owner to another", async function () {
      let tokenOwner = await this.polarisContract.ownerOf(0);
      let balance = await this.polarisContract.balanceOf(account_two);

      assert.equal(tokenOwner, account_two, "wrong token owner");
      assert.equal(Number(balance), 3, "wrong balance value");

      await this.polarisContract.transferFrom(account_two, account_three, 0, {
        from: account_two,
      });
      tokenOwner = await this.polarisContract.ownerOf(0);
      balance = await this.polarisContract.balanceOf(account_three);

      assert.equal(tokenOwner, account_three, "wrong token owner");
      assert.equal(Number(balance), 1, "wrong balance value");
    });
  });

  describe("have ownership properties", function () {
    beforeEach(async function () {
      // this.contract = await ERC721MintableComplete.new({ from: account_one });

      this.cepheusContract = await ERC721MintableComplete.new(
        "Cepheus",
        "CEPH",
        {
          from: account_three,
        }
      );

      await this.cepheusContract.mint(account_three, 0, {
        from: account_three,
      });
    });

    it("should fail when minting when address is not contract owner", async function () {
      let reverted = false;
      try {
        await this.cepheusContract.mint(account_three, 0, {
          from: account_one,
        });
      } catch (error) {
        reverted = true;
      }

      assert.equal(
        reverted,
        true,
        "could mint when address is not the contract owner"
      );
    });

    it("should return contract owner", async function () {
      let tokenOwner = await this.cepheusContract.getOwner();
      let balance = await this.cepheusContract.balanceOf(account_three);

      assert.equal(tokenOwner, account_three, "wrong contract owner");
      assert.equal(Number(balance), 1, "wrong balance value");
    });
  });
});
