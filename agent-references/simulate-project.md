# Simulate a project

Runs an elaborated testbench under GHDL, captures a `.ghw` waveform, and (when a display is available) opens it in GTKWave.

## Inputs

A testbench entity name `<tb>` (e.g. `flip_flop_tb`) and the project it belongs to (`<proj>`, see [compile-project.md](compile-project.md)).

## Recipe

Run from the repo root:

```bash
# 1. Make sure the project is compiled (idempotent — see compile-project.md)

# 2. Run the testbench, capturing a GHW waveform
ghdl -r <tb> --wave=<proj>/workdir/<tb>_wave.ghw [--stop-time=<N>ns]

# 3. Open the waveform (skip on headless systems)
gtkwave <proj>/workdir/<tb>_wave.ghw
```

GHDL's `-r` looks up the elaborated entity in the current directory's library (`work`) by default. If GHDL can't find the testbench, ensure step 6 of [compile-project.md](compile-project.md) ran successfully.

## Stop time

- If the testbench self-terminates (asserts `std.env.stop` or runs out of stimulus), omit `--stop-time`.
- For `flip_flop_tb` and other always-clocked benches, `.vscode/tasks.json` uses `--stop-time=100ns`. Match that as a default when the user doesn't specify.
- If the user gives a duration (e.g. "simulate for 10us"), pass it directly: `--stop-time=10us`.

## Wave format

**Always use `.ghw`, never `.vcd`.** TVL's custom types (`kleene`, `bal_logic`, `bal_numeric`) lose information when dumped as VCD; GHW preserves them so GTKWave displays them correctly. This is documented in the repo [README.md](../README.md) under "Other information".

## Headless / no-display environments

When `$DISPLAY` is unset (Linux), or when running over SSH/CI without X forwarding:

- Run step 2 (the simulation) as normal.
- **Skip step 3.** Instead, report the waveform path to the user: e.g. `Waveform written to rtl_designs/workdir/flip_flop_tb_wave.ghw`.
- The user can copy the file to a machine with GTKWave installed.

## Multiple testbenches

To simulate every testbench in a project, loop:

```bash
for f in <proj>/testbench/*_tb.vhdl; do
  tb=$(basename "$f" .vhdl)
  ghdl -r "$tb" --wave="<proj>/workdir/${tb}_wave.ghw" || true
done
```

Use `|| true` (or check exit codes individually) so one failing testbench doesn't abort the rest.

## VUnit alternative

If the project has a `run.py` and VUnit is installed, prefer the VUnit flow — see [vunit-flow.md](vunit-flow.md). VUnit handles compile + simulate + reporting in one command and is the project's preferred test driver.
