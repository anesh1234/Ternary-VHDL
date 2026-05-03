---
description: Compile a Ternary-VHDL project — TVL → analyze RTL → elaborate → analyze testbench → elaborate
argument-hint: <project-path-or-name>
---

Read [../../agent-references/compile-project.md](../../agent-references/compile-project.md) and follow the recipe for the project given in `$ARGUMENTS` (e.g. `rtl_designs`, `rtl_designs/old_testbench/kleene`). If `$ARGUMENTS` is empty, default to `rtl_designs`.

Before starting:
- If `tvl_lib/workdir/` is missing or stale, run the compile-tvl workflow first ([../../agent-references/compile-tvl.md](../../agent-references/compile-tvl.md)).
- Confirm the project's `rtl/` and `testbench/` directories exist; if not, report the missing path and stop.

Prefer the VUnit flow if the project has a `run.py` and VUnit is importable — see [../../agent-references/vunit-flow.md](../../agent-references/vunit-flow.md).
