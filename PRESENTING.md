# Presenting Notes

Read this once before your first run. It captures the things that aren't in the per-demo READMEs: pacing, ordering, what to skip if you're short on time, and what to do when the room asks the hard questions.

## Order matters

```
Demo 1 -> Demo 2 -> Demo 3
```

- Demo 1 establishes the **mental model** ("apm install is just like npm install"). Without it, Demos 2 and 3 land as features instead of as a system.
- Demo 2 establishes **trust** (it's not just convenient — it's safe).
- Demo 3 establishes **scale** (it's not just safe for me — it's governable for the org).

If you only have **3 minutes**, run Demo 1 + the install-block beat from Demo 2. Skip the audit beat and skip Demo 3.

If you only have **5 minutes**, run Demo 1 + Demo 3. The supply-chain story comes through implicitly when Demo 3 mentions "MCP servers governed too."

## What to NOT say

- Don't call APM "magic" or "AI-powered." It's a package manager. The boring framing wins with technical buyers.
- Don't promise APM solves prompt injection or jailbreaks. It doesn't. (See the Demo 2 honesty beat.)
- Don't compare APM to specific competitors by name on stage. If the audience asks, talk about npm/cargo/brew as the analogue.

## What to ALWAYS say

- "One verb. Install." — repeat it across all three demos.
- "Same way you ship a linter config." — for the governance beat.
- "The platform your security team already audits." — for gh-aw / GitHub Actions framing.

## Audience tuning

| Audience | Lead with | Skip |
|---|---|---|
| C-level (CTO/CISO) | Demo 3 (governance), then Demo 1 (mental model) | Demo 2's `--verbose` codepoint dump |
| Platform engineers | Demo 1 (mental model), Demo 2 (audit + SARIF), Demo 3 (org policy) | Nothing |
| OSS developers | Demo 1 + Demo 2 install-block | Demo 3 (org-level governance is less relevant) |
| Security-led room | Demo 2 first, Demo 3 second, Demo 1 last | Demo 1's `apm search` (lighter content) |

## Hard questions you'll get asked

> "How is this different from devcontainer.json / .vscode/settings.json / shared dotfiles?"

Those configure **tools**. APM packages **agent context** — personas, skills, MCP servers, instructions — as a versioned dependency. The unit of distribution is "what the agent knows about your codebase," not "which extensions VS Code loads."

> "What stops a malicious package from doing something the audit can't see?"

Nothing. Same as npm. APM blocks invisible Unicode payloads (Demo 2 Beat B) and gives you org policy to allow-list trusted sources (Demo 3). Beyond that, you trust your sources — same trust model as every package manager.

> "Does this work with Claude / Cursor / Cline / Aider?"

Yes — the integrators emit per-target files (`.github/agents/` for Copilot, `.claude/skills/` for Claude, etc.). One `apm install`, every IDE that the project supports gets the same context. Run `apm compile --target claude` to demonstrate.

> "Why GitHub Agentic Workflows over a custom agent runtime?"

Two reasons: (1) the security model is what your team already audits — declared permissions, locked egress, sanitized outputs; (2) zero new infrastructure. The workflow file is just a Markdown file in `.github/workflows/`.

> "What happens when the org policy file is unreachable?"

Fail-open with a loud warning. Verified end-to-end in PR #832's W4 matrix. The reasoning: policies should never be a single point of failure that bricks every developer's install. Block-mode enforcement still works for **discovered** violations; it just doesn't *invent* a block when it can't read the policy.

## After the demo

- Run `./scripts/reset-all.sh`.
- If you ran the install-block beat in Demo 2, double-check `apm.yml` in `demo-2-supply-chain/` is back to its original state (`git status` should be clean).
- Don't forget to mention: **the infographic, the LinkedIn post, and Chapter 7 of the Handbook are all in the followups link**.
