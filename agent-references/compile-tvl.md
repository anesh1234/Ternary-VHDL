# Compile the TVL library

Analyzes the six TVL source files into the `TVL` library at `tvl_lib/workdir/` in dependency order. Idempotent: re-running with no source changes is a no-op.

## File order (mandatory)

The order matters — package specs must precede their bodies, and `kleene` is depended on by `bal_logic`, which is depended on by `bal_numeric`:

1. `tvl_lib/lib/kleene_pkg.vhdl`
2. `tvl_lib/lib/kleene_pkg-body.vhdl`
3. `tvl_lib/lib/bal_logic.vhdl`
4. `tvl_lib/lib/bal_logic-body.vhdl`
5. `tvl_lib/lib/bal_numeric.vhdl`
6. `tvl_lib/lib/bal_numeric-body.vhdl`

Authoritative source: `.vscode/tasks.json` → `"TVL Lib"` task and its six dependencies.

## Single-command sequence

Run from the repo root:

```bash
mkdir -p tvl_lib/workdir
for f in kleene_pkg kleene_pkg-body bal_logic bal_logic-body bal_numeric bal_numeric-body; do
  ghdl -a --std=08 --work=TVL --workdir=tvl_lib/workdir tvl_lib/lib/$f.vhdl || exit 1
done
```

## Verification

After completion, `tvl_lib/workdir/` should contain:

- `TVL-obj08.cf` — the GHDL library config file
- `kleene_pkg.o`, `bal_logic.o`, `bal_numeric.o` (and their bodies) — compiled object files

If any analyze step fails, GHDL will print a diagnostic with the offending file/line. Do not continue to subsequent steps — fix the source first.

## When to re-run

Re-run after any change to a file under `tvl_lib/lib/`. GHDL's `-a` is incremental within a workdir; deleting `tvl_lib/workdir/` forces a full rebuild.

## Command anatomy

See [ghdl-command-pattern.md](ghdl-command-pattern.md). Key points for this workflow:

- `--work=TVL` — target library is `TVL` (not the default `work`).
- `--workdir=tvl_lib/workdir` — object cache lives next to the sources.
- No `-P` flag needed here: TVL only depends on standard libraries.
