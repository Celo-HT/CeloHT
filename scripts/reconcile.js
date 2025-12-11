#!/usr/bin/env node

import fs from "fs";

console.log("===> RECONCILIATION CELOHT");

const folder = fs.readdirSync("snapshots").sort().reverse()[0];
const ROOT = "snapshots/" + folder;

const celoBalance = Number(fs.readFileSync(`${ROOT}/celo.txt`, "utf8"));
const cusdBalance = Number(fs.readFileSync(`${ROOT}/cusd.txt`, "utf8"));

const celoTx = JSON.parse(fs.readFileSync("exports/celo.json"));
const tokenTx = JSON.parse(fs.readFileSync("exports/token.json"));

let report = {
  snapshot: folder,
  balances: { celo: celoBalance, cusd: cusdBalance },
  txCounts: { celo: celoTx.length, token: tokenTx.length },
  results: {},
  issues: []
};

// === CELO RECONCILIATION ===
let incomingCELO = 0;
let outgoingCELO = 0;
let gasTotal = 0;

for (const tx of celoTx) {
  if (tx.isError === "1") report.issues.push(`Failed tx: ${tx.hash}`);

  const gasCost = Number(tx.gasUsed) * Number(tx.gasPrice);
  gasTotal += gasCost;

  const value = Number(tx.value);

  if (tx.to?.toLowerCase() === process.env.CELOHT_TREASURY.toLowerCase()) {
    incomingCELO += value;
  } else if (tx.from?.toLowerCase() === process.env.CELOHT_TREASURY.toLowerCase()) {
    outgoingCELO += value;
  }
}

const expectedCELO = incomingCELO - outgoingCELO - gasTotal;
if (Math.abs(expectedCELO - celoBalance) > 1e10) {
  report.issues.push(
    `CELO mismatch: expected=${expectedCELO} actual=${celoBalance}`
  );
}

// === cUSD RECONCILIATION ===
let incomingCUSD = 0;
let outgoingCUSD = 0;

for (const tx of tokenTx) {
  if (tx.tokenSymbol !== "cUSD") continue;
  const val = Number(tx.value);

  if (tx.to?.toLowerCase() === process.env.CELOHT_TREASURY.toLowerCase()) {
    incomingCUSD += val;
  } else if (tx.from?.toLowerCase() === process.env.CELOHT_TREASURY.toLowerCase()) {
    outgoingCUSD += val;
  }
}

const expectedCUSD = incomingCUSD - outgoingCUSD;

if (expectedCUSD !== cusdBalance) {
  report.issues.push(
    `cUSD mismatch: expected=${expectedCUSD} actual=${cusdBalance}`
  );
}

report.results = {
  celo: { incomingCELO, outgoingCELO, gasTotal, expectedCELO },
  cusd: { incomingCUSD, outgoingCUSD, expectedCUSD }
};

fs.writeFileSync("reconciliation_report.json", JSON.stringify(report, null, 2));
console.log("OK → reconciliation_report.json");