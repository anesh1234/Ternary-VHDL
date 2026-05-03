---
mode: agent
description: Simulate a testbench — compile, run with .ghw waveform, open in GTKWave
---

Read [../../agent-references/simulate-project.md](../../agent-references/simulate-project.md) and simulate the testbench named by the user (e.g. `flip_flop_tb`, `kleene_binaryfunc_tb`).

Steps:
1. Make sure the project containing the testbench is compiled — see [../../agent-references/compile-project.md](../../agent-references/compile-project.md).
2. Run `ghdl -r <tb> --wave=<workdir>/<tb>_wave.ghw [--stop-time=…]`. Default `--stop-time=100ns` for `flip_flop_tb`; otherwise omit and let the testbench self-terminate, unless the user specifies a duration.
3. Open the waveform in GTKWave when a display is available. On headless systems, skip GTKWave and report the `.ghw` path.

Prefer VUnit (`python <project>/run.py "*<tb>*"`) when `run.py` exists and VUnit is importable — see [../../agent-references/vunit-flow.md](../../agent-references/vunit-flow.md).
