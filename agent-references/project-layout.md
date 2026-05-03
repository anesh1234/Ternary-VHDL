# Project layout

Map of the Ternary-VHDL repo, the conventions every workflow assumes, and where each library lives.

## Directory map

```
Ternary-VHDL/
├── tvl_lib/
│   ├── lib/                    # TVL library sources (compile in fixed order — see compile-tvl.md)
│   ├── testbench/              # TVL self-tests (driven by VUnit)
│   ├── workdir/                # GHDL object cache for the TVL library (created on first compile)
│   └── run.py                  # VUnit driver for TVL self-tests
├── rtl_designs/
│   ├── rtl/                    # Active project RTL sources (flat layout)
│   ├── testbench/              # Active project testbenches
│   ├── old_testbench/          # Per-subproject testbenches (nested layout)
│   │   ├── kleene/{kleene_*_tb.vhdl, workdir/}
│   │   ├── logic/{*_tb.vhdl, workdir/}
│   │   ├── numeric/{*_tb.vhdl, workdir/}
│   │   └── paper/{*_tb.vhdl, workdir/}
│   ├── bin_vs_tern_synth/      # Synthesis examples (deferred to v2)
│   ├── workdir/                # GHDL object cache for the active project
│   └── run.py                  # VUnit driver for RTL + testbenches
├── vunit_vhdl_src/             # Vendored VUnit + OSVVM (used by run.py)
├── python/                     # Python helpers
├── vhdl_ls.toml                # VHDL language server config (library bindings)
├── .vscode/
│   ├── tasks.json              # VS Code task wiring (1:1 with the GHDL commands)
│   ├── commands_single.txt     # Canonical templates (source for ghdl-command-pattern.md)
│   └── create_tb_tasks.py      # Generator for tasks.json
└── README.md                   # Human-facing docs (toolchain versions, prereqs)
```

## Library bindings

From `vhdl_ls.toml`:

| Library | Files |
|---|---|
| `TVL` | `tvl_lib/lib/*.vhdl` |
| `defaultlib` (= `work` for GHDL) | `rtl_designs/**/*.vhdl`, `tvl_lib/testbench/**/*.vhdl` |
| `vunit_lib` | `vunit_vhdl_src/**/*.vhd` (with exclusions for VHDL-93/2002/2019 variants) |
| `osvvm` | `vunit_vhdl_src/osvvm/**/*.vhd` |

Keep `vhdl_ls.toml` and the `run.py` library-binding calls in sync — the IDE uses the former, VUnit uses the latter.

## Workdir convention

Each library has its own `workdir/`:

- `tvl_lib/workdir/` — TVL library
- `rtl_designs/workdir/` — active flat-layout project
- `rtl_designs/<sub>/workdir/` — nested-layout subprojects (e.g. `rtl_designs/old_testbench/logic/workdir/`)

Workdirs are GHDL's per-library object cache. They're regenerated on every analyze, and **safe to delete** to force a clean rebuild.

## Project naming conventions

- RTL filename → entity name. `flip_flop.vhdl` declares `entity flip_flop`. Confirm with `grep -E '^[[:space:]]*entity[[:space:]]+' <file>` if unsure.
- Testbench filename → `<entity>_tb.vhdl` declaring `entity <entity>_tb`.
- Waveform output → `<workdir>/<entity>_wave.ghw`.

## Adding a new project

When the user wants to add a new RTL design:

1. Create `rtl_designs/<proj>/rtl/` and `rtl_designs/<proj>/testbench/`.
2. Add it to the `defaultlib.files` glob in `vhdl_ls.toml` (already covered by `rtl_designs/**/*.vhdl`).
3. Optionally add it to `rtl_designs/run.py` for VUnit.
4. Run [compile-project.md](compile-project.md) — `<proj>/workdir/` is created automatically.

No edits to `.vscode/tasks.json` are required for the agent-driven flow; tasks.json remains for users who prefer the VS Code task UI.
