#!/usr/bin/env bash
# Demo 3 -- reset to clean.
set -e
cd "$(dirname "$0")"
rm -rf apm_modules .github/agents .github/skills apm.lock.yaml \
       .apm/skills/azure-cloud-development 2>/dev/null || true
git checkout -- apm.yml 2>/dev/null || true
echo "[+] Demo 3 reset."
