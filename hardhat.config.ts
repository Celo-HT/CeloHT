import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

/**
 * CeloHT Hardhat Configuration
 * Pillars:
 * 1. Education (on-chain learning & rewards)
 * 2. Environmental Action (reforestation & agents)
 * 3. Stable Finance (Celo cUSD via Valora)
 *
 * No token. No ICO. No speculation.
 */

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  networks: {
    celo: {
      url: process.env.CELO_RPC ?? "https://forno.celo.org",
      chainId: 42220,
      accounts: process.env.PRIVATE_KEY
        ? [process.env.PRIVATE_KEY]
        : [],
    },
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      chainId: 44787,
      accounts: process.env.PRIVATE_KEY
        ? [process.env.PRIVATE_KEY]
        : [],
    },
  },

  etherscan: {
    apiKey: {
      celo: process.env.CELOSCAN_API_KEY ?? "",
      alfajores: process.env.CELOSCAN_API_KEY ?? "",
    },
    customChains: [
      {
        network: "celo",
        chainId: 42220,
        urls: {
          apiURL: "https://api.celoscan.io/api",
          browserURL: "https://celoscan.io",
        },
      },
      {
        network: "alfajores",
        chainId: 44787,
        urls: {
          apiURL: "https://api-alfajores.celoscan.io/api",
          browserURL: "https://alfajores.celoscan.io",
        },
      },
    ],
  },
};

export default config;