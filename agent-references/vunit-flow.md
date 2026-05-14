# VUnit flow

VUnit (<https://vunit.github.io/>) is the project's preferred test driver. When available, it replaces the manual ANA → ELA → run sequence with a single Python invocation that handles dependency tracking, parallel execution, and pass/fail reporting.

## When to prefer VUnit

Use the VUnit flow when **both**:

- The project has a `run.py` at its root. The repo currently ships two:
  - [tvl_lib/run.py](../tvl_lib/run.py) — runs all TVL library testbenches.
  - [rtl_designs/run.py](../rtl_designs/run.py) — runs RTL + RTL testbenches against TVL.
- VUnit is importable: `python -c "import vunit"` returns 0.

If either condition fails, fall back to raw GHDL ([compile-project.md](compile-project.md) + [simulate-project.md](simulate-project.md)).

## Commands

Run from the repo root, the directory containing the relevant `run.py`, or anywhere — but prefer the script's own directory so relative paths resolve cleanly.

```bash
# Compile and run every testbench in the project
python tvl_lib/run.py
python rtl_designs/run.py

# Filter to a single test by entity name (wildcards allowed)
python rtl_designs/run.py "*flip_flop_tb*"

# Pick a custom output directory (default is ./vunit_out next to run.py)
python rtl_designs/run.py --output-path /tmp/vunit_out
```

The repo [README.md](../README.md) shows the same command shape under "VUnit Run Command".

## Environment variables

Both `run.py` files set these at startup, so you don't need to export them yourself:

```python
os.environ['VUNIT_VHDL_STANDARD'] = '2008'
os.environ['VUNIT_SIMULATOR']     = 'ghdl'
```

If you invoke VUnit some other way, set them first.

## Library bindings

`tvl_lib/run.py` adds:

- Library `TVL` ← `tvl_lib/lib/*.vhdl` and `tvl_lib/testbench/**/*.vhdl`

`rtl_designs/run.py` adds:

- Library `TVL` ← `tvl_lib/lib/*.vhdl`
- Library `RTL` ← `rtl_designs/rtl/*.vhdl` and `rtl_designs/testbench/**/*.vhdl`

These bindings should match `vhdl_ls.toml` for IDE consistency.

## Viewing waveforms with VUnit

VUnit writes `.ghw` files into `<output-path>/test_output/<test_name>/ghdl/wave.ghw`. Open with:

```bash
gtkwave vunit_out/test_output/<test_name>/ghdl/wave.ghw
```

VUnit can also auto-open GTKWave when a test fails — see VUnit's docs for `--gui` and per-test wave settings.

## VUnit's GHDL flags

`tvl_lib/run.py` sets:

```python
vu.set_sim_option("ghdl.sim_flags", ["--assert-level=none"])
vu.set_sim_option("vhdl_assert_stop_level", "failure")
```

`--assert-level=none` prevents any assertion violation from stopping simulation (so a failing assertion is reported but the test continues to completion). `vhdl_assert_stop_level=failure` then makes VUnit treat `failure`-severity asserts as test failures. Don't change these without a reason — they're tuned to how the testbenches report results.
