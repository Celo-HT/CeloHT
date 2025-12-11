#!/usr/bin/env node

import fs from "fs";
import axios from "axios";

const API = "https://explorer.celo.org/mainnet/api";
const KEY = process.env.CELO_EXPLORER_KEY;

async function run() {
  console.log("===> Exporting CELOHT Treasury Transactions");

  const treasury = process.env.CELOHT_TREASURY;

  // Normal CELO transactions
  const celoTxs = (
    await axios.get(
      `${API}?module=account&action=txlist&address=${treasury}&sort=asc&apikey=${KEY}`
    )
  ).data;

  // ERC20 transactions (cUSD, cEUR, etc.)
  const erc20Txs = (
    await axios.get(
      `${API}?module=account&action=tokentx&address=${treasury}&sort=asc&apikey=${KEY}`
    )
  ).data;

  fs.mkdirSync("exports", { recursive: true });

  fs.writeFileSync("exports/celo_txs.json", JSON.stringify(celoTxs, null, 2));
  fs.writeFileSync("exports/token_txs.json", JSON.stringify(erc20Txs, null, 2));

  console.log("Export complete");
}

run();