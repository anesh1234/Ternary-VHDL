-- --------------------------------------------------------------------
-- Title   : 
-- Purpose :
-- Notes   :
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity numeric_misc_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of numeric_misc_tb is
    signal v_empty : BTERN_LOGIC_VECTOR(-1 downto 0);
    signal v_NAC   : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');
    signal find_test_vec : BTERN_LOGIC_VECTOR (11 downto 0);
begin
  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);

    if run("abs overload") then
        check_equal(TO_STRING(abs(BTERN_LOGIC_VECTOR'("-0+-0+"))), 
                        TO_STRING(BTERN_LOGIC_VECTOR'("+0-+0-")));

        check_equal(TO_STRING(abs(BTERN_LOGIC_VECTOR'("+0-+0-"))), 
                        TO_STRING(BTERN_LOGIC_VECTOR'("+0-+0-")));

        check_equal(TO_STRING(abs(BTERN_LOGIC_VECTOR'("+0-+0U"))), 
                        TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));

        check_equal(TO_STRING(abs(v_empty)), 
                    TO_STRING(v_NAC));

    elsif run("1-arity minus") then
        check_equal(TO_STRING(-BTERN_LOGIC_VECTOR'("-0+-0+")), 
                     TO_STRING(BTERN_LOGIC_VECTOR'("+0-+0-")));

        check_equal(TO_STRING(-BTERN_LOGIC_VECTOR'("+0-+0-")), 
                     TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0+")));

        check_equal(TO_STRING(-BTERN_LOGIC_VECTOR'("+0-+0U")), 
                     TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0X")));

        check_equal(TO_STRING(-v_empty), 
                    TO_STRING(v_NAC));

    elsif run("find_ functions") then
      find_test_vec <= BTERN_ULOGIC_VECTOR'("UX-0+++ZWLMH");
      wait for 1 ns;

      check_equal(find_leftmost(find_test_vec, BTERN_ULOGIC'('+')), 7);
      check_equal(find_leftmost(find_test_vec, BTERN_ULOGIC'('U')), 11);
      check_equal(find_leftmost(find_test_vec, BTERN_ULOGIC'('D')), -1);

      check_equal(find_rightmost(find_test_vec, BTERN_ULOGIC'('+')), 5);
      check_equal(find_rightmost(find_test_vec, BTERN_ULOGIC'('U')), 11);
      check_equal(find_rightmost(find_test_vec, BTERN_ULOGIC'('D')), -1);

    elsif run("STD_MATCH functions") then
      check_true(STD_MATCH(BTERN_LOGIC'('+'), BTERN_LOGIC'('+')));
      check_true(STD_MATCH(BTERN_LOGIC'('+'), BTERN_LOGIC'('H')));
      check_true(STD_MATCH(BTERN_LOGIC'('D'), BTERN_LOGIC'('0')));

      check_false(STD_MATCH(BTERN_LOGIC'('+'), BTERN_LOGIC'('-')));
      check_false(STD_MATCH(BTERN_LOGIC'('L'), BTERN_LOGIC'('M')));
      check_false(STD_MATCH(BTERN_LOGIC'('X'), BTERN_LOGIC'('0')));

      check_true(STD_MATCH(BTERN_LOGIC_VECTOR'("-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH"), 
                           BTERN_LOGIC_VECTOR'("-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH"))
                           );

      check_true(STD_MATCH(BTERN_LOGIC_VECTOR'("-0+LMHD"), 
                           BTERN_LOGIC_VECTOR'("-0+LMHX"))
                           );

      check_false(STD_MATCH(BTERN_LOGIC_VECTOR'("UX-0+ZWL"), 
                           BTERN_LOGIC_VECTOR'("UX-0+ZWLMHD"))
                           );
      check_false(STD_MATCH(BTERN_LOGIC_VECTOR'("-0+LMH"), 
                            BTERN_LOGIC_VECTOR'("-0+LMH-0+LMH"))
                           );
      check_false(STD_MATCH(BTERN_LOGIC_VECTOR'("-0+LMH-0+LMH"), 
                            BTERN_LOGIC_VECTOR'("-0+LMH"))
                           );
      check_false(STD_MATCH(BTERN_LOGIC_VECTOR'("-0+LMH-0+LMH"), 
                            BTERN_LOGIC_VECTOR'("-0+LMH-0+LLL"))
                           );

    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;