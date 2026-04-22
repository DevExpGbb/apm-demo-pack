# Demo 3 — Org Policy Governance

**Time:** ~60 seconds. **What it proves:** One YAML in one repo controls every install attempt across every team. Auto-discovered. No flags needed.

## How auto-discovery works

When you run `apm install` in a project, APM walks the git remote → `<org>/.github/apm-policy.yml`. **The developer didn't opt in. Governance is the default.**

This demo only works because:

1. This repo is in the **DevExpGbb** org.
2. `DevExpGbb/.github/apm-policy.yml` is in `enforcement: block` mode with `github/awesome-copilot/plugins/azure-cloud-development` on the deny list.

Both conditions are permanent — no setup/teardown. The policy is a test fixture per [microsoft/apm#832](https://github.com/microsoft/apm/pull/832).

## Pre-stage

`apm.yml` in this directory references the denied package. Nothing else to set up.

## Stage script

```bash
cd demo-3-policy

# Beat 1 -- normal developer attempting an install
apm install
# -> [!] Policy: org:DevExpGbb/.github -- enforcement=block
# -> [x] Policy violation: dependency-denylist
#       github/awesome-copilot/plugins/azure-cloud-development: denied by pattern
# -> [x] Install blocked by org policy -- see violations above

# Beat 2 -- show where the rule lives (one file, central, versioned)
gh browse --repo DevExpGbb/.github apm-policy.yml
# (or: cat ../policy/apm-policy.yml -- mirror of what's deployed)
```

### Land Beat 2

> "This file is the entire governance system. One YAML, in one repo, controls every install attempt across every team. Bump the version → every dev gets the new rule on their next install. No agent install can sneak past it."

```bash
# Beat 3 -- the escape hatch is loud, audited, and CI still wins
apm install --no-policy
# -> [!] Policy enforcement disabled by --no-policy for this invocation.
#       This does NOT bypass apm audit --ci. CI will still fail the PR
#       for the same policy violation.
# -> [+] github/awesome-copilot/plugins/azure-cloud-development integrated
```

## Talking points (pick the ones that land for the room)

- **Auto-discovery, no flags.** APM walks the git remote → `<org>/.github/apm-policy.yml`. Governance is the *default*.
- **Block vs warn modes.** Currently `block`. Flip to `warn` for soft-launch; violations still surface in CI.
- **CI gate is uncheatable.** `--no-policy` and `APM_POLICY_DISABLE=1` work locally; `apm audit --ci` ignores both by design.
- **MCP servers governed too.** Policy covers `dependencies.mcp` (transports, allow/deny by name). The matrix in PR #832 verified this end-to-end across 11 scenarios.

## Verify

```bash
./verify.sh
```

Asserts the install is blocked with the expected message, and that `--no-policy` lets it through with the loud warning. Skipped if you're not running from a clone with a DevExpGbb remote.

## Reset

```bash
./reset.sh
```

Removes `apm_modules/`, `.apm/skills/`, `.apm/agents/`, `.github/skills/`, `.github/agents/`, `apm.lock.yaml`. Restores `apm.yml` from git (in case `--no-policy` install mutated it).
