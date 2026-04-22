# Demo 2 — Supply Chain

**Time:** ~90 seconds. **What it proves:** APM catches what humans cannot see, and blocks poisoned packages before they touch your repo.

This demo has **two beats**: the audit (Beat A) and the install-time block (Beat B). Run both; they're complementary.

## Pre-stage

This directory ships with:

- `apm.yml` — references the same packages Demo 1 installs (so audit has something to scan).
- `.apm/skills/poisoned-reviewer/SKILL.md` — a hand-crafted file containing 41 hidden Unicode tag characters (U+E0041 et al.) plus visible emoji. Used by the optional `--file` beat.

Before the talk, install the deps **once** (rest of the demo runs against this state):

```bash
cd demo-2-supply-chain
apm install
```

`./verify.sh` does this for you.

---

## Beat A — Audit

```bash
cd demo-2-supply-chain

apm audit
# -> "5 info-level finding(s) in 2 file(s) -- unusual characters"
# POINT: "Info-level = harmless. Look how it tells me what kind."

apm audit --verbose | head -40
# -> shows codepoints (e.g., U+FE0F -- emoji presentation selector, kept by --strip)
# "These are emoji metadata. APM knows the difference between cosmetic glyph hints and a payload."

apm audit --ci
# -> 6 lockfile-integrity checks ALL PASS:
#    lockfile-exists | ref-consistency | deployed-files-present
#    no-orphaned-packages | config-consistency | content-integrity
# POINT: "Same command runs in CI. Exit 0, your build proceeds."

apm audit --format sarif -o audit.sarif && head -20 audit.sarif
# SARIF for GitHub Code Scanning (drop into Actions, get the security tab)
```

## Beat B — Install-time block

A purpose-built poisoned package lives at <https://github.com/danielmeppiel/poisoned-reviewer-demo> (public). It contains the same 41-char hidden payload as the local `.apm/skills/poisoned-reviewer/SKILL.md`.

```bash
apm install danielmeppiel/poisoned-reviewer-demo
# -> [x] Blocked: danielmeppiel/poisoned-reviewer-demo contains critical hidden character(s)
#    |-- Inspect source: apm_modules/danielmeppiel/poisoned-reviewer-demo
#    |-- Use --force to deploy anyway

ls .apm/skills/    # poisoned-reviewer NOT present -- the SKILL.md never reached the project tree.
```

## The honesty beat (say it out loud)

> "APM does not solve malicious *semantics* in plain English. APM stops the things humans literally cannot see."

## Optional — `--file` beat (if you have time)

The local poisoned file is pre-staged at `.apm/skills/poisoned-reviewer/SKILL.md`. Run:

```bash
apm audit --file .apm/skills/poisoned-reviewer/SKILL.md
# -> 41 CRITICAL findings, exit 1

apm audit --file .apm/skills/poisoned-reviewer/SKILL.md --strip --dry-run
# -> preview shows tag chars removed, emoji preserved
```

## Stop conditions

- If `--verbose` dump scrolls too long, hit Ctrl+C and land:
  > "Secure by default. Reasoned. Auditable. Not magic."

## Verify

```bash
./verify.sh
```

Runs Beats A + B + the `--file` optional non-interactively. Checks for the expected finding count, exit codes, and the absence of `poisoned-reviewer` in `.apm/skills/`.

## Reset

```bash
./reset.sh
```

Removes installed `apm_modules/`, `.apm/skills/azure-*`, `.apm/skills/microsoft-docs`, `.github/agents/`, `.github/skills/`, `audit.sarif`, lockfile. **Preserves** the pre-staged poisoned file.
