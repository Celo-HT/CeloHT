#!/usr/bin/env bash
set -e

RPC="https://forno.celo.org"
TS=$(date +"%Y%m%d_%H%M%S")
OUT="snapshots/$TS"

mkdir -p $OUT

echo "===> Snapshotting CELOHT Treasury (CELO + cUSD)"

# Block height
cast block-number --rpc-url $RPC > $OUT/block.txt

# Balans CELO
cast balance $CELOHT_TREASURY --rpc-url $RPC > $OUT/celo_balance.txt

# Balans cUSD
cast call $CUSD "balanceOf(address)" $CELOHT_TREASURY --rpc-url $RPC > $OUT/cusd_balance.txt

echo "Snapshot saved to $OUT"