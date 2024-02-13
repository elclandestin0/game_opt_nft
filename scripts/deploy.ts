import {ethers} from "hardhat";
import {AbiCoder} from "ethers";
import * as dotenv from "dotenv";

async function main() {
    const [owner] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", owner.address);

    // Deploy PolicyMaker
    const SharpshooterPassFactory = await ethers.getContractFactory("SharpshooterPass");
    // Simulate the same encoding and hashing process as in the contract
    const defaultAbiCoder = new AbiCoder();
    const secretKey = ethers.keccak256(defaultAbiCoder.encode(["string"], [process.env.salt]));
    const sharpshooter = await SharpshooterPassFactory.deploy(owner.address, "", secretKey);

    // Wait for the contract to be deployed
    await sharpshooter.waitForDeployment();
    console.log("Policy Maker deployed to address:", sharpshooter.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
