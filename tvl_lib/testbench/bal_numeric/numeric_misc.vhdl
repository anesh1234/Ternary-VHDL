-- --------------------------------------------------------------------
-- Title   : BAL_NUMERIC Miscellaneous Functions
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
    signal TNAC   : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');
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
                    TO_STRING(TNAC));

    elsif run("1-arity minus") then
        check_equal(TO_STRING(-BTERN_LOGIC_VECTOR'("-0+-0+")), 
                     TO_STRING(BTERN_LOGIC_VECTOR'("+0-+0-")));

        check_equal(TO_STRING(-BTERN_LOGIC_VECTOR'("+0-+0-")), 
                     TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0+")));

        check_equal(TO_STRING(-BTERN_LOGIC_VECTOR'("+0-+0U")), 
                     TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0X")));

        check_equal(TO_STRING(-v_empty), 
                    TO_STRING(TNAC));

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

    elsif run("LEFTMOST_NZ") then
      check(LEFTMOST_NZ(BTERN_LOGIC_VECTOR'("000+-+-")) = '+');
      check(LEFTMOST_NZ(BTERN_LOGIC_VECTOR'("000--++")) = '-');
      check(LEFTMOST_NZ(BTERN_LOGIC_VECTOR'("0000000")) = '0');
      check(LEFTMOST_NZ(BTERN_LOGIC_VECTOR'("00X0000")) = 'X');
      check(LEFTMOST_NZ(BTERN_LOGIC_VECTOR'("00X000W")) = 'X');

    elsif run("NUM_BTRITS") then
      check(NUM_BTRITS(0) = 1);
      check(NUM_BTRITS(1) = 1);
      check(NUM_BTRITS(-1) = 1);
      check(NUM_BTRITS(2) = 2);
      check(NUM_BTRITS(-2) = 2);
      check(NUM_BTRITS(364) = 6);
      check(NUM_BTRITS(-364) = 6);
      check(NUM_BTRITS(2147483647)  = 21);
      check(NUM_BTRITS(-2147483647) = 21);


    elsif run("MAXIMUM VectorVector") then

      -- Normal logical values
      check_true(MAXIMUM(BTERN_LOGIC_VECTOR'("00000+"), 
                         BTERN_LOGIC_VECTOR'("+000000")) = 
                         BTERN_LOGIC_VECTOR'("+000000"));

      check_true(MAXIMUM(BTERN_LOGIC_VECTOR'("+00000-"), 
                         BTERN_LOGIC_VECTOR'("-")) = 
                         BTERN_LOGIC_VECTOR'("+00000-"));
                  
      -- empty vectors
      check_true(TO_STRING(MAXIMUM(v_empty, 
                         BTERN_LOGIC_VECTOR'("+++"))) = 
                         TO_STRING(TNAC));

      check_true(TO_STRING(MAXIMUM(BTERN_LOGIC_VECTOR'("+++"), 
                         v_empty)) = 
                         TO_STRING(TNAC));

      -- Metalogical values
      check_true(TO_STRING(MAXIMUM(BTERN_LOGIC_VECTOR'("00000DX"), 
                                   BTERN_LOGIC_VECTOR'("+000000"))) = 
                         TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXXX")));

      check_true(TO_STRING(MAXIMUM(BTERN_LOGIC_VECTOR'("+00000-"), 
                                   BTERN_LOGIC_VECTOR'("D"))) = 
                         TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXXX")));

    elsif run("MAXIMUM VectorInteger combinations") then
      check_true(MAXIMUM(1, 
                         BTERN_LOGIC_VECTOR'("+000000")) = 
                         BTERN_LOGIC_VECTOR'("+000000"));

      check_true(MAXIMUM(BTERN_LOGIC_VECTOR'("+00000-"), 
                         -1) = 
                         BTERN_LOGIC_VECTOR'("+00000-"));

      check_true(MAXIMUM(364, 
                         BTERN_LOGIC_VECTOR'("0+0000")) = 
                         BTERN_LOGIC_VECTOR'("++++++"));

      -- integer size larger than vector
      check_true(MAXIMUM(364, 
                         BTERN_LOGIC_VECTOR'("-")) = 
                         BTERN_LOGIC_VECTOR'("+"));

    elsif run("MINIMUM VectorVector") then

      -- Normal logical values
      check_true(MINIMUM(BTERN_LOGIC_VECTOR'("00000+"), 
                         BTERN_LOGIC_VECTOR'("+000000")) = 
                         BTERN_LOGIC_VECTOR'("000000+"));

      check_true(MINIMUM(BTERN_LOGIC_VECTOR'("+00000-"), 
                         BTERN_LOGIC_VECTOR'("-")) = 
                         BTERN_LOGIC_VECTOR'("000000-"));

      -- empty vectors
      check_true(TO_STRING(MINIMUM(v_empty, 
                                   BTERN_LOGIC_VECTOR'("+++"))) = 
                         TO_STRING(TNAC));

      check_true(TO_STRING(MINIMUM(BTERN_LOGIC_VECTOR'("+++"), 
                                   v_empty)) = 
                         TO_STRING(TNAC));
                         
      -- Metalogical values
      check_true(TO_STRING(MINIMUM(BTERN_LOGIC_VECTOR'("00000DX"), 
                                   BTERN_LOGIC_VECTOR'("+000000"))) = 
                         TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXXX")));

      check_true(TO_STRING(MINIMUM(BTERN_LOGIC_VECTOR'("+00000-"), 
                                   BTERN_LOGIC_VECTOR'("D"))) = 
                         TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXXX")));

    elsif run("MINIMUM VectorInteger combinations") then
      check_true(MINIMUM(1, 
                         BTERN_LOGIC_VECTOR'("+000000")) = 
                         BTERN_LOGIC_VECTOR'("000000+"));

      check_true(MINIMUM(BTERN_LOGIC_VECTOR'("+00000-"), 
                         -1) = 
                         BTERN_LOGIC_VECTOR'("000000-"));

      check_true(MINIMUM(364, 
                         BTERN_LOGIC_VECTOR'("0+0000")) = 
                         BTERN_LOGIC_VECTOR'("0+0000"));

      -- integer size larger than vector
      check_true(MINIMUM(364, 
                         BTERN_LOGIC_VECTOR'("-")) = 
                         BTERN_LOGIC_VECTOR'("-"));

    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;