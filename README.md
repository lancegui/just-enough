# just-enough

A general-purpose code-restraint discipline for AI coding agents: walk a reuse ladder before writing anything, and stop at the minimal **readable** solution — never a golfed one-liner.

De-golfed [ponytail](https://github.com/DietrichGebert/ponytail): keeps the "should this code exist?" ladder, drops the fewest-lines terminal value in favour of readability.

## Skill

- `just-enough` — fires when writing or editing any code; walks necessity → reuse → stdlib → existing dependency → minimal readable code.

## Install

Add this directory as a local plugin and restart your agent. Pairs with (but does not require) the econ-specific `analysis-craft` skill, which specialises the readability standard for research code.
