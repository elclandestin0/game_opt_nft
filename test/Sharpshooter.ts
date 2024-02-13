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
        sharpshooterPass = SharpshooterPass.attach("0xCA87833e830652C2ab07E1e03eBa4F2c246D3b58");
    });

    it("Should mint a new token if the signature is valid", async function () {
        const tokenId = 1;
        const amount = 1;

        const proof = ethers.ZeroHash;
        await expect(sharpshooterPass.mintNFT(tokenId, proof))
            .to.be.revertedWith("Invalid proof.");
        
        // tx with correct proof
        const correctProof = await sharpshooterPass.connect(owner).generateNFTProof(1);
        // Ensure the proof string is correctly prefixed with '0x'
        const isValidProof = await sharpshooterPass.verifyNFTProof(tokenId, correctProof);
        expect(isValidProof).to.be.true;
        // expect(balance).to.equal(amount);
    });
});
