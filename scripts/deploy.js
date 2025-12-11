// scripts/deploy.js
// Deployment script for CeloHT smart contracts
// Requires: Node.js + ethers v6 + dotenv

import { ethers } from "ethers";
import * as fs from "fs";
import dotenv from "dotenv";
dotenv.config();

// ------------------------------
// CONFIG
// ------------------------------
const RPC = process.env.RPC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

// Sètifye ke anviwònman an bon
if (!RPC) throw new Error("Missing RPC URL in .env");
if (!PRIVATE_KEY) throw new Error("Missing PRIVATE_KEY in .env");

// Nou konekte sou RPC Celo mainnet / alfajores
const provider = new ethers.JsonRpcProvider(RPC);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

// ------------------------------
// LOAD CONTRACT ARTIFACTS
// ------------------------------
function loadArtifact(name) {
  const path = `./out/${name}.sol/${name}.json`;
  if (!fs.existsSync(path)) {
    throw new Error(`Artifact missing: ${path}`);
  }
  return JSON.parse(fs.readFileSync(path, "utf8"));
}

// Egzanp : CeloHTCore, Treasury, Governance
const coreArtifact = loadArtifact("CeloHTCore");
const treasuryArtifact = loadArtifact("Treasury");
const govArtifact = loadArtifact("Governance");

// ------------------------------
// DEPLOY FUNCTION
// ------------------------------
async function deploy() {
  console.log("Deploy starting…");
  console.log("Deployer:", await wallet.getAddress());
  console.log("Balance:", await provider.getBalance(wallet.address));

  // 1 – Deploy Treasury
  console.log("\nDeploying Treasury…");
  const TreasuryFactory = new ethers.ContractFactory(
    treasuryArtifact.abi,
    treasuryArtifact.bytecode.object,
    wallet
  );
  const treasury = await TreasuryFactory.deploy();
  await treasury.waitForDeployment();
  console.log("Treasury deployed at:", treasury.target);

  // 2 – Deploy Governance
  console.log("\nDeploying Governance…");
  const GovFactory = new ethers.ContractFactory(
    govArtifact.abi,
    govArtifact.bytecode.object,
    wallet
  );
  const governance = await GovFactory.deploy(treasury.target);
  await governance.waitForDeployment();
  console.log("Governance deployed at:", governance.target);

  // 3 – Deploy CeloHT Core
  console.log("\nDeploying CeloHTCore…");
  const CoreFactory = new ethers.ContractFactory(
    coreArtifact.abi,
    coreArtifact.bytecode.object,
    wallet
  );
  const core = await CoreFactory.deploy(
    governance.target,
    treasury.target,
    // Nou adopte CELO ak cUSD sèlman
    {
      celoAddress: "0x471EcE3750Da237f93B8E339c536989b8978a438",
      cUSDAddress: "0x765DE816845861e75A25fCA122bb6898B8B1282a",
    }
  );
  await core.waitForDeployment();
  console.log("CeloHTCore deployed at:", core.target);

  // Save JSON result
  const deployed = {
    network: await provider.getNetwork(),
    deployer: wallet.address,
    Treasury: treasury.target,
    Governance: governance.target,
    CeloHTCore: core.target,
    timestamp: Date.now(),
  };

  fs.writeFileSync("./deployments/latest.json", JSON.stringify(deployed, null, 2));
  console.log("\nDeployment saved → deployments/latest.json");

  return deployed;
}

// Run script
deploy().catch((err) => {
  console.error("DEPLOY ERROR:", err);
  process.exit(1);
});