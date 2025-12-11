#!/usr/bin/env node

import fs from "fs";
import axios from "axios";

const API = "https://explorer.celo.org/mainnet/api";
const KEY = process.env.CELO_EXPLORER_KEY;
const TREASURY = process.env.CELOHT_TREASURY;

if (!TREASURY) {
  console.error("Missing CELOHT_TREASURY");
  process.exit(1);
}

async function safeGet(url) {
  try {
    const r = await axios.get(url);
    if (!r.data || !r.data.result) throw new Error("Invalid response");
    return r.data.result;
  } catch {
    return [];
  }
}

async function run() {
  console.log("===> EXPORT STATE CELOHT");

  const celoTx = await safeGet(
    `${API}?module=account&action=txlist&address=${TREASURY}&sort=asc&apikey=${KEY}`
  );

  const tokenTx = await safeGet(
    `${API}?module=account&action=tokentx&address=${TREASURY}&sort=asc&apikey=${KEY}`
  );

  // Retire doublons Explorer
  const uniqCelo = [...new Map(celoTx.map(x => [x.hash, x])).values()];
  const uniqToken = [...new Map(tokenTx.map(x => [x.hash + x.tokenSymbol, x])).values()];

  fs.mkdirSync("exports", { recursive: true });
  fs.writeFileSync("exports/celo.json", JSON.stringify(uniqCelo, null, 2));
  fs.writeFileSync("exports/token.json", JSON.stringify(uniqToken, null, 2));

  console.log("Export OK");
}

run();