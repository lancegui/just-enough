---
name: just-enough
description: >-
  Use when WRITING or EDITING code — before adding a function, file, dependency, or abstraction — to write the least code that works while staying obvious. Walks a reuse ladder (need it? → reuse what's here → runtime/stdlib → native feature → installed or project-standard package → minimal code) and stops at the first rung that works. Keep clear one-liners; split only when a line hides decisions. Non-trivial logic leaves the smallest runnable check; trivial one-liners need none. Use when hand-rolling code a library handles, adding a package, building an abstraction, compressing logic into a clever line, or padding a punchy line in the name of readability. The best code is the code you never wrote; the second best is code anyone can read.
---

# just-enough

## Overview

The best code is the code you never wrote. Most defects, most maintenance, and most review cost come from code that did not need to exist — a hand-rolled utility for something the standard library or project-standard package already does, an abstraction built for a second caller that never arrives, a dependency added to save three lines. This skill is the restraint that runs *before* you write: climb a ladder of cheaper options first, and stop at the first rung that works.

It is **not** about line count in either direction. A clean one-liner can be the leanest code; a golfed one-liner that hides three operations is debt with the cost moved from writing to reading. Splitting one obvious expression into a ten-line ritual is debt too. Lean means *necessary and readable*: the shortest shape that does the job while letting the next person follow it in one pass.

**Lazy about the solution, never about reading.** Before climbing the ladder, read the code the change touches and trace the real flow. The ladder runs after you understand the problem, not instead of it.

## The reuse ladder — stop at the first rung that works

1. **Does this need to exist?** Skip speculative work. The feature, the config flag, the abstraction "for later" — if nothing needs it now, don't write it. (YAGNI.)
2. **Is it already here?** Reuse a function, pattern, or module already in this codebase before writing a new one. Search first.
3. **Language/runtime primitive or stdlib?** Prefer the thing the language/runtime ships for this job over a custom implementation or a new dependency.
4. **A native feature?** Use the platform's own capability (a language construct, an OS/runtime feature, a database constraint) before re-implementing it in application code.
5. **An installed or project-standard ecosystem package?** Use the package the project already depends on, or the obvious package for the domain in that ecosystem, before writing custom code.
6. **Minimal readable code.** Only now write it — the least code that does the job and stays obvious. Keep a one-liner when it says one plain thing; introduce names or steps when compression hides decisions.

## Key principles

- **No premature abstraction.** Interfaces, factories, generic config, and plugin points should not exist without a proven second caller. Inline beats a single-use helper.
- **Deletion over addition.** Removing code is a fix. Prefer it to adding more. Boring beats clever.
- **Root-cause fixes.** Fix the underlying issue where all callers converge, not the symptom in each caller.
- **Stop at minimal *readable*, never golfed or padded.** One plain idea can be one line. A line that folds together a fetch, a filter, and a transform is three decisions a reviewer can't see separately — split it.
- **Prefer the punchy shape when it is still obvious.** Readable does not mean expanded. Guard clauses, direct returns, simple comprehensions, and familiar method chains should stay compact when they read in one pass.
- **Do not make stdlib a purity test.** In Python, R, Julia, and similar ecosystems, a mature package already used by the project can be the platform primitive. Base-only code that is longer, stranger, or easier to get wrong is not lean.
- **Leave the smallest useful check.** Non-trivial logic is unfinished until one runnable check would fail if it breaks. Prefer an existing focused test; otherwise add the tiniest assert, demo, self-check, or `test_*` file that fits the project.

## Package rule — reuse beats purity

The stdlib rung means "prefer owned, stable, boring primitives," not "avoid packages at all costs." Use base/runtime tools when they are clear and correct. Use an already-installed or project-standard package when it makes the code shorter, safer, and more idiomatic than a custom rewrite: for example, `pandas`/`numpy` in a Python data project, `data.table`/`dplyr`/`fixest` in an R project, or `DataFrames.jl`/`CSV.jl` in a Julia data project.

Add a new package only when it removes real owned complexity, handles domain edge cases better than local code, and fits the project's dependency norms. Do not add one just to save a handful of obvious lines.

## Testing rule — one check, no ceremony

Trivial one-liners, pure stdlib/native delegation, and obvious glue need no new test. For anything branchy, parsed, stateful, security-sensitive, money-related, data-loss-prone, concurrent, or fixed because it was broken, leave the smallest runnable check behind.

Do not add a framework, fixture farm, snapshot maze, or broad suite unless the project already uses that shape and the change needs it. The check should prove the lazy path works without becoming the new overbuild.

## The `# lean:` marker — name your deliberate simplifications

When you take the minimal path on purpose and it has a ceiling, mark it so the next person knows it was a choice, not an oversight, and knows when to revisit:

`# lean: <the simplification> — upgrade when <the condition that breaks it>`

Example: `# lean: linear scan, fine for the ~50 configs we load — index it when this is hot`. The marker turns a silent shortcut into a documented trade-off with an upgrade path.

## Red flags — STOP

- Hand-rolling something a language/runtime primitive, stdlib, native feature, or project-standard package already does.
- Adding a dependency to save a handful of obvious lines.
- Avoiding the project's idiomatic package and writing longer, riskier base-only code in the name of "stdlib first."
- Building an interface, factory, or config system with exactly one caller.
- Adding a feature, parameter, or branch nothing currently needs ("for later").
- Compressing working logic into a clever one-liner that hides what it does.
- Expanding a clear one-liner into boilerplate or ceremony just to look "readable".
- Shipping non-trivial logic or a bug fix with no runnable check.
- Patching the same symptom in three callers instead of fixing where they converge.

## Common rationalizations

| Excuse | Reality |
|---|---|
| "I'm making it flexible for the future." | The future caller usually never comes, and the flexibility you guessed at is usually wrong. Generalize when the second real caller appears. |
| "A one-liner is elegant." | Sometimes. Keep it when it says one plain thing with ordinary syntax; split it when it hides decisions, side effects, or reviewer gymnastics. |
| "Readable means more lines." | No. Readable means obvious. If one line is obvious and ten lines are ceremony, the one-liner is the leaner code. |
| "It's too small to test." | Maybe. Trivial glue needs none; a bug fix, branch, parser, or risky path gets one tiny runnable check. |
| "Stdlib first means no packages." | No. It means don't own code the platform or project-standard tools already handle. Use the package when it is the idiomatic primitive. |
| "It's just one small dependency." | Every new dependency is a permanent cost — supply chain, version churn, build weight. Use the stdlib, native feature, or what's already installed first. |
| "A framework is more professional than a script." | For a task that needs a script, the readable script is the professional choice. Overcomplication isn't rigor. |

## The bottom line

```
Just enough  →  the fewest things that need to exist, each in its shortest obvious shape, checked when non-trivial
Otherwise    →  code nobody needed, a clever line nobody can read, unchecked logic, or ceremony nobody asked for
```
