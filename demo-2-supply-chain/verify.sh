#!/usr/bin/env bash
# Demo 2 -- non-interactive smoke test.
set -euo pipefail
export COLUMNS=200 NO_COLOR=1
cd "$(dirname "$0")"

echo "[1/6] Setup: install awesome-copilot deps"
rm -rf apm_modules .apm/skills/devops-oncall .apm/skills/azure-cloud-development \
       .github/agents .github/skills audit.sarif apm.lock.yaml 2>/dev/null || true
apm install >/dev/null  # devops-oncall is allowed by DevExpGbb policy

echo "[2/6] apm audit -- expect 'unusual characters' findings"
audit_out=$(apm audit 2>&1 || true)
echo "$audit_out" | grep -q "unusual characters" \
  || { echo "FAIL: expected 'unusual characters' in audit output"; echo "$audit_out"; exit 1; }

echo "[3/6] apm audit --ci -- expect exit 0"
apm audit --ci >/dev/null

echo "[4/6] apm audit --format sarif"
apm audit --format sarif -o audit.sarif >/dev/null
test -s audit.sarif || { echo "FAIL: audit.sarif empty"; exit 1; }

echo "[5/6] Beat B: install-block on poisoned-reviewer-demo"
# Snapshot apm.yml so install rollback semantics don't mutate it
cp apm.yml apm.yml.snap
out=$(apm install danielmeppiel/poisoned-reviewer-demo 2>&1 || true)
echo "$out" | grep -q "Blocked" \
  || { echo "FAIL: expected 'Blocked' in install output"; echo "$out"; exit 1; }
test ! -d .apm/skills/poisoned-reviewer-demo \
  && test ! -f .apm/skills/poisoned-reviewer/SKILL.md.from-package \
  || { echo "FAIL: poisoned package leaked into .apm/skills/"; exit 1; }
mv apm.yml.snap apm.yml

echo "[6/6] Optional --file beat"
file_out=$(apm audit --file .apm/skills/poisoned-reviewer/SKILL.md 2>&1 || true)
echo "$file_out" | grep -q -i "critical" \
  || { echo "FAIL: --file scan should report CRITICAL"; echo "$file_out"; exit 1; }
strip_out=$(apm audit --file .apm/skills/poisoned-reviewer/SKILL.md --strip --dry-run 2>&1 || true)
echo "$strip_out" | grep -q -i "would" \
  || echo "WARN: --strip --dry-run output didn't mention 'would' -- check manually"

echo
echo "[+] Demo 2 verified -- ready for stage."
