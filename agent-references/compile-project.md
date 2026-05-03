# Compile a project

Compiles a project's RTL and testbench sources against the TVL library, producing analyzed and elaborated artifacts ready to simulate.

## Inputs

A project name `<proj>` resolving to a directory layout of:

```
<proj>/
├── rtl/                  # synthesizable RTL sources (*.vhdl)
└── testbench/            # testbench sources (*_tb.vhdl)
```

Two layouts exist in this repo:

- **Flat** — `rtl_designs/rtl/` and `rtl_designs/testbench/`. Treat `<proj>` = `rtl_designs`.
- **Nested** — `rtl_designs/<sub>/rtl/` and `rtl_designs/<sub>/testbench/`. Treat `<proj>` = `rtl_designs/<sub>` (e.g. `rtl_designs/old_testbench/kleene`).

If neither layout matches the user's request, report the missing directory and stop.

## Recipe

Run from the repo root:

```bash
# 1. TVL must be compiled first (no-op if up to date — see compile-tvl.md)
#    Skip this if you've just run /compile-tvl.

# 2. Prepare workdir
mkdir -p <proj>/workdir

# 3. Analyze every RTL source
for f in <proj>/rtl/*.vhdl; do
  ghdl -a --std=08 --work=work --workdir=<proj>/workdir -Ptvl_lib/workdir "$f" || exit 1
done

# 4. Elaborate the top RTL entity (entity name = filename stem unless user specifies otherwise)
ghdl -e --std=08 --work=work --workdir=<proj>/workdir -Ptvl_lib/workdir <rtl_top_entity>

# 5. Analyze every testbench source
for f in <proj>/testbench/*.vhdl; do
  ghdl -a --std=08 --work=work --workdir=<proj>/workdir -Ptvl_lib/workdir "$f" || exit 1
done

# 6. Elaborate each testbench entity
for f in <proj>/testbench/*_tb.vhdl; do
  tb=$(basename "$f" .vhdl)
  ghdl -e --std=08 --work=work --workdir=<proj>/workdir -Ptvl_lib/workdir "$tb" || exit 1
done
```

## Identifying the top RTL entity

If the user names a specific entity, use it. Otherwise:

- For `rtl_designs/rtl/<name>.vhdl` the entity is conventionally `<name>` (e.g. `flip_flop.vhdl` → entity `flip_flop`).
- Confirm by `grep -E '^[[:space:]]*entity[[:space:]]+' <proj>/rtl/*.vhdl`.
- If multiple entities exist and none is obviously top, ask the user.

If the user only wants to simulate a testbench (and not run a synthesis-style elaboration of the RTL on its own), step 4 may be skipped — testbench elaboration in step 6 will pull in the needed RTL.

## Verification

After completion, `<proj>/workdir/` should contain:

- `work-obj08.cf` — library config
- `<entity>` executables for each elaborated entity (no extension on Linux/macOS, `.exe` on Windows)
- `*.o` object files for every analyzed source

## Command anatomy

See [ghdl-command-pattern.md](ghdl-command-pattern.md). Key points for this workflow:

- `--work=work` — project sources go into the default `work` library.
- `-Ptvl_lib/workdir` — required so GHDL can resolve `library TVL; use TVL.bal_logic.all;` etc.
- `--workdir=<proj>/workdir` keeps each project's objects separate.

## Authoritative reference

See `.vscode/tasks.json` for the exact command lines used historically — this recipe is the runtime equivalent of `create_tb_tasks.py`.
