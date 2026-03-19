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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity division_experimenting_tb is
  generic (runner_cfg : string);
end entity;

architecture test of division_experimenting_tb is

begin

  main : process
    procedure check_euclidean (DIVIDEND, DIVISOR, QUOT, REMAIN : INTEGER;
                               FLAG : out BOOLEAN) is
    begin
        if DIVIDEND = DIVISOR * QUOT + REMAIN then
            if REMAIN >= 0 and REMAIN < abs(DIVISOR) then
                FLAG := TRUE;
            end if;
        end if;
    end procedure;

    procedure test_div_type_int(A, B : INTEGER) is
        variable int_quot, int_rem, int_mod : INTEGER;
        variable checker : BOOLEAN := false;
    begin
        int_quot := A / B;
        int_rem  := A rem B;
        int_mod  := A mod B;

        check_euclidean(A,B,int_quot,int_rem,checker);

        print(TO_STRING(A) & " / " & TO_STRING(B) & " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem) & " | " & TO_STRING(int_mod), "z_type_test.txt");
        print(TO_STRING(checker), "z_type_test.txt");
    end procedure;

    procedure test_div_type_signed(A, B : SIGNED) is
        variable int_quot, int_rem, int_mod : INTEGER;
        variable checker : BOOLEAN := false;
    begin
        int_quot := TO_INTEGER(A / B);
        int_rem  := TO_INTEGER(A rem B);
        int_mod  := TO_INTEGER(A mod B);

        check_euclidean(TO_INTEGER(A),TO_INTEGER(B),int_quot,int_rem,checker);

        print(TO_STRING(A) & " / " & TO_STRING(B) & " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem) & " | " & TO_STRING(int_mod), "z_type_test.txt");
        print(TO_STRING(checker), "z_type_test.txt");
    end procedure;

    procedure test_tdiv_btern(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR
    ) is
      variable quotient_vec, rem_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                    := (others => '0');
      variable a_i, b_i, quotient_i, rem_i, int_quot, int_rem  : INTEGER;

      -- DEBUG
      variable trunc_checker : BOOLEAN := false;
      variable euclid_checker : BOOLEAN := false;
    begin
        a_i := TO_INTEGER(a_vec);
        b_i := TO_INTEGER(b_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;

        TDIV_BTERN(a_vec, b_vec, quotient_vec, rem_vec);

        quotient_i := TO_INTEGER(quotient_vec);
        rem_i      := TO_INTEGER(rem_vec);

        if (quotient_i = int_quot) and (rem_i = int_rem) then
            trunc_checker := true;
        end if;

        check_euclidean(a_i, b_i, quotient_i, rem_i, euclid_checker);

        -- DEBUG
        print("e"&TO_STRING(euclid_checker) & " | " & "t"&TO_STRING(trunc_checker) & " | " & TO_STRING(a_i) & " / " & TO_STRING(b_i) & " | " & 
              TO_STRING(quotient_i) & " | " & TO_STRING(rem_i) & " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem), "z_tdiv_btern.txt");
    end procedure;

    procedure test_binarydiv(
      constant a_vec : SIGNED;
      constant b_vec : SIGNED;
      constant expected : INTEGER
    ) is
      variable quotient_vec : SIGNED(a_vec'length-1 downto 0) 
                                                    := (others => '0');
      variable rem_vec : SIGNED(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable a_i, b_i, quotient_i, rem_i, int_quot, int_rem  : INTEGER;

      -- DEBUG
      variable checker : BOOLEAN := false;
    begin
        quotient_vec := a_vec / b_vec;
        rem_vec := a_vec rem b_vec;

        quotient_i := TO_INTEGER(quotient_vec);
        rem_i      := TO_INTEGER(rem_vec);

        a_i := TO_INTEGER(a_vec);
        b_i := TO_INTEGER(b_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;

        -- Check that remainder has the same sign as dividend, and that its abs value 
        -- is smaller than the abs of the divisor.
        -- Then check if the division algorithm holds
        if (a_vec'left = rem_vec'left) and (abs(rem_i) < abs(b_i)) then
            if a_i = quotient_i * b_i + rem_i then
                checker := true;
            end if;
        end if;

        -- DEBUG
        print(TO_STRING(checker)    & " | " & TO_STRING(a_i) & " / " & TO_STRING(b_i) & " | " & 
              TO_STRING(quotient_i) & " | " & TO_STRING(rem_i) & " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem), "z_binarydiv.txt");
    end procedure;

    procedure test_jones_2(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR
    ) is
      variable quot_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable rem_vec  : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable a_i, b_i, quot_i, rem_i, int_quot, int_rem  : INTEGER;

      -- DEBUG
      variable trunc_checker  : BOOLEAN := false;
      variable euclid_checker : BOOLEAN := false;
    begin
        a_i := TO_INTEGER(a_vec);
        b_i := TO_INTEGER(b_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;

        JONES2(a_vec, b_vec, quot_vec, rem_vec);

        quot_i := TO_INTEGER(quot_vec);
        rem_i  := TO_INTEGER(rem_vec);

        if (quot_i = int_quot) and (rem_i = int_rem) then
            trunc_checker := true;
        end if;

        check_euclidean(a_i, b_i, quot_i, rem_i, euclid_checker);

        -- DEBUG
        print("e"&TO_STRING(euclid_checker) & " | " & "t"&TO_STRING(trunc_checker) & " | " & TO_STRING(a_i) & " / " & TO_STRING(b_i) & " | " & 
              TO_STRING(quot_i) & " | " & TO_STRING(rem_i) & " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem), "z_jones_2.txt");
    end procedure;

    procedure test_jones_1(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR
    ) is
      variable quot_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable rem_vec  : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable a_i, b_i, quot_i, rem_i, int_quot, int_rem  : INTEGER;

      -- DEBUG
      variable trunc_checker  : BOOLEAN := false;
      variable euclid_checker : BOOLEAN := false;
    begin
        a_i := TO_INTEGER(a_vec);
        b_i := TO_INTEGER(b_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;

        JONES1(a_vec, b_vec, quot_vec, rem_vec);

        quot_i := TO_INTEGER(quot_vec);
        rem_i  := TO_INTEGER(rem_vec);

        if (quot_i = int_quot) and (rem_i = int_rem) then
            trunc_checker := true;
        end if;

        check_euclidean(a_i, b_i, quot_i, rem_i, euclid_checker);

        -- DEBUG
        print("e"&TO_STRING(euclid_checker) & " | " & "t"&TO_STRING(trunc_checker) & " | " & TO_STRING(a_i) & " / " & TO_STRING(b_i) & " | " & 
              TO_STRING(quot_i) & " | " & TO_STRING(rem_i) & " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem), "z_jones_1.txt");
    end procedure;

    procedure test_jones1_prog(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR
    ) is
      variable quot_vec : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable rem_vec  : BTERN_LOGIC_VECTOR(a_vec'length-1 downto 0) 
                                                := (others => '0');
      variable a_i, b_i, quot_i, rem_i, int_quot, int_rem  : INTEGER;

      -- DEBUG
      variable trunc_checker  : BOOLEAN := false;
      variable euclid_checker : BOOLEAN := false;
    begin
        a_i := TO_INTEGER(a_vec);
        b_i := TO_INTEGER(b_vec);

        int_quot := a_i / b_i;
        int_rem  := a_i rem b_i;

        JONES1_PROG(a_vec, b_vec, quot_vec, rem_vec);

        quot_i := TO_INTEGER(quot_vec);
        rem_i  := TO_INTEGER(rem_vec);

        if (quot_i = int_quot) and (rem_i = int_rem) then
            trunc_checker := true;
        end if;

        check_euclidean(a_i, b_i, quot_i, rem_i, euclid_checker);

        -- DEBUG
        print("e"&TO_STRING(euclid_checker) & " | " & "t"&TO_STRING(trunc_checker) & " | " & TO_STRING(a_i) & " / " & TO_STRING(b_i) & " | " & 
              TO_STRING(quot_i) & " | " & TO_STRING(rem_i) & " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem), "z_jones1_prog.txt");
    end procedure;

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

      -- DEBUG
      variable trunc_checker : BOOLEAN := false;
      variable euclid_checker : BOOLEAN := false;
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

        if (quotient_i = int_quot) and (rem_i = int_rem) and (mod_i = int_mod) then
            trunc_checker := true;
        end if;

        check_euclidean(a_i, b_i, quotient_i, rem_i, euclid_checker);

        -- DEBUG
        print("e"&TO_STRING(euclid_checker) & " | " & "t"&TO_STRING(trunc_checker) & " | " & TO_STRING(a_i) & " / " & TO_STRING(b_i) & 
              " | " & TO_STRING(quotient_i) & " | " & TO_STRING(rem_i) & " | " & TO_STRING(mod_i) & 
              " | " & TO_STRING(int_quot) & " | " & TO_STRING(int_rem) & " | " & TO_STRING(int_mod), "z_div_op.txt");
    end procedure;

  begin
    test_runner_setup(runner, runner_cfg);

    if run("Jones 1") then

        -- DEBUG
        print("Euclidean" & " | " & "Truncating" & " | " & "Calculation" & " | " & "BTERN Quot" & " | "  & "BTERN rem" & " | " & "INTEGER Quot" & " | " & "INTEGER rem", "z_jones_1.txt");
        
        -- ==========================================
        -- Tests for the specific inputs used by 
        -- Jones.
        -- ==========================================

        for i in -10 to 10 loop
            test_jones_1(
            TO_BALTERN(i, 3),
            TO_BALTERN(2, 3));
        end loop;

        for i in -10 to 10 loop
            test_jones_1(
            TO_BALTERN(i, 3),
            TO_BALTERN(4, 3));
        end loop;

    elsif run("Jones 2") then

        -- DEBUG
        print("Euclidean" & " | " & "Truncating" & " | " & "Calculation" & " | " & "BTERN Quot" & " | "  & "BTERN rem" & " | " & "INTEGER Quot" & " | " & "INTEGER rem", "z_jones_2.txt");
        
        -- ==========================================
        -- Tests for the specific inputs used by 
        -- Jones.
        -- ==========================================

        for i in -10 to 10 loop
            test_jones_2(
            TO_BALTERN(i, 3),
            TO_BALTERN(2, 3));
        end loop;

        for i in -10 to 10 loop
            test_jones_2(
            TO_BALTERN(i, 3),
            TO_BALTERN(4, 3));
        end loop;

    elsif run("Jones1 Progressive") then

        -- DEBUG
        print("Euclidean" & " | " & "Truncating" & " | " & "Calculation" & " | " & "BTERN Quot" & " | "  & "BTERN rem" & " | " & "INTEGER Quot" & " | " & "INTEGER rem", "z_jones1_prog.txt");
        
        -- ==========================================
        -- Tests for the specific inputs used by 
        -- Jones.
        -- ==========================================

        -- for i in -10 to 10 loop
        --     test_jones1_prog(
        --     TO_BALTERN(i, 3),
        --     TO_BALTERN(2, 3));
        -- end loop;

        -- for i in -10 to 10 loop
        --     test_jones1_prog(
        --     TO_BALTERN(i, 3),
        --     TO_BALTERN(4, 3));
        -- end loop;

        -- ==========================================
        -- All numbers -10 to 10
        -- ==========================================

        for x in -10 to 10 loop
            for y in -10 to -1 loop
                test_jones1_prog(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6));
            end loop;
        end loop;

        for x in -10 to 10 loop
            for y in 1 to 10 loop
                test_jones1_prog(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6));
            end loop;
        end loop;


        -- ==========================================
        -- Specific numbers
        -- ==========================================

        -- test_jones1_prog(
        --             TO_BALTERN(5, 3),
        --             TO_BALTERN( 2, 3));

    elsif run("TDIV_BTERN") then

        -- DEBUG
        print("Euclidean" & " | " & "Truncating" & " | " & "Calculation" & " | " & "BTERN Quot" & " | "  & "BTERN rem" & " | " & "INTEGER Quot" & " | " & "INTEGER rem", "z_tdiv_btern.txt");
        
        -- ==========================================
        -- All 6-trit numbers
        -- ==========================================

        for x in -364 to 364 loop
            for y in -364 to -1 loop
                test_tdiv_btern(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6));
            end loop;
        end loop;

        for x in -364 to 364 loop
            for y in 1 to 364 loop
                test_tdiv_btern(
                TO_BALTERN(x, 6),
                TO_BALTERN(y, 6));
            end loop;
        end loop;

        -- ==========================================
        -- All numbers -10 to 10
        -- ==========================================

        -- for x in -10 to 10 loop
        --     for y in -10 to -1 loop
        --         test_tdiv_btern(
        --         TO_BALTERN(x, 6),
        --         TO_BALTERN(y, 6));
        --     end loop;
        -- end loop;

        -- for x in -10 to 10 loop
        --     for y in 1 to 10 loop
        --         test_tdiv_btern(
        --         TO_BALTERN(x, 6),
        --         TO_BALTERN(y, 6));
        --     end loop;
        -- end loop;


        -- ==========================================
        -- All POSITIVE numbers 1-364
        -- ==========================================

        -- for x in 0 to 364 loop
        --     for y in 1 to 364 loop
        --         test_tdiv_btern(
        --         TO_BALTERN(x, 6),
        --         TO_BALTERN(y, 6));
        --     end loop;
        -- end loop;

        -- ==========================================
        -- Specific numbers
        -- ==========================================

        -- test_tdiv_btern(
        --             TO_BALTERN(10, 6),
        --             TO_BALTERN( 6, 6));
        -- test_tdiv_btern(
        --             TO_BALTERN(-10, 6),
        --             TO_BALTERN( -6, 6));
        -- test_tdiv_btern(
        --             TO_BALTERN(10, 6),
        --             TO_BALTERN(-6, 6));
        -- test_tdiv_btern(
        --             TO_BALTERN(-10, 6),
        --             TO_BALTERN(  6, 6));

    elsif run("Binary div") then

        -- ==========================================
        -- All numbers 1-10
        -- ==========================================

        -- DEBUG
        print("Success" & " | " & "Calculation" & " | " & "BIN Quot" & " | "  & "BIN rem" & " | " & "INTEGER Quot" & " | " & "INTEGER rem", "z_binarydiv.txt");

        for x in -364 to 364 loop
            for y in -364 to -1 loop
                test_binarydiv(
                TO_SIGNED(x, 10),
                TO_SIGNED(y, 10),
                          x / y);
            end loop;
        end loop;

        for x in -364 to 364 loop
            for y in 1 to 364 loop
                test_binarydiv(
                TO_SIGNED(x, 10),
                TO_SIGNED(y, 10),
                          x / y);
            end loop;
        end loop;
    
    elsif run("Check division definition") then

        -- ==========================================
        -- Chech the VHDL div/mod/rem results against certain numbers
        -- ==========================================

        -- DEBUG
        print("Calculation" & " | " & "Quot" & " | " & "rem" & " | " & "mod", "z_type_test.txt");

        test_div_type_int(5, 3);
        test_div_type_int(5, -3);
        test_div_type_signed(TO_SIGNED(5, 4), TO_SIGNED(3,4));
        test_div_type_signed(TO_SIGNED(5, 4), TO_SIGNED(-3,4));

    elsif run("Division operator /") then

        -- DEBUG
        print("Euclidean" & " | " & "Truncating" & " | " & "Calculation" & 
              " | " & "BTERN Quot" & " | "  & "BTERN rem" & " | " & "BTERN mod" & 
              " | " & "INTEGER Quot" & " | " & "INTEGER rem" & " | " & "INTEGER mod", 
              "z_div_op.txt");
        
        -- -- ==========================================
        -- -- All 6-trit numbers
        -- -- ==========================================

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

        -- ==========================================
        -- All 6-trit POSITIVE numbers (works in 13.03)
        -- ==========================================
        
        -- for x in 0 to 364 loop
        --     for y in 1 to 364 loop
        --         test_div_op(
        --         TO_BALTERN(x, 6),
        --         TO_BALTERN(y, 6));
        --     end loop;
        -- end loop;

        -- ==========================================
        -- All 6-trit NEGATIVE / POSITIVE numbers
        -- ==========================================

        -- for x in 0 downto -364 loop
        --     for y in 1 to 364 loop
        --         test_div_op(
        --         TO_BALTERN(x, 6),
        --         TO_BALTERN(y, 6));
        --     end loop;
        -- end loop;

        -- ==========================================
        -- All 6-trit POSITIVE / NEGATIVE numbers
        -- ==========================================

        -- for x in 0 to 364 loop
        --     for y in -1 downto -364 loop
        --         test_div_op(
        --         TO_BALTERN(x, 6),
        --         TO_BALTERN(y, 6));
        --     end loop;
        -- end loop;
    end if;
    
    test_runner_cleanup(runner);
  end process;
  
end architecture;