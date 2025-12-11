#!/usr/bin/env bash
set -e

RPC="https://forno.celo.org"
TS=$(date +"%Y%m%d_%H%M%S")
OUT="snapshots/$TS"

mkdir -p "$OUT"

echo "===> SNAPSHOT CELOHT TREASURY"

if [ -z "$CELOHT_TREASURY" ] || [ -z "$CUSD" ]; then
  echo "Error: Missing CELOHT_TREASURY or CUSD env variable."
  exit 1
fi

# Block height
block=$(cast block-number --rpc-url $RPC)
echo "$block" > "$OUT/block.txt"

# Balans CELO
celo=$(cast balance $CELOHT_TREASURY --rpc-url $RPC)
echo "$celo" > "$OUT/celo.txt"

# Balans cUSD
cusd=$(cast call $CUSD "balanceOf(address)" $CELOHT_TREASURY --rpc-url $RPC)
echo "$cusd" > "$OUT/cusd.txt"

# Validasyon done yo
if [ "$celo" -lt 0 ] || [ "$cusd" -lt 0 ]; then
  echo "Error: Negative balance detected"
  exit 1
fi

echo "Snapshot OK → $OUT"