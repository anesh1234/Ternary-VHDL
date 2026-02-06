-- --------------------------------------------------------------------
-- Title   : Balanced Ternary Addition Tests
-- Purpose : Test "+" operator with static and random vectors
-- Notes   : Uses VUnit and OSVVM for comprehensive coverage
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity numeric_addition_tb is
  generic (runner_cfg : string);
end entity;

architecture test of numeric_addition_tb is
  
  -- Test configuration
  constant NUM_RANDOM_TESTS : INTEGER := 1000;
  
  -- Null-array testing
  signal v_empty : BTERN_LOGIC_VECTOR(-1 downto 0);
  signal T_NAC : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');

  -- 19 trits is the width which comes closest to half 
  -- of a max VHDL INTEGER type (+/- 2147483647) in the case where it is all +'s.
  signal a, neg_a, b, c, result1, result2 : BTERN_LOGIC_VECTOR(18 downto 0);
  signal zero : BTERN_LOGIC_VECTOR(18 downto 0) := (others => '0');

  signal a_int, b_int, result_int, expected_int : INTEGER;
        
begin

  main : process

    -- OSVVM random variable    
    variable RV : RandomPType;

    -- Helper procedure to test addition with two vectors.
    procedure test_addition(
      -- X meaning expected
      constant L, R, X : BTERN_LOGIC_VECTOR) is
      variable result : BTERN_LOGIC_VECTOR(L'length-1 downto 0);
      variable L_int, R_int, res_int, X_int : INTEGER;
    begin
      result := L + R;
      
      -- Convert to integers for verification
      L_int   := TO_INTEGER(L);
      R_int   := TO_INTEGER(R);
      res_int := TO_INTEGER(result);
      X_int   := TO_INTEGER(X);
      
      -- Check BTERN_LOGIC_VECTOR equivalence
      check_equal(TO_STRING(result), TO_STRING(X),
                  ": Vector mismatch. " &
                  TO_STRING(L) & " + " & TO_STRING(R) &
                  " = " & TO_STRING(result) &
                  " (expected " & TO_STRING(X) & ")");
      
      -- Check integer equivalence
      check_equal(res_int, X_int,
                  ": Integer mismatch. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (expected " & INTEGER'image(X_int) & ")");
      
      -- Verify arithmetic correctness
      check_equal(res_int, L_int + R_int,
                  ": Arithmetic error. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (should be " & INTEGER'image(L_int + R_int) & ")");
    end procedure;

    -- Helper procedure to test addition with one scalar
    -- and one vector.
    procedure test_addition(
      -- X meaning expected
      constant L : BTERN_LOGIC_VECTOR;
               R : BTERN_LOGIC;
               X : BTERN_LOGIC_VECTOR) is
      variable result : BTERN_LOGIC_VECTOR(L'length-1 downto 0);
      variable L_int, R_int, res_int, X_int : INTEGER;
    begin
      result := L + R;
      
      -- Convert to integers for verification
      L_int   := TO_INTEGER(L);
      R_int   := TO_INTEGER(R);
      res_int := TO_INTEGER(result);
      X_int   := TO_INTEGER(X);
      
      -- Check BTERN_LOGIC_VECTOR equivalence
      check_equal(TO_STRING(result), TO_STRING(X),
                  ": Vector mismatch. " &
                  TO_STRING(L) & " + " & TO_STRING(R) &
                  " = " & TO_STRING(result) &
                  " (expected " & TO_STRING(X) & ")");
      
      -- Check integer equivalence
      check_equal(res_int, X_int,
                  ": Integer mismatch. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (expected " & INTEGER'image(X_int) & ")");
      
      -- Verify arithmetic correctness
      check_equal(res_int, L_int + R_int,
                  ": Arithmetic error. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (should be " & INTEGER'image(L_int + R_int) & ")");
    end procedure;
    
    -- Helper procedure to test addition with one scalar
    -- and one vector (reverse order).
    procedure test_addition(
      -- X meaning expected
      constant L : BTERN_LOGIC;
               R : BTERN_LOGIC_VECTOR;
               X : BTERN_LOGIC_VECTOR) is
      variable result : BTERN_LOGIC_VECTOR(R'length-1 downto 0);
      variable L_int, R_int, res_int, X_int : INTEGER;
    begin
      result := L + R;
      
      -- Convert to integers for verification
      L_int   := TO_INTEGER(L);
      R_int   := TO_INTEGER(R);
      res_int := TO_INTEGER(result);
      X_int   := TO_INTEGER(X);
      
      -- Check BTERN_LOGIC_VECTOR equivalence
      check_equal(TO_STRING(result), TO_STRING(X),
                  ": Vector mismatch. " &
                  TO_STRING(L) & " + " & TO_STRING(R) &
                  " = " & TO_STRING(result) &
                  " (expected " & TO_STRING(X) & ")");
      
      -- Check integer equivalence
      check_equal(res_int, X_int,
                  ": Integer mismatch. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (expected " & INTEGER'image(X_int) & ")");
      
      -- Verify arithmetic correctness
      check_equal(res_int, L_int + R_int,
                  ": Arithmetic error. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (should be " & INTEGER'image(L_int + R_int) & ")");
    end procedure;

    -- Helper procedure to test addition with one integer
    -- and one vector.
    procedure test_addition(
      -- X meaning expected
      constant L : BTERN_LOGIC_VECTOR;
               R : INTEGER;
               X : BTERN_LOGIC_VECTOR) is
      variable result : BTERN_LOGIC_VECTOR(L'length-1 downto 0);
      variable L_int, res_int, X_int : INTEGER;
    begin
      result := L + R;
      
      -- Convert to integers for verification
      L_int   := TO_INTEGER(L);
      res_int := TO_INTEGER(result);
      X_int   := TO_INTEGER(X);
      
      -- Check BTERN_LOGIC_VECTOR equivalence
      check_equal(TO_STRING(result), TO_STRING(X),
                  ": Vector mismatch. " &
                  TO_STRING(L) & " + " & TO_STRING(R) &
                  " = " & TO_STRING(result) &
                  " (expected " & TO_STRING(X) & ")");
      
      -- Check integer equivalence
      check_equal(res_int, X_int,
                  ": Integer mismatch. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R) &
                  " = " & INTEGER'image(res_int) &
                  " (expected " & INTEGER'image(X_int) & ")");
      
      -- Verify arithmetic correctness
      check_equal(res_int, L_int + R,
                  ": Arithmetic error. " &
                  INTEGER'image(L_int) & " + " & INTEGER'image(R) &
                  " = " & INTEGER'image(res_int) &
                  " (should be " & INTEGER'image(L_int + R) & ")");
    end procedure;

    -- Helper procedure to test addition with one integer
    -- and one vector (reverse order).
    procedure test_addition(
      -- X meaning expected
      constant L : INTEGER;
               R : BTERN_LOGIC_VECTOR;
               X : BTERN_LOGIC_VECTOR) is
      variable result : BTERN_LOGIC_VECTOR(R'length-1 downto 0);
      variable R_int, res_int, X_int : INTEGER;
    begin
      result := L + R;
      
      -- Convert to integers for verification
      R_int   := TO_INTEGER(R);
      res_int := TO_INTEGER(result);
      X_int   := TO_INTEGER(X);
      
      -- Check BTERN_LOGIC_VECTOR equivalence
      check_equal(TO_STRING(result), TO_STRING(X),
                  ": Vector mismatch. " &
                  TO_STRING(L) & " + " & TO_STRING(R) &
                  " = " & TO_STRING(result) &
                  " (expected " & TO_STRING(X) & ")");
      
      -- Check integer equivalence
      check_equal(res_int, X_int,
                  ": Integer mismatch. " &
                  INTEGER'image(L) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (expected " & INTEGER'image(X_int) & ")");
      
      -- Verify arithmetic correctness
      check_equal(res_int, L + R_int,
                  ": Arithmetic error. " &
                  INTEGER'image(L) & " + " & INTEGER'image(R_int) &
                  " = " & INTEGER'image(res_int) &
                  " (should be " & INTEGER'image(L + R_int) & ")");
    end procedure;

    -- Helper to generate random balanced ternary vector
    impure function random_btern_vector(width : INTEGER) return BTERN_LOGIC_VECTOR is
      variable result : BTERN_LOGIC_VECTOR(width-1 downto 0);
      variable rand_val : INTEGER;
      type btern_values is array (0 to 2) of BTERN_LOGIC;
      constant valid_values : btern_values := ('-', '0', '+');
    begin
      -- loop only until the next-leftmost trit to prevent
      -- overflow in the case of two maxed-out vectors
      result(width-1) := '0';
      for i in 0 to width-2 loop
        rand_val := RV.RandInt(0, 2);
        result(i) := valid_values(rand_val);
      end loop;
      return result;
    end function;
    
  begin
    test_runner_setup(runner, runner_cfg);
    
    -- Initialize random seed
    RV.InitSeed(RV'instance_name);

    -- Tests are run either with static, hard-coded vector numbers 
    -- or with randomly generated vector numbers. The test cases
    -- are named to indicate which is which
    
    if run("Static - Exhaustive -364 to +364") then
      -- Runs an exhaustive 6-trit test combining all numbers from 
      -- -364 to +364. The operands and result thus need to be 7-trit
      -- to protect against overflow.

      for x in -364 to 364 loop
        for y in -364 to 364 loop
          test_addition(
          TO_BALTERN(x, 7),
          TO_BALTERN(y, 7),
          TO_BALTERN(x + y, 7)
          );
        end loop;
      end loop;

    elsif run("Static - Basic addition cases") then
      
      -- 0 + 0 = 0
      test_addition(
        BTERN_LOGIC_VECTOR'("0000"),
        BTERN_LOGIC_VECTOR'("0000"),
        BTERN_LOGIC_VECTOR'("0000"));
      
      -- 1 + 0 = 1 (+ + 0 = +)
      test_addition(
        BTERN_LOGIC_VECTOR'("000+"),
        BTERN_LOGIC_VECTOR'("0000"),
        BTERN_LOGIC_VECTOR'("000+"));
      
      -- 1 + 1 = 2 (+ + + = +-)
      test_addition(
        BTERN_LOGIC_VECTOR'("000+"),
        BTERN_LOGIC_VECTOR'("000+"),
        BTERN_LOGIC_VECTOR'("00+-"));
      
      -- -1 + 0 = -1 (- + 0 = -)
      test_addition(
        BTERN_LOGIC_VECTOR'("000-"),
        BTERN_LOGIC_VECTOR'("0000"),
        BTERN_LOGIC_VECTOR'("000-"));
      
      -- 1 + (-1) = 0 (+ + - = 0)
      test_addition(
        BTERN_LOGIC_VECTOR'("000+"),
        BTERN_LOGIC_VECTOR'("000-"),
        BTERN_LOGIC_VECTOR'("0000"));

      -- -1 + -1 = -2 (- + - = -+)
      test_addition(
        BTERN_LOGIC_VECTOR'("000-"),
        BTERN_LOGIC_VECTOR'("000-"),
        BTERN_LOGIC_VECTOR'("00-+"));
      
      -- -2 + -1 = -3 (-+ + - = -0)
      test_addition(
        BTERN_LOGIC_VECTOR'("00-+"),
        BTERN_LOGIC_VECTOR'("000-"),
        BTERN_LOGIC_VECTOR'("00-0"));
      
      -- 3 + (-1) = 2
      test_addition(
        BTERN_LOGIC_VECTOR'("00+0"),
        BTERN_LOGIC_VECTOR'("000-"),
        BTERN_LOGIC_VECTOR'("00+-"));
      
      
    elsif run("Static - Different widths") then
      
      -- 4-trit vectors
      test_addition(
        BTERN_LOGIC_VECTOR'("00+-"),
        BTERN_LOGIC_VECTOR'("000+"),
        BTERN_LOGIC_VECTOR'("00+0"));
      
      -- 8-trit vectors
      test_addition(
        BTERN_LOGIC_VECTOR'("0000+0-0"),
        BTERN_LOGIC_VECTOR'("00000+0+"),
        BTERN_LOGIC_VECTOR'("0000++-+"));
      
      -- 12-trit vectors
      test_addition(
        BTERN_LOGIC_VECTOR'("000000000+-0"),
        BTERN_LOGIC_VECTOR'("00000000000+"),
        BTERN_LOGIC_VECTOR'("000000000+-+"));
      
    elsif run("Random - Commutative property") then
      for i in 1 to 100 loop
        a <= random_btern_vector(19);
        b <= random_btern_vector(19);
        wait for 1 ns;
        result1 <= a + b;
        result2 <= b + a;
        
        check_equal(TO_STRING(result1), TO_STRING(result2),
                    "Commutative property failed: " &
                    TO_STRING(a) & " + " & TO_STRING(b));
      end loop;
      
    elsif run("Random - Associative property") then

      for i in 1 to 100 loop
        a <= random_btern_vector(19);
        b <= random_btern_vector(19);
        c <= random_btern_vector(19);
        wait for 1 ns;
        result1 <= (a + b) + c;
        result2 <= a + (b + c);
        wait for 1 ns;
        
        check_equal(TO_STRING(result1), TO_STRING(result2),
                    "Associative property failed");
      end loop;
      
    elsif run("Random - Addition with inverse") then

      for i in 1 to 100 loop
        a       <= random_btern_vector(19);
        wait for 1 ns;
        neg_a   <= -a;
        wait for 1 ns;
        result1 <= a + neg_a;
        wait for 1 ns;
        check_equal(TO_STRING(result1), TO_STRING(zero),
                    "Inverse failed: " & TO_STRING(a) & " + " & TO_STRING(neg_a));
      end loop;
      
    elsif run("Random - Exhaustive") then

      for i in 1 to NUM_RANDOM_TESTS loop
        a       <= random_btern_vector(19);
        b       <= random_btern_vector(19);
        wait for 1 ns;
        result1 <= a + b;
        wait for 1 ns;
      
        a_int        <= TO_INTEGER(a);
        b_int        <= TO_INTEGER(b);
        result_int   <= TO_INTEGER(result1);
        wait for 1 ns;
        expected_int <= a_int + b_int;
        wait for 1 ns;
        
        check_equal(result_int, expected_int,
                    "Random test " & INTEGER'image(i) & " failed: " &
                    INTEGER'image(a_int) & " + " & INTEGER'image(b_int) &
                    " = " & INTEGER'image(result_int) &
                    " (expected " & INTEGER'image(expected_int) & ")");
      end loop;

    elsif run("Boundary values & null-arrays") then
      
      -- Maximum positive value
      test_addition(
        BTERN_LOGIC_VECTOR'("+++"),
        BTERN_LOGIC_VECTOR'("000"),
        BTERN_LOGIC_VECTOR'("+++"));
      
      -- Minimum negative value
      test_addition(
        BTERN_LOGIC_VECTOR'("---"),
        BTERN_LOGIC_VECTOR'("000"),
        BTERN_LOGIC_VECTOR'("---"));

      -- Null-arrays
      check_equal(
        TO_STRING(v_empty + BTERN_LOGIC_VECTOR'("00+")),
        TO_STRING(T_NAC)
        );
      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("00+") + v_empty),
        TO_STRING(T_NAC)
        );

      -- With metalogical values
      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("0D+") + BTERN_LOGIC_VECTOR'("00+")),
        TO_STRING(BTERN_LOGIC_VECTOR'("XXX"))
        );
      check_equal(
        TO_STRING(BTERN_LOGIC_VECTOR'("00+") + BTERN_LOGIC_VECTOR'("0Z+")),
        TO_STRING(BTERN_LOGIC_VECTOR'("XXX"))
        );
      
    elsif run("Vector and scalar combinations") then

      test_addition(
        BTERN_LOGIC_VECTOR'("00+-"),
                  BTERN_LOGIC'('+'),
        BTERN_LOGIC_VECTOR'("00+0")
        );
      test_addition(
        BTERN_LOGIC_VECTOR'("00+-"),
                  BTERN_LOGIC'('-'),
        BTERN_LOGIC_VECTOR'("000+")
        );
      test_addition(
        BTERN_LOGIC_VECTOR'("00+-"),
                  BTERN_LOGIC'('0'),
        BTERN_LOGIC_VECTOR'("00+-")
        );

      test_addition(
                  BTERN_LOGIC'('+'),
        BTERN_LOGIC_VECTOR'("00+-"),
        BTERN_LOGIC_VECTOR'("00+0")
        );
      test_addition(
                  BTERN_LOGIC'('-'),
        BTERN_LOGIC_VECTOR'("00+-"),
        BTERN_LOGIC_VECTOR'("000+")
        );
      test_addition(
                  BTERN_LOGIC'('0'),
        BTERN_LOGIC_VECTOR'("00+-"),
        BTERN_LOGIC_VECTOR'("00+-")
        );

    elsif run("Vector and integer combinations") then
      -- Max integer for 4 trits is +/- 40
      test_addition(
        BTERN_LOGIC_VECTOR'("00+-"),
                              1,
        BTERN_LOGIC_VECTOR'("00+0")
        );
      test_addition(
        BTERN_LOGIC_VECTOR'("00+-"),
                              0,
        BTERN_LOGIC_VECTOR'("00+-")
        );
      test_addition(
        BTERN_LOGIC_VECTOR'("00+-"),
                              38,
        BTERN_LOGIC_VECTOR'("++++")
        );

      test_addition(
                              1,
        BTERN_LOGIC_VECTOR'("00+-"),
        BTERN_LOGIC_VECTOR'("00+0")
        );
      test_addition(
                              0,
        BTERN_LOGIC_VECTOR'("00+-"),
        BTERN_LOGIC_VECTOR'("00+-")
        );
      test_addition(
                              38,
        BTERN_LOGIC_VECTOR'("00+-"),
        BTERN_LOGIC_VECTOR'("++++")
        );

    end if;
    
    test_runner_cleanup(runner);
  end process;
  
end architecture;