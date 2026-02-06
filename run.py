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

# Add random support (integrates OSVVM)
vu.add_random()

tvl_lib = vu.add_library("TVL")
tvl_lib.add_source_files(str(root / "tvl_lib/lib/*.vhdl"))
tvl_lib.add_source_files(str(root / "tvl_lib/testbench/**/*.vhdl"))

# Option --assert-level=none prevents any assertion violation from stopping simulation. -GHDL docs
vu.set_sim_option("ghdl.sim_flags", ["--assert-level=none"])
vu.set_sim_option("vhdl_assert_stop_level", "failure")

vu.main()