const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Replace with Celo cUSD address on Alfajores or Mainnet
  const cUSDAddress = "0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1";

  const CeloHT = await hre.ethers.getContractFactory("CeloHTcUSD");
  const celoHT = await CeloHT.deploy(cUSDAddress);

  await celoHT.deployed();
  console.log("CeloHT contract deployed to:", celoHT.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});