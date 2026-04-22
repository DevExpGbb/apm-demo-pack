#!/usr/bin/env bash
# Run all three verification scripts in order. ~2-3 minutes total.
set -e
HERE="$(cd "$(dirname "$0")/.." && pwd)"
echo "=== Demo 1 ===" && "$HERE/demo-1-portability/verify.sh"
echo
echo "=== Demo 2 ===" && "$HERE/demo-2-supply-chain/verify.sh"
echo
echo "=== Demo 3 ===" && "$HERE/demo-3-policy/verify.sh"
echo
echo "[+] All three demos verified -- you are ready to present."
