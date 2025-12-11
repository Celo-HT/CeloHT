#!/usr/bin/env node

import fs from "fs";

console.log("===> Running CeloHT Reconciliation");

// Load last snapshot folder
const folder = fs.readdirSync("snapshots").sort().reverse()[0];
const path = "snapshots/" + folder;

const celoBalance = Number(fs.readFileSync(`${path}/celo_balance.txt`, "utf8"));
const cusdBalance = Number(fs.readFileSync(`${path}/cusd_balance.txt`, "utf8"));

const celoTxs = JSON.parse(fs.readFileSync("exports/celo_txs.json"));
const tokenTxs = JSON.parse(fs.readFileSync("exports/token_txs.json"));

const report = {
  snapshotFolder: folder,
  balances: {
    celo: celoBalance,
    cusd: cusdBalance
  },
  txCounts: {
    celo: celoTxs.result.length,
    erc20: tokenTxs.result.length
  },
  errors: []
};

// Checks
if (celoBalance < 0) report.errors.push("CELO balance cannot be negative");
if (cusdBalance < 0) report.errors.push("cUSD balance cannot be negative");
if (!celoTxs.result.length) report.errors.push("No CELO transactions found");
if (!tokenTxs.result.length) report.errors.push("No token (cUSD) transactions found");

fs.writeFileSync("reconciliation_report.json", JSON.stringify(report, null, 2));

console.log("Reconciliation finished → reconciliation_report.json");