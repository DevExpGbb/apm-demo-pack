#!/usr/bin/env bash
# Demo 1 -- non-interactive smoke test.
# Exits 0 if the demo will work on stage; non-zero otherwise.
set -euo pipefail

DEMO_DIR="${HOME}/demos/apm-talk-1-verify"
trap 'rm -rf "$DEMO_DIR"' EXIT

rm -rf "$DEMO_DIR" && mkdir -p "$DEMO_DIR" && cd "$DEMO_DIR" && git init -q

echo "[1/5] apm init"
apm init -y >/dev/null

echo "[2/5] apm search azure@awesome-copilot"
search_out=$(apm search azure@awesome-copilot 2>&1)
echo "$search_out" | grep -q "azure-cloud-development" \
  || { echo "FAIL: expected 'azure-cloud-development' in search results"; echo "$search_out"; exit 1; }

echo "[3/5] apm install azure-cloud-development@awesome-copilot"
apm install azure-cloud-development@awesome-copilot >/dev/null
test -d .github/agents || { echo "FAIL: .github/agents/ not created"; exit 1; }
test -d .github/skills || { echo "FAIL: .github/skills/ not created"; exit 1; }
agent_count=$(ls .github/agents | wc -l | tr -d ' ')
[ "$agent_count" -ge 7 ] || { echo "FAIL: expected >= 7 agents, got $agent_count"; exit 1; }

echo "[4/5] lockfile sanity"
test -f apm.lock.yaml || { echo "FAIL: apm.lock.yaml missing"; exit 1; }
grep -q "resolved_commit" apm.lock.yaml || { echo "FAIL: lockfile missing resolved_commit"; exit 1; }
grep -q "content_hash" apm.lock.yaml || { echo "FAIL: lockfile missing content_hash"; exit 1; }

echo "[5/5] apm install microsoft-docs@awesome-copilot (MCP)"
apm install microsoft-docs@awesome-copilot >/dev/null

echo
echo "[+] Demo 1 verified -- ready for stage."
