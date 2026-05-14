# Ternary-VHDL
Introducing the three-valued logic (TVL) VHDL library based on [IEEE-1076](https://gitlab.com/IEEE-P1076/packages), which enables description of balanced ternary hardware and pre-synthesis simulation with GHDL, VUnit and Surfer/GTKWave.
All arithmetic operations are supported, including two novel balanced ternary integer division algorithms.
The new Kleene type is introduced, being the ternary equivalent of the binary Boolean.
The TVL library itself lies in *tvl_lib/lib/*, and its VUnit testbenches in *tvl_lib/testbench/*.
Several minimal RTL designs have been produced to validate the library, which can be found in *rtl_designs/rtl*, with their testbenches in *rtl_designs/testbench*.

## Prerequisites
* Microsoft VSCode is recommended because it allows seamless usage of the extensions:
    * [VHDL by HGB](https://marketplace.visualstudio.com/items?itemName=P2L2.vhdl-by-hgb) - Provides a VHDL language server and syntax highlighting. It can be helpful to set the "vhdl-by-hgb.vhdlls.toml.generation" option in the extension's settings to "manual". In this way, you will use the dedicated .toml file from this project without changes to start with.
    * [VUnit by HGB](https://marketplace.visualstudio.com/items?itemName=P2L2.vunit-by-hgb) - Enables the "Testing" sidebar for VUnit tests.
* The recommended open-source VHDL compiler is [GHDL](https://github.com/ghdl/ghdl?tab=readme-ov-file#getting-ghdl) >= v5.1.1. See platform-specific installation guides on its GitHub page. If on Windows, ghdl.exe must be added to PATH.
* VUnit, necessary to run the library's tests, can be installed with pip ```pip install --upgrade vunit_hdl```, or from their [GitHub repository](https://github.com/vunit/vunit/). To be able to launch the Surfer fork enabling ternary signals via VUnit, the version must be >= 5.0.0. V5 was a development version at the time of writing.

## Other information
* The TVL library has only been verified to work with VHDL 2008.
* The commands used to compile the TVL library can be found in _.vscode/tasks.json_ under the section "Compile TVL Library".
* Regarding simulation waveform viewing there are two recommendations:
    * The [Surfer fork](https://github.com/anesh1234/Surfer-Balanced-Ternary-Support) produced during this project, enbaling ternary signal levels and proper array views.
    * [GTKWave](https://sourceforge.net/projects/gtkwave/) >= v3.3.100.
* To be able to see the new types in GTKWave/Surfer, the output waveform files from GHDL must be of type **.ghw**. With the VUnit VSC extension, this happens automatically, otherwise it can be set with command-line options in its settings. If not using the VUnit extension, see the "run" commands used in _.vscode/tasks.json_.