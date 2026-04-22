#!/usr/bin/env bash
# Master reset for all three demos.
set -e
HERE="$(cd "$(dirname "$0")/.." && pwd)"
"$HERE/demo-1-portability/reset.sh"
"$HERE/demo-2-supply-chain/reset.sh"
"$HERE/demo-3-policy/reset.sh"
echo
echo "[+] All three demos reset."
