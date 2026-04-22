#!/usr/bin/env bash
# Verify the operator's machine is ready for all three demos.
set -e

ok=true
warn() { echo "[!] $1"; ok=false; }
pass() { echo "[+] $1"; }

# 1. apm
if ! command -v apm >/dev/null 2>&1; then
  warn "apm not found on PATH. Install: curl -sSL https://raw.githubusercontent.com/microsoft/apm/main/install.sh | bash"
else
  pass "apm: $(apm --version 2>&1 | head -1)"
fi

# 2. gh
if ! command -v gh >/dev/null 2>&1; then
  warn "gh CLI not found. Install: https://cli.github.com/"
else
  if ! gh auth status >/dev/null 2>&1; then
    warn "gh CLI not authenticated. Run: gh auth login"
  else
    pass "gh: authenticated"
  fi
fi

# 3. git
if ! command -v git >/dev/null 2>&1; then
  warn "git not found"
else
  pass "git: $(git --version)"
fi

# 4. awesome-copilot marketplace registered
if command -v apm >/dev/null 2>&1; then
  if apm marketplace list 2>/dev/null | grep -q "awesome-copilot"; then
    pass "marketplace: awesome-copilot registered"
  else
    warn "marketplace 'awesome-copilot' NOT registered. Run: apm marketplace add github/awesome-copilot"
  fi
fi

# 5. Network reach to GitHub
if curl -sSf -o /dev/null -m 5 https://github.com; then
  pass "network: github.com reachable"
else
  warn "network: cannot reach github.com (demos require live fetches)"
fi

echo
if $ok; then
  echo "[+] All prereqs pass. You can run the demos."
  exit 0
else
  echo "[x] Fix the warnings above before running the demos."
  exit 1
fi
