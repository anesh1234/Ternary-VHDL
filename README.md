# Ternary-VHDL
VHDL library based on [IEEE-1076](https://gitlab.com/IEEE-P1076/packages) which enables description of balanced ternary RTL hardware.

## Prerequisites
* Microsoft VSCode is reccomended because it allows seamless usage of the extensions:
    * [VHDL by HGB](https://marketplace.visualstudio.com/items?itemName=P2L2.vhdl-by-hgb), which provides a VHDL language server and syntax highlighting
    * [VUnit by HGB](https://marketplace.visualstudio.com/items?itemName=P2L2.vunit-by-hgb), which enables the "Testing" sidebar for VUnit tests.
* The reccomended open-source VHDL compiler is [GHDL](https://github.com/ghdl/ghdl?tab=readme-ov-file#getting-ghdl) >= v5.1.1.
    * The commands used by the author to compile the TVL library can be found in _.vscode/tasks.json_ under the section "Compile TVL Library".
* The library has only been verified to work with the VHDL 2008 standard.
* The reccomended simulation waveform viewer is [GTKWave](https://sourceforge.net/projects/gtkwave/) >= v3.3.100.
    * To be able to see the new types in GTKWave, the output waveform files from GHDL must be of type **.ghw**. See the "run" commands used in _.vscode/tasks.json_.
* VUnit can be installed with pip ```pip install vunit_hdl```, or from their [GitHub repository](https://github.com/vunit/vunit/).