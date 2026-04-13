-- --------------------------------------------------------------------
-- Title   : BAL_NUMERIC Subtraction Overloads
-- Notes   : Uses an OSVVM random variable to create randomized
--           balanced ternary vectors. Tests all possible 6-trit 
--           integers for comprehensive coverage, and randomized 
--           19-trit integers. 
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity numeric_subtraction_tb is
  generic (runner_cfg : string);
end entity;

architecture test of numeric_subtraction_tb is
  
  -- test configuration
  constant NUM_RANDOM_TESTS : INTEGER := 1000;
  
  -- null-array testing
  signal v_empty : BTERN_LOGIC_VECTOR(-1 downto 0);
  signal TNAC    : BTERN_LOGIC_VECTOR (0 downto 1) := (others => '0');

  -- signals for random tests
  signal a_rand_i, b_rand_i, res_rand_i,
          exp_rand_i : INTEGER;

  -- 19 trits is the width which comes closest to half 
  -- of a max VHDL INTEGER type (+/- 2147483647) in the 
  -- case where it is all +'s or -'s.
  signal a_rand_vec, b_rand_vec, res_rand_vec
          : BTERN_LOGIC_VECTOR(18 downto 0);

begin

  main : process

    -- OSVVM random variable    
    variable RV : RandomPType;

    -- VectorVector
    procedure test_subtraction(
      constant L, R : BTERN_LOGIC_VECTOR;
      constant L_int, R_int : INTEGER) is
      variable res_vec : BTERN_LOGIC_VECTOR(L'length-1 downto 0);
      variable res_int, res_vec_i : INTEGER;
    begin
      res_vec := L - R;
      res_vec_i := TO_INTEGER(res_vec);

      res_int := L_int - R_int;

      check_equal(res_vec_i, res_int);

    end procedure;

    -- VectorInteger
    procedure test_subtraction(
      constant L : BTERN_LOGIC_VECTOR;
      constant R : INTEGER;
      constant L_int, R_int : INTEGER) is
      variable res_vec : BTERN_LOGIC_VECTOR(L'length-1 downto 0);
      variable res_int, res_vec_i : INTEGER;
    begin
      res_vec := L - R;
      res_vec_i := TO_INTEGER(res_vec);

      res_int := L_int - R_int;

      check_equal(res_vec_i, res_int);

    end procedure;

    -- IntegerVector
    procedure test_subtraction(
      constant L : INTEGER;
      constant R : BTERN_LOGIC_VECTOR;
      constant L_int, R_int : INTEGER) is
      variable res_vec : BTERN_LOGIC_VECTOR(R'length-1 downto 0);
      variable res_int, res_vec_i : INTEGER;
    begin
      res_vec := L - R;
      res_vec_i := TO_INTEGER(res_vec);

      res_int := L_int - R_int;

      check_equal(res_vec_i, res_int);

    end procedure;

    -- VectorScalar
    procedure test_subtraction(
      constant L : BTERN_LOGIC_VECTOR;
      constant R : BTERN_LOGIC) is
      variable res_vec : BTERN_LOGIC_VECTOR(L'length-1 downto 0);
      variable res_int, res_vec_i : INTEGER;
    begin
      res_vec := L - R;
      res_vec_i := TO_INTEGER(res_vec);

      res_int := TO_INTEGER(L) - TO_INTEGER(R);

      check_equal(res_vec_i, res_int);

    end procedure;
    
    -- ScalarVector
    procedure test_subtraction(
      constant L : BTERN_LOGIC;
      constant R : BTERN_LOGIC_VECTOR) is
      variable res_vec : BTERN_LOGIC_VECTOR(R'length-1 downto 0);
      variable res_int, res_vec_i : INTEGER;
    begin
      res_vec := L - R;
      res_vec_i := TO_INTEGER(res_vec);

      res_int := TO_INTEGER(L) - TO_INTEGER(R);

      check_equal(res_vec_i, res_int);
      
    end procedure;

    -- VectorVector overload, specifically 
    -- for max/min test. Adds one trit to
    -- left operand to prevent overflow.
    procedure test_subtraction(
      constant L, R : BTERN_LOGIC_VECTOR) is
      variable res_vec : BTERN_LOGIC_VECTOR(L'length downto 0);
      variable res_int, res_vec_i : INTEGER;
    begin
      res_vec := ("0" & L) - R;
      res_vec_i := TO_INTEGER(res_vec);

      res_int := TO_INTEGER(L) - TO_INTEGER(R);

      check_equal(res_vec_i, res_int);
      
    end procedure;

    -- generates a random balanced ternary vector
    -- of a certain size. Impure so that it can 
    -- access the OSVVM random variable.
    impure function random_btern_vector(SIZE : INTEGER) 
    return BTERN_LOGIC_VECTOR is
      variable result : BTERN_LOGIC_VECTOR(SIZE-1 downto 0);
      variable rand_val : INTEGER;
      type btern_values is array (0 to 2) of BTERN_LOGIC;
      constant valid_values : btern_values := ('-', '0', '+');
    begin
      -- loop only until the next-leftmost trit to prevent
      -- overflow in the case of addition after this function
      -- with two maxed-out vectors
      result(SIZE-1) := '0';
      for i in 0 to SIZE-2 loop
        rand_val := RV.RandInt(0, 2);
        result(i) := valid_values(rand_val);
      end loop;
      return result;
    end function;

    -- generates a maximum/minumum (determined by boolean input) 
    -- vector of a certain size
    function max_min_vector (SIZE : NATURAL; NEG : BOOLEAN) 
    return BTERN_LOGIC_VECTOR is
      variable RESULT : BTERN_LOGIC_VECTOR (SIZE-1 downto 0);
    begin
      for i in RESULT'range loop
        if NEG then
          RESULT(i) := '-';
        else
          RESULT(i) := '+';
        end if;
      end loop;
      return RESULT;
    end function max_min_vector;


  begin
    test_runner_setup(runner, runner_cfg);
    
    -- Initialize random seed
    RV.InitSeed(RV'instance_name);

    if run("All 6-trit VectorVector") then
      
      -- ===============================================
      -- Subtracts all 6-trit numbers and tests 
      -- against the results of the integer type.
      -- The operands and result need to be 7-trit
      -- to protect against overflow.
      -- ===============================================

      for x in -364 to 364 loop
        for y in -364 to 364 loop
          test_subtraction(
          TO_BALTERN(x, 7),
          TO_BALTERN(y, 7),
                     x, y);
        end loop;
      end loop;
    
    elsif run("Subset VectorInteger") then

      -- ===============================================
      -- Same test as above, but because every number is 
      -- tested above, only a subset is tested here to 
      -- reduce overall test time
      -- ===============================================

      for x in -50 to 50 loop
        for y in -50 to 50 loop
          test_subtraction(
            TO_BALTERN(x, 6),
                      y,
                      x, y);
        end loop;
      end loop;

    elsif run("Subset IntegerVector") then

      -- ===============================================
      -- Same test as above, but because every number is 
      -- tested above, only a subset is tested here to 
      -- reduce overall test time
      -- ===============================================

      for x in -50 to 50 loop
        for y in -50 to 50 loop
          test_subtraction(
                      x,
            TO_BALTERN(y, 6),
                      x, y);
        end loop;
      end loop;

    elsif run("VectorScalar combinations") then
      
      -- VectorScalar
      test_subtraction(
        BTERN_LOGIC_VECTOR'("00+-"),
                  BTERN_LOGIC'('+'));

      test_subtraction(
        BTERN_LOGIC_VECTOR'("00+-"),
                  BTERN_LOGIC'('-'));

      test_subtraction(
        BTERN_LOGIC_VECTOR'("00+-"),
                  BTERN_LOGIC'('0'));

      -- ScalarVector
      test_subtraction(
                  BTERN_LOGIC'('+'),
        BTERN_LOGIC_VECTOR'("00+-"));

      test_subtraction(
                  BTERN_LOGIC'('-'),
        BTERN_LOGIC_VECTOR'("00+-"));

      test_subtraction(
                  BTERN_LOGIC'('0'),
        BTERN_LOGIC_VECTOR'("00+-"));

    elsif run("Different widths") then
      
      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+-") -     -- 2
                  BTERN_LOGIC_VECTOR'("000+")),   -- - 1
        TO_STRING(BTERN_LOGIC_VECTOR'("000+")));  -- = 1

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("00+000") -  -- 27
                  BTERN_LOGIC_VECTOR'("0+0")),     -- - 3
        TO_STRING(BTERN_LOGIC_VECTOR'("00+0-0"))); -- = 24

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+") -         -- 1
                  BTERN_LOGIC_VECTOR'("0++++++")),   -- - 364
        TO_STRING(BTERN_LOGIC_VECTOR'("0-----0")));  -- = -363

      -- Integer length more than vector (MST truncation)
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+++") - 27), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("+++")));

    elsif run("Random Tests") then

      for i in 1 to NUM_RANDOM_TESTS loop
        a_rand_vec <= random_btern_vector(19);
        b_rand_vec <= random_btern_vector(19);
        wait for 1 ns;
        res_rand_vec <= a_rand_vec - b_rand_vec;
        wait for 1 ns;
        a_rand_i   <= TO_INTEGER(a_rand_vec);
        b_rand_i   <= TO_INTEGER(b_rand_vec);
        res_rand_i <= TO_INTEGER(res_rand_vec);
        wait for 1 ns;
        exp_rand_i <= a_rand_i - b_rand_i;
        wait for 1 ns;
        check_equal(res_rand_i, exp_rand_i,
                    "Random test " & INTEGER'image(i) & " failed: " &
                    INTEGER'image(a_rand_i) & " + " & INTEGER'image(b_rand_i) &
                    " = " & INTEGER'image(res_rand_i) &
                    " (expected " & INTEGER'image(exp_rand_i) & ")");
      end loop;

    elsif run("Empty vectors all overloads") then
      
      -- Empty vectors VectorVector
      check_equal(TO_STRING(v_empty - TO_BALTERN(364, 6)), 
                                        TO_STRING(TNAC));

      check_equal(TO_STRING(TO_BALTERN(364, 6) - v_empty), 
                                        TO_STRING(TNAC));

      -- Empty vectors VectorInteger combinations
      check_equal(TO_STRING(v_empty - 364), 
                          TO_STRING(TNAC));

      check_equal(TO_STRING(364 - v_empty),
                          TO_STRING(TNAC));

      -- Empty vectors VectorScalar combinations
      check_equal(TO_STRING(v_empty - BTERN_LOGIC'('+')), 
                          TO_STRING(TNAC));

      check_equal(TO_STRING(BTERN_LOGIC'('-') - v_empty),
                          TO_STRING(TNAC));

    elsif run("Metalogical values all overloads") then             
                      
      -- Metalogical values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") -
                            BTERN_LOGIC_VECTOR'("-0+-0+")), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));

      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0+") - 
                            BTERN_LOGIC_VECTOR'("-0+D")), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));

      -- Metalogical values VectorInteger combinations
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") - 10), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

      check_equal(TO_STRING(10 - BTERN_LOGIC_VECTOR'("-0+D")), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

      -- Metalogical values VectorScalar combinations
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") - BTERN_LOGIC'('+')), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

      check_equal(TO_STRING(BTERN_LOGIC'('-') - BTERN_LOGIC_VECTOR'("-0+D")), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

    elsif run("Weak values all overloads") then

     -- Weak values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") -  -- 5
                            BTERN_LOGIC_VECTOR'("+L")),   -- - 2
                  TO_STRING(BTERN_LOGIC_VECTOR'("0+0"))); -- = 3

      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("MMHM") -  -- 3
                            BTERN_LOGIC_VECTOR'("00H0")),  -- - 3
                  TO_STRING(BTERN_LOGIC_VECTOR'("0000"))); -- = 0

      -- Weak values VectorInteger combinations
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") -  -- 5
                                                    2),   -- - 2
                  TO_STRING(BTERN_LOGIC_VECTOR'("0+0"))); -- = 3

      check_equal(TO_STRING(3 -                            -- 3
                            BTERN_LOGIC_VECTOR'("MMHM")),  -- - 3
                  TO_STRING(BTERN_LOGIC_VECTOR'("0000"))); -- = 0

      -- Weak values VectorScalar combinations
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") -  -- 5
                            BTERN_LOGIC'('+')),           -- - 1
                  TO_STRING(BTERN_LOGIC_VECTOR'("0++"))); -- = 4

      check_equal(TO_STRING(BTERN_LOGIC'('-') -            -- -1
                            BTERN_LOGIC_VECTOR'("MMHM")),  -- - 3
                  TO_STRING(BTERN_LOGIC_VECTOR'("00--"))); -- = -4

    elsif run("Max/Min vectors boundary tests") then
      
      for i in 0 to 9 loop
        -- Maximum positive
        test_subtraction(
            max_min_vector(i+1, false), 
            max_min_vector(i+1, false));

        -- Maximum negative
        test_subtraction(
            max_min_vector(i+1, true), 
            max_min_vector(i+1, true));
      end loop;

    end if;
    
    test_runner_cleanup(runner);
  end process;
  
end architecture;