from vunit import VUnit
from pathlib import Path
import os

# set VUnit environment variables

os.environ['VUNIT_VHDL_STANDARD'] = '2008'
os.environ['VUNIT_SIMULATOR'] = 'ghdl'

root = Path(__file__).parent

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv(compile_builtins=False)

# Add VUnit's builtin HDL utilities for checking, logging, communication...
# See http://vunit.github.io/hdl_libraries.html.
vu.add_vhdl_builtins()

tvl_lib = vu.add_library("TVL")
tvl_lib.add_source_files(str(root / "tvl_lib/lib/*.vhdl"))
tvl_lib.add_source_files(str(root / "tvl_lib/testbench/*.vhdl"))

vu.main()