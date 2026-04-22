#!/usr/bin/env bash
# Demo 2 -- reset to clean (preserves .apm/skills/poisoned-reviewer/).
set -e
cd "$(dirname "$0")"
rm -rf apm_modules .github/agents .github/skills audit.sarif apm.lock.yaml \
       .apm/skills/azure-cloud-development .apm/skills/microsoft-docs 2>/dev/null || true
# Restore apm.yml in case install-block partially mutated it
git checkout -- apm.yml 2>/dev/null || true
echo "[+] Demo 2 reset (poisoned fixture preserved)."
