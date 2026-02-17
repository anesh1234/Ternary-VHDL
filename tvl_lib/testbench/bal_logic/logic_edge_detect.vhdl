-- --------------------------------------------------------------------
-- Title   : BAL_LOGIC Edge Detection Functions Testbench
-- Notes   : Uses the test_transition procedure to simplify the 
--           expression of individual test cases. The "edge_monitor"
--           process sets the "...detected" signals 
--           based on values passed to that procedure.
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;

entity logic_edge_detect_tb is
  generic (runner_cfg : string);
end entity;

architecture test of logic_edge_detect_tb is
  
  signal test_sig  : BTERN_ULOGIC := '-';
  signal reset_sig : BOOLEAN := false;
  
  -- Helper signals to capture edge detection results
  signal any_rising_detected  : BOOLEAN := false;
  signal mz_rising_detected   : BOOLEAN := false;
  signal zp_rising_detected   : BOOLEAN := false;
  signal mp_rising_detected   : BOOLEAN := false;

  signal any_falling_detected : BOOLEAN := false;
  signal pz_falling_detected  : BOOLEAN := false;
  signal zm_falling_detected  : BOOLEAN := false;
  signal pm_falling_detected  : BOOLEAN := false;
  
begin

  -- Edge detection monitoring process
  edge_monitor : process(test_sig, reset_sig)
  begin
    -- if-test guard to protect against previous result intervention.
    -- When no changes are made to a signal no events are raised,
    -- and therefore this process is not called nor are any changes
    -- made to the "detected" signals. The "reset_sig" signal 
    -- remedies this by being a mechanism to reset the "detected" signals.
    if reset_sig then
      -- Reset all detection flags
      any_rising_detected  <= false;
      mz_rising_detected   <= false;
      zp_rising_detected   <= false;
      mp_rising_detected   <= false;
      any_falling_detected <= false;
      pz_falling_detected  <= false;
      zm_falling_detected  <= false;
      pm_falling_detected  <= false;
    else
      any_rising_detected  <= any_rising_edge(test_sig);
      mz_rising_detected   <= mz_rising_edge(test_sig);
      zp_rising_detected   <= zp_rising_edge(test_sig);
      mp_rising_detected   <= mp_rising_edge(test_sig);
      any_falling_detected <= any_falling_edge(test_sig);
      pz_falling_detected  <= pz_falling_edge(test_sig);
      zm_falling_detected  <= zm_falling_edge(test_sig);
      pm_falling_detected  <= pm_falling_edge(test_sig);
    end if;
  end process;

  main : process
    
    -- Variables for test_mutual_exclusivity
    variable from_value : BTERN_ULOGIC;
    variable to_value   : BTERN_ULOGIC;

    -- Helper procedure to apply a transition and verify edge detection
    procedure test_transition(
      from_val : BTERN_ULOGIC;
      to_val   : BTERN_ULOGIC;
      expect_any_rising  : BOOLEAN := false;
      expect_mz_rising   : BOOLEAN := false;
      expect_zp_rising   : BOOLEAN := false;
      expect_mp_rising   : BOOLEAN := false;
      expect_any_falling : BOOLEAN := false;
      expect_pz_falling  : BOOLEAN := false;
      expect_zm_falling  : BOOLEAN := false;
      expect_pm_falling  : BOOLEAN := false
    ) is
    begin
      -- Set initial value
      test_sig <= from_val;
      wait for 1 ns;

      -- Ensure we start with clean state
      reset_sig <= true;
      wait for 1 ns;
      reset_sig <= false;

      -- Apply transition
      test_sig <= to_val;
      wait for 1 ns;
      
      -- Check all edge detections
      check_equal(any_rising_detected, expect_any_rising,
                  "any_rising_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
      
      check_equal(mz_rising_detected, expect_mz_rising,
                  "mz_rising_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
      
      check_equal(zp_rising_detected, expect_zp_rising,
                  "zp_rising_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
      
      check_equal(mp_rising_detected, expect_mp_rising,
                  "mp_rising_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
      
      check_equal(any_falling_detected, expect_any_falling,
                  "any_falling_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
      
      check_equal(pz_falling_detected, expect_pz_falling,
                  "pz_falling_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
      
      check_equal(zm_falling_detected, expect_zm_falling,
                  "zm_falling_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
      
      check_equal(pm_falling_detected, expect_pm_falling,
                  "pm_falling_edge: " & BTERN_ULOGIC'image(from_val) & 
                  " -> " & BTERN_ULOGIC'image(to_val));
    end procedure;
    
  begin
    test_runner_setup(runner, runner_cfg);

    if run("Test transitions") then
      test_transition('-', '0', expect_mz_rising  => true,
                                expect_any_rising => true);
      test_transition('0', '+', expect_zp_rising  => true,
                                expect_any_rising => true);
      test_transition('-', '+', expect_mp_rising  => true,
                                expect_any_rising => true);

      test_transition('+', '0', expect_pz_falling  => true,
                                expect_any_falling => true);
      test_transition('0', '-', expect_zm_falling  => true,
                                expect_any_falling => true);
      test_transition('+', '-', expect_pm_falling  => true,
                                expect_any_falling => true);

    elsif run("test_no_event_detection") then
      info("Testing that stable signals don't trigger edge detection");

      test_transition('-', '-');
      test_transition('0', '0');
      test_transition('+', '+');
      
    elsif run("test_mutual_exclusivity") then
      info("Testing that rising and falling edges are mutually exclusive");
      
      -- Test all 9 possible transitions
      for from_idx in 0 to 2 loop
        for to_idx in 0 to 2 loop
          case from_idx is
            when 0 => from_value := '-';
            when 1 => from_value := '0';
            when 2 => from_value := '+';
            when others => null;
          end case;
          
          case to_idx is
            when 0 => to_value := '-';
            when 1 => to_value := '0';
            when 2 => to_value := '+';
            when others => null;
          end case;
          
          test_sig <= from_value;
          wait for 1 ns;
          test_sig <= to_value;
          wait for 1 ns;
          
          -- Rising and falling should never both be true
          check_false(any_rising_detected and any_falling_detected,
                      "Both rising and falling detected for " &
                      BTERN_ULOGIC'image(from_value) & " -> " &
                      BTERN_ULOGIC'image(to_value));
        end loop;
      end loop;

    elsif run("test_weak_and_unknown_values") then
      info("Testing edge detection with weak and unknown values");
      
      -- Test transitions involving weak values (L, M, H, W)
      -- These are converted to (-, 0, +, X) before comparison
      test_transition('L', '-');
      test_transition('M', '0');
      test_transition('H', '+');
      test_transition('W', 'X');
      
      -- Test transitions involving unknown/uninitialized (U, X)
      test_transition('U', '0');
      test_transition('X', '+');
      test_transition('0', 'U');
      
      -- Test transitions involving don't care (D)
      test_transition('D', '0');
      test_transition('0', 'D');
      
      -- Test transitions involving high impedance (Z)
      test_transition('Z', '0');
      test_transition('0', 'Z');
      
    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;