import {expect} from "chai";
import {ethers} from "hardhat";
import {BigNumber, Contract, Signer} from "ethers";
import {SharpshooterPass} from "../typechain/contracts/SharpshooterPass"; // Adjust the import path to where your typechain artifacts are located

describe("SharpshooterPass", function () {
    let sharpshooterPass: SharpshooterPass;
    let owner: Signer;
    let addr1: JSON;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        const SharpshooterPass = await ethers.getContractFactory("SharpshooterPass");
        sharpshooterPass = SharpshooterPass.attach("0xF357118EBd576f3C812c7875B1A1651a7f140E9C");
    });

    it("Should mint a new token if the signature is valid", async function () {
        const tokenId = 19;
        const amount = 1;

        const proof = ethers.ZeroHash;
        await expect(sharpshooterPass.mintNFT(tokenId, proof))
            .to.be.revertedWith("Invalid proof.");
        
        // tx with correct proof
        const correctProof = await sharpshooterPass.connect(owner).generateNFTProof(1);
        // Ensure the proof string is correctly prefixed with '0x'
        const proofHexString = `0x${correctProof}`;
        console.log(correctProof);
        const isValidProof = await sharpshooterPass.verifyNFTProof(tokenId, proofHexString);
        expect(isValidProof).to.be.true;
        // expect(balance).to.equal(amount);
    });
});
