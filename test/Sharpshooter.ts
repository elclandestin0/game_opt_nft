const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SharpshooterPass", function () {
  it("Should mint a new token if the signature is valid", async function () {
    const [owner, addr1] = await ethers.getSigners();

    // Deploy the contract
    const SharpshooterPass = await ethers.getContractFactory("SharpshooterPass");
    const sharpshooterPass = await SharpshooterPass.deploy(owner.address);
    await sharpshooterPass.deployed();

    // Sign a tokenId for addr1 using the owner's account
    const tokenId = 1;
    const amount = 1;
    const messageHash = ethers.utils.solidityKeccak256(["uint256", "address"], [tokenId, addr1.address]);
    const signature = await owner.signMessage(ethers.utils.arrayify(messageHash));

    // Mint a new token
    await expect(sharpshooterPass.connect(addr1).mintNFT(signature, tokenId, amount))
        .to.emit(sharpshooterPass, 'TransferSingle');

    // Check that the balance of addr1 is now 1
    expect(await sharpshooterPass.balanceOf(addr1.address, tokenId)).to.equal(amount);
  });
});