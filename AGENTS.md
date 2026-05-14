# AGENTS.md — Ternary-VHDL

This file gives AI coding agents (Claude Code, GitHub Copilot, Cursor, Aider, Codex CLI, …) the project context and workflows needed to build, test, and simulate the TVHDL library and its RTL designs.

## What this repo is

**Ternary-VHDL (TVHDL)** is a VHDL-2008 library for describing balanced-ternary RTL hardware. It is based on [IEEE-1076](https://gitlab.com/IEEE-P1076/packages) and introduces a `kleene` type (the ternary equivalent of `boolean`) plus balanced-ternary logic and numeric packages. Designs are simulated with [GHDL](https://github.com/ghdl/ghdl) and visualized in [GTKWave](https://sourceforge.net/projects/gtkwave/); tests are typically driven by [VUnit](https://vunit.github.io/).

## Prerequisites

Before running any workflow, verify:

```bash
ghdl --version          # ≥ 5.1.1
gtkwave --version       # ≥ 3.3.100
python -c "import vunit"  # optional, enables the VUnit flow
```

Do not auto-install missing tools — direct the user to [agent-references/prerequisites.md](agent-references/prerequisites.md).

## Quick reference

| Workflow | One-line summary | Reference |
|---|---|---|
| Compile TVL library | Analyze the 6 TVL files into `tvl_lib/workdir/` in fixed order | [agent-references/compile-tvl.md](agent-references/compile-tvl.md) |
| Compile a project | TVL → analyze RTL → elaborate → analyze testbench → elaborate | [agent-references/compile-project.md](agent-references/compile-project.md) |
| Simulate a project | Compile → `ghdl -r <tb> --wave=…ghw` → GTKWave | [agent-references/simulate-project.md](agent-references/simulate-project.md) |

The exact command lines are also visible (per testbench) in `.vscode/tasks.json` if you need to cross-check.

## Decision rule: VUnit vs raw GHDL

If the project has a `run.py` **and** `python -c "import vunit"` succeeds, prefer the VUnit flow ([agent-references/vunit-flow.md](agent-references/vunit-flow.md)) — it is the project's preferred test driver. Otherwise fall back to raw GHDL.

The repo currently ships [tvl_lib/run.py](tvl_lib/run.py) and [rtl_designs/run.py](rtl_designs/run.py).

## Mandatory GHDL flags

Every analyze/elaborate invocation in this repo uses:

- `--std=08` — TVL is VHDL-2008 only.
- `-Ptvl_lib/workdir` — required whenever the unit being compiled depends on TVL.
- `--wave=…ghw` (not `.vcd`) — GHW is the only format that preserves TVL's custom enumerated types in GTKWave.

Full pattern in [agent-references/ghdl-command-pattern.md](agent-references/ghdl-command-pattern.md).

## Project layout

Two project layouts coexist:

- **Flat** — `rtl_designs/rtl/` and `rtl_designs/testbench/` (the active project).
- **Nested** — `rtl_designs/<sub>/rtl/` and `rtl_designs/<sub>/testbench/` (e.g. `rtl_designs/old_testbench/kleene/`).

Detail and library bindings (`TVL`, `work`, `vunit_lib`, `osvvm`) in [agent-references/project-layout.md](agent-references/project-layout.md).

## Fallback for unmapped requests

If the user asks for something not covered above:

1. Read [agent-references/ghdl-command-pattern.md](agent-references/ghdl-command-pattern.md).
2. Run `ghdl --help` and `ghdl <subcmd> --help`.
3. Derive the right invocation; ask the user before running anything destructive.

## Tool-specific entry points

These are thin wrappers around the references above — the references are the source of truth.

- **Claude Code** — slash commands at `.claude/commands/{compile-tvl,compile-project,simulate-project}.md`.
- **GitHub Copilot** — reusable prompts at `.github/prompts/{compile-tvl,compile-project,simulate-project}.prompt.md`. `/.github/copilot-instructions.md` points Copilot here.

When editing this tooling, change the `agent-references/*.md` files first; the wrappers only need updating if the workflow names or argument shapes change.
