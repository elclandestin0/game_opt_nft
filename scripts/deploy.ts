import {ethers} from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", owner.address);

  // Deploy PolicyMaker
  const SharpshooterPassFactory = await ethers.getContractFactory("SharpshooterPass");
  const sharpshooter = await SharpshooterPassFactory.deploy(owner.address);

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
