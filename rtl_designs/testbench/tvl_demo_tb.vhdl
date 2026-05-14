library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;
use TVL.kleene_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;

entity tvl_demo_tb is
  generic (runner_cfg : string);
end entity;

architecture Behavioral of tvl_demo_tb is

    signal bos : BOOLEAN;
    signal bov : BOOLEAN_VECTOR(2 downto 0) := (false,false,true);

    signal sts  : STD_LOGIC;
    signal stv  : STD_LOGIC_VECTOR(8 downto 0) := "UX01ZWLH-";
    signal stv2 : STD_LOGIC_VECTOR(0 to 8) := "UX01ZWLH-";

    signal bts : BTERN_LOGIC;
    signal btv : BTERN_LOGIC_VECTOR(10 downto 0) := BTERN_LOGIC_VECTOR'("UX-0+ZWLMHD");
    signal btv2 : BTERN_LOGIC_VECTOR(0 to 10) := BTERN_LOGIC_VECTOR'("UX-0+ZWLMHD");

    signal kls : KLEENE;
    signal klv : KLEENE_VECTOR(2 downto 0) := (false,unk,true);

begin
    main : process
    begin
        test_runner_setup(runner, runner_cfg);

        if run("All values of all types") then
            wait for 120 ns;
        end if;

        test_runner_cleanup(runner);
    end process;

    std : process
        type slv_array is array (0 to 8) of std_logic;
        constant VALUES : slv_array := ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-');
    begin
        for i in VALUES'range loop
            sts <= VALUES(i);
            wait for 10 ns;
        end loop;
    end process;

    bt : process
        type bt_array is array (0 to 10) of BTERN_LOGIC;
        constant VALUES : bt_array := ('U','X','-','0','+','Z','W','L','M','H','D');
    begin
        for i in VALUES'range loop
            bts <= VALUES(i);
            wait for 10 ns;
        end loop;
    end process;

    kl : process
        type kle_array is array (0 to 2) of KLEENE;
        constant VALUES : kle_array := (false, unk, true);
    begin
        for i in VALUES'range loop
            kls <= VALUES(i);
            wait for 10 ns;
        end loop;
    end process;

    bl : process
        type boo_array is array (0 to 1) of BOOLEAN;
        constant VALUES : boo_array := (false, true);
    begin
        for i in VALUES'range loop
            bos <= VALUES(i);
            wait for 10 ns;
        end loop;
    end process;
end architecture;
