---
name: just-enough
description: Use when WRITING or EDITING any code — before adding a function, a file, a dependency, or a layer of abstraction — to write the least code that does the job and keep it readable. Walks a reuse ladder (does this need to exist? → reuse what's already here → standard library → a native feature → an existing dependency → minimal code) and stops at the first rung that works, then writes the result so a teammate follows it in one pass. Use whenever you're about to hand-roll something a library already does, add a package, build an abstraction, or compress working logic into a clever one-liner — even if the request is just "add this", "write a script for", or "fix this". The best code is the code you never wrote; the second best is the code anyone can read.
---

# just-enough

## Overview

The best code is the code you never wrote. Most defects, most maintenance, and most review cost come from code that did not need to exist — a hand-rolled utility for something the standard library already does, an abstraction built for a second caller that never arrives, a dependency added to save three lines. This skill is the restraint that runs *before* you write: climb a ladder of cheaper options first, and stop at the first rung that works.

It is **not** about fewest lines. A golfed one-liner that hides three operations is not lean — it is debt with the cost moved from writing to reading. Lean means *necessary and readable*: the minimum code that does the job, written so the next person follows it in one pass.

**Lazy about the solution, never about reading.** Before climbing the ladder, read the code the change touches and trace the real flow. The ladder runs after you understand the problem, not instead of it.

## The reuse ladder — stop at the first rung that works

1. **Does this need to exist?** Skip speculative work. The feature, the config flag, the abstraction "for later" — if nothing needs it now, don't write it. (YAGNI.)
2. **Is it already here?** Reuse a function, pattern, or module already in this codebase before writing a new one. Search first.
3. **Standard library?** Prefer a built-in over a custom implementation or a new dependency.
4. **A native feature?** Use the platform's own capability (a language construct, an OS/runtime feature, a database constraint) before re-implementing it in application code.
5. **An installed dependency?** Use a package the project already has before adding a new one.
6. **Minimal readable code.** Only now write it — the least code that does the job, decomposed into named steps a reader can follow. **Not** a one-liner that hides what it does.

## Key principles

- **No premature abstraction.** Interfaces, factories, generic config, and plugin points should not exist without a proven second caller. Inline beats a single-use helper.
- **Deletion over addition.** Removing code is a fix. Prefer it to adding more. Boring beats clever.
- **Root-cause fixes.** Fix the underlying issue where all callers converge, not the symptom in each caller.
- **Stop at minimal *readable*, never golfed.** One conceptual step per line. A line that folds together a fetch, a filter, and a transform is three decisions a reviewer can't see separately — split it.

## The `# lean:` marker — name your deliberate simplifications

When you take the minimal path on purpose and it has a ceiling, mark it so the next person knows it was a choice, not an oversight, and knows when to revisit:

`# lean: <the simplification> — upgrade when <the condition that breaks it>`

Example: `# lean: linear scan, fine for the ~50 configs we load — index it when this is hot`. The marker turns a silent shortcut into a documented trade-off with an upgrade path.

## Red flags — STOP

- Hand-rolling something the standard library or an installed dependency already does.
- Adding a dependency to save a handful of lines.
- Building an interface, factory, or config system with exactly one caller.
- Adding a feature, parameter, or branch nothing currently needs ("for later").
- Compressing working logic into a clever one-liner that hides what it does.
- Patching the same symptom in three callers instead of fixing where they converge.

## Common rationalizations

| Excuse | Reality |
|---|---|
| "I'm making it flexible for the future." | The future caller usually never comes, and the flexibility you guessed at is usually wrong. Generalize when the second real caller appears. |
| "A one-liner is elegant." | Elegant to write, expensive to read. Lean is necessary-and-readable, not short. Split it into named steps. |
| "It's just one small dependency." | Every dependency is a permanent cost — supply chain, version churn, build weight. Use the stdlib or what's already installed first. |
| "A framework is more professional than a script." | For a task that needs a script, the readable script is the professional choice. Overcomplication isn't rigor. |

## The bottom line

```
Just enough  →  the fewest things that need to exist, each readable in one pass, simplifications marked
Otherwise    →  code nobody needed, or a clever line nobody can read
```
