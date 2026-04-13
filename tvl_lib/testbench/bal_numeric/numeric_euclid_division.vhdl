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

entity numeric_euclid_division_tb is
  generic (runner_cfg : string);
end entity;

architecture test of numeric_euclid_division_tb is

  -- test configuration
  constant NUM_RANDOM_TESTS : INTEGER := 1000;
  
  -- null-array testing
  signal v_empty : BTERN_LOGIC_VECTOR(-1 downto 0);
  signal TNAC    : BTERN_LOGIC_VECTOR (0 downto 1) := (others => '0');

begin

  main : process

    variable RV : RandomPType;  -- OSVVM random variable

    -- VectorVector
    procedure test_BTEDIV(
      constant a_vec, b_vec : BTERN_LOGIC_VECTOR;
      constant L_int, R_int : INTEGER) is
      variable quo_vec : BTERN_LOGIC_VECTOR(5 downto 0) 
                                    := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(5 downto 0) 
                                    := (others => '0');
      variable quo_i, mod_i : INTEGER;
    begin
      quo_vec := BTEDIV(a_vec, b_vec);
      mod_vec := BTEMOD(a_vec, b_vec);

      quo_i := TO_INTEGER(quo_vec);
      mod_i := TO_INTEGER(mod_vec);

      -- check that the division rule is upheld
      check_equal(L_int, R_int * quo_i + mod_i);

      -- check that the remainder is positive or zero
      check_true(mod_i >= 0);

      -- check that the remainder is less than the 
      -- absolute value of the divisor
      check_true(mod_i < abs(R_int));

    end procedure;

    -- VectorInteger
    procedure test_BTEDIV(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_i   : INTEGER) is
      variable quo_vec : BTERN_LOGIC_VECTOR(5 downto 0) 
                                    := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(5 downto 0) 
                                    := (others => '0');
      variable a_i, quo_i, mod_i : INTEGER;
    begin
      quo_vec := BTEDIV(a_vec, b_i);
      mod_vec := BTEMOD(a_vec, b_i);

      quo_i := TO_INTEGER(quo_vec);
      mod_i := TO_INTEGER(mod_vec);
      a_i   := TO_INTEGER(a_vec);

      -- check that the division rule is upheld
      check_equal(a_i, b_i * quo_i + mod_i);

      -- check that the remainder is positive or zero
      check_true(mod_i >= 0);

      -- check that the remainder is less than the 
      -- absolute value of the divisor
      check_true(mod_i < abs(b_i));

    end procedure;

    -- IntegerVector
    procedure test_BTEDIV(
      constant a_i   : INTEGER; 
      constant b_vec : BTERN_LOGIC_VECTOR) is
      variable quo_vec : BTERN_LOGIC_VECTOR(5 downto 0) 
                                    := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(5 downto 0) 
                                    := (others => '0');
      variable b_i, quo_i, mod_i : INTEGER;
    begin
      quo_vec := BTEDIV(a_i, b_vec);
      mod_vec := BTEMOD(a_i, b_vec);

      quo_i := TO_INTEGER(quo_vec);
      mod_i := TO_INTEGER(mod_vec);
      b_i   := TO_INTEGER(b_vec);

      -- check that the division rule is upheld
      check_equal(a_i, b_i * quo_i + mod_i);

      -- check that the remainder is positive or zero
      check_true(mod_i >= 0);

      -- check that the remainder is less than the 
      -- absolute value of the divisor
      check_true(mod_i < abs(b_i));

    end procedure;

    -- VectorVector overload, specifically 
    -- for max/min test.
    procedure test_BTEDIV(
      constant a_vec, b_vec : BTERN_LOGIC_VECTOR) is
      variable quo_vec : 
        BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                := (others => '0');
      variable mod_vec : 
        BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                    := (others => '0');
      variable a_i, b_i, quo_i, mod_i : INTEGER;
    begin
      quo_vec := BTEDIV(a_vec, b_vec);
      mod_vec := BTEMOD(a_vec, b_vec);

      quo_i := TO_INTEGER(quo_vec);
      mod_i := TO_INTEGER(mod_vec);
      a_i   := TO_INTEGER(a_vec);
      b_i   := TO_INTEGER(b_vec);

      -- check that the division rule is upheld
      check_equal(a_i, b_i * quo_i + mod_i);

      -- check that the remainder is positive or zero
      check_true(mod_i >= 0);

      -- check that the remainder is less than the 
      -- absolute value of the divisor
      check_true(mod_i < abs(b_i));

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
      -- To avoid zero-divisor, each vector
      -- is set to be at least 1.
      result(0) := '+';
      for i in 1 to SIZE-1 loop
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

    if run("All 6-trit VectorVector (div, mod)") then

      -- ===============================================
      -- Test all 6-trit numbers against the
      -- requirements for Euclidean division.
      -- ===============================================

      for x in -364 to 364 loop
          for y in -364 to -1 loop
              test_BTEDIV(
              TO_BALTERN(x, 6),
              TO_BALTERN(y, 6),
                        x, y);
          end loop;
      end loop;

      for x in -364 to 364 loop
          for y in 1 to 364 loop
              test_BTEDIV(
              TO_BALTERN(x, 6),
              TO_BALTERN(y, 6),
                        x, y);
          end loop;
      end loop;

    elsif run("Subset VectorInteger (div, mod)") then

      -- ===============================================
      -- Same test as above, but because every number is 
      -- tested above, only a subset is tested here to 
      -- reduce overall test time
      -- ===============================================

      for x in -50 to 50 loop
          for y in -50 to -1 loop
              test_BTEDIV(
              TO_BALTERN(x, 6),
                         y);
          end loop;
      end loop;

      for x in -50 to 50 loop
          for y in 1 to 50 loop
              test_BTEDIV(
              TO_BALTERN(x, 6),
                         y);
          end loop;
      end loop;
        
    elsif run("Subset IntegerVector (div, mod)") then
        
      -- ===============================================
      -- Same test as above, but because every number is 
      -- tested above, only a subset is tested here to 
      -- reduce overall test time
      -- ===============================================

      for x in -50 to 50 loop
          for y in -50 to -1 loop
              test_BTEDIV(
                          x,
               TO_BALTERN(y, 6));
          end loop;
      end loop;

      for x in -50 to 50 loop
          for y in 1 to 50 loop
              test_BTEDIV(
                          x,
               TO_BALTERN(y, 6));
          end loop;
      end loop;

    elsif run("Different widths div") then
      
      check_equal(
        TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("+--"), -- 5
                  BTERN_LOGIC_VECTOR'("000+-"))),    -- / 2
        TO_STRING(BTERN_LOGIC_VECTOR'("0+-")));      -- = 2

      check_equal(
        TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("00+00+"), -- 28
                  BTERN_LOGIC_VECTOR'("0+0"))),         -- / 3
        TO_STRING(BTERN_LOGIC_VECTOR'("000+00")));      -- = 9

      check_equal(
        TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("+"),  -- 1
                  BTERN_LOGIC_VECTOR'("0++++++"))), -- / 364
        TO_STRING(BTERN_LOGIC_VECTOR'("0")));       -- = 0

      -- Integer length more than vector (MST truncation)
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("+++"), 27)), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("000")));

    elsif run("Different widths mod") then
      
      check_equal(
        TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("+--"), -- 5
                  BTERN_LOGIC_VECTOR'("000+-"))),    -- mod 2
        TO_STRING(BTERN_LOGIC_VECTOR'("0000+")));    -- = 1

      check_equal(
        TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("00+00+"), -- 28
                  BTERN_LOGIC_VECTOR'("0+0"))),         -- mod 3
        TO_STRING(BTERN_LOGIC_VECTOR'("00+")));         -- = 1

      check_equal(
        TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("+"),  -- 1
                  BTERN_LOGIC_VECTOR'("0++++++"))), -- mod 364
        TO_STRING(BTERN_LOGIC_VECTOR'("000000+"))); -- = 1

      -- Integer length more than vector (MST truncation)
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("+++"), 27)), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("+++")));

    elsif run("Random tests") then

      -- As we don't need to worry about overflow
      -- with division, we can max out the integer type.
      -- The closest we get to the integer maximum without
      -- being to big with max/min vectors is 20 trits.
      
      for i in 1 to NUM_RANDOM_TESTS loop
        test_BTEDIV(
          random_btern_vector(20),
          random_btern_vector(20));
      end loop;

    elsif run("div empty and weak/metalogical") then

      -- Empty vectors VectorVector
      check_equal(TO_STRING(BTEDIV(v_empty, TO_BALTERN(364, 6))), TO_STRING(TNAC));
      check_equal(TO_STRING(BTEDIV(TO_BALTERN(364, 6), v_empty)), TO_STRING(TNAC));

      -- Empty vectors VectorInteger combinations
      check_equal(TO_STRING(BTEDIV(v_empty, 364)), TO_STRING(TNAC));
      check_equal(TO_STRING(BTEDIV(364, v_empty)), TO_STRING(TNAC));

      -- Metalogical values VectorVector
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("-0+D"), BTERN_LOGIC_VECTOR'("-0+-0+"))), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("-0+-0+"), BTERN_LOGIC_VECTOR'("-0+D"))), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));

      -- Metalogical values VectorInteger combinations
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("-0+D"), 10)), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));
      check_equal(TO_STRING(BTEDIV(10, BTERN_LOGIC_VECTOR'("-0+D"))), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

     -- Weak values VectorVector
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("HLL"), BTERN_LOGIC_VECTOR'("+L"))), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+-")));
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("MMHM"), BTERN_LOGIC_VECTOR'("00HM"))), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("000+")));

      -- Weak values VectorInteger
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("HLL"), 2)), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+-")));
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("MMHM"), 3)), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("000+")));

      -- Weak values IntegerVector
      check_equal(TO_STRING(BTEDIV(5, BTERN_LOGIC_VECTOR'("HL"))), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("+-")));
      check_equal(TO_STRING(BTEDIV(3, BTERN_LOGIC_VECTOR'("MMHM"))), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("000+")));

      -- Integer length more than vector
      check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("+++"), 27)), TO_STRING(BTERN_LOGIC_VECTOR'("000")));

    elsif run("mod empty and weak/metalogical") then

      -- Empty vectors VectorVector
      check_equal(TO_STRING(BTEMOD(v_empty, TO_BALTERN(364, 6))), TO_STRING(TNAC));
      check_equal(TO_STRING(BTEMOD(TO_BALTERN(364, 6), v_empty)), TO_STRING(TNAC));

      -- Empty vectors VectorInteger combinations
      check_equal(TO_STRING(BTEMOD(v_empty, 364)), TO_STRING(TNAC));
      check_equal(TO_STRING(BTEMOD(364, v_empty)), TO_STRING(TNAC));

      -- Metalogical values VectorVector
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("-0+D"), BTERN_LOGIC_VECTOR'("-0+-0+"))), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("-0+-0+"), BTERN_LOGIC_VECTOR'("-0+D"))), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

      -- Metalogical values VectorInteger combinations
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("-0+D"), 10)), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));
      check_equal(TO_STRING(BTEMOD(10, BTERN_LOGIC_VECTOR'("-0+D"))), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

     -- Weak values VectorVector
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("HLL"), BTERN_LOGIC_VECTOR'("+L"))), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+")));
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("MMHM"), BTERN_LOGIC_VECTOR'("00H0"))), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));
      -- Weak values VectorInteger
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("HLL"), 2)), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("00+")));
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("MMHM"), 3)), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));

      -- Weak values IntegerVector
      check_equal(TO_STRING(BTEMOD(5, BTERN_LOGIC_VECTOR'("HL"))), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+")));
      check_equal(TO_STRING(BTEMOD(3, BTERN_LOGIC_VECTOR'("MMHM"))), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));

      -- Integer length more than vector
      check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("+++"), 27)), TO_STRING(BTERN_LOGIC_VECTOR'("+++")));

    elsif run("Max/Min vectors boundary tests") then
      
      for i in 0 to 20 loop
        -- Maximum positive
        test_BTEDIV(
            max_min_vector(i+1, false), 
            max_min_vector(i+1, false));

        -- Maximum negative
        test_BTEDIV(
            max_min_vector(i+1, true), 
            max_min_vector(i+1, true));

      end loop;
 

    -- elsif run("Euclidean div by zero") then
    --   -- Should fail, only here to verify that it does
    --   check_equal(TO_STRING(BTEDIV(BTERN_LOGIC_VECTOR'("+--"),
    --                         BTERN_LOGIC_VECTOR'("0"))),
    --               TO_STRING(BTERN_LOGIC_VECTOR'("X")));

    -- elsif run("Euclidean mod by zero") then
    --   -- Should fail, only here to verify that it does
    --   check_equal(TO_STRING(BTEMOD(BTERN_LOGIC_VECTOR'("+--"),
    --                         BTERN_LOGIC_VECTOR'("0"))),
    --               TO_STRING(BTERN_LOGIC_VECTOR'("X")));

    end if;


    test_runner_cleanup(runner);
  end process;
  
end architecture;