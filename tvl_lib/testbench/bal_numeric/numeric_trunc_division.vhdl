-- --------------------------------------------------------------------
-- Title   : BAL_NUMERIC Truncating Division Overloads
-- Notes   : Tests all overloads of the native division operators in
--           VHDL, including "/", "rem" and "mod". These are tested
--           against the results produced by the INTEGER type.
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity numeric_trunc_division_tb is
  generic (runner_cfg : string);
end entity;

architecture test of numeric_trunc_division_tb is

  -- test configuration
  constant NUM_RANDOM_TESTS : INTEGER := 1000;
  
  -- null-array testing
  signal v_empty : BTERN_LOGIC_VECTOR(-1 downto 0);
  signal TNAC    : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');

  -- signals for random tests
  signal a_rand_i, b_rand_i, res_rand_i,
          exp_rand_i : INTEGER;

  -- As we don't need to worry about overflow
  -- with division, we can max out the integer type.
  -- The closest we get to the integer maximum without
  -- being to big with max/min vectors is 20 trits.
  signal a_rand_vec, b_rand_vec
          : BTERN_LOGIC_VECTOR(19 downto 0);

  signal res_rand_vec : BTERN_LOGIC_VECTOR(19 downto 0);

begin

  main : process

    variable RV : RandomPType;  -- OSVVM random variable

    -- VectorVector
    procedure test_div_op(
      constant a_vec, b_vec : BTERN_LOGIC_VECTOR;
      constant L_int, R_int : INTEGER) is
      variable quotient_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                    := (others => '0');
      variable rem_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                                := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                                := (others => '0');
      variable quotient_i, rem_i, mod_i, 
               int_quot, int_rem, int_mod  : INTEGER;
    begin

        int_quot := L_int / R_int;
        int_rem  := L_int rem R_int;
        int_mod  := L_int mod R_int;

        quotient_vec := a_vec / b_vec;
        rem_vec      := a_vec rem b_vec;
        mod_vec      := a_vec mod b_vec;

        quotient_i := TO_INTEGER(quotient_vec);
        rem_i      := TO_INTEGER(rem_vec);
        mod_i      := TO_INTEGER(mod_vec);

      -- Check equivalence to INTEGER type i.e., 
      -- truncating division
      check_equal(quotient_i, int_quot);
      check_equal(rem_i, int_rem);
      check_equal(mod_i, int_mod);

    end procedure;

    -- VectorInteger
    procedure test_div_op(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_i : INTEGER
    ) is
      variable quotient_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                    := (others => '0');
      variable rem_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable a_i, quotient_i, rem_i, mod_i, 
               int_quot, int_rem, int_mod  : INTEGER;
    begin
        a_i := TO_INTEGER(a_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;
        int_mod  := a_i mod b_i;

        quotient_vec := a_vec / b_i;
        rem_vec      := a_vec rem b_i;
        mod_vec      := a_vec mod b_i;

        quotient_i := TO_INTEGER(quotient_vec);
        rem_i      := TO_INTEGER(rem_vec);
        mod_i      := TO_INTEGER(mod_vec);

      -- Check equivalence to INTEGER type i.e., 
      -- truncating division
      check_equal(quotient_i, int_quot);
      check_equal(rem_i, int_rem);
      check_equal(mod_i, int_mod);

    end procedure;

    -- IntegerVector
    procedure test_div_op(
      constant a_i : INTEGER;
      constant b_vec : BTERN_LOGIC_VECTOR
    ) is
      variable quotient_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                                    := (others => '0');
      variable rem_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                                := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                                := (others => '0');
      variable quotient_i, b_i, rem_i, mod_i, 
               int_quot, int_rem, int_mod  : INTEGER;
    begin
        b_i := TO_INTEGER(b_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;
        int_mod  := a_i mod b_i;

        quotient_vec := a_i / b_vec;
        rem_vec      := a_i rem b_vec;
        mod_vec      := a_i mod b_vec;

        quotient_i := TO_INTEGER(quotient_vec);
        rem_i      := TO_INTEGER(rem_vec);
        mod_i      := TO_INTEGER(mod_vec);

      -- Check equivalence to INTEGER type i.e., 
      -- truncating division
      check_equal(quotient_i, int_quot);
      check_equal(rem_i, int_rem);
      check_equal(mod_i, int_mod);

    end procedure;

    -- VectorVector overload, specifically 
    -- for max/min test.
    procedure test_div_op(
      constant a_vec, b_vec : BTERN_LOGIC_VECTOR) is
      variable quo_vec : 
        BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                := (others => '0');
      variable rem_vec : 
        BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                := (others => '0');
      variable mod_vec : 
        BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                := (others => '0');
      variable a_i, b_i, quo_i, rem_i, mod_i, 
               int_quo, int_rem, int_mod  : INTEGER;
    begin
      a_i := TO_INTEGER(a_vec);
      b_i := TO_INTEGER(b_vec);

      int_quo := a_i / b_i;
      int_rem := a_i rem b_i;
      int_mod := a_i mod b_i;

      quo_vec := a_vec / b_vec;
      rem_vec := a_vec rem b_vec;
      mod_vec := a_vec mod b_vec;

      quo_i := TO_INTEGER(quo_vec);
      rem_i := TO_INTEGER(rem_vec);
      mod_i := TO_INTEGER(mod_vec);

      -- Check equivalence to INTEGER type i.e., 
      -- truncating division
      check_equal(quo_i, int_quo);
      check_equal(rem_i, int_rem);
      check_equal(mod_i, int_mod);

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

    if run("All 6-trit VectorVector (/, mod, rem)") then

      -- ===============================================
      -- Test all 6-trit numbers for equality of 
      -- quotient, rem and mod against the integer type
      -- i.e., truncating division.
      -- ===============================================

      for x in -364 to 364 loop
          for y in -364 to -1 loop
              test_div_op(
              TO_BALTERN(x, 6),
              TO_BALTERN(y, 6),
                        x, y);
          end loop;
      end loop;

      for x in -364 to 364 loop
          for y in 1 to 364 loop
              test_div_op(
              TO_BALTERN(x, 6),
              TO_BALTERN(y, 6),
                        x, y);
          end loop;
      end loop;

    elsif run("Subset VectorInteger (/, mod, rem)") then

      -- ===============================================
      -- Same test as above, but because every number is 
      -- tested above, only a subset is tested here to 
      -- reduce overall test time
      -- ===============================================

      for x in -50 to 50 loop
          for y in -50 to -1 loop
              test_div_op(
              TO_BALTERN(x, 6),
                          y);
          end loop;
      end loop;

      for x in -50 to 50 loop
          for y in 1 to 50 loop
              test_div_op(
              TO_BALTERN(x, 6),
                          y);
          end loop;
      end loop;
        
    elsif run("Subset IntegerVector (/, mod, rem)") then
        
      -- ===============================================
      -- Same test as above, but because every number is 
      -- tested above, only a subset is tested here to 
      -- reduce overall test time
      -- ===============================================

      for x in -50 to 50 loop
          for y in -50 to -1 loop
              test_div_op(
                          x,
              TO_BALTERN(y, 6));
          end loop;
      end loop;

      for x in -50 to 50 loop
          for y in 1 to 50 loop
              test_div_op(
                          x,
              TO_BALTERN(y, 6));
          end loop;
      end loop;

    elsif run("Different widths /") then
      
      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+--") /   -- 5
                  BTERN_LOGIC_VECTOR'("000+-")), -- / 2
        TO_STRING(BTERN_LOGIC_VECTOR'("0+-")));   -- = 2

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("00+00+") /  -- 28
                  BTERN_LOGIC_VECTOR'("0+0")),     -- / 3
        TO_STRING(BTERN_LOGIC_VECTOR'("000+00"))); -- = 9

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+") /       -- 1
                  BTERN_LOGIC_VECTOR'("0++++++")), -- / 364
        TO_STRING(BTERN_LOGIC_VECTOR'("0")));      -- = 0

      -- Integer length more than vector (MST truncation)
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+++") / 27), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("000")));

    elsif run("Different widths rem") then
      
      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+--") rem  -- 5
                  BTERN_LOGIC_VECTOR'("000+-")),  -- mod 2
        TO_STRING(BTERN_LOGIC_VECTOR'("0000+"))); -- = 1

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("00+00+") rem -- 28
                  BTERN_LOGIC_VECTOR'("0+0")),      -- mod 3
        TO_STRING(BTERN_LOGIC_VECTOR'("00+")));     -- = 1

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+") rem      -- 1
                  BTERN_LOGIC_VECTOR'("0++++++")),  -- mod 364
        TO_STRING(BTERN_LOGIC_VECTOR'("000000+"))); -- = 1

      -- Integer length more than vector (MST truncation)
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+++") rem 27), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("+++")));

    elsif run("Different widths mod") then
      
      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+--") mod  -- 5
                  BTERN_LOGIC_VECTOR'("000+-")),  -- mod 2
        TO_STRING(BTERN_LOGIC_VECTOR'("0000+"))); -- = 1

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("00+00+") mod -- 28
                  BTERN_LOGIC_VECTOR'("0+0")),      -- mod 3
        TO_STRING(BTERN_LOGIC_VECTOR'("00+")));     -- = 1

      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("+") mod      -- 1
                  BTERN_LOGIC_VECTOR'("0++++++")),  -- mod 364
        TO_STRING(BTERN_LOGIC_VECTOR'("000000+"))); -- = 1

      -- Integer length more than vector (MST truncation)
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+++") mod 27), 
                  TO_STRING(BTERN_LOGIC_VECTOR'("+++")));

    elsif run("Random tests") then

      -- As we don't need to worry about overflow
      -- with division, we can max out the integer type.
      -- The closest we get to the integer maximum without
      -- being to big with max/min vectors is 20 trits.

      for i in 1 to NUM_RANDOM_TESTS loop
        test_div_op(
          random_btern_vector(20),
          random_btern_vector(20));
      end loop;

    elsif run("/ empty and weak/metalogical") then

      -- Empty vectors VectorVector
      check_equal(TO_STRING(v_empty / TO_BALTERN(364, 6)), TO_STRING(TNAC));
      check_equal(TO_STRING(TO_BALTERN(364, 6) / v_empty), TO_STRING(TNAC));

      -- Empty vectors VectorInteger combinations
      check_equal(TO_STRING(v_empty / 364), TO_STRING(TNAC));
      check_equal(TO_STRING(364 / v_empty), TO_STRING(TNAC));

      -- Metalogical values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") / BTERN_LOGIC_VECTOR'("-0+-0+")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0+") / BTERN_LOGIC_VECTOR'("-0+D")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));

      -- Metalogical values VectorInteger combinations
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") / 10), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));
      check_equal(TO_STRING(10 / BTERN_LOGIC_VECTOR'("-0+D")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

     -- Weak values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") / BTERN_LOGIC_VECTOR'("+L")), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+-")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("MMHM") / BTERN_LOGIC_VECTOR'("00HM")), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("000+")));

      -- Weak values VectorInteger
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") / 2), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+-")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("MMHM") / 3), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("000+")));

      -- Weak values IntegerVector
      check_equal(TO_STRING(5 / BTERN_LOGIC_VECTOR'("HL")), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("+-")));
      check_equal(TO_STRING(3 / BTERN_LOGIC_VECTOR'("MMHM")), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("000+")));

      -- Integer length more than vector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+++") / 27), TO_STRING(BTERN_LOGIC_VECTOR'("000")));

    elsif run("rem empty and weak/metalogical") then

      -- Empty vectors VectorVector
      check_equal(TO_STRING(v_empty rem TO_BALTERN(364, 6)), TO_STRING(TNAC));
      check_equal(TO_STRING(TO_BALTERN(364, 6) rem v_empty), TO_STRING(TNAC));

      -- Empty vectors VectorInteger combinations
      check_equal(TO_STRING(v_empty rem 364), TO_STRING(TNAC));
      check_equal(TO_STRING(364 rem v_empty), TO_STRING(TNAC));

      -- Metalogical values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") rem BTERN_LOGIC_VECTOR'("-0+-0+")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0+") rem BTERN_LOGIC_VECTOR'("-0+D")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

      -- Metalogical values VectorInteger combinations
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") rem 10), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));
      check_equal(TO_STRING(10 rem BTERN_LOGIC_VECTOR'("-0+D")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

     -- Weak values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") rem BTERN_LOGIC_VECTOR'("+L")), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("MMHM") rem BTERN_LOGIC_VECTOR'("00H0")), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));
      -- Weak values VectorInteger
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") rem 2), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("00+")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("MMHM") rem 3), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));

      -- Weak values IntegerVector
      check_equal(TO_STRING(5 rem BTERN_LOGIC_VECTOR'("HL")), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+")));
      check_equal(TO_STRING(3 rem BTERN_LOGIC_VECTOR'("MMHM")), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));

      -- Integer length more than vector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+++") rem 27), TO_STRING(BTERN_LOGIC_VECTOR'("+++")));

    elsif run("mod empty and weak/metalogical") then

      -- Empty vectors VectorVector
      check_equal(TO_STRING(v_empty mod TO_BALTERN(364, 6)), TO_STRING(TNAC));
      check_equal(TO_STRING(TO_BALTERN(364, 6) mod v_empty), TO_STRING(TNAC));

      -- Empty vectors VectorInteger combinations
      check_equal(TO_STRING(v_empty mod 364), TO_STRING(TNAC));
      check_equal(TO_STRING(364 mod v_empty), TO_STRING(TNAC));

      -- Metalogical values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") mod BTERN_LOGIC_VECTOR'("-0+-0+")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXXXX")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+-0+") mod BTERN_LOGIC_VECTOR'("-0+D")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

      -- Metalogical values VectorInteger combinations
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("-0+D") mod 10), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));
      check_equal(TO_STRING(10 mod BTERN_LOGIC_VECTOR'("-0+D")), 
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("XXXX")));

     -- Weak values VectorVector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") mod BTERN_LOGIC_VECTOR'("+L")), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("MMHM") mod BTERN_LOGIC_VECTOR'("00H0")), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));
      -- Weak values VectorInteger
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("HLL") mod 2), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("00+")));
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("MMHM") mod 3), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));

      -- Weak values IntegerVector
      check_equal(TO_STRING(5 mod BTERN_LOGIC_VECTOR'("HL")), -- 5/2
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0+")));
      check_equal(TO_STRING(3 mod BTERN_LOGIC_VECTOR'("MMHM")), -- 3/3
                                                  TO_STRING(BTERN_LOGIC_VECTOR'("0000")));

      -- Integer length more than vector
      check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+++") mod 27), TO_STRING(BTERN_LOGIC_VECTOR'("+++")));

    elsif run("Max/Min vectors boundary tests") then
      
      for i in 0 to 20 loop
        -- Maximum positive
        test_div_op(
            max_min_vector(i+1, false), 
            max_min_vector(i+1, false));

        -- Maximum negative
        test_div_op(
            max_min_vector(i+1, true), 
            max_min_vector(i+1, true));

      end loop;
 
      -- elsif run("Truncating / by zero") then
    --   -- Should fail, only here to verify that it does
    --   check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+--") / 
    --                         BTERN_LOGIC_VECTOR'("0")),
    --               TO_STRING(BTERN_LOGIC_VECTOR'("X")));

    -- elsif run("Truncating rem by zero") then
    --   -- Should fail, only here to verify that it does
    --   check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+--") rem 
    --                         BTERN_LOGIC_VECTOR'("0")),
    --               TO_STRING(BTERN_LOGIC_VECTOR'("X")));

    -- elsif run("Truncating mod by zero") then
    --   -- Should fail, only here to verify that it does
    --   check_equal(TO_STRING(BTERN_LOGIC_VECTOR'("+--") mod 
    --                         BTERN_LOGIC_VECTOR'("0")),
    --               TO_STRING(BTERN_LOGIC_VECTOR'("X")));

    end if;
    
    test_runner_cleanup(runner);
  end process;
  
end architecture;