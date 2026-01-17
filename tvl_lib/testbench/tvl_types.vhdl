-- --------------------------------------------------------------------
-- Title   : 
-- Purpose :
-- ---------------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;
library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;
use TVL.kleene_pkg.all;

entity tvl_types_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of tvl_types_tb is
  signal btu_sc   : BTERN_ULOGIC;
  signal btl_sc   : BTERN_LOGIC;
  signal trit_sc  : TRIT;
  signal btu_vec  : BTERN_ULOGIC_VECTOR(5 downto 0);
  signal btl_vec  : BTERN_ULOGIC_VECTOR(5 downto 0);
  signal trit_vec : TRIT_VECTOR(5 downto 0);
  signal xp       : X2P;
  signal xz       : X2Z;
  signal up       : U2P;
  signal uz       : U2Z;
begin
  main : process
  begin
    test_runner_setup(runner, runner_cfg);

    -- Put test suite setup code here. This code is common to the entire test suite
    -- and is executed *once* prior to all test cases.

    while test_suite loop

      -- Put test case setup code here. This code executed before *every* test case.

      if run("Test BTERN_ULOGIC ") then
        for i in 0 to 8 loop
          btu_sc <= BTERN_ULOGIC'VAL(i);
          check_equal(TO_STRING(btu_sc), TO_STRING(BTERN_ULOGIC'VAL(i)));
        end loop;
      end if;

      -- Put test case cleanup code here. This code executed after *every* test case.

    end loop;

    -- Put test suite cleanup code here. This code is common to the entire test suite
    -- and is executed *once* after all test cases have been run.

    test_runner_cleanup(runner);
  end process;
end architecture;