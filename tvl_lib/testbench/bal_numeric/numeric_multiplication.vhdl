-- --------------------------------------------------------------------
-- Title   : BAL_NUMERIC Multiplication Overloads
-- Notes   : Uses an OSVVM random variable to create randomized
--           balanced ternary vectors where the most significant trit
--           is set to 0 to prevent arithmetic overflow. Tests all 
--           possible 6-trit integers for comprehensive coverage,
--           and randomized 10-trit integers. 
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity numeric_multiplication_tb is
  generic (runner_cfg : string);
end entity;

architecture test of numeric_multiplication_tb is

    -- Test configuration
    constant NUM_RANDOM_TESTS : INTEGER := 1000;

    --Test signals for "Commutative property"
    signal a_com, b_com : BTERN_LOGIC_VECTOR (10 downto 0);
    signal result1_com, result2_com : BTERN_LOGIC_VECTOR (21 downto 0);

    --Test signals for "Distributive property"
    signal a_dist, b_dist, c_dist : BTERN_LOGIC_VECTOR (9 downto 0);
    signal result1_dist, result2_dist : BTERN_LOGIC_VECTOR (19 downto 0);
   
    -- Test signals for "RANDOM - 10-trit combinations"
    signal a_10rand, b_10rand : BTERN_LOGIC_VECTOR (10 downto 0);
    signal a_int, b_int, result_int, expected_int, last_val : INTEGER;

begin

  main : process
    variable RV : RandomPType;  -- OSVVM random variable
    
    -- Helper procedure to test multiplication
    procedure test_multiplication(
      constant a_vec : BTERN_LOGIC_VECTOR;
      constant b_vec : BTERN_LOGIC_VECTOR;
      constant expected_vec : BTERN_LOGIC_VECTOR
    ) is
      variable result : BTERN_LOGIC_VECTOR(a_vec'length+b_vec'length-1 downto 0);
      variable a_i, b_i, result_i, expected_i : INTEGER;
    begin
      result := a_vec * b_vec;
      
      -- Convert to integers for verification
      a_i := TO_INTEGER(a_vec);
      b_i := TO_INTEGER(b_vec);
      result_i := TO_INTEGER(result);
      expected_i := TO_INTEGER(expected_vec);
      
      -- Check BTERN_LOGIC_VECTOR equivalence
      check_equal(TO_STRING(result), TO_STRING(expected_vec),
                  ": Vector mismatch. " &
                  TO_STRING(a_vec) & " * " & TO_STRING(b_vec) &
                  " = " & TO_STRING(result) &
                  " (expected " & TO_STRING(expected_vec) & ")");
      
      -- Check integer equivalence
      check_equal(result_i, expected_i,
                  ": Integer mismatch. " &
                  INTEGER'image(a_i) & " * " & INTEGER'image(b_i) &
                  " = " & INTEGER'image(result_i) &
                  " (expected " & INTEGER'image(expected_i) & ")");
      
      -- Verify arithmetic correctness
      check_equal(result_i, a_i * b_i,
                  ": Arithmetic error. " &
                  INTEGER'image(a_i) & " * " & INTEGER'image(b_i) &
                  " = " & INTEGER'image(result_i) &
                  " (should be " & INTEGER'image(a_i * b_i) & ")");
    end procedure;
    
    -- Helper to generate random balanced ternary vector
    impure function random_btern_vector(width : INTEGER) 
    return BTERN_LOGIC_VECTOR is
      variable result : BTERN_LOGIC_VECTOR(width-1 downto 0);
      variable rand_val : INTEGER;
      type btern_values is array (0 to 2) of BTERN_LOGIC;
      constant valid_values : btern_values := ('-', '0', '+');
    begin
      -- loop only until the next-leftmost trit to prevent
      -- overflow in the case of addition after this function
      -- with two maxed-out vectors
      result(width-1) := '0';
      for i in 0 to width-2 loop
        rand_val := RV.RandInt(0, 2);
        result(i) := valid_values(rand_val);
      end loop;
      return result;
    end function;
    
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

    if run("Static - Exhaustive -364 to +364") then
      -- Runs an exhaustive 6-trit test combining all numbers from 
      -- -364 to +364.

      for x in -364 to 364 loop
        for y in -364 to 364 loop
          test_multiplication(
          TO_BALTERN(x, 6),
          TO_BALTERN(y, 6),
          TO_BALTERN(x * y, 12)
          );
        end loop;
      end loop;
    
    elsif run("Commutative property") then
    
        for i in 1 to 100 loop
            a_com <= random_btern_vector(11);
            b_com <= random_btern_vector(11);
            wait for 1 ns;
            result1_com <= a_com * b_com;
            result2_com <= b_com * a_com;
            wait for 1 ns;
            
            check_equal(TO_STRING(result1_com), TO_STRING(result2_com),
                        "Commutative property failed: " &
                        TO_STRING(a_com) & " * " & TO_STRING(b_com));
        end loop;
    
    elsif run("Distributive property") then
          -- max VHDL INTEGER type is +/- 2'147'483'647.
          -- As we are multiplying, we need to ensure the product can get no
          -- greater than this. The closest we can get is two all-plus 
          -- 10-trit numbers, giving 29524^2 = 871'666'576.
        for i in 1 to NUM_RANDOM_TESTS loop
            a_dist <= random_btern_vector(10);
            b_dist <= random_btern_vector(10);
            c_dist <= random_btern_vector(10);
            wait for 1 ns;

            result1_dist <= a_dist * (b_dist + c_dist);
            result2_dist <= (a_dist * b_dist) + (a_dist * c_dist);
            wait for 1 ns;

            check_equal(TO_INTEGER(result1_dist), TO_INTEGER(result2_dist),
                        "Distributive property failed");
        end loop;

    elsif run("Random - 10-trit combinations") then
      
      for i in 1 to NUM_RANDOM_TESTS loop
          -- max VHDL INTEGER type is +/- 2'147'483'647.
          -- As we are multiplying, we need to ensure the product can get no
          -- greater than this. The closest we can get is two all-plus 
          -- 10-trit numbers, giving 29524^2 = 871'666'576.
          -- 11 is set here due to the modifications done in the 
          -- random_btern_vector-function to accomodate addition.
          a_10rand <= random_btern_vector(11);
          b_10rand <= random_btern_vector(11);
          wait for 1 ns;
          
          result_int <= TO_INTEGER(a_10rand * b_10rand);
          a_int      <= TO_INTEGER(a_10rand);
          b_int      <= TO_INTEGER(b_10rand);
          wait for 1 ns;

          expected_int <= a_int * b_int;
          wait for 1 ns;

          check_equal(result_int, expected_int,
                      "Random test failed: " &
                      INTEGER'image(a_int) & " * " & INTEGER'image(b_int) &
                      " = " & INTEGER'image(result_int) &
                      " (expected " & INTEGER'image(expected_int) & ")");
      end loop;

    elsif run("Max/Min 10-trit vectors") then

      last_val <= 0;
      wait for 1 ns;

      for i in 0 to 9 loop
        last_val <= last_val + (3**i);
        wait for 1 ns;

        -- Maximum positive
        test_multiplication(
            max_min_vector(i+1, false), 
            max_min_vector(i+1, false),
            TO_BALTERN(last_val*last_val, (i+1)*2)
        );

        -- Maximum negative
        test_multiplication(
            max_min_vector(i+1, true), 
            max_min_vector(i+1, true),
            TO_BALTERN(last_val*last_val, (i+1)*2)
        );
      end loop;

    end if;
    
    test_runner_cleanup(runner);
  end process;
  
end architecture;