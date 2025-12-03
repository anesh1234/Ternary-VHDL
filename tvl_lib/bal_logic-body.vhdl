-- -----------------------------------------------------------------
--
--   Title     :  Standard ternary logic package
--             :  (BAL_LOGIC package body)
--             :
--   Library   :  This package shall be compiled into a library
--             :  symbolically named TVL.
--             :
--   Developers:  Anders Mørk Minde, University of South Eastern Norway
--             :
--   Purpose   :  This packages defines a standard for designers
--             :  to use in describing the interconnection data types
--             :  used in vhdl modeling of ternary hardware.
--             :
--   Limitation:  The logic system defined in this package may
--             :  be insufficient for modeling switched transistors,
--             :  since such a requirement is out of the scope of this
--             :  effort. Furthermore, mathematics, primitives,
--             :  timing standards, etc. are considered orthogonal
--             :  issues as it relates to this package and are therefore
--             :  beyond the scope of this effort.
--             :
--   Note      :  
--             :
-- --------------------------------------------------------------------
-- $Revision: 1 $
-- $Date: 2025-07-10 (Tue, 10 Oct 2025) $
-- --------------------------------------------------------------------

package body bal_logic is

  -- null range array constant and implementation controls
  constant NAC : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');
  constant NO_WARNING : BOOLEAN := FALSE;  -- default to emit warnings
  
  -------------------------------------------------------------------
  -- local types
  -------------------------------------------------------------------
  type bternlogic_1d is array (BTERN_ULOGIC) of BTERN_ULOGIC;
  type bternlogic_table is array(BTERN_ULOGIC, BTERN_ULOGIC) of BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- resolution function
  -- -, 0 and + are resolved the same way as in binary,
  -- resolving to X when different values are presented
  -------------------------------------------------------------------
  constant btern_resolution_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U'),  -- | U |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('U', 'X', '-', 'X', 'X', '-', '-', '-', '-', '-', 'X'),  -- | - |
             ('U', 'X', 'X', '0', 'X', '0', '0', '0', '0', '0', 'X'),  -- | 0 |
             ('U', 'X', 'X', 'X', '+', '+', '+', '+', '+', '+', 'X'),  -- | + |
             ('U', 'X', '-', '0', '+', 'Z', 'W', 'B', 'L', 'H', 'X'),  -- | Z |
             ('U', 'X', '-', '0', '+', 'W', 'W', 'W', 'W', 'W', 'X'),  -- | W |
             ('U', 'X', '-', '0', '+', 'B', 'W', 'B', 'W', 'W', 'X'),  -- | B |
             ('U', 'X', '-', '0', '+', 'L', 'W', 'W', 'L', 'W', 'X'),  -- | L |
             ('U', 'X', '-', '0', '+', 'H', 'W', 'W', 'W', 'H', 'X'),  -- | H |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             );

  function resolved (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    variable result : BTERN_ULOGIC := 'Z';  -- weakest state default
  begin
    -- the test for a single driver is essential otherwise the
    -- loop would return 'X' for a single driver of 'D' and that
    -- would conflict with the value of a single driver unresolved
    -- signal.
    if (s'length = 1) then return s(s'low);
    else
      for i in s'range loop
        result := btern_resolution_table(result, s(i));
      end loop;
    end if;
    return result;
  end function resolved;

  -------------------------------------------------------------------
  -- Tables for unary logical functions, preceded by 
  -- their respective heptavintimal index in brackets []
  -------------------------------------------------------------------

  -- truth table for [0], CONST_LOW
  constant col_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X');
  
  -- truth table for [2], Negative Ternary Inverter
  constant nti_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '+', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [5], Standard Ternary Inverter
  constant sti_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [6], Middle Toggling Inverter, DETECT_MIDDLE
  constant mti_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '-', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [7], Increment, NEXT, SUCCESSOR
  constant inc_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '0', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [8], Positive Ternary Inverter
  constant pti_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '+', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [B], DECREMENT, PREV, PREDECESSOR
  constant dec_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '+', '-', '0', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [C], CLAMP_DOWN
  constant cld_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '-', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [D], CONST_MIDDLE
  constant com_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [K], Inverted PTI, DETECT_HIGH
  constant ipt_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '-', '-', '+', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [N], Inverted MTI, inverted DETECT_MIDDLE
  constant imt_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '+', '-', '+', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [P], BUFFER
  constant buf_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [R], CLAMP_UP
  constant clu_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [V], Inverted NTI
  constant int_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '-', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X');

  -- truth table for [Z], CONST_HIGH
  constant coh_table : bternlogic_1d :=
    -- ---------------------------------------------------------
    -- |  U    X    -    0    +    Z    W    B    L    H    D   |
    -- --------------------------------------------------------- 
        ('X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X');


  -------------------------------------------------------------------
  -- Tables for binary logical functions, preceded by 
  -- their respective heptavintimal index in brackets []
  -------------------------------------------------------------------
 
  -- [7PB] (SUM), TRISHIFT (DEC,BUF,INC)
  constant sum_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '+', '-', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '0', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             );

  -- [RDC] CONSENSUS (CON)
  constant con_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '-', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             );

  -- [4DE] NCONS (NCO)
  constant nco_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '+', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '0', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             );
 
  -- [PC0] Minimum (MINI), Ternary AND
  constant min_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '-', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 
 
  -- [ZRP] Maximum (MAX), Ternary OR
  constant max_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [045] NMIN (NMI)
  constant nmi_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [5EZ] NMAX (NMA)
  constant nma_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '+', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [5DP] XOR
  constant btern_xor_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             );

  -- [PD5] MULTIPLY (MUL)
  constant mul_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             );

  -- [PRZ] IMPLICATION (IMP)
  constant imp_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [XP9] ANY
  constant any_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '-', '-', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '0', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [15H] NANY (NAN)
  constant nan_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '+', '+', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '0', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [H51] COMPARE, MORE,LESS,EQUAL (MLE)
  constant mle_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '0', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '+', '+', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [RD4] ENABLE (ENA)
  constant ena_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '0', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -- [VP0] DESELECT (DES)
  constant des_table : bternlogic_table := (
    --      ---------------------------------------------------------
    --      |  U    X    -    0    +    Z    W    B    L    H    D   |
    --      ---------------------------------------------------------     
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | U |  
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | - |
             ('X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | 0 |
             ('X', 'X', '-', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | + |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | B |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | L |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | D |
             ); 

  -------------------------------------------------------------------
  -- Ternary unary logical functions for scalar and vector types, 
  -- preceded by their respective heptavintimal index in brackets [].
  -------------------------------------------------------------------

  -------------------------------------------------------------------
  -- [0], CONST_LOW
  -------------------------------------------------------------------
  function COL (l : BTERN_ULOGIC) return U2P is
  begin
    return (col_table(l));
  end function COL;
  ------------------------------------------------------------------- 
  function COL (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := col_table(lv(i));
    end loop;
    return result;
  end function COL;

  -------------------------------------------------------------------
  -- [2], Negative Ternary Inverter, DETECT_LOW
  -------------------------------------------------------------------
  function NTI (l : BTERN_ULOGIC) return U2P is
  begin
    return (nti_table(l));
  end function NTI;
  -------------------------------------------------------------------
  function NTI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := nti_table(lv(i));
    end loop;
    return result;
  end function NTI;

  -------------------------------------------------------------------
  -- [5], Standard Ternary Inverter
  -------------------------------------------------------------------
  function STI (l : BTERN_ULOGIC) return U2P is
  begin
    return (sti_table(l));
  end function STI;
  -------------------------------------------------------------------
  function STI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := sti_table(lv(i));
    end loop;
    return result;
  end function STI;

  -------------------------------------------------------------------
  -- [6], Middle Toggling Inverter, DETECT_MIDDLE
  -------------------------------------------------------------------
  function MTI (l : BTERN_ULOGIC) return U2P is
  begin
    return (mti_table(l));
  end function MTI;
  -------------------------------------------------------------------
  function MTI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := mti_table(lv(i));
    end loop;
    return result;
  end function MTI;

  -------------------------------------------------------------------
  -- [7], Increment, NEXT, SUCCESSOR
  -------------------------------------------------------------------
  function INC (l : BTERN_ULOGIC) return U2P is
  begin
    return (inc_table(l));
  end function INC;
  -------------------------------------------------------------------
  function INC (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := inc_table(lv(i));
    end loop;
    return result;
  end function INC;

  -------------------------------------------------------------------
  -- [8], Positive Ternary Inverter
  -------------------------------------------------------------------
  function PTI (l : BTERN_ULOGIC) return U2P is
  begin
    return (pti_table(l));
  end function PTI;
  -------------------------------------------------------------------
  function PTI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := pti_table(lv(i));
    end loop;
    return result;
  end function PTI;

  -------------------------------------------------------------------
  -- [B], DECREMENT, PREV, PREDECESSOR
  -------------------------------------------------------------------
  function DEC (l : BTERN_ULOGIC) return U2P is
  begin
    return (dec_table(l));
  end function DEC;
  -------------------------------------------------------------------
  function DEC (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := dec_table(lv(i));
    end loop;
    return result;
  end function DEC;

  -------------------------------------------------------------------
  -- [C], CLAMP_DOWN
  -------------------------------------------------------------------
  function CLD (l : BTERN_ULOGIC) return U2P is
  begin
    return (cld_table(l));
  end function CLD;
  -------------------------------------------------------------------
  function CLD (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := cld_table(lv(i));
    end loop;
    return result;
  end function CLD;

  -------------------------------------------------------------------
  -- [D], CONST_MIDDLE
  -------------------------------------------------------------------
  function COM (l : BTERN_ULOGIC) return U2P is
  begin
    return (com_table(l));
  end function COM;
  -------------------------------------------------------------------
  function COM (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := com_table(lv(i));
    end loop;
    return result;
  end function COM;

  -------------------------------------------------------------------
  -- [K], Inverted PTI, DETECT_HIGH
  -------------------------------------------------------------------
  function IPT (l : BTERN_ULOGIC) return U2P is
  begin
    return (ipt_table(l));
  end function IPT;
  -------------------------------------------------------------------
  function IPT (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := ipt_table(lv(i));
    end loop;
    return result;
  end function IPT;

  -------------------------------------------------------------------
  -- [N], Inverted MTI, inverted DETECT_MIDDLE
  -------------------------------------------------------------------
  function IMT (l : BTERN_ULOGIC) return U2P is
  begin
    return (imt_table(l));
  end function IMT;
  -------------------------------------------------------------------
  function IMT (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := imt_table(lv(i));
    end loop;
    return result;
  end function IMT;

  -------------------------------------------------------------------
  -- [P], BUFFER
  -------------------------------------------------------------------
  function BUF (l : BTERN_ULOGIC) return U2P is
  begin
    return (buf_table(l));
  end function BUF;
  -------------------------------------------------------------------
  function BUF (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := buf_table(lv(i));
    end loop;
    return result;
  end function BUF;

  -------------------------------------------------------------------
  -- [R], CLAMP_UP
  -------------------------------------------------------------------
  function CLU (l : BTERN_ULOGIC) return U2P is
  begin
    return (clu_table(l));
  end function CLU;
  -------------------------------------------------------------------
  function CLU (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := clu_table(lv(i));
    end loop;
    return result;
  end function CLU;

  -------------------------------------------------------------------
  -- [V], Inverted NTI
  -------------------------------------------------------------------
  function INT (l : BTERN_ULOGIC) return U2P is
  begin
    return (int_table(l));
  end function INT;
  -------------------------------------------------------------------
  function INT (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := int_table(lv(i));
    end loop;
    return result;
  end function INT;

  -------------------------------------------------------------------
  -- [Z], CONST_HIGH
  -------------------------------------------------------------------
  function COH (l : BTERN_ULOGIC) return U2P is
  begin
    return (coh_table(l));
  end function COH;
  -------------------------------------------------------------------
  function COH (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => 'X');
  begin
    for i in result'range loop
      result(i) := coh_table(lv(i));
    end loop;
    return result;
  end function COH;

  -------------------------------------------------------------------
  -- Ternary binary logical functions for scalar and vector types, 
  -- preceded by their respective heptavintimal index in brackets [].
  -------------------------------------------------------------------

  -------------------------------------------------------------------
  -- [7PB] SUM, TRISHIFT (DEC,BUF,INC)
  -------------------------------------------------------------------

  function SUM (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (sum_table(l, r));
  end function SUM;
  -------------------------------------------------------------------

  function SUM (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.SUM: "
        & "arguments of SUM function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := sum_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function SUM;
  -------------------------------------------------------------------

  function SUM (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := sum_table (lv(i), r);
    end loop;
    return result;
  end function SUM;
  -------------------------------------------------------------------

  function SUM (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := sum_table (l, rv(i));
    end loop;
    return result;
  end function SUM;

  -------------------------------------------------------------------
  -- [RDC] CONSENSUS (CON)
  -------------------------------------------------------------------

  function CON (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (con_table(l, r));
  end function CON;
  -------------------------------------------------------------------

  function CON (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.CON: "
        & "arguments of CON function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := con_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function CON;
  -------------------------------------------------------------------

  function CON (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := con_table (lv(i), r);
    end loop;
    return result;
  end function CON;
  -------------------------------------------------------------------

  function CON (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := con_table (l, rv(i));
    end loop;
    return result;
  end function CON;

  -------------------------------------------------------------------
  -- [4DE] NCONS (NCO)
  -------------------------------------------------------------------

  function NCO (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (nco_table(l, r));
  end function NCO;
  -------------------------------------------------------------------

  function NCO (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.NCO: "
        & "arguments of NCO function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := nco_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function NCO;
  -------------------------------------------------------------------

  function NCO (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nco_table (lv(i), r);
    end loop;
    return result;
  end function NCO;
  -------------------------------------------------------------------

  function NCO (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nco_table (l, rv(i));
    end loop;
    return result;
  end function NCO;

  -------------------------------------------------------------------
  -- [PC0] Minimum (MINI)
  -------------------------------------------------------------------

  function MINI (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (min_table(l, r));
  end function MINI;
  -------------------------------------------------------------------

  function MINI (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.MINI: "
        & "arguments of MINI function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := min_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function MINI;
  -------------------------------------------------------------------

  function MINI (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := min_table (lv(i), r);
    end loop;
    return result;
  end function MINI;
  -------------------------------------------------------------------

  function MINI (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := min_table (l, rv(i));
    end loop;
    return result;
  end function MINI;

  -------------------------------------------------------------------
  -- [ZRP] Maximum (MAX)
  -------------------------------------------------------------------

  function MAX (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (max_table(l, r));
  end function MAX;
  -------------------------------------------------------------------

  function MAX (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.MAX: "
        & "arguments of MAX function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := max_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function MAX;
  -------------------------------------------------------------------

  function MAX (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := max_table (lv(i), r);
    end loop;
    return result;
  end function MAX;
  -------------------------------------------------------------------

  function MAX (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := max_table (l, rv(i));
    end loop;
    return result;
  end function MAX;

  -------------------------------------------------------------------
  -- [045] NMIN (NMI)
  -------------------------------------------------------------------

  function NMI (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (nmi_table(l, r));
  end function NMI;
  -------------------------------------------------------------------

  function NMI (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.NMI: "
        & "arguments of NMI function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := nmi_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function NMI;
  -------------------------------------------------------------------

  function NMI (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nmi_table (lv(i), r);
    end loop;
    return result;
  end function NMI;
  -------------------------------------------------------------------

  function NMI (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nmi_table (l, rv(i));
    end loop;
    return result;
  end function NMI;

  -------------------------------------------------------------------
  -- [5EZ] NMAX (NMA)
  -------------------------------------------------------------------

  function NMA (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (nma_table(l, r));
  end function NMA;
  -------------------------------------------------------------------

  function NMA (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.NMA: "
        & "arguments of NMA function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := nma_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function NMA;
  -------------------------------------------------------------------

  function NMA (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nma_table (lv(i), r);
    end loop;
    return result;
  end function NMA;
  -------------------------------------------------------------------

  function NMA (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nma_table (l, rv(i));
    end loop;
    return result;
  end function NMA;

  -------------------------------------------------------------------
  -- [5DP] XOR
  -------------------------------------------------------------------
  function "XOR" (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (btern_xor_table(l, r));
  end function "XOR";
  -------------------------------------------------------------------
  function "XOR" (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.""XOR"": "
        & "arguments of ""XOR"" function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := btern_xor_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function "XOR";
  -------------------------------------------------------------------
  function "XOR" (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := btern_xor_table (lv(i), r);
    end loop;
    return result;
  end function "XOR";
  -------------------------------------------------------------------
  function "XOR" (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := btern_xor_table (l, rv(i));
    end loop;
    return result;
  end function "XOR";

  -------------------------------------------------------------------
  -- [PD5] MULTIPLY (MUL)
  -------------------------------------------------------------------
  function MUL (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (mul_table(l, r));
  end function MUL;
  -------------------------------------------------------------------
  function MUL (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.MUL: "
        & "arguments of MUL function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := mul_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function MUL;
  -------------------------------------------------------------------
  function MUL (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := mul_table (lv(i), r);
    end loop;
    return result;
  end function MUL;
  -------------------------------------------------------------------
  function MUL (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := mul_table (l, rv(i));
    end loop;
    return result;
  end function MUL;

  -------------------------------------------------------------------
  -- [PRZ] IMPLICATION (IMP)
  -------------------------------------------------------------------
  function IMP (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (imp_table(l, r));
  end function IMP;
  -------------------------------------------------------------------
  function IMP (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.IMP: "
        & "arguments of IMP function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := imp_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function IMP;
  -------------------------------------------------------------------
  function IMP (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := imp_table (lv(i), r);
    end loop;
    return result;
  end function IMP;
  -------------------------------------------------------------------
  function IMP (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := imp_table (l, rv(i));
    end loop;
    return result;
  end function IMP;

  -------------------------------------------------------------------
  -- [XP9] ANY
  -------------------------------------------------------------------
  function ANY (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (any_table(l, r));
  end function ANY;
  -------------------------------------------------------------------
  function ANY (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.ANY: "
        & "arguments of ANY function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := any_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function ANY;
  -------------------------------------------------------------------
  function ANY (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := any_table (lv(i), r);
    end loop;
    return result;
  end function ANY;
  -------------------------------------------------------------------
  function ANY (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := any_table (l, rv(i));
    end loop;
    return result;
  end function ANY;

  -------------------------------------------------------------------
  -- [15H] NANY (NAN)
  -------------------------------------------------------------------
  function NAN (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (nan_table(l, r));
  end function NAN;
  -------------------------------------------------------------------
  function NAN (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.NAN: "
        & "arguments of NAN function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := nan_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function NAN;
  -------------------------------------------------------------------
  function NAN (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nan_table (lv(i), r);
    end loop;
    return result;
  end function NAN;
  -------------------------------------------------------------------
  function NAN (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nan_table (l, rv(i));
    end loop;
    return result;
  end function NAN;

  -------------------------------------------------------------------
  -- [H51] COMPARE, MORE,LESS,EQUAL (MLE)
  -------------------------------------------------------------------
  function MLE (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (mle_table(l, r));
  end function MLE;
  -------------------------------------------------------------------
  function MLE (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.MLE: "
        & "arguments of MLE function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := mle_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function MLE;
  -------------------------------------------------------------------
  function MLE (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := mle_table (lv(i), r);
    end loop;
    return result;
  end function MLE;
  -------------------------------------------------------------------
  function MLE (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := mle_table (l, rv(i));
    end loop;
    return result;
  end function MLE;

  -------------------------------------------------------------------
  -- [RD4] ENABLE (ENA)
  -------------------------------------------------------------------
  function ENA (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (ena_table(l, r));
  end function ENA;
  -------------------------------------------------------------------
  function ENA (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.ENA: "
        & "arguments of ENA function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := ena_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function ENA;
  -------------------------------------------------------------------
  function ENA (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := ena_table (lv(i), r);
    end loop;
    return result;
  end function ENA;
  -------------------------------------------------------------------
  function ENA (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := ena_table (l, rv(i));
    end loop;
    return result;
  end function ENA;

  -------------------------------------------------------------------
  -- [VP0] DESELECT (DES)
  -------------------------------------------------------------------

  function DES (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P is
  begin
    return (des_table(l, r));
  end function DES;
  -------------------------------------------------------------------
  function DES (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "BTERN_LOGIC.DES: "
        & "arguments of DES function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := des_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function DES;
  -------------------------------------------------------------------
  function DES (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := des_table (lv(i), r);
    end loop;
    return result;
  end function DES;
  -------------------------------------------------------------------
  function DES (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias rv        : BTERN_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : BTERN_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := des_table (l, rv(i));
    end loop;
    return result;
  end function DES;

  -------------------------------------------------------------------
  -- shift operators
  -------------------------------------------------------------------
  -- sll
  -------------------------------------------------------------------
  function "sll" (l : BTERN_ULOGIC_VECTOR; r : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => '0');
  begin
    if r >= 0 then
      result(1 to l'length - r) := lv(r + 1 to l'length);
    else
      result := l srl -r;
    end if;
    return result;
  end function "sll";

  -------------------------------------------------------------------
  -- srl
  -------------------------------------------------------------------
  function "srl" (l : BTERN_ULOGIC_VECTOR; r : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => '0');
  begin
    if r >= 0 then
      result(r + 1 to l'length) := lv(1 to l'length - r);
    else
      result := l sll -r;
    end if;
    return result;
  end function "srl";

  -------------------------------------------------------------------
  -- rol
  -------------------------------------------------------------------
  function "rol" (l : BTERN_ULOGIC_VECTOR; r : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length);
    constant rm     : INTEGER := r mod l'length;
  begin
    if r >= 0 then
      result(1 to l'length - rm)            := lv(rm + 1 to l'length);
      result(l'length - rm + 1 to l'length) := lv(1 to rm);
    else
      result := l ror -r;
    end if;
    return result;
  end function "rol";

  -------------------------------------------------------------------
  -- ror
  -------------------------------------------------------------------
  function "ror" (l : BTERN_ULOGIC_VECTOR; r : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    alias lv        : BTERN_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : BTERN_ULOGIC_VECTOR (1 to l'length) := (others => '0');
    constant rm     : INTEGER := r mod l'length;
  begin
    if r >= 0 then
      result(rm + 1 to l'length) := lv(1 to l'length - rm);
      result(1 to rm)            := lv(l'length - rm + 1 to l'length);
    else
      result := l rol -r;
    end if;
    return result;
  end function "ror";

  -------------------------------------------------------------------
  -- conversion tables
  -------------------------------------------------------------------
  type logic_x2p_table is array (BTERN_ULOGIC'low to BTERN_ULOGIC'high) of X2P;
  type logic_x2z_table is array (BTERN_ULOGIC'low to BTERN_ULOGIC'high) of X2Z;
  type logic_u2p_table is array (BTERN_ULOGIC'low to BTERN_ULOGIC'high) of U2P;
  ----------------------------------------------------------
  -- table name : cvt_to_x2p
  --
  -- parameters :
  --        in  :  btern_ulogic  -- ternary logic value
  -- returns    :  X2P         -- state value of logic value in the range [X,-,0,+]
  -- purpose    :  to convert state-strength to state only
  --
  -- example    : if (cvt_to_x2p (input_signal) = '+' ) then ...
  --
  ----------------------------------------------------------
  constant cvt_to_x2p : logic_x2p_table := (
    'X',                                -- 'U'
    'X',                                -- 'X'
    '-',                                -- '-'
    '0',                                -- '0'
    '+',                                -- '+'
    'X',                                -- 'Z'
    'X',                                -- 'W'
    '-',                                -- 'B'
    '0',                                -- 'L'
    '+',                                -- 'H'
    'X'                                 -- 'D'
    );

  ----------------------------------------------------------
  -- table name : cvt_to_x2z
  --
  -- parameters :
  --        in  :  btern_ulogic  -- ternary logic value
  -- returns    :  X2Z -- state value of logic value in the range [X,-,0,+,Z]
  -- purpose    :  to convert state-strength to state only
  --
  -- example    : if (cvt_to_x2z (input_signal) = '+' ) then ...
  --
  ----------------------------------------------------------
  constant cvt_to_x2z : logic_x2z_table := (
    'X',                                -- 'U'
    'X',                                -- 'X'
    '-',                                -- '-'
    '0',                                -- '0'
    '+',                                -- '+'
    'Z',                                -- 'Z'
    'X',                                -- 'W'
    '-',                                -- 'B'
    '0',                                -- 'L'
    '+',                                -- 'H'
    'X'                                 -- 'D'
    );

  ----------------------------------------------------------
  -- table name : cvt_to_u2p
  --
  -- parameters :
  --        in  :  btern_ulogic  -- ternary logic value
  -- returns    :  u2p -- state value of logic value in range [U,X,-,0,+]
  -- purpose    :  to convert state-strength to state only
  --
  -- example    : if (cvt_to_u2p (input_signal) = '+' ) then ...
  --
  ----------------------------------------------------------
  constant cvt_to_u2p : logic_u2p_table := (
    'U',                                -- 'U'
    'X',                                -- 'X'
    '-',                                -- '-'
    '0',                                -- '0'
    '+',                                -- '+'
    'X',                                -- 'Z'
    'X',                                -- 'W'
    '-',                                -- 'B'
    '0',                                -- 'L'
    '+',                                -- 'H'
    'X'                                 -- 'D'
    );

  -------------------------------------------------------------------
  -- Strength strippers and type conversion functions
  -------------------------------------------------------------------

  function RESIZE (ARG : BTERN_ULOGIC_VECTOR; NEW_SIZE : NATURAL)
    return BTERN_ULOGIC_VECTOR
  is
    constant ARG_LEFT : INTEGER := ARG'length-1;
    alias XARG        : BTERN_ULOGIC_VECTOR(ARG_LEFT downto 0) is ARG;
    variable RESULT   : BTERN_ULOGIC_VECTOR(NEW_SIZE-1 downto 0) :=
      (others => '0');
  begin
    if (NEW_SIZE < 1) then return NAC;
    end if;
    if XARG'length = 0 then return RESULT;
    end if;
    if (RESULT'length < ARG'length) then
      RESULT(RESULT'left downto 0) := XARG(RESULT'left downto 0);
    else
      RESULT(RESULT'left downto XARG'left+1) := (others => '0');
      RESULT(XARG'left downto 0)             := XARG;
    end if;
    return RESULT;
  end function RESIZE;

  ------------------------------------------------------------------------

  -- Converts an integer to a balanced ternary vector of the given size.
  -- Does not guard against overflow.
  function To_BALTERN (ARG : INTEGER; SIZE : NATURAL) return BTERN_ULOGIC_VECTOR is
    variable RESULT    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable I_VAL     : INTEGER := ARG;
    variable REMAINDER : INTEGER;
    begin
    if (SIZE < 1) then return NAC;
    end if;
    for I in 0 to RESULT'length - 1 loop
      REMAINDER := I_VAL mod 3;
      if REMAINDER = 0 then                
        RESULT(I) := '0';
      elsif REMAINDER = 1 then
        RESULT(I) := '+';
        I_VAL := I_VAL - 1;
      elsif REMAINDER = 2 then
        RESULT(I) := '-';
        I_VAL := I_VAL + 1;
      end if;
      I_VAL := I_VAL / 3;
    end loop;
    if not(I_VAL = 0) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.To_BALTERN: vector truncated"
        severity warning;
    end if;
    return RESULT;
  end function To_BALTERN;

  ------------------------------------------------------------------------

  -- Converts a BTERN_ULOGIC_VECTOR to an integer.
  -- Used in the overloads of relational operators.
  -- The predefined 32-bit INTEGER type in VHDL is guaranteed by the VHDL LRM to 
  -- include the range –2'147'483'647 to +2'147'483'647
  -- The closest all-plus trit-count is 20 with values +/- 1'743'392'200
  -- However, as it is the norm to not protect against overflows, the decision was made to stick to that.
  function To_INT (ARG : BTERN_ULOGIC_VECTOR) return INTEGER is
    variable RESULT : INTEGER := 0;
    variable BASE   : INTEGER;
    alias XARG      : BTERN_ULOGIC_VECTOR(ARG'length - 1 downto 0) is ARG;
    variable ARGM2P : BTERN_ULOGIC_VECTOR(ARG'length - 1 downto 0);
  begin
    if (ARG'length < 1) then
      assert false
        report "TVL.BAL_LOGIC.To_INT: "
        & "null argument detected, returning 0"
        severity warning;
        return 0;
    end if;
    ARGM2P := To_M2P(XARG, 'X');
    if ARGM2P(ARGM2P'left) = 'X' then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">"": metavalue detected, returning 0"
        severity warning;
      return 0;
    end if;
    for I in ARGM2P'range loop
      if    ARGM2P(I) = '-' then BASE := -1;
      elsif ARGM2P(I) = '0' then BASE :=  0;
      elsif ARGM2P(I) = '+' then BASE :=  1;
      end if;
      RESULT := RESULT + (BASE * 3**I);
    end loop;
    return RESULT;
  end function To_INT;

  
  ------------------------------------------------------------------------
  -- conversions between logic/ulogic vectors
  ------------------------------------------------------------------------

  function To_TernLogicVector (s : BTERN_ULOGIC_VECTOR)
    return BTERN_LOGIC_VECTOR
  is
    alias sv        : BTERN_ULOGIC_VECTOR (s'length-1 downto 0) is s;
    variable result : BTERN_LOGIC_VECTOR (s'length-1 downto 0);
  begin
    for i in result'range loop
      result(i) := sv(i);
    end loop;
    return result;
  end function To_TernLogicVector;

  ------------------------------------------------------------------------

  function To_TernULogicVector (s : BTERN_LOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    alias sv        : BTERN_LOGIC_VECTOR (s'length-1 downto 0) is s;
    variable result : BTERN_ULOGIC_VECTOR (s'length-1 downto 0);
  begin
    for i in result'range loop
      result(i) := sv(i);
    end loop;
    return result;
  end function To_TernULogicVector;

  ------------------------------------------------------------------------
  -- removing metalogical values and strength
  ------------------------------------------------------------------------

  function To_M2P (s : BTERN_ULOGIC_VECTOR; xmap : BTERN_ULOGIC := '0')
    return BTERN_ULOGIC_VECTOR
  is
    variable RESULT      : BTERN_ULOGIC_VECTOR(s'length-1 downto 0);
    variable BAD_ELEMENT : BOOLEAN := false;
    alias XS             : BTERN_ULOGIC_VECTOR(s'length-1 downto 0) is s;
  begin
    for I in RESULT'range loop
      case XS(I) is
        when '-' | 'B' => RESULT(I)   := '-';
        when '0' | 'L' => RESULT(I)   := '0';
        when '+' | 'H' => RESULT(I)   := '+';
        when others    => BAD_ELEMENT := true;
      end case;
    end loop;
    if BAD_ELEMENT then
      for I in RESULT'range loop
        RESULT(I) := xmap;              -- standard fixup
      end loop;
    end if;
    return RESULT;
  end function To_M2P;
  -------------------------------------------------------------------
  function To_M2P (s : BTERN_ULOGIC; xmap : BTERN_ULOGIC := '0') return BTERN_ULOGIC is
  begin
    case s is
      when '-' | 'B' => RETURN '-';
      when '0' | 'L' => RETURN '0';
      when '+' | 'H' => RETURN '+';
      when others    => return xmap;
    end case;
  end function To_M2P;

  -------------------------------------------------------------------

  function To_X2P (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias sv        : BTERN_ULOGIC_VECTOR (1 to s'length) is s;
    variable result : BTERN_ULOGIC_VECTOR (1 to s'length);
  begin
    for i in result'range loop
      result(i) := cvt_to_x2p (sv(i));
    end loop;
    return result;
  end function To_X2P;

  --------------------------------------------------------------------

  function To_X2P (s : BTERN_ULOGIC) return X2P is
  begin
    return (cvt_to_x2p(s));
  end function To_X2P;

  --------------------------------------------------------------------
  
  function To_X2Z (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias sv        : BTERN_ULOGIC_VECTOR (1 to s'length) is s;
    variable result : BTERN_ULOGIC_VECTOR (1 to s'length);
  begin
    for i in result'range loop
      result(i) := cvt_to_x2z (sv(i));
    end loop;
    return result;
  end function To_X2Z;

  --------------------------------------------------------------------

  function To_X2Z (s : BTERN_ULOGIC) return X2Z is
  begin
    return (cvt_to_x2z(s));
  end function To_X2Z;

  --------------------------------------------------------------------
  
  function To_U2P (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias sv        : BTERN_ULOGIC_VECTOR (1 to s'length) is s;
    variable result : BTERN_ULOGIC_VECTOR (1 to s'length);
  begin
    for i in result'range loop
      result(i) := cvt_to_u2p (sv(i));
    end loop;
    return result;
  end function To_U2P;

  --------------------------------------------------------------------

  function To_U2P (s : BTERN_ULOGIC) return U2P is
  begin
    return (cvt_to_u2p(s));
  end function To_U2P;
  
  --------------------------------------------------------------------
  -- Overload of the condition operator
  -------------------------------------------------------------------

  function "??" (l : BTERN_ULOGIC) return KLEENE is
  begin
    case l is
      when '-' | 'B' => RETURN FALSE;
      when '+' | 'H' => RETURN TRUE;
      when others    => RETURN UNK;
    end case;
  end function "??";

  -------------------------------------------------------------------
  -- edge detection
  -------------------------------------------------------------------
  -- rising edge
  -------------------------------------------------------------------

  function any_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return ((s'event and (To_X2P(s) = '+') and
            (To_X2P(s'last_value) = '0')) or
            (s'event and (To_X2P(s) = '0') and
            (To_X2P(s'last_value) = '-')) or
            (s'event and (To_X2P(s) = '+') and
            (To_X2P(s'last_value) = '-'))
            );
  end function any_rising_edge;

  ------------------------------------------------------------------- 

  function mz_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return (s'event and (To_X2P(s) = '0') and
            (To_X2P(s'last_value) = '-'));
  end function mz_rising_edge;
  
 -------------------------------------------------------------------

  function zp_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return (s'event and (To_X2P(s) = '+') and
            (To_X2P(s'last_value) = '0'));
  end function zp_rising_edge;

 -------------------------------------------------------------------

  function mp_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return (s'event and (To_X2P(s) = '+') and
            (To_X2P(s'last_value) = '-'));
  end function mp_rising_edge;

  -------------------------------------------------------------------
  -- falling edge
  ------------------------------------------------------------------- 

  function any_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return ((s'event and (To_X2P(s) = '0') and
            (To_X2P(s'last_value) = '+')) or
            (s'event and (To_X2P(s) = '-') and
            (To_X2P(s'last_value) = '0')) or
            (s'event and (To_X2P(s) = '-') and
            (To_X2P(s'last_value) = '+'))
            );
  end function any_falling_edge;

  ------------------------------------------------------------------- 

  function pz_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return (s'event and (To_X2P(s) = '0') and
            (To_X2P(s'last_value) = '+'));
  end function pz_falling_edge;

 -------------------------------------------------------------------

  function zm_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return (s'event and (To_X2P(s) = '-') and
            (To_X2P(s'last_value) = '0'));
  end function zm_falling_edge;

 -------------------------------------------------------------------

  function pm_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN is
  begin
    return (s'event and (To_X2P(s) = '-') and
            (To_X2P(s'last_value) = '+'));
  end function pm_falling_edge;

  -------------------------------------------------------------------
  -- object contains an unknown
  -------------------------------------------------------------------

  function Is_X (s : BTERN_ULOGIC_VECTOR) return BOOLEAN is
  begin
    for i in s'range loop
      case s(i) is
        when 'U' | 'X' | 'Z' | 'W' | 'D' => return true;
        when others                      => null;
      end case;
    end loop;
    return false;
  end function Is_X;

  --------------------------------------------------------------------

  function Is_X (s : BTERN_ULOGIC) return BOOLEAN is
  begin
    case s is
      when 'U' | 'X' | 'Z' | 'W' | 'D' => return true;
      when others                      => null;
    end case;
    return false;
  end function Is_X;

  --------------------------------------------------------------------
  --Local subprograms supporting relational operators
  --------------------------------------------------------------------

  function EQUAL (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return TRIT_VECTOR(L) = TRIT_VECTOR(R);
  end function EQUAL;

  --------------------------------------------------------------------

  function LESS (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return TRIT_VECTOR(L) < TRIT_VECTOR(R);
  end function LESS;

  --------------------------------------------------------------------

  function LESS_OR_EQUAL (L, R : BTERN_ULOGIC_VECTOR)
    return BOOLEAN is
  begin
    return TRIT_VECTOR(L) <= TRIT_VECTOR(R);
  end function LESS_OR_EQUAL;

  --=================================================================
  -- ordinary relational operator overloads
  --=================================================================

  -------------------------------------------------------------------
  -- >
  -------------------------------------------------------------------

  function ">" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
    constant SIZE   : NATURAL := MAXIMUM(L'length, R'length);
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">"": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    RM2P := To_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">"": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not LESS_OR_EQUAL(RESIZE(LM2P, SIZE), RESIZE(RM2P, SIZE));
  end function ">";

  -------------------------------------------------------------------

  function ">" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN is 
    constant R_LEFT : INTEGER := R'length-1;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
  begin
    if (R'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">"": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    RM2P := To_M2P(XR, 'X');
    if (RM2P(RM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">"": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not LESS_OR_EQUAL(To_BALTERN(L, RM2P'length), RM2P);
  end function ">";

  -------------------------------------------------------------------

  function ">" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN is 
    constant L_LEFT : INTEGER := L'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
  begin
    if (L'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">"": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(L, 'X');
    if (LM2P(LM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">"": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not LESS_OR_EQUAL(LM2P, To_BALTERN(R, LM2P'length));
  end function ">";

  -------------------------------------------------------------------
  -- <
  -------------------------------------------------------------------
  
  function "<" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
    constant SIZE   : NATURAL := MAXIMUM(L'length, R'length);
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<"": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    RM2P := To_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<"": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return LESS(RESIZE(LM2P, SIZE), RESIZE(RM2P, SIZE));
  end function "<";

  -------------------------------------------------------------------

  function "<" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN is 
    constant R_LEFT : INTEGER := R'length-1;
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if (R'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<"": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    RM2P := To_M2P(XR, 'X');
    if (RM2P(RM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<"": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return LESS(To_BALTERN(L, RM2P'length), RM2P);
  end function "<";

  -------------------------------------------------------------------

  function "<" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN is 
    constant L_LEFT : INTEGER := L'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
  begin
    if (L'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<"": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    if (LM2P(LM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<"": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return LESS(LM2P, To_BALTERN(R, LM2P'length));
  end function "<";

  -------------------------------------------------------------------
  -- <=
  -------------------------------------------------------------------
  
  function "<=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
    constant SIZE   : NATURAL := MAXIMUM(L'length, R'length);
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    RM2P := To_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return TO_INT(L) <= TO_INT(R);
    return LESS_OR_EQUAL(RESIZE(LM2P, SIZE), RESIZE(RM2P, SIZE));
  end function "<=";

  -------------------------------------------------------------------

  function "<=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN is 
    constant R_LEFT : INTEGER := R'length-1;
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if (R'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    RM2P := To_M2P(XR, 'X');
    if (RM2P(RM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return LESS_OR_EQUAL(To_BALTERN(L, RM2P'length), RM2P);
  end function "<=";

  -------------------------------------------------------------------

  function "<=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN is 
    constant L_LEFT : INTEGER := L'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
  begin
    if (L'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    if (LM2P(LM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""<="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return LESS_OR_EQUAL(LM2P, To_BALTERN(R, LM2P'length));
  end function "<=";

  -------------------------------------------------------------------
  -- >=
  -------------------------------------------------------------------

  function ">=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
    constant SIZE   : NATURAL := MAXIMUM(L'length, R'length);
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    RM2P := To_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not LESS(RESIZE(LM2P, SIZE), RESIZE(RM2P, SIZE));
  end function ">=";

  -------------------------------------------------------------------

  function ">=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN is 
    constant R_LEFT : INTEGER := R'length-1;
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if (R'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    RM2P := To_M2P(XR, 'X');
    if (RM2P(RM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not LESS(To_BALTERN(L, RM2P'length), RM2P);
  end function ">=";

  -------------------------------------------------------------------

  function ">=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN is 
    constant L_LEFT : INTEGER := L'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
  begin
    if (L'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    if (LM2P(LM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC."">="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not LESS(LM2P, To_BALTERN(R, LM2P'length));
  end function ">=";
  
  -------------------------------------------------------------------
  -- =
  -------------------------------------------------------------------

  function "=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
    constant SIZE   : NATURAL := MAXIMUM(L'length, R'length);
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    RM2P := To_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return EQUAL(RESIZE(LM2P, SIZE), RESIZE(RM2P, SIZE));
  end function "=";
  
  -------------------------------------------------------------------

  function "=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN is 
    constant R_LEFT : INTEGER := R'length-1;
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if (R'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    RM2P := To_M2P(XR, 'X');
    if (RM2P(RM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return EQUAL(To_BALTERN(L, RM2P'length), RM2P);
  end function "=";

  -------------------------------------------------------------------

  function "=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN is 
    constant L_LEFT : INTEGER := L'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
  begin
    if (L'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    if (LM2P(LM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return EQUAL(LM2P, To_BALTERN(R, LM2P'length));
  end function "=";
  
  -------------------------------------------------------------------
  -- /=
  -------------------------------------------------------------------

  function "/=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
    constant SIZE   : NATURAL := MAXIMUM(L'length, R'length);
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    variable LM2P    : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P    : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""/="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    RM2P := To_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""/="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not EQUAL(RESIZE(LM2P, SIZE), RESIZE(RM2P, SIZE));
  end function "/=";
  
  -------------------------------------------------------------------

  function "/=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN is 
    constant R_LEFT : INTEGER := R'length-1;
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    if (R'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""/="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    RM2P := To_M2P(XR, 'X');
    if (RM2P(RM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""/="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not EQUAL(To_BALTERN(L, RM2P'length), RM2P);
  end function "/=";

  -------------------------------------------------------------------

  function "/=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN is 
    constant L_LEFT : INTEGER := L'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
  begin
    if (L'length < 1) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""/="": null argument detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := To_M2P(XL, 'X');
    if (LM2P(LM2P'left) = 'X') then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.""/="": metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    return not EQUAL(LM2P, To_BALTERN(R, LM2P'length));
  end function "/=";

  -------------------------------------------------------------------
  -- The ternary "spaceship" operator (<=>)
  -------------------------------------------------------------------

  function SPACE (L, R : BTERN_ULOGIC) return KLEENE is
    variable RESULT : KLEENE;
    variable LM2P  : BTERN_ULOGIC;
    variable RM2P  : BTERN_ULOGIC;
  begin
    LM2P := To_M2P(L, 'X');
    RM2P := To_M2P(R, 'X');
    if ((LM2P = 'X') or (RM2P = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.SPACE: metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    if LM2P < RM2P then
      return FALSE;
    elsif LM2P = RM2P then
      return UNK;
    elsif LM2P > RM2P then
      return TRUE;
    end if;
  end function SPACE;

  -------------------------------------------------------------------

  function SPACE (L, R : BTERN_ULOGIC_VECTOR) return KLEENE is
    constant SIZE   : NATURAL := MAXIMUM(L'length, R'length);
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    variable RESULT : KLEENE;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
  begin
    LM2P := To_M2P(XL, 'X');
    RM2P := To_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      assert NO_WARNING
        report "TVL.BAL_LOGIC.SPACE: metavalue detected, returning FALSE"
        severity warning;
      return false;
    end if;
    LM2P := RESIZE(LM2P, SIZE);
    RM2P := RESIZE(RM2P, SIZE);
    if LM2P < RM2P then
      return FALSE;
    elsif LM2P = RM2P then
      return UNK;
    elsif LM2P > RM2P then
      return TRUE;
    end if;
  end function SPACE;

  -------------------------------------------------------------------

  function SPACE (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return KLEENE is
  begin
    return SPACE(To_BALTERN(L, R'length), R);
  end function SPACE;

  -------------------------------------------------------------------
  
  function SPACE (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return KLEENE is
  begin
    return SPACE(L, To_BALTERN(R, L'length));
  end function SPACE;

      
  --=================================================================
  -- Matching relational operator overloads

  -- Just like in the IEEE library, these do not 
  -- guard against overflow.
  -- Exceptions when "Don't care" values are present has been
  -- inherited from the IEEE library.
  --=================================================================
  
  -------------------------------------------------------------------
  -- ?>
  -------------------------------------------------------------------

  function "?>" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    begin
      if ((L'length < 1) or (R'length < 1)) then
        assert NO_WARNING
          report "TVL.BAL_LOGIC.""?>"": null argument detected, returning X"
          severity warning;
        return 'X';
      end if;
      for i in L'range loop
        if L(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      for i in R'range loop
        if R(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      if IS_X(L) or IS_X(R) then
        return 'X';
      elsif L > R then
        return '+';
      else
        return '0';
      end if;
  end function "?>";

  -------------------------------------------------------------------

  function "?>" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
  begin
    return To_BALTERN(L, R'length) ?> R;
  end function "?>";

  -------------------------------------------------------------------
  
  function "?>" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC is
  begin
    return L ?> To_BALTERN(R, L'length);
  end function "?>";

  -------------------------------------------------------------------
  -- ?<
  -------------------------------------------------------------------

  function "?<" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    begin
      if ((L'length < 1) or (R'length < 1)) then
        assert NO_WARNING
          report "TVL.BAL_LOGIC.""?>"": null argument detected, returning X"
          severity warning;
        return 'X';
      end if;
      for i in L'range loop
        if L(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      for i in R'range loop
        if R(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      if IS_X(L) or IS_X(R) then
        return 'X';
      elsif L < R then
        return '+';
      else
        return '0';
      end if;
  end function "?<";

  -------------------------------------------------------------------

  function "?<" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
  begin
    return To_BALTERN(L, R'length) ?< R;
  end function "?<";

  -------------------------------------------------------------------
  
  function "?<" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC is
  begin
    return L ?< To_BALTERN(R, L'length);
  end function "?<";

  -------------------------------------------------------------------
  -- ?<=
  -------------------------------------------------------------------

  function "?<=" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    begin
      if ((L'length < 1) or (R'length < 1)) then
        assert NO_WARNING
          report "TVL.BAL_LOGIC.""?>"": null argument detected, returning X"
          severity warning;
        return 'X';
      end if;
      for i in L'range loop
        if L(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      for i in R'range loop
        if R(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      if IS_X(L) or IS_X(R) then
        return 'X';
      elsif L <= R then
        return '+';
      else
        return '0';
      end if;
  end function "?<=";

  -------------------------------------------------------------------

  function "?<=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
  begin
    return To_BALTERN(L, R'length) ?<= R;
  end function "?<=";

  -------------------------------------------------------------------
  
  function "?<=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC is
  begin
    return L ?<= To_BALTERN(R, L'length);
  end function "?<=";

  -------------------------------------------------------------------
  -- ?>=
  -------------------------------------------------------------------

  function "?>=" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    begin
      if ((L'length < 1) or (R'length < 1)) then
        assert NO_WARNING
          report "TVL.BAL_LOGIC.""?>"": null argument detected, returning X"
          severity warning;
        return 'X';
      end if;
      for i in L'range loop
        if L(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      for i in R'range loop
        if R(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      if IS_X(L) or IS_X(R) then
        return 'X';
      elsif L >= R then
        return '+';
      else
        return '0';
      end if;
  end function "?>=";

  -------------------------------------------------------------------

  function "?>=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
  begin
    return To_BALTERN(L, R'length) ?>= R;
  end function "?>=";

  -------------------------------------------------------------------
  
  function "?>=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC is
  begin
    return L ?>= To_BALTERN(R, L'length);
  end function "?>=";

  -------------------------------------------------------------------
  -- ?=
  -------------------------------------------------------------------

  function "?=" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    begin
      if ((L'length < 1) or (R'length < 1)) then
        assert NO_WARNING
          report "TVL.BAL_LOGIC.""?>"": null argument detected, returning X"
          severity warning;
        return 'X';
      end if;
      for i in L'range loop
        if L(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      for i in R'range loop
        if R(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      if IS_X(L) or IS_X(R) then
        return 'X';
      elsif L = R then
        return '+';
      else
        return '0';
      end if;
  end function "?=";

  -------------------------------------------------------------------

  function "?=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
  begin
    return To_BALTERN(L, R'length) ?= R;
  end function "?=";

  -------------------------------------------------------------------
  
  function "?=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC is
  begin
    return L ?= To_BALTERN(R, L'length);
  end function "?=";

  -------------------------------------------------------------------
  -- ?/=
  -------------------------------------------------------------------

  function "?/=" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    begin
      if ((L'length < 1) or (R'length < 1)) then
        assert NO_WARNING
          report "TVL.BAL_LOGIC.""?>"": null argument detected, returning X"
          severity warning;
        return 'X';
      end if;
      for i in L'range loop
        if L(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      for i in R'range loop
        if R(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      if IS_X(L) or IS_X(R) then
        return 'X';
      elsif L /= R then
        return '+';
      else
        return '0';
      end if;
  end function "?/=";

  -------------------------------------------------------------------

  function "?/=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
  begin
    return To_BALTERN(L, R'length) ?/= R;
  end function "?/=";

  -------------------------------------------------------------------
  
  function "?/=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC is
  begin
    return L ?/= To_BALTERN(R, L'length);
  end function "?/=";

  -------------------------------------------------------------------
  -- M_SPACE
  -------------------------------------------------------------------

  function M_SPACE (L, R : BTERN_ULOGIC) return BTERN_ULOGIC is
    variable RESULT : KLEENE;
  begin
    if L = 'D' then
      report "TVL.BAL_LOGIC.M_SPACE: 'D' found in compare string"
        severity error;
      return 'X';
    end if;
    if R = 'D' then
      report "TVL.BAL_LOGIC.M_SPACE: 'D' found in compare string"
        severity error;
      return 'X';
    end if;
    if IS_X(L) or IS_X(R) then
      return 'X';
    elsif L < R then
      return '-';
    elsif L = R then
      return '0';
    else
      return '+';
    end if;
  end function M_SPACE;

  -------------------------------------------------------------------

  function M_SPACE (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    begin
      if ((L'length < 1) or (R'length < 1)) then
        assert NO_WARNING
          report "TVL.BAL_LOGIC.""?>"": null argument detected, returning X"
          severity warning;
        return 'X';
      end if;
      for i in L'range loop
        if L(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      for i in R'range loop
        if R(i) = 'D' then
          report "TVL.BAL_LOGIC.""?>"": 'D' found in compare string"
            severity error;
          return 'X';
        end if;
      end loop;
      if IS_X(L) or IS_X(R) then
        return 'X';
      elsif L < R then
        return '-';
      elsif L = R then
        return '0';
      else
        return '+';
      end if;
  end function M_SPACE;

  -------------------------------------------------------------------

  function M_SPACE (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
  begin
    return M_SPACE(To_BALTERN(L, R'length), R);
  end function M_SPACE;

  -------------------------------------------------------------------
  
  function M_SPACE (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC is
  begin
    return M_SPACE(L, To_BALTERN(R, L'length));
  end function M_SPACE;

  -------------------------------------------------------------------
  -- MINIMUM overloads for array type
  -------------------------------------------------------------------

  function MINIMUM (L, R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR is
    constant SIZE : NATURAL := MAXIMUM(L'length, R'length);
    variable LM2P : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    alias XL      : BTERN_ULOGIC_VECTOR(L'length-1 downto 0) is L;
    alias XR      : BTERN_ULOGIC_VECTOR(R'length-1 downto 0) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := To_M2P(RESIZE(XL, SIZE), 'X');
    if (LM2P(LM2P'left) = 'X') then return LM2P;
    end if;
    RM2P := To_M2P(RESIZE(XR, SIZE), 'X');
    if (RM2P(RM2P'left) = 'X') then return RM2P;
    end if;
    if LESS(LM2P, RM2P) then
      return LM2P;
    else
      return RM2P;
    end if;
  end function MINIMUM;

  -------------------------------------------------------------------

  function MINIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MINIMUM(To_BALTERN(L, R'length), R);
  end function MINIMUM;

  -------------------------------------------------------------------

  function MINIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MINIMUM(L, To_BALTERN(R, L'length));
  end function MINIMUM;

  -------------------------------------------------------------------
  -- MAXIMUM overloads for array type
  -------------------------------------------------------------------

  function MAXIMUM (L, R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR is
    constant SIZE : NATURAL := MAXIMUM(L'length, R'length);
    variable LM2P : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    alias XL      : BTERN_ULOGIC_VECTOR(L'length-1 downto 0) is L;
    alias XR      : BTERN_ULOGIC_VECTOR(R'length-1 downto 0) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := To_M2P(RESIZE(XL, SIZE), 'X');
    if (LM2P(LM2P'left) = 'X') then return LM2P;
    end if;
    RM2P := To_M2P(RESIZE(XR, SIZE), 'X');
    if (RM2P(RM2P'left) = 'X') then return RM2P;
    end if;
    if LESS(LM2P, RM2P) then
      return RM2P;
    else
      return LM2P;
    end if;
  end function MAXIMUM;

  -------------------------------------------------------------------

  function MAXIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MAXIMUM(To_BALTERN(L, R'length), R);
  end function MAXIMUM;

  -------------------------------------------------------------------

  function MAXIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MAXIMUM(L, To_BALTERN(R, L'length));
  end function MAXIMUM;

  -------------------------------------------------------------------

-- KNOWN TO BE MISSING:
-- Explicit (matching) relational operator overloads for BTERN_ULOGIC
-- MINIMUM and MAXIMUM overloads for BTERN_ULOGIC
-- One could argue that the ordinary/matching spaceship operator is the solution for both of these



  -------------------------------------------------------------------
  -- string conversion and read/write operations
  -------------------------------------------------------------------

  -- function TO_STRING (value : BTERN_ULOGIC) return STRING is
  --   variable RESULT : STRING(1 to 1);
  --   begin
  --     RESULT(1) := BTERN_ULOGIC'image(value)(2);
  --     return RESULT;
  --   end function TO_STRING;


  -- function TO_STRING (value : BTERN_ULOGIC_VECTOR) return STRING is
  --   variable RESULT : STRING(value'range);
  --   begin
  --     for I in value'range loop
  --       RESULT(I) := BTERN_ULOGIC'image(value(I))(2);
  --     end loop;
  --     return RESULT;
  --   end function TO_STRING;

  -- function TO_HEPSTRING (value : BTERN_ULOGIC_VECTOR) return STRING is
  --   variable TEMP : BTERN_ULOGIC;
  --   variable RESULT : BTERN_ULOGIC_VECTOR(value'length - 1 downto 0);
  --   begin
  --     for I in value'range loop
  --       case s is
  --         when '0' | 'L' => return ('0');
  --         when '1' | 'H' => return ('1');
  --         when others    => return xmap;
  --       end case;
  --     end loop;
  --   end function TO_HEPSTRING;

  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC; GOOD : out BOOLEAN);
  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC);

  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR);

  -- procedure WRITE (L : inout LINE; VALUE : in BTERN_ULOGIC;
  --                 JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

  -- procedure WRITE (L : inout LINE; VALUE : in BTERN_ULOGIC_VECTOR;
  --                 JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

  -- procedure HEPREAD (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  -- procedure HEPREAD (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR);
  -- procedure HEPWRITE (L : inout LINE; VALUE : in BTERN_ULOGIC_VECTOR;
  --                  JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

end package body bal_logic;