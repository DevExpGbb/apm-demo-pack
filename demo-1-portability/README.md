# Demo 1 — Portability

**Time:** ~90 seconds. **What it proves:** One manifest, one verb, every primitive.

## Stage script

```bash
# Run from a clean dir (NOT this one -- this one is just instructions).
mkdir -p ~/demos/apm-talk-1 && rm -rf ~/demos/apm-talk-1/* && cd ~/demos/apm-talk-1 && git init -q

apm init -y
# -> creates apm.yml (5 lines, two empty deps lists)

cat apm.yml
# READ ALOUD: "Five lines. That's the manifest."

apm search azure@awesome-copilot
# -> 4 hits (azure, azure-cloud-development, devops-oncall, microsoft-docs)
# POINT: "Discovery from a marketplace I trust."

apm install azure-cloud-development@awesome-copilot
# -> "7 agents integrated -> .github/agents/"
# -> "4 skill(s) integrated -> .github/skills/"
# POINT: "One install. A plugin that bundles 7 agents + 4 skills."

ls .github/agents/ .github/skills/
# show the materialized files (7 .agent.md + 4 skill dirs)

head -20 apm.lock.yaml
# POINT to: resolved_commit + content_hash + deployed_files
# "This is what makes the next teammate get the same agent I got."

apm install microsoft-docs@awesome-copilot
# -> "Installed 1 APM dependency and 1 MCP server."
# POINT: "Same command shape. Plugin, skill, MCP server. One verb: install."
```

## Land it

> "One manifest. Multiple runtimes. The agent finally knows what your codebase expects."

## Stop conditions

- If anything stalls > 30s, jump to the lockfile and land the line above.
- If marketplace fetch fails, you already have `apm_modules/` cached from `verify.sh` — re-run `apm install` offline.

## Pre-talk verification

```bash
./verify.sh
```

Runs the full demo non-interactively against a temp directory, checks for the expected `apm.lock.yaml` entries and integrated files. Exits non-zero on any drift. Run this before every talk.

## Reset

```bash
./reset.sh
```

Wipes `~/demos/apm-talk-1/`. Safe to re-run.
