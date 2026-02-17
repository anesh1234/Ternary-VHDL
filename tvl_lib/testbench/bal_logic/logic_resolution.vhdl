-- --------------------------------------------------------------------
-- Title   : BAL_LOGIC Resolution Functions
-- Notes   : Tests the resolution function tied to the resolved type, 
--           and ensures that the unresolved type throws a compiler
--           error when driven by more than one signal.
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;

entity logic_resolution_tb is
  generic (runner_cfg : string);
end entity;

architecture test of logic_resolution_tb is
  
  -- Resolved signal to test
  signal resolved_sig : BTERN_LOGIC;

  -- Unresolved signal to test
  signal unresolved_sig : BTERN_ULOGIC;
  
  -- Resolved driver signals
  signal driver1 : BTERN_LOGIC := 'U';
  signal driver2 : BTERN_LOGIC := 'U';
  signal driver3 : BTERN_LOGIC := 'U';

  -- Unresolved driver signals
  signal driver1_U : BTERN_ULOGIC := 'U';
  -- signal driver2_U : BTERN_ULOGIC := 'U';
  
  -- Expected value
  signal expected : BTERN_LOGIC;

begin

  -- Connect drivers to resolved signal
  resolved_sig <= driver1;
  resolved_sig <= driver2;
  resolved_sig <= driver3;

  -- VALID: Single driver on BTERN_ULOGIC (unresolved type)
  unresolved_sig <= driver1_U;
  -- INVALID: This would cause a compile error (multiple drivers on unresolved)
  -- Uncomment to verify compiler catches this:
  -- unresolved_sig <= driver2_U;

  main : process

    variable vec_L : BTERN_LOGIC_VECTOR(7 downto 0);
    variable vec_U : BTERN_ULOGIC_VECTOR(7 downto 0);

    -- Helper procedure to test two-driver case
    procedure test_two_drivers(d1, d2, exp : BTERN_LOGIC) is
    begin
      driver1 <= d1;
      driver2 <= d2;
      driver3 <= 'Z';  -- High impedance (doesn't affect result)
      wait for 1 ns;
      
      check_equal(TO_STRING(resolved_sig), TO_STRING(exp), 
                  "Driver1=" & BTERN_LOGIC'image(d1) & 
                  ", Driver2=" & BTERN_LOGIC'image(d2) & 
                  " => Expected=" & BTERN_LOGIC'image(exp) &
                  ", Got=" & BTERN_LOGIC'image(resolved_sig));
    end procedure;
    
    -- Helper procedure to test three-driver case
    procedure test_three_drivers(d1, d2, d3, exp : BTERN_LOGIC) is
    begin
      driver1 <= d1;
      driver2 <= d2;
      driver3 <= d3;
      wait for 1 ns;

      check_equal(TO_STRING(resolved_sig), TO_STRING(exp), 
                  "3-Driver: D1=" & BTERN_LOGIC'image(d1) & 
                  ", D2=" & BTERN_LOGIC'image(d2) & 
                  ", D3=" & BTERN_LOGIC'image(d3) &
                  " => Expected=" & BTERN_LOGIC'image(exp) &
                  ", Got=" & BTERN_LOGIC'image(resolved_sig));
    end procedure;
    
    variable all_values : BTERN_LOGIC_VECTOR(0 to 10) := 
      ('U', 'X', '-', '0', '+', 'Z', 'W', 'L', 'M', 'H', 'D');
    
  begin
    test_runner_setup(runner, runner_cfg);
    
    while test_suite loop
      
      if run("LOGIC single driver") then
        for i in all_values'range loop
            driver1 <= all_values(i);
            driver2 <= 'Z';
            driver3 <= 'Z';
            wait for 1 ns;
            if driver1 = 'D' then
                expected <= 'X';
            else 
              expected <= all_values(i);
            end if;
            wait for 1 ns;
            check_equal(TO_STRING(resolved_sig), TO_STRING(expected));
        end loop;

      elsif run("LOGIC forcing conflicts") then
        -- Forcing 0 vs Forcing +
        test_two_drivers('0', '+', 'X');
        -- Forcing - vs Forcing 0
        test_two_drivers('-', '0', 'X');
        -- Forcing - vs Forcing +
        test_two_drivers('-', '+', 'X');
        
      elsif run("LOGIC forcing dominates weak") then
        -- Forcing 0 dominates Weak values
        test_two_drivers('0', 'L', '0');
        test_two_drivers('0', 'M', '0');
        test_two_drivers('0', 'H', '0');
        test_two_drivers('0', 'W', '0');
        
        -- Forcing + dominates Weak values
        test_two_drivers('+', 'L', '+');
        test_two_drivers('+', 'M', '+');
        test_two_drivers('+', 'H', '+');
        test_two_drivers('+', 'W', '+');
        
        -- Forcing - dominates Weak values
        test_two_drivers('-', 'L', '-');
        test_two_drivers('-', 'M', '-');
        test_two_drivers('-', 'H', '-');
        test_two_drivers('-', 'W', '-');
        
      elsif run("LOGIC weak resolution") then
        -- Same weak values resolve to themselves
        test_two_drivers('L', 'L', 'L');
        test_two_drivers('M', 'M', 'M');
        test_two_drivers('H', 'H', 'H');
        
        -- Different weak values resolve to W
        test_two_drivers('L', 'M', 'W');
        test_two_drivers('L', 'H', 'W');
        test_two_drivers('M', 'H', 'W');
        
      elsif run("LOGIC unknown propagation") then
        for i in all_values'range loop
          if all_values(i) /= 'U' then
            test_two_drivers('U', all_values(i), 'U');
          end if;
        end loop;

        test_two_drivers('X', '0', 'X');
        test_two_drivers('X', '+', 'X');
        test_two_drivers('X', '-', 'X');
        
      elsif run("LOGIC don't care behavior") then
        test_two_drivers('D', '0', 'X');
        test_two_drivers('D', '+', 'X');
        test_two_drivers('D', '-', 'X');
        test_two_drivers('D', 'L', 'X');
        test_two_drivers('D', 'M', 'X');
        test_two_drivers('D', 'H', 'X');
        
      elsif run("LOGIC three drivers") then
        test_three_drivers('0', '0', '0', '0');
        test_three_drivers('0', 'M', 'L', '0');
        test_three_drivers('L', 'M', 'H', 'W');
        test_three_drivers('0', '+', '-', 'X');
        test_three_drivers('0', '+', 'Z', 'X');


      elsif run("ULOGIC single driver") then
        info("Testing BTERN_ULOGIC accepts single driver");
        
        -- Test all values work on unresolved type
        for i in all_values'range loop
          driver1_U <= BTERN_ULOGIC(all_values(i));
          wait for 1 ns;
          check_equal(TO_STRING(unresolved_sig), TO_STRING(all_values(i)));
        end loop;

  elsif run("Cross-type assignment 1") then
        
        -- Can assign ULOGIC to LOGIC signal
        driver1_U <= '0';
        wait for 1 ns;
        driver1 <= BTERN_LOGIC(driver1_U);
        driver2 <= 'Z';
        driver3 <= 'Z';
        wait for 1 ns;
        check_equal(TO_STRING(resolved_sig), TO_STRING(BTERN_LOGIC'('0')));
        
  elsif run("Cross-type assignment 2") then
        -- LOGIC to ULOGIC (valid, but loses resolution capability)
        driver1 <= '+';
        driver2 <= 'Z';
        driver3 <= 'Z';
        wait for 1 ns;
        driver1_U <= BTERN_ULOGIC(resolved_sig);
        wait for 1 ns;
        check_equal(TO_STRING(unresolved_sig), TO_STRING(BTERN_ULOGIC'('+')));
                   
      elsif run("Cross-type vector compatibility") then
        vec_U := (others => '0');
        vec_L := BTERN_LOGIC_VECTOR(vec_U);
        check_equal(vec_L'length, 8, "Conversion preserves length");
        
        vec_L := (others => '+');
        vec_U := BTERN_ULOGIC_VECTOR(vec_L);
        check_equal(vec_U'length, 8, "Conversion preserves length");

      end if;
    end loop;
    
    test_runner_cleanup(runner);
  end process;
end architecture;