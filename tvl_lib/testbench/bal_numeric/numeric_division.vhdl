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

begin

  main : process

    procedure test_div_op(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR
    ) is
      variable quotient_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                    := (others => '0');
      variable rem_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                                := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
                                                := (others => '0');
      variable a_i, b_i, quotient_i, rem_i, mod_i, 
               int_quot, int_rem, int_mod  : INTEGER;
    begin
        a_i := TO_INTEGER(a_vec);
        b_i := TO_INTEGER(b_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;
        int_mod  := a_i mod b_i;

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
      check_equal(quotient_i, int_quot,
                    "Integer Quot: " & TO_STRING(int_quot) & " Btern Quot: " & TO_STRING(quotient_i) & 
                    " Integer rem: " & TO_STRING(int_rem) & " Btern rem: " & TO_STRING(rem_i) & 
                    " Integer mod: " & TO_STRING(int_mod) & " Btern mod: " & TO_STRING(mod_i));
      check_equal(rem_i, int_rem,
                    "Integer Quot: " & TO_STRING(int_quot) & " Btern Quot: " & TO_STRING(quotient_i) & 
                    " Integer rem: " & TO_STRING(int_rem) & " Btern rem: " & TO_STRING(rem_i) & 
                    " Integer mod: " & TO_STRING(int_mod) & " Btern mod: " & TO_STRING(mod_i));
      check_equal(mod_i, int_mod,
                    "Integer Quot: " & TO_STRING(int_quot) & " Btern Quot: " & TO_STRING(quotient_i) & 
                    " Integer rem: " & TO_STRING(int_rem) & " Btern rem: " & TO_STRING(rem_i) & 
                    " Integer mod: " & TO_STRING(int_mod) & " Btern mod: " & TO_STRING(mod_i));

    end procedure;

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
      check_equal(quotient_i, int_quot,
                    "Integer Quot: " & TO_STRING(int_quot) & " Btern Quot: " & TO_STRING(quotient_i) & 
                    " Integer rem: " & TO_STRING(int_rem) & " Btern rem: " & TO_STRING(rem_i) & 
                    " Integer mod: " & TO_STRING(int_mod) & " Btern mod: " & TO_STRING(mod_i));
      check_equal(rem_i, int_rem,
                    "Integer Quot: " & TO_STRING(int_quot) & " Btern Quot: " & TO_STRING(quotient_i) & 
                    " Integer rem: " & TO_STRING(int_rem) & " Btern rem: " & TO_STRING(rem_i) & 
                    " Integer mod: " & TO_STRING(int_mod) & " Btern mod: " & TO_STRING(mod_i));
      check_equal(mod_i, int_mod,
                    "Integer Quot: " & TO_STRING(int_quot) & " Btern Quot: " & TO_STRING(quotient_i) & 
                    " Integer rem: " & TO_STRING(int_rem) & " Btern rem: " & TO_STRING(rem_i) & 
                    " Integer mod: " & TO_STRING(int_mod) & " Btern mod: " & TO_STRING(mod_i));

    end procedure;

    procedure test_BTEDIV(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR
    ) is
      variable quo_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                    := (others => '0');
      variable mod_vec : BTERN_LOGIC_VECTOR(b_vec'length-1 downto 0) 
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

  begin
    test_runner_setup(runner, runner_cfg);

    if run("Exhaustive Static VectorVector") then

        -- ===============================================
        -- Test all 6-trit numbers for equality of 
        -- quotient, rem and mod against the integer type
        -- ===============================================

        for x in -364 to 364 loop
            for y in -364 to -1 loop
                test_div_op(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6));
            end loop;
        end loop;

        for x in -364 to 364 loop
            for y in 1 to 364 loop
                test_div_op(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6));
            end loop;
        end loop;

    elsif run("Exhaustive Static VectorInteger") then

        -- ===============================================
        -- Test all 6-trit numbers for equality of 
        -- quotient, rem and mod against the integer type
        -- ===============================================

        for x in -364 to 364 loop
            for y in -364 to -1 loop
                test_div_op(
                TO_BALTERN(x, 6),
                           y);
            end loop;
        end loop;

        for x in -364 to 364 loop
            for y in 1 to 364 loop
                test_div_op(
                TO_BALTERN(x, 6),
                           y);
            end loop;
        end loop;

    elsif run("Exhaustive Static IntegerVector") then
        
        -- ===============================================
        -- Test all 6-trit numbers for equality of 
        -- quotient, rem and mod against the integer type
        -- ===============================================

        for x in -364 to 364 loop
            for y in -364 to -1 loop
                test_div_op(
                           x,
                TO_BALTERN(y, 6));
            end loop;
        end loop;

        for x in -364 to 364 loop
            for y in 1 to 364 loop
                test_div_op(
                           x,
                TO_BALTERN(y, 6));
            end loop;
        end loop;

    elsif run("BTE Exhaustive Static VectorVector") then

      -- ===============================================
      -- 
      -- ===============================================

      for x in -2147483647 to 2147483647 loop
          for y in -2147483647 to -1 loop
              test_BTEDIV(
              TO_BALTERN(x, 21),
              TO_BALTERN(y, 21));
          end loop;
      end loop;

      for x in -2147483647 to 2147483647 loop
          for y in 1 to 2147483647 loop
              test_BTEDIV(
              TO_BALTERN(x, 21),
              TO_BALTERN(y, 21));
          end loop;
      end loop;
    
    end if;
    
    test_runner_cleanup(runner);
  end process;
  
end architecture;