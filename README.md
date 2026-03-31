# Ternary-VHDL
VHDL library based on [IEEE-1076](https://gitlab.com/IEEE-P1076/packages) which enables description of balanced ternary RTL hardware.
All arithmetic operations are supported, including several novel balanced ternary integer division algorithms.
The new Kleene type is introduced, being the ternary equivalent of the binary Boolean.

## Prerequisites
* Microsoft VSCode is recommended because it allows seamless usage of the extensions:
    * [VHDL by HGB](https://marketplace.visualstudio.com/items?itemName=P2L2.vhdl-by-hgb), which provides a VHDL language server and syntax highlighting. It can be helpful to set the "vhdl-by-hgb.vhdlls.toml.generation" option in the extension's settings to "manual". This way, you will use the dedicated .toml file from this project.
    * [VUnit by HGB](https://marketplace.visualstudio.com/items?itemName=P2L2.vunit-by-hgb), which enables the "Testing" sidebar for VUnit tests.
* The recommended open-source VHDL compiler is [GHDL](https://github.com/ghdl/ghdl?tab=readme-ov-file#getting-ghdl) >= v5.1.1. See platform-specific installation guides on its GitHub page. If on Windows, ghdl.exe must be added to PATH.
* VUnit, necessary to run the library's tests, can be installed with pip ```pip install vunit_hdl```, or from their [GitHub repository](https://github.com/vunit/vunit/).

## Other information
* The TVL library has only been verified to work with VHDL 2008.
* The commands used to compile the TVL library can be found in _.vscode/tasks.json_ under the section "Compile TVL Library".
* The recommended simulation waveform viewer is [GTKWave](https://sourceforge.net/projects/gtkwave/) >= v3.3.100.
* To be able to see the new types in GTKWave, the output waveform files from GHDL must be of type **.ghw**. See the "run" commands used in _.vscode/tasks.json_.