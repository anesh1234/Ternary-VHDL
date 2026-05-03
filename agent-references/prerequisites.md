# Prerequisites

Before running any TVHDL workflow, verify the toolchain is available.

## Required tools

| Tool | Minimum version | Check command |
|---|---|---|
| GHDL | 5.1.1 | `ghdl --version` |
| GTKWave | 3.3.100 | `gtkwave --version` |

## Optional tools

| Tool | Purpose | Check command |
|---|---|---|
| VUnit (Python) | Test runner — preferred when present (see [vunit-flow.md](vunit-flow.md)) | `python -c "import vunit"` |

## If a required tool is missing

**Do not auto-install.** Report the missing tool to the user and point them to:

- GHDL: <https://github.com/ghdl/ghdl#getting-ghdl> — platform-specific install guides. On Windows, `ghdl.exe` must be on `PATH`.
- GTKWave: <https://sourceforge.net/projects/gtkwave/>
- VUnit: `pip install vunit_hdl` or <https://github.com/vunit/vunit/>

Project-level details are in the repo [README.md](../README.md).

## Workdir setup

GHDL stores per-library object files in `workdir/` directories. Before the first analyze of any library, create the directory:

```bash
mkdir -p tvl_lib/workdir
mkdir -p <project>/workdir   # per-project, e.g. rtl_designs/workdir
```

Workdirs may be deleted at any time to force a clean rebuild.

## VHDL standard

Every GHDL invocation in this repo uses `--std=08` (VHDL-2008). The TVL library has only been verified against VHDL-2008 — older standards will fail to compile.
