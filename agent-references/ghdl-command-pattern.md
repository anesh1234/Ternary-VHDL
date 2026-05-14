# GHDL command pattern

The canonical GHDL invocations used by every workflow in this repo. Use these as fallback when a request doesn't match a specific reference doc.

## Templates

```bash
# Analyze (compile a source file into a library)
ghdl -a --std=08 --work=<lib> --workdir=<dir> [-P<lib_dir>] <file.vhdl>

# Elaborate (link an entity for simulation)
ghdl -e --std=08 --work=<lib> --workdir=<dir> [-P<lib_dir>] <entity>

# Run (simulate and capture a waveform)
ghdl -r <entity> --wave=<dir>/<entity>.ghw [--stop-time=<N>ns]

# View
gtkwave <dir>/<entity>.ghw
```

These come from the project's own template at `.vscode/commands_single.txt`.

## Mandatory flags

| Flag | Why |
|---|---|
| `--std=08` | TVL is VHDL-2008 only. Older standards fail to compile. |
| `--workdir=<dir>` | GHDL stores object files here. One workdir per library. |
| `-Ptvl_lib/workdir` | Required on **every** invocation that uses TVL — analysis, elaboration, and synthesis. Tells GHDL where to find the precompiled `TVL` library. |

## Library convention

| Library | Source location | Used for |
|---|---|---|
| `TVL` | `tvl_lib/lib/*.vhdl` | The reusable balanced-ternary library |
| `work` | `rtl_designs/**/*.vhdl` | Per-project RTL and testbenches |
| `vunit_lib`, `osvvm` | `vunit_vhdl_src/**` | VUnit + OSVVM verification framework (used via `run.py`) |

See `vhdl_ls.toml` for the authoritative mapping (also used by the VHDL language server).

## Waveform format

Use `.ghw`, not `.vcd`. VCD cannot represent TVL's custom enumerated types (`kleene`, `bal_logic`, `bal_numeric`); GHW preserves them so GTKWave shows the correct symbolic values.

## Synthesis (deferred to v2)

Synthesis with `ghdl --synth` is not covered by this skill yet. The template lives in `.vscode/commands_single.txt` if needed:

```
ghdl --synth --std=08 --out=vhdl -Ptvl_lib/workdir <file.vhdl> -e <entity>
```

## When to consult `ghdl --help`

If a user request doesn't fit any of the above:

```bash
ghdl --help              # list subcommands
ghdl <subcommand> --help # full usage for one subcommand
```

GHDL's help is comprehensive — derive the right flags from there before guessing.
