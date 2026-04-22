# APM Demo Pack

Three reproducible field demos for [APM](https://github.com/microsoft/apm) (Agent Package Manager) and the Agentic SDLC pattern. Built for presales engineers, conference talks, and customer briefings.

Each demo runs in **under 90 seconds** and produces a clear "wow" beat. Total runtime ~5 minutes if you run all three back to back.

## What you'll demo

| # | Title | What it proves | Time |
|---|---|---|---|
| 1 | **Portability** | One manifest, one verb (`install`), every primitive (agents, skills, MCP). The package-manager mental model finally applied to AI context. | ~90s |
| 2 | **Supply chain** | `apm audit` catches what humans literally cannot see (hidden Unicode), and the pre-deploy security gate blocks poisoned packages from ever landing on disk. | ~90s |
| 3 | **Org policy governance** | Auto-discovered org policy (one YAML in `<org>/.github/`) blocks non-compliant installs at the developer's terminal — same way npm registries reject blocked packages. | ~60s |

## Prereqs

```bash
# 1. APM installed (>= 0.9.0)
curl -sSL https://raw.githubusercontent.com/microsoft/apm/main/install.sh | bash
apm --version

# 2. gh CLI authenticated (needed for Demo 3 -- `gh browse`)
gh auth status

# 3. One-time marketplace registration (used by Demo 1)
apm marketplace add github/awesome-copilot
```

Run the prereq checker:

```bash
./scripts/check-prereqs.sh
```

## Run the demos

Each demo lives in its own directory with a `README.md` (the script you read on stage), a `verify.sh` (non-interactive smoke test you run before the talk), and a `reset.sh` (cleanup between dry-runs).

```bash
cd demo-1-portability && cat README.md
cd demo-2-supply-chain && cat README.md
cd demo-3-policy && cat README.md
```

**Always run `./verify.sh` for each demo at least once before going on stage.** It catches network issues, stale caches, and version drift in ~60 seconds total.

## Demo 3 requires this org

Demo 3 only works from inside a clone of a repo in the **DevExpGbb** GitHub org, because APM auto-discovers org policy via the git remote (`<org>/.github/apm-policy.yml`). This repo is in DevExpGbb for exactly that reason.

The policy file lives at: <https://github.com/DevExpGbb/.github/blob/main/apm-policy.yml>

It is permanently in `enforcement: block` mode with `github/awesome-copilot/plugins/azure-cloud-development` on the deny list. This is a test fixture (per [microsoft/apm#832](https://github.com/microsoft/apm/pull/832)), not a real org policy — please don't rely on it for production governance.

## Reset everything

```bash
./scripts/reset-all.sh
```

Idempotent. Safe to run between rehearsals.

## Recovery beats (if something goes wrong on stage)

| Symptom | Fallback line |
|---|---|
| `apm install` stalls > 30s | "Network's slow — let me show you what the lockfile already captured." Then `cat apm.lock.yaml`. |
| `apm audit --verbose` scrolls forever | Ctrl+C, then: "Secure by default. Reasoned. Auditable. Not magic." |
| Demo 3 doesn't block | Check git remote points to DevExpGbb (`git remote -v`). Policy auto-discovery walks the remote. |
| Marketplace fetch fails | The cached package in `apm_modules/` from your dry-run will satisfy the install offline. |

## What this is the practical companion to

- The Agentic SDLC Handbook, Chapter 7: <https://github.com/danielmeppiel/agentic-sdlc-handbook>
- The PR Review Panel reference implementation: <https://github.com/microsoft/apm/pull/832>
- APM project: <https://github.com/microsoft/apm>

## Contributing

Found a beat that lands better? Send a PR. Keep beats under 90 seconds, keep stage prose in `README.md`, keep automation in `verify.sh` and `reset.sh`.
