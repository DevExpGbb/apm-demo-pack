#!/usr/bin/env bash
# Demo 3 -- non-interactive smoke test.
# Skipped if not running from a clone with a DevExpGbb git remote
# (auto-discovery requires the org context).
set -euo pipefail
cd "$(dirname "$0")"

if ! git remote -v 2>/dev/null | grep -qi "DevExpGbb/"; then
  echo "[~] Skipped: not running from a DevExpGbb clone."
  echo "    Run: git clone https://github.com/DevExpGbb/apm-demo-pack && cd apm-demo-pack/demo-3-policy && ./verify.sh"
  exit 0
fi

echo "[1/3] Reset state"
rm -rf apm_modules .github/agents .github/skills apm.lock.yaml \
       .apm/skills/azure-cloud-development 2>/dev/null || true
git checkout -- apm.yml 2>/dev/null || true

echo "[2/3] Beat 1: install should be BLOCKED"
out=$(apm install 2>&1 || true)
echo "$out" | grep -q "enforcement=block" \
  || { echo "FAIL: expected 'enforcement=block' in output"; echo "$out"; exit 1; }
echo "$out" | grep -q "Install blocked by org policy" \
  || { echo "FAIL: expected 'Install blocked by org policy'"; echo "$out"; exit 1; }
test ! -d .apm/skills/azure-cloud-development \
  || { echo "FAIL: package leaked into .apm/skills/ despite block"; exit 1; }

echo "[3/3] Beat 3: --no-policy bypass should work with loud warning"
out=$(apm install --no-policy 2>&1)
echo "$out" | grep -q "Policy enforcement disabled by --no-policy" \
  || { echo "FAIL: expected --no-policy warning"; echo "$out"; exit 1; }
echo "$out" | grep -q "CI will still fail" \
  || { echo "FAIL: expected CI reminder in --no-policy warning"; echo "$out"; exit 1; }

# Cleanup
rm -rf apm_modules .github/agents .github/skills apm.lock.yaml \
       .apm/skills/azure-cloud-development 2>/dev/null || true
git checkout -- apm.yml 2>/dev/null || true

echo
echo "[+] Demo 3 verified -- ready for stage."
