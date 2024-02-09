import {expect} from "chai";
import {ethers} from "hardhat";
import {Contract, Signer} from "ethers";
import {SharpshooterPass} from "../typechain/contracts/SharpshooterPass"; // Adjust the import path to where your typechain artifacts are located

describe("SharpshooterPass", function () {
    let sharpshooterPass: SharpshooterPass;
    let owner: Signer;
    let addr1: JSON;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        const SharpshooterPass = await ethers.getContractFactory("SharpshooterPass");
        sharpshooterPass = SharpshooterPass.attach("0x519b05b3655F4b89731B677d64CEcf761f4076f6");
    });

    it("Should mint a new token if the signature is valid", async function () {
        const tokenId = 1;
        const amount = 1;

        // Mint a new token
        await sharpshooterPass.connect(addr1).mintNFT(tokenId);

        // Check that the balance of addr1 is now 1
        const balance = await sharpshooterPass.balanceOf(await addr1.getAddress(), tokenId);
        expect(balance).to.equal(amount);
    });
});
