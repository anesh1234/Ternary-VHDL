-- --------------------------------------------------------------------
-- Title   : BAL_NUMERIC Division Overloads
-- Notes   : 
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity numeric_division_tb is
  generic (runner_cfg : string);
end entity;

architecture test of numeric_division_tb is

    -- Test configuration
    constant NUM_RANDOM_TESTS : INTEGER := 1000;



begin

  main : process
    variable RV : RandomPType;  -- OSVVM random variable
    
    procedure test_division(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR;
      constant expected_vec : BTERN_LOGIC_VECTOR
    ) is
      variable rem_rem, rem_mod 
               : BTERN_LOGIC_VECTOR (b_vec'length-1 downto 0);
      variable quotient : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0);
      variable a_i, b_i, expected_i, quotient_i, 
               rem_rem_i, rem_mod_i  : INTEGER;

      -- DEBUG
      variable checker : BOOLEAN := false;
    begin
        a_i := TO_INTEGER(a_vec);
        b_i := TO_INTEGER(b_vec);
        expected_i := TO_INTEGER(expected_vec);

        quotient := a_vec / b_vec;
        rem_rem := a_vec rem b_vec;
        rem_mod := a_vec mod b_vec;

        quotient_i := TO_INTEGER(quotient);
        rem_rem_i := TO_INTEGER(rem_rem);
        rem_mod_i := TO_INTEGER(rem_mod);

        -- if quotient_i = expected_i then
        --     checker := true;
        -- end if;
        if a_i = b_i * expected_i + rem_rem_i then
            if rem_rem_i >= 0 and rem_rem_i < abs(b_i) then
                checker := true;
            end if;
        end if;

        -- DEBUG
        print(TO_STRING(checker) & " | " & TO_STRING(a_i) & " / " & TO_STRING(b_i) & " | "
              & TO_STRING(quotient_i) & " | " & TO_STRING(expected_i) & " | " 
              & TO_STRING(rem_rem_i) & " | " & TO_STRING(rem_mod_i), "vunit_out.txt");

    end procedure;

  begin
    test_runner_setup(runner, runner_cfg);
    
    -- Initialize random seed
    RV.InitSeed(RV'instance_name);

    if run("Static - Exhaustive -364 to +364") then
      -- Runs an exhaustive 6-trit test combining all numbers from 
      -- -364 to +364. Done in steps here to avoid division by 0.

        -- DEBUG
        print("Success" & " | " & "Calculation" & " | " & "Quot. Got" & " | " & "Quot. Expected" & " | " & "rem" & " | " & "mod", "vunit_out.txt");
        for x in -364 to -1 loop
            for y in -364 to -1 loop
                test_division(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6),
                TO_BALTERN(x / y, 6)
                );
            end loop;
        end loop;

        for x in -364 to -1 loop
            for y in 364 downto 1 loop
                test_division(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6),
                TO_BALTERN(x / y, 6)
                );
            end loop;
        end loop;

        for x in 364 downto 1 loop
            for y in -364 to -1 loop
                test_division(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6),
                TO_BALTERN(x / y, 6)
                );
            end loop;
        end loop;

        for x in 364 downto 1 loop
            for y in 364 downto 1 loop
                test_division(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6),
                TO_BALTERN(x / y, 6)
                );
            end loop;
        end loop;
    end if;
    
    test_runner_cleanup(runner);
  end process;
  
end architecture;