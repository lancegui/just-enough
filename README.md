# just-enough

> The best code is the code you never wrote — and the second best is the code anyone can read.

A general-purpose **code-restraint discipline** for AI coding agents. Before writing anything, it walks a **reuse ladder** — *does this need to exist? → reuse what's already here → language/runtime primitive or stdlib → a native feature → an installed or project-standard ecosystem package → minimal code* — and stops at the first rung that works. Then it stops at the minimal **readable** solution: keep the punchy one-liner when it says one plain thing, and split only when compression hides decisions.

[ponytail](https://github.com/DietrichGebert/ponytail) with taste: it keeps ponytail's "should this code exist?" ladder and one-line punch, but drops line-count golf in favour of code that still reads cleanly.

## What it does

- **Walks the reuse ladder** so you reach for language/runtime primitives, native features, existing helpers, or project-standard packages before hand-rolling logic or adding a dependency.
- **Stops at minimal *readable* code, not maximal expansion.** One plain idea can be one line; no clever line should fold a fetch, a filter, and a transform into a single unreviewable step.
- **Treats stdlib as a boring-primitive preference, not package purity.** In Python/R/Julia-style ecosystems, the idiomatic package already used by the project can be the leanest answer.
- **Leaves one tiny check for non-trivial logic.** Trivial one-liners need none; bug fixes, branchy behavior, parsers, and risky paths get the smallest runnable proof.
- **Marks deliberate simplifications** with `# lean: <simplification> — upgrade when <Y>`, so a shortcut is a documented trade-off with an upgrade path, not a silent one.

It is intentionally general — any language, any project. For econ/research code, pair it with **`analysis-craft`** (in [causal-powers](https://github.com/lancegui/causal-powers)), which specialises the readability standard for that domain: economic-unit variable names, `# why:` decision comments, and the "can a referee follow it in one pass?" test. `just-enough` says *should this exist + don't reinvent + don't golf or pad*; `analysis-craft` adds the econ-specific readability layer on top.

## Install

The discipline is a single `SKILL.md`. Each agent reads skills from a different place — pick your agent below.

### Claude Code

```
/plugin marketplace add lancegui/just-enough
/plugin install just-enough@just-enough
```

From a local clone, point the marketplace at the directory instead:

```
/plugin marketplace add ~/Developer/just-enough
/plugin install just-enough@just-enough
```

Restart Claude Code. A `SessionStart` hook also injects a one-line card so the discipline is present from the first turn, not only on description match.

### OpenCode

OpenCode auto-discovers skills from `~/.config/opencode/skills/`. From a local clone:

```
./scripts/install-opencode.sh
```

This **symlinks** the skill into that directory, so repo edits stay live and the installed copy can never drift stale. Restart OpenCode (or run `/skills`) and confirm `just-enough` is listed. Manual equivalent:

```
ln -sfn "$PWD/skills/just-enough" ~/.config/opencode/skills/just-enough
```

(Use `./scripts/install-opencode.sh --copy` for a plain copy, or `--uninstall` to remove it.)

### Codex / other SKILL.md agents

Symlink (or copy) `skills/just-enough` into the directory the agent scans for skills, then restart it:

```
ln -sfn "$PWD/skills/just-enough" ~/.agents/skills/just-enough   # adjust path to your agent
```

## Repository layout

```
.claude-plugin/
  plugin.json          # Claude Code plugin manifest
  marketplace.json     # so `/plugin marketplace add` can find it
skills/just-enough/
  SKILL.md             # the discipline (shared by all agents)
hooks/
  hooks.json           # Claude Code SessionStart wiring
  session-start        # injects the standing card (Claude Code only)
scripts/
  install-opencode.sh  # symlink the skill into OpenCode
```

The `hooks/` card is Claude Code-specific; on OpenCode and Codex the skill triggers by description match alone, which is the primary mechanism on every agent.

## License

MIT © Lance Gui
