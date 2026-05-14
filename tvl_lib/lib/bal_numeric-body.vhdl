-- -----------------------------------------------------------------
--
--   Title     :  Standard ternary logic package
--             :  (BTERN_NUMERIC package declaration)
--             :
--   Library   :  This package shall be compiled into a library
--             :  symbolically named TVL.
--             :
--   Developers:  Anders Mørk Minde, University of South Eastern Norway
--             :
--   Purpose   :  This package defines arithmetic functions
--             :  for use with synthesis tools. Values of type BTERN_ULOGIC_VECTOR
--             :  are interpreted as balanced ternary numbers in vector form.
--             :  The leftmost trit is treated as the most significant trit.
--             :
--             :  If any argument to a function is a null array, a null array
--             :  is returned (exceptions, if any, are noted individually).
--             :
--   Note      :  
--             :
-- --------------------------------------------------------------------
-- $Revision: 1 $
-- $Date: 2025-07-10 (Tue, 10 Oct 2025) $
-- --------------------------------------------------------------------

library TVL;
use TVL.kleene_pkg.all;

package body bal_numeric is

  -- null range array constant and implementation controls
  constant NAC : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');
  constant NO_WARNING : BOOLEAN := FALSE;  -- default to emit warnings

  --=================================================================
  -- Local subprograms
  --=================================================================

  -- Computes the addition of two BTERN_ULOGIC_VECTOR with input carry.
  -- Both arguments must be of the same length
  function ADD_BTERN_VEC (L, R : BTERN_ULOGIC_VECTOR; C : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    constant L_LEFT : INTEGER   := L'length-1;
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is R;
    variable RESULT : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable CTRIT  : BTERN_ULOGIC := C;
  begin
    for I in 0 to L_LEFT loop
      RESULT(I) := SUM(CTRIT, SUM(XL(I), XR(I)));
      CTRIT     := ANY(CON(CTRIT, SUM(XL(I), XR(I))), CON(XL(I), XR(I)));
    end loop;
    return RESULT;
  end function ADD_BTERN_VEC;

  -------------------------------------------------------------------

  -- Based on the first of the two balanced ternary division algorithms
  -- proposed by Jones.
  -- All arguments must be of the same length
  procedure DIVMOD (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                        XQUO, XREM : out BTERN_ULOGIC_VECTOR) is
    variable SINGLE    : INTEGER := DIVIDEND'length;
    variable DOUBLE    : INTEGER := DIVIDEND'length*2;
    variable HIGH      : BTERN_ULOGIC_VECTOR(SINGLE downto 0);
    variable LOW       : BTERN_ULOGIC_VECTOR(SINGLE downto 0);
    variable CLOSEST_Z : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    variable HIGHQUO   : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    variable LOWQUO    : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    -- REMQUO's length should not be more than 2x argument's length.
    -- All others need to account for overflow in calculation of
    -- partial remainder.
    variable REMQUO    : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0)
                          := (others => '0');
  begin
    assert DIVISOR /= 0 report "TVL.BAL_NUMERIC.DIVMOD: DIV, MOD, or REM by zero"
      severity error;

    REMQUO(SINGLE-1 downto 0) := DIVIDEND;

    for I in SINGLE-1 downto 0 loop
      
      REMQUO := REMQUO sll 1;

      -- if partial remainder >= 1 and divisor is a maxed out vector 
      -- of length SINGLE, then these may overflow.
      HIGH := REMQUO(DOUBLE-1 downto SINGLE) + ("0" & DIVISOR);
      LOW  := REMQUO(DOUBLE-1 downto SINGLE) - ("0" & DIVISOR);

      HIGHQUO   := HIGH & REMQUO(SINGLE-1 downto 0);
      LOWQUO    := LOW  & REMQUO(SINGLE-1 downto 0);
      CLOSEST_Z := MINIMUM(abs(LOWQUO), MINIMUM(abs(REMQUO), abs(HIGHQUO)));

      if CLOSEST_Z = abs(REMQUO) then
        null;
      elsif CLOSEST_Z = abs(HIGHQUO) then
        REMQUO := HIGHQUO(DOUBLE-1 downto 0);
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) - 1;
      elsif CLOSEST_Z = abs(LOWQUO) then 
        REMQUO := LOWQUO(DOUBLE-1 downto 0);
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) + 1;
      end if;
    end loop;

    if REMQUO(DOUBLE-1 downto SINGLE) < 0 then
      REMQUO(DOUBLE-1 downto SINGLE) := REMQUO(DOUBLE-1 downto SINGLE) + DIVISOR;
      REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) - 1;
    end if;

    XREM := REMQUO(DOUBLE-1 downto SINGLE);
    XQUO := REMQUO(SINGLE-1 downto 0);
  end procedure DIVMOD;

  -------------------------------------------------------------------

  -- VHDL-version of the 1st of the two pseudocoded balanced ternary 
  -- division algorithms proposed by Jones.
  -- All arguments must be of the same length
  procedure JONES1 (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                        XQUO, XREM : out BTERN_ULOGIC_VECTOR) is
    variable SINGLE    : INTEGER := DIVIDEND'length;
    variable DOUBLE    : INTEGER := DIVIDEND'length*2;
    variable HIGH      : BTERN_ULOGIC_VECTOR(SINGLE downto 0);
    variable LOW       : BTERN_ULOGIC_VECTOR(SINGLE downto 0);
    variable CLOSEST_Z : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    variable HIGHQUO   : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    variable LOWQUO    : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    -- REMQUO's length should not be more than 2x argument's length.
    -- All others need to account for overflow in calculation of
    -- partial remainder.
    variable REMQUO    : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0)
                          := (others => '0');
  begin
    assert DIVISOR /= 0 report "TVL.BAL_NUMERIC.DIVMOD: DIV, MOD, or REM by zero"
      severity error;

    -- quo = dividend;
    -- rem = 0;
    -- HERE: rem is set to 0 in declarative part, quo is set below. 

    REMQUO(SINGLE-1 downto 0) := DIVIDEND;

    -- for (i = 0; i < trits_per_word; i++) {
    -- HERE: SINGLE represents trits_per_word

    for I in 0 to SINGLE-1 loop

    -- /* first shift rem-quo double register 1 trit left */
    -- (rem,quo) = (rem,quo) <<3 1;

      REMQUO := REMQUO sll 1;

      -- /* second, compute candidates for next remainder */
	    -- balanced int high = rem + divisor;
	    -- balanced int mid = rem;
	    -- balanced int low = rem - divisor;
      -- HERE: these contenders these may overflow, so appending 0,
      -- meaning their sizes are double-register + 1.
      HIGH := REMQUO(DOUBLE-1 downto SINGLE) + ("0" & DIVISOR);
      LOW  := REMQUO(DOUBLE-1 downto SINGLE) - ("0" & DIVISOR);
      -- HERE: Then, concatenating with quo-part of REMQUO to help in
      -- the comparison.
      HIGHQUO   := HIGH & REMQUO(SINGLE-1 downto 0);
      LOWQUO    := LOW  & REMQUO(SINGLE-1 downto 0);

      -- /* pick a candidate, using long comparison */
      -- (rem,) = closest_to_zero( (high,quo), (mid,quo), (low,quo) );
      -- HERE: CLOSEST_Z is set to the absolute value of the smallest 
      -- magnitude contender. 
      CLOSEST_Z := MINIMUM(abs(LOWQUO), MINIMUM(abs(REMQUO), abs(HIGHQUO)));

      -- /* set the quotiet digit */
      -- if (rem == high) 
      --   quo = quo - 1;
      -- else if (rem == low) 
      --   quo = quo + 1;
      -- HERE: Using CLOSEST_Z variable instead of setting rem-part of 
      -- REMQUO first to avoid two if-tests. Matches the CLOSEST_Z 
      -- variable with the absolute value of the contenders, and then 
      -- sets rem -and quotient parts of REMQUO. 

      if CLOSEST_Z = abs(HIGHQUO) then
        REMQUO := HIGHQUO(DOUBLE-1 downto 0);
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) - 1;
      elsif CLOSEST_Z = abs(LOWQUO) then 
        REMQUO := LOWQUO(DOUBLE-1 downto 0);
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) + 1;
      end if;
    end loop;

    -- HERE: The respective parts of REMQUO are written 
    -- to the input variables.
    XREM := REMQUO(DOUBLE-1 downto SINGLE);
    XQUO := REMQUO(SINGLE-1 downto 0);
  end procedure JONES1;

  -------------------------------------------------------------------

  -- VHDL-version of the 2nd "optimized" version of the two pseudocoded 
  -- balanced ternary division algorithms proposed by Jones.
  -- All arguments must be of the same length
  procedure JONES2 (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                    XQUO, XREM : out BTERN_ULOGIC_VECTOR) is
    variable DOUBLE    : INTEGER := DIVIDEND'length*2;
    variable SINGLE    : INTEGER := DIVIDEND'length;
    variable ONE       : BTERN_ULOGIC := '+';
    variable XDIVISOR  : BTERN_ULOGIC_VECTOR (SINGLE-1 downto 0) := DIVISOR;
    variable REMAINDER : BTERN_ULOGIC_VECTOR(SINGLE-1 downto 0) := (others => '0');
    variable QUO       : BTERN_ULOGIC_VECTOR(SINGLE-1 downto 0);
    variable REMQUO    : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0) := (others => '0');
    variable LOW       : BTERN_ULOGIC_VECTOR (SINGLE-1 downto 0);
    variable HIGH      : BTERN_ULOGIC_VECTOR (SINGLE-1 downto 0);
  begin
    -- balanced int one = 1; /* determines whether to negate bits of quotient */
    -- HERE: Done in declarative part.

    -- if (divisor < 0) { /* take absolute value of divisor */
    --     divisor = -divisor;
    --     one = -one;
    -- HERE: Using a replacement variable XDIVISOR to avoid changing DIVISOR.
    -- Then using the STI logical function to invert.
    if DIVISOR < 0 then
      XDIVISOR := STI(XDIVISOR);
      ONE := STI(ONE);
    end if;

    -- quo = dividend;
    -- rem = 0;
    -- HERE: Lower part of REMQUO set = DIVIDEND, and upper part are already 
    -- 0's (set in declarative part).
    REMQUO(SINGLE-1 downto 0) := DIVIDEND;

    -- for (i = 0; i < trits_per_word; i++) {
    -- HERE: SINGLE represents trits_per_word
    for I in 0 to SINGLE-1 loop

      -- /* first shift rem-quo double register 1 trit left */
      -- (rem,quo) = (rem,quo) <<3 1;
      -- HERE: Additionally, pull the values from the double register
      -- for more readable code.
      REMQUO    := REMQUO sll 1;
      REMAINDER := REMQUO(DOUBLE-1 downto SINGLE);
      QUO       := REMQUO(SINGLE-1 downto 0);

      /* second, compute one trit of quotient */
      -- if (rem > 0) {
	    --   balanced int low = rem - divisor;
      --     if ( (-low < rem) || ((-low == rem) && (quo > 0)) ) {
      --       quo = quo + one;
      --       rem = low;
      --     }
      -- }
      if REMAINDER > 0 then
        LOW := REMAINDER - XDIVISOR;
        if (-LOW < REMAINDER) or ((-LOW = REMAINDER) and (QUO > 0)) then
          QUO := QUO + ONE;
          REMAINDER := LOW;
        end if;

      -- else if (rem < 0) {
      --    balanced int high = rem + divisor;
      --    if ( (-high > rem) || ((-high == rem) && (quo < 0)) ) {
      --      quo = quo - one;
      --      rem = high;
      --    }
      -- }
      elsif REMAINDER < 0 then
        HIGH := REMAINDER + XDIVISOR;
        if (-HIGH > REMAINDER) or ((-HIGH = REMAINDER) and (QUO < 0)) then
          QUO := QUO - ONE;
          REMAINDER := HIGH;
        end if;
      end if;

      -- HERE: Put the calculated helper-variables back into the 
      -- double-register for shifting in the next cycle.
      REMQUO(DOUBLE-1 downto SINGLE) := REMAINDER;
      REMQUO(SINGLE-1 downto 0)      := QUO;
    end loop;

    -- HERE: The respective parts of REMQUO are written 
    -- to the input variables.
    XREM := REMQUO(DOUBLE-1 downto SINGLE);
    XQUO := REMQUO(SINGLE-1 downto 0);
  end procedure JONES2;

  -------------------------------------------------------------------

  -- Euclidean division working for all 6-trit pos/neg numbers
  procedure BTE_DIVMOD (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                        XQUO, XREM : out BTERN_ULOGIC_VECTOR) is
    variable SINGLE    : INTEGER := DIVIDEND'length;
    variable DOUBLE    : INTEGER := DIVIDEND'length*2;
    -- REMQUO should not be more than 2x argument's length.
    -- Others need to account for overflow in calculation
    -- of partial remainder contenders.
    variable REMQUO    : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0)
                          := (others => '0');
    variable HIGH      : BTERN_ULOGIC_VECTOR(SINGLE downto 0);
    variable LOW       : BTERN_ULOGIC_VECTOR(SINGLE downto 0);
    variable CLOSEST_Z : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    variable HIGHQUO   : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
    variable LOWQUO    : BTERN_ULOGIC_VECTOR(DOUBLE downto 0);
  begin
    assert DIVISOR /= 0 report "TVL.BAL_NUMERIC.BTE_DIVMOD: DIV or MOD by zero"
      severity error;

    REMQUO(SINGLE-1 downto 0) := DIVIDEND;

    for I in SINGLE-1 downto 0 loop
      
      REMQUO := REMQUO sll 1;

      HIGH := REMQUO(DOUBLE-1 downto SINGLE) + ("0" & DIVISOR);
      LOW  := REMQUO(DOUBLE-1 downto SINGLE) - ("0" & DIVISOR);

      HIGHQUO   := HIGH & REMQUO(SINGLE-1 downto 0);
      LOWQUO    := LOW  & REMQUO(SINGLE-1 downto 0);
      CLOSEST_Z := MINIMUM(abs(LOWQUO), MINIMUM(abs(REMQUO), abs(HIGHQUO)));

      if CLOSEST_Z = abs(REMQUO) then
        null;
      elsif CLOSEST_Z = abs(HIGHQUO) then
        REMQUO := HIGHQUO(DOUBLE-1 downto 0);
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) - 1;
      elsif CLOSEST_Z = abs(LOWQUO) then 
        REMQUO := LOWQUO(DOUBLE-1 downto 0);
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) + 1;
      end if;
    end loop;

    if REMQUO(DOUBLE-1 downto SINGLE) < 0 then
      if LEFTMOST_NZ(REMQUO(DOUBLE-1 downto SINGLE)) /= LEFTMOST_NZ(DIVISOR) then
        REMQUO(DOUBLE-1 downto SINGLE) := REMQUO(DOUBLE-1 downto SINGLE) + DIVISOR;
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) - 1;
      else
        REMQUO(DOUBLE-1 downto SINGLE) := REMQUO(DOUBLE-1 downto SINGLE) - DIVISOR;
        REMQUO(SINGLE-1 downto 0) := REMQUO(SINGLE-1 downto 0) + 1;
      end if;
    end if;

    XREM := REMQUO(DOUBLE-1 downto SINGLE);
    XQUO := REMQUO(SINGLE-1 downto 0);
  end procedure BTE_DIVMOD;

  -------------------------------------------------------------------

procedure DIV_TESTING (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                       XQUO, XREM : out BTERN_ULOGIC_VECTOR) is
  variable E         : BTERN_ULOGIC_VECTOR(DIVIDEND'length-1 downto 0) := (others => '0');
  variable SC        : INTEGER;
  variable SD        : INTEGER;
  variable QUOT_TRIT : BTERN_ULOGIC_VECTOR(0 downto 0);
  variable G         : BTERN_ULOGIC_VECTOR(DIVIDEND'length*2-1 downto 0);
  variable C         : BTERN_ULOGIC_VECTOR(DIVIDEND'length*2-1 downto 0);
  variable D         : BTERN_ULOGIC_VECTOR(DIVIDEND'length*2-1 downto 0); -- FIX 1: added
  variable TEMP      : BTERN_ULOGIC_VECTOR(DIVIDEND'length*4-1 downto 0);

begin
  assert DIVISOR /= 0
    report "TVL.BAL_NUMERIC.DIVMOD: DIV, MOD, or REM by zero"
    severity error;

  -- FIX 1: prepare — sign of divisor and take absolute value
  if DIVISOR > 0 then
    SD := 1;
  else
    SD := -1;
  end if;
  D := RESIZE(abs(DIVISOR), DIVIDEND'length*2);

  -- FIX 2: prepare — double C exactly once before the loop, not inside it
  TEMP := DIVIDEND * 2;
  C    := TEMP(DIVIDEND'length*2-1 downto 0);

  -- E is zeroed by initialisation above

  for I in 0 to DIVIDEND'length-1 loop

    if C > 0 then
      SC := 1;
    else
      SC := -1;
    end if;

    -- FIX 2: G = |C| - D, no extra doubling here
    TEMP := C * SC - D;
    G    := TEMP(DIVIDEND'length*2-1 downto 0);

    if G > 0 then
      QUOT_TRIT := TO_BALTERN(SC * SD, 1);
      E(I)      := QUOT_TRIT(0);
      TEMP := (G - D) * SC;
      C    := TEMP(DIVIDEND'length*2-1 downto 0);
    end if;

    -- FIX 3: do not multiply on the last iteration
    -- otherwise C carries an extra factor of 3 into the remainder
    if I < DIVIDEND'length-1 then
      TEMP := C * 3;
      C    := TEMP(DIVIDEND'length*2-1 downto 0);
    end if;

  end loop;

  -- FIX 3: C = 2 * remainder because of the initial doubling in prepare
  -- halve C to recover the true remainder
-- divide by 2 using your type's operation
  XREM := RESIZE(C / 2, XREM'length);
  XQUO := RESIZE(E, XQUO'length);

end procedure DIV_TESTING;

  -------------------------------------------------------------------

  function NUM_BTRITS (ARG : INTEGER) return NATURAL is
    variable NTRITS : NATURAL := 0;
    variable REMAIN : NATURAL := 0;
    variable N      : NATURAL := abs(ARG);
  begin
    if N = 0 then
      NTRITS := 1;
      return NTRITS; 
    end if;   
    while N /= 0 loop
      NTRITS := NTRITS+1;
      REMAIN := N mod 3;
      if REMAIN = 1 then
        N := N - 1;
      elsif REMAIN = 2 then
        N := N + 1;
      end if;
      N := N / 3;
    end loop;
    return NTRITS; 
  end function NUM_BTRITS;
  
  -------------------------------------------------------------------

  -- Returns the BTERN_ULOGIC value of the leftmost trit which is not 0.
  -- Returns '0' if none was found.
  function LEFTMOST_NZ (ARG : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC is
    alias XR : BTERN_ULOGIC_VECTOR (ARG'length-1 downto 0) is ARG;
  begin
    for i in XR'range loop
      if XR(i) /= '0' then
        return XR(i);
      end if;
    end loop;
    return '0';
  end function leftmost_nz;

  --=================================================================
  -- Arithmetic operators for simplification
  --=================================================================

  function "abs" (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    constant L_LEFT : INTEGER := L'length-1;
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    variable RESULT : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
  begin
    if L'length < 1 then return NAC;
    end if;
    RESULT := TO_M2P(XL, 'X');
    if (RESULT(RESULT'left) = 'X') then return RESULT;
    end if;
    if RESULT < 0 then
      RESULT := -RESULT;
    end if;
    return RESULT;
  end function "abs";

  -------------------------------------------------------------------

  function "-" (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
  begin
    return STI(L);
  end function "-";
  
  --=================================================================
  -- Overloads of the "+" predefined operator
  --=================================================================

  function "+" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    constant SIZE : NATURAL := MAXIMUM(L'length, R'length);
    variable LM2P : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := TO_M2P(RESIZE(L, SIZE), 'X');
    if (LM2P(LM2P'left) = 'X') then return LM2P;
    end if;
    RM2P := TO_M2P(RESIZE(R, SIZE), 'X');
    if (RM2P(RM2P'left) = 'X') then return RM2P;
    end if;
    return ADD_BTERN_VEC(LM2P, RM2P, '0');
  end function "+";

  -------------------------------------------------------------------

  function "+" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC)
  return BTERN_ULOGIC_VECTOR is
    variable XR : BTERN_ULOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    if L'length < 1 then return NAC;
    end if;
    XR(0) := R;
    return (L + XR);
  end function "+";

  -------------------------------------------------------------------

  function "+" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    variable XL : BTERN_ULOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    if R'length < 1 then return NAC;
    end if;
    XL(0) := L;
    return (XL + R);
  end function "+";

  -------------------------------------------------------------------
  
  function "+" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
   return BTERN_ULOGIC_VECTOR is
  begin
    if L'length < 1 then return NAC;
    end if;
    return L + TO_BALTERN(R, L'length);
  end function "+";

  -------------------------------------------------------------------
  
  function "+" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
   return BTERN_ULOGIC_VECTOR is
  begin
    if R'length < 1 then return NAC;
    end if;
    return TO_BALTERN(L, R'length) + R;
  end function "+";
 
  --=================================================================
  -- Overloads of the "-" predefined operator
  --=================================================================

  function "-" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    constant SIZE : NATURAL := MAXIMUM(L'length, R'length);
    variable LM2P  : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P  : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := TO_M2P(RESIZE(L, SIZE), 'X');
    if (LM2P(LM2P'left) = 'X') then return LM2P;
    end if;
    RM2P := TO_M2P(RESIZE(R, SIZE), 'X');
    if (RM2P(RM2P'left) = 'X') then return RM2P;
    end if;
    return ADD_BTERN_VEC(LM2P, STI(RM2P), '0');
  end function "-";
  -------------------------------------------------------------------

  function "-" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    variable XR : BTERN_ULOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    if L'length < 1 then return NAC;
    end if;
    XR(0) := R;
    return (L + STI(XR));
  end function "-";

  -------------------------------------------------------------------

  function "-" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    variable XL : BTERN_ULOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    if R'length < 1 then return NAC;
    end if;
    XL(0) := L;
    return (XL + STI(R));
  end function "-";

  -------------------------------------------------------------------
  
  function "-" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
   return BTERN_ULOGIC_VECTOR is
  begin
    if L'length < 1 then return NAC;
    end if;
   return L + STI(TO_BALTERN(R, L'length));
  end function "-";

  -------------------------------------------------------------------
  
  function "-" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
   return BTERN_ULOGIC_VECTOR is
  begin
    if R'length < 1 then return NAC;
    end if;
   return TO_BALTERN(L, R'length) + STI(R);
  end function "-";

  --=================================================================
  -- Overloads of the "*" predefined operator
  --=================================================================

  function "*" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    variable RESULT : BTERN_ULOGIC_VECTOR(L'length+R'length-1 downto 0) :=
      (others => '0');
    variable ADVAL  : BTERN_ULOGIC_VECTOR(L'length+R'length-1 downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := TO_M2P(L, 'X');
    RM2P := TO_M2P(R, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      RESULT := (others => 'X');
      return RESULT;
    end if;
    ADVAL := RESIZE(RM2P, RESULT'length);
    for I in 0 to L_LEFT loop
      if LM2P(I)    = '+' then RESULT := RESULT + ADVAL;
      elsif LM2P(I) = '-' then RESULT := RESULT - ADVAL;
      end if;
      ADVAL := ADVAL sll 1;
    end loop;
    return RESULT;
  end function "*";

  -------------------------------------------------------------------

  function "*" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR is
  begin
    return L * TO_BALTERN(R, L'length);
  end function "*";

  -------------------------------------------------------------------

  function "*" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
    return BTERN_ULOGIC_VECTOR is
  begin
    return TO_BALTERN(L, R'length) * R;
  end function "*";

  --=================================================================
  -- Functions for use like the "/" predefined operator. 
  -- Returns the quotient of Euclidean division.
  --=================================================================

  function BTEDIV (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    variable SIZE    : INTEGER := MAXIMUM(L'length, R'length);
    variable LM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FQUOT   : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FREMAIN : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := TO_M2P(RESIZE(L, SIZE), 'X');
    RM2P := TO_M2P(RESIZE(R, SIZE), 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      FQUOT := (others => 'X');
      return RESIZE(FQUOT, L'length);
    end if;
    BTE_DIVMOD(LM2P, RM2P, FQUOT, FREMAIN);
    return RESIZE(FQUOT, L'length);
  end function BTEDIV;

  -------------------------------------------------------------------

  function BTEDIV (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    constant R_LENGTH : NATURAL := MAXIMUM(L'length, NUM_BTRITS(R));
    variable XR, QUOT : BTERN_ULOGIC_VECTOR(R_LENGTH-1 downto 0);
  begin
    if (L'length < 1) then return NAC;
    end if;
    if (R_LENGTH > L'length) then
      QUOT := (others => '0');
      return RESIZE(QUOT, L'length);
    end if;
    XR   := TO_BALTERN(R, R_LENGTH);
    QUOT := BTEDIV(L, XR);
    return RESIZE(QUOT, L'length);
  end function BTEDIV;

  -------------------------------------------------------------------

  function BTEDIV (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    constant L_LENGTH : NATURAL := MAXIMUM(NUM_BTRITS(L), R'length);
    variable XL, QUOT : BTERN_ULOGIC_VECTOR(L_LENGTH-1 downto 0);
  begin
    if (R'length < 1) then return NAC;
    end if;
    XL   := TO_BALTERN(L, L_LENGTH);
    QUOT := BTEDIV(XL, R);
    if L_LENGTH > R'length and QUOT(0) /= 'X'
      and QUOT(L_LENGTH-1 downto R'length)
      /= (L_LENGTH-1 downto R'length => QUOT(R'length-1))
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.BTEDIV: Quotient Truncated"
        severity warning;
    end if;
    return RESIZE(QUOT, R'length);
  end function BTEDIV;

  --=================================================================
  -- Functions for use like the "rem" or "mod" predefined operators. 
  -- Returns the remainder of Euclidean division.
  --=================================================================

  function BTEMOD (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    variable SIZE    : INTEGER := MAXIMUM(L'length, R'length);
    variable LM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FQUOT   : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FREMAIN : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := RESIZE(TO_M2P(L, 'X'), SIZE);
    RM2P := RESIZE(TO_M2P(R, 'X'), SIZE);
    if ((LM2P(LM2P'right) = 'X') or (RM2P(RM2P'right) = 'X')) then
      FREMAIN := (others => 'X');
      return RESIZE(FREMAIN, R'length);
    end if;
    BTE_DIVMOD(LM2P, RM2P, FQUOT, FREMAIN);
    return RESIZE(FREMAIN, R'length);
  end function BTEMOD;

  -------------------------------------------------------------------

 function BTEMOD (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    constant R_LENGTH : NATURAL := MAXIMUM(L'length, NUM_BTRITS(R));
    variable XR, XREM : BTERN_ULOGIC_VECTOR(R_LENGTH-1 downto 0);
  begin
    if (L'length < 1) then return NAC;
    end if;
    XR   := TO_BALTERN(R, R_LENGTH);
    XREM := RESIZE(BTEMOD(L, XR), XREM'length);
    if R_LENGTH > L'length and XREM(0) /= 'X' 
      and XREM(R_LENGTH-1 downto L'length) 
      /= (R_LENGTH-1 downto L'length => XREM(L'length-1))
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.""mod"": Modulus Truncated"
        severity warning;
    end if;
    return RESIZE(XREM, L'length);
  end function BTEMOD;

  -------------------------------------------------------------------

  function BTEMOD (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    constant L_LENGTH : NATURAL := MAXIMUM(NUM_BTRITS(L), R'length);
    variable XL, XREM : BTERN_ULOGIC_VECTOR(L_LENGTH-1 downto 0);
  begin
    if (R'length < 1) then return NAC;
    end if;
    XL   := TO_BALTERN(L, L_LENGTH);
    XREM := RESIZE(BTEMOD(XL, R), XREM'length);
    if L_LENGTH > R'length and XREM(0) /= 'X'
      and XREM(L_LENGTH-1 downto R'length)
      /= (L_LENGTH-1 downto R'length => XREM(R'length-1))
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.""mod"": Modulus Truncated"
        severity warning;
    end if;
    return RESIZE(XREM, R'length);
  end function BTEMOD;

  --=================================================================
  -- Overloads of the "/" predefined operator
  --=================================================================

  function "/" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    variable SIZE    : INTEGER := MAXIMUM(L'length, R'length);
    variable LM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FQUOT   : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FREMAIN : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable QNEG    : BOOLEAN := false;
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := RESIZE(TO_M2P(L, 'X'), SIZE);
    RM2P := RESIZE(TO_M2P(R, 'X'), SIZE);
    if ((LM2P(LM2P'right) = 'X') or (RM2P(RM2P'right) = 'X')) then
      FQUOT := (others => 'X');
      return RESIZE(FQUOT, L'length);
    end if;
    if LEFTMOST_NZ(LM2P) = '-' then
      LM2P := STI(LM2P);
      QNEG := true;
    end if;
    if LEFTMOST_NZ(RM2P) = '-' then
      RM2P := STI(RM2P);
      QNEG   := not QNEG;
    end if;
    DIVMOD(LM2P, RM2P, FQUOT, FREMAIN);
    if QNEG then FQUOT := "0"-FQUOT;
    end if;
    return RESIZE(FQUOT, L'length);
  end function "/";

  -------------------------------------------------------------------

  function "/" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    constant R_LENGTH : NATURAL := MAXIMUM(L'length, NUM_BTRITS(R));
    variable XR, QUOT : BTERN_ULOGIC_VECTOR(R_LENGTH-1 downto 0);
  begin
    if (L'length < 1) then return NAC;
    end if;
    if (R_LENGTH > L'length) then
      QUOT := (others => '0');
      return RESIZE(QUOT, L'length);
    end if;
    XR   := TO_BALTERN(R, R_LENGTH);
    QUOT := RESIZE((L / XR), QUOT'length);
    return RESIZE(QUOT, L'length);
  end function "/";

  -------------------------------------------------------------------

  function "/" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    constant L_LENGTH : NATURAL := MAXIMUM(NUM_BTRITS(L), R'length);
    variable XL, QUOT : BTERN_ULOGIC_VECTOR(L_LENGTH-1 downto 0);
  begin
    if (R'length < 1) then return NAC;
    end if;
    XL   := TO_BALTERN(L, L_LENGTH);
    QUOT := RESIZE((XL / R), QUOT'length);
    if L_LENGTH > R'length and QUOT(0) /= 'X'
      and QUOT(L_LENGTH-1 downto R'length)
      /= (L_LENGTH-1 downto R'length => '0')
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.""/"": Quotient Truncated"
        severity warning;
    end if;
    return RESIZE(QUOT, R'length);
  end function "/";

  --=================================================================
  -- "rem" overloads
  --=================================================================

  function "rem" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    variable SIZE    : INTEGER := MAXIMUM(L'length, R'length);
    variable LM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FQUOT   : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FREMAIN : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RNEG    : BOOLEAN := false;
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := RESIZE(TO_M2P(L, 'X'), SIZE);
    RM2P := RESIZE(TO_M2P(R, 'X'), SIZE);
    if ((LM2P(LM2P'right) = 'X') or (RM2P(RM2P'right) = 'X')) then
      FREMAIN := (others => 'X');
      return RESIZE(FREMAIN, R'length);
    end if;
    if LEFTMOST_NZ(LM2P) = '-' then
      LM2P := STI(LM2P);
      RNEG := true;
    end if;
    if LEFTMOST_NZ(RM2P) = '-' then
      RM2P := STI(RM2P);
    end if;
    DIVMOD(LM2P, RM2P, FQUOT, FREMAIN);
    if RNEG then
      FREMAIN := "0"-FREMAIN;
    end if;
    return RESIZE(FREMAIN, R'length);
  end function "rem";

  -------------------------------------------------------------------

  function "rem" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    constant R_LENGTH : NATURAL := MAXIMUM(L'length, NUM_BTRITS(R));
    variable XR, XREM : BTERN_ULOGIC_VECTOR(R_LENGTH-1 downto 0);
  begin
    if (L'length < 1) then return NAC;
    end if;
    XR   := TO_BALTERN(R, R_LENGTH);
    XREM := RESIZE((L rem XR), XREM'length);
    if R_LENGTH > L'length and XREM(0) /= 'X'
      and XREM(R_LENGTH-1 downto L'length)
      /= (R_LENGTH-1 downto L'length => XREM(L'length-1))
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.""rem"": Remainder Truncated"
        severity warning;
    end if;
    return RESIZE(XREM, L'length);
  end function "rem";

  -------------------------------------------------------------------

 function "rem" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    constant L_LENGTH : NATURAL := MAXIMUM(NUM_BTRITS(L), R'length);
    variable XL, XREM : BTERN_ULOGIC_VECTOR(L_LENGTH-1 downto 0);
  begin
    if (R'length < 1) then return NAC;
    end if;
    XL   := TO_BALTERN(L, L_LENGTH);
    XREM := RESIZE((XL rem R), XREM'length);
    if L_LENGTH > R'length and XREM(0) /= 'X'
      and XREM(L_LENGTH-1 downto R'length)
      /= (L_LENGTH-1 downto R'length => XREM(R'length-1))
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.""rem"": Remainder Truncated"
        severity warning;
    end if;
    return RESIZE(XREM, R'length);
  end function "rem";

  --=================================================================
  -- "mod" overloads
  --=================================================================

  function "mod" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    variable SIZE    : INTEGER := MAXIMUM(L'length, R'length);
    variable LM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FQUOT   : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FREMAIN : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RNEG    : BOOLEAN := false;
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := RESIZE(TO_M2P(L, 'X'), SIZE);
    RM2P := RESIZE(TO_M2P(R, 'X'), SIZE);
    if ((LM2P(LM2P'right) = 'X') or (RM2P(RM2P'right) = 'X')) then
      FREMAIN := (others => 'X');
      return RESIZE(FREMAIN, R'length);
    end if;
    if LEFTMOST_NZ(LM2P) = '-' then
      LM2P := STI(LM2P);
    end if;
    if LEFTMOST_NZ(RM2P) = '-' then
      RM2P := STI(RM2P);
      RNEG := true;
    end if;
    DIVMOD(LM2P, RM2P, FQUOT, FREMAIN);
    if RNEG and LEFTMOST_NZ(L) = '-' then
      FREMAIN := "0"-FREMAIN;
    elsif RNEG and FREMAIN /= "0" then
      FREMAIN := FREMAIN-RM2P;
    elsif LEFTMOST_NZ(L) = '-' and FREMAIN /= "0" then
      FREMAIN := RM2P-FREMAIN;
    end if;
    return RESIZE(FREMAIN, R'length);
  end function "mod";

  -------------------------------------------------------------------

 function "mod" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    constant R_LENGTH : NATURAL := MAXIMUM(L'length, NUM_BTRITS(R));
    variable XR, XREM : BTERN_ULOGIC_VECTOR(R_LENGTH-1 downto 0);
  begin
    if (L'length < 1) then return NAC;
    end if;
    XR   := TO_BALTERN(R, R_LENGTH);
    XREM := RESIZE((L mod XR), XREM'length);
    if R_LENGTH > L'length and XREM(0) /= 'X'
      and XREM(R_LENGTH-1 downto L'length)
      /= (R_LENGTH-1 downto L'length => XREM(L'length-1))
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.""mod"": Modulus Truncated"
        severity warning;
    end if;
    return RESIZE(XREM, L'length);
  end function "mod";

  -------------------------------------------------------------------

  function "mod" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    constant L_LENGTH : NATURAL := MAXIMUM(NUM_BTRITS(L), R'length);
    variable XL, XREM : BTERN_ULOGIC_VECTOR(L_LENGTH-1 downto 0);
  begin
    if (R'length < 1) then return NAC;
    end if;
    XL   := TO_BALTERN(L, L_LENGTH);
    XREM := RESIZE((XL mod R), XREM'length);
    if L_LENGTH > R'length and XREM(0) /= 'X'
      and XREM(L_LENGTH-1 downto R'length)
      /= (L_LENGTH-1 downto R'length => XREM(R'length-1))
    then
      assert NO_WARNING report "TVL.BAL_NUMERIC.""mod"": Modulus Truncated"
        severity warning;
    end if;
    return RESIZE(XREM, R'length);
  end function "mod";

  --=================================================================
  -- find_ functions
  --=================================================================

  function find_leftmost (ARG : BTERN_ULOGIC_VECTOR; Y : BTERN_ULOGIC)
    return INTEGER is
  begin
    for INDEX in ARG'range loop
      if ARG(INDEX) = Y then
        return INDEX;
      end if;
    end loop;
    return -1;
  end function find_leftmost;

  -------------------------------------------------------------------

  function find_rightmost (ARG : BTERN_ULOGIC_VECTOR; Y : BTERN_ULOGIC)
    return INTEGER is
  begin
    for INDEX in ARG'reverse_range loop
      if ARG(INDEX) = Y then
        return INDEX;
      end if;
    end loop;
    return -1;
  end function find_rightmost;

  --=================================================================
  -- MINIMUM functions
  --=================================================================

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
    LM2P := TO_M2P(RESIZE(XL, SIZE), 'X');
    if (LM2P(LM2P'left) = 'X') then return LM2P;
    end if;
    RM2P := TO_M2P(RESIZE(XR, SIZE), 'X');
    if (RM2P(RM2P'left) = 'X') then return RM2P;
    end if;
    if LM2P < RM2P then
      return LM2P;
    else
      return RM2P;
    end if;
  end function MINIMUM;

  -------------------------------------------------------------------

  function MINIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MINIMUM(TO_BALTERN(L, R'length), R);
  end function MINIMUM;

  -------------------------------------------------------------------

  function MINIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MINIMUM(L, TO_BALTERN(R, L'length));
  end function MINIMUM;

  --=================================================================
  -- MAXIMUM functions
  --=================================================================

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
    LM2P := TO_M2P(RESIZE(XL, SIZE), 'X');
    if (LM2P(LM2P'left) = 'X') then return LM2P;
    end if;
    RM2P := TO_M2P(RESIZE(XR, SIZE), 'X');
    if (RM2P(RM2P'left) = 'X') then return RM2P;
    end if;
    if LM2P < RM2P then
      return RM2P;
    else
      return LM2P;
    end if;
  end function MAXIMUM;

  -------------------------------------------------------------------

  function MAXIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MAXIMUM(TO_BALTERN(L, R'length), R);
  end function MAXIMUM;

  -------------------------------------------------------------------

  function MAXIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR is
  begin
    return MAXIMUM(L, TO_BALTERN(R, L'length));
  end function MAXIMUM;

  --=================================================================
  -- STD_MATCH functions
  --=================================================================

  -------------------------------------------------------------------
  -- support constants for STD_MATCH
  -------------------------------------------------------------------

  type BOOLEAN_TABLE is array(BTERN_ULOGIC, BTERN_ULOGIC) of BOOLEAN;

  constant MATCH_TABLE : BOOLEAN_TABLE := (
    -- ------------------------------------------------------------------------------------------
    -- |   U      X      -      0      +      Z      W      L      M      H      D    
    -- ------------------------------------------------------------------------------------------  
        (false, false, false, false, false, false, false, false, false, false, true),  -- | U |  
        (false, false, false, false, false, false, false, false, false, false, true),  -- | X |
        (false, false, true,  false, false, false, false, true,  false, false, true),  -- | - |
        (false, false, false, true,  false, false, false, false, true,  false, true),  -- | 0 |
        (false, false, false, false, true,  false, false, false, false, true,  true),  -- | + |
        (false, false, false, false, false, false, false, false, false, false, true),  -- | Z |
        (false, false, false, false, false, false, false, false, false, false, true),  -- | W |
        (false, false, true,  false, false, false, false, true,  false, false, true),  -- | L |
        (false, false, false, true,  false, false, false, false, true,  false, true),  -- | M |
        (false, false, false, false, true,  false, false, false, false, true,  true),  -- | H |
        (true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true)   -- | D |
        ); 

  -------------------------------------------------------------------

  function STD_MATCH (L, R : BTERN_ULOGIC) return BOOLEAN is
  begin
    return MATCH_TABLE(L, R);
  end function STD_MATCH;

  -------------------------------------------------------------------

  function STD_MATCH (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN is
    alias LV : BTERN_ULOGIC_VECTOR(1 to L'length) is L;
    alias RV : BTERN_ULOGIC_VECTOR(1 to R'length) is R;
  begin
    if ((L'length < 1) or (R'length < 1)) then
      assert NO_WARNING
        report "TVL.BAL_NUMERIC.STD_MATCH: null detected, returning FALSE"
        severity warning;
      return false;
    end if;
    if LV'length /= RV'length then
      assert NO_WARNING
        report "TVL.BAL_NUMERIC.STD_MATCH: L'LENGTH /= R'LENGTH, returning FALSE"
        severity warning;
      return false;
    else
      for I in LV'low to LV'high loop
        if not (MATCH_TABLE(LV(I), RV(I))) then
          return false;
        end if;
      end loop;
      return true;
    end if;
  end function STD_MATCH;

end package body bal_numeric;


