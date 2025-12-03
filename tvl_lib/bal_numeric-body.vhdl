-- -----------------------------------------------------------------
--
--   Title     :  Standard ternary logic package
--             :  (BTERN_NUMERIC package declaration)
--             :
--   Library   :  This package shall be compiled into a library
--             :  symbolically named BTERN.
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

package body bal_numeric is

  -- null range array constant and implementation controls
  constant NAC : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');
  constant NO_WARNING : BOOLEAN := FALSE;  -- default to emit warnings

  ------------------------------------------------------------------------
  -- Local subprograms
  ------------------------------------------------------------------------

  -- Computes the addition of two BTERN_ULOGIC_VECTOR with input carry trit
  -- * the two arguments must be of the same length
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

  ------------------------------------------------------------------------
  -- Requirements:
  -- Both arguments must be of the same length
  procedure DIVMOD (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                    XQUO, XREM : out BTERN_ULOGIC_VECTOR) is
    variable DOUBLE    : INTEGER := DIVIDEND'length*2;
    variable SINGLE    : INTEGER := DIVIDEND'length;
    alias XDIVISOR     : BTERN_ULOGIC_VECTOR(SINGLE-1 downto 0)
                          is DIVISOR;
    variable QUO       : BTERN_ULOGIC_VECTOR(SINGLE-1 downto 0);
    variable HIGH      : BTERN_ULOGIC_VECTOR(SINGLE-1 downto 0);
    variable MID       : BTERN_ULOGIC_VECTOR(SINGLE-1 downto 0);
    variable LOW       : BTERN_ULOGIC_VECTOR(SINGLE-1 downto 0);
    variable HIGHQUO   : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0);
    variable MIDQUO    : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0);
    variable LOWQUO    : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0);
    variable CLOSEST_Z : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0);
    variable REMQUO    : BTERN_ULOGIC_VECTOR(DOUBLE-1 downto 0)
                          := (others => '0');
  begin
    assert DIVISOR /= 0 report "BTERN.BAL_LOGIC.DIVMOD: DIV, MOD, or REM by zero"
      severity error;
    -- quo = dividend;
    -- rem = 0;
    -- REMQUO is already initialized to all 0's,
    -- so setting lower part = DIVIDEND
    REMQUO(SINGLE-1 downto 0) := DIVIDEND;
    for I in 0 to SINGLE-1 loop
      -- (rem,quo) = (rem,quo) <<3 1;
      REMQUO := REMQUO sll 1;

      -- balanced int high = rem + divisor;
	    -- balanced int mid  = rem;
	    -- balanced int low  = rem - divisor;
      HIGH := REMQUO(DOUBLE-1 downto SINGLE) + XDIVISOR;
      MID  := REMQUO(DOUBLE-1 downto SINGLE); 
      LOW  := REMQUO(DOUBLE-1 downto SINGLE) - XDIVISOR;
      -- (rem,) = closest_to_zero( (high,quo), (mid,quo), (low,quo) );
      -- Using absolute values to compare,
      -- but REMQUO must be set to their original values after
      HIGHQUO   := HIGH & REMQUO(SINGLE-1 downto 0);
      MIDQUO    := MID  & REMQUO(SINGLE-1 downto 0);
      LOWQUO    := LOW  & REMQUO(SINGLE-1 downto 0);
      CLOSEST_Z := MINIMUM(abs(LOWQUO), MINIMUM(abs(MIDQUO), abs(HIGHQUO)));
      if CLOSEST_Z = abs(HIGHQUO) then
        REMQUO := HIGHQUO;
      elsif CLOSEST_Z = abs(MIDQUO) then
        REMQUO := MIDQUO;
      elsif CLOSEST_Z = abs(LOWQUO) then
        REMQUO := LOWQUO;
      end if;
      -- if (rem == high) { quo = quo - 1; }
      -- else if (rem == low) { quo = quo + 1; }
      -- Avoiding long statements here for readability
      if REMQUO(DOUBLE-1 downto SINGLE) = HIGH then
        QUO := REMQUO(SINGLE-1 downto 0);
        QUO := QUO - 1;
        REMQUO(SINGLE-1 downto 0) := QUO;
      elsif REMQUO(DOUBLE-1 downto SINGLE) = LOW then
        QUO := REMQUO(SINGLE-1 downto 0);
        QUO := QUO + 1;
        REMQUO(SINGLE-1 downto 0) := QUO;
      end if;
    end loop;
    XREM := RESIZE(REMQUO(DOUBLE-1 downto SINGLE), XREM'length);
    XQUO := RESIZE(REMQUO(SINGLE-1 downto 0), XQUO'length);
  end procedure DIVMOD;

  ------------------------------------------------------------------------

  -- Returns the number of trits necessary to express any integer
  function NUM_TRITS (ARG : INTEGER) return NATURAL is
    variable NTRITS : NATURAL;
    variable N      : NATURAL;
  begin
    if ARG >= 0 then
      N := ARG;
    else
      N := -(ARG);
    end if;
    NTRITS := 1;
    while N > 0 loop
      NTRITS := NTRITS+1;
      N := N / 3;
    end loop;
    return NTRITS;
  end function NUM_TRITS;

  ------------------------------------------------------------------------
  -- Overloads of the "+" predefined operator
  ------------------------------------------------------------------------

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

  ------------------------------------------------------------------------

  function "+" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC)
  return BTERN_ULOGIC_VECTOR is
    variable XR : BTERN_ULOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L + XR);
  end function "+";

  ------------------------------------------------------------------------

  function "+" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    variable XL : BTERN_ULOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL + R);
  end function "+";

  ------------------------------------------------------------------------
  
  function "+" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
   return BTERN_ULOGIC_VECTOR is
  begin
   return L + To_BALTERN(R, L'length);
  end function "+";

  -- ------------------------------------------------------------------------
  
  function "+" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
   return BTERN_ULOGIC_VECTOR is
  begin
   return To_BALTERN(L, R'length) + R;
  end function "+";
 
  ------------------------------------------------------------------------
  -- Overloads of the "-" predefined operator
  ------------------------------------------------------------------------

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
  ------------------------------------------------------------------------

  function "-" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC)
    return BTERN_ULOGIC_VECTOR
  is
    variable XR : BTERN_ULOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L + STI(XR));
  end function "-";

  ------------------------------------------------------------------------

  function "-" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    variable XL : BTERN_ULOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL + STI(R));
  end function "-";

  ------------------------------------------------------------------------
  
  function "-" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
   return BTERN_ULOGIC_VECTOR is
  begin
   return L + STI(To_BALTERN(R, L'length));
  end function "-";

  -- ------------------------------------------------------------------------
  
  function "-" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
   return BTERN_ULOGIC_VECTOR is
  begin
   return To_BALTERN(L, R'length) + STI(R);
  end function "-";

  ------------------------------------------------------------------------
  -- Overloads of the "*" predefined operator
  ------------------------------------------------------------------------

  function "*" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    constant L_LEFT : INTEGER := L'length-1;
    constant R_LEFT : INTEGER := R'length-1;
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    alias XR        : BTERN_ULOGIC_VECTOR(R_LEFT downto 0) is R;
    variable LM2P   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
    variable RM2P   : BTERN_ULOGIC_VECTOR(R_LEFT downto 0);
    variable RESULT : BTERN_ULOGIC_VECTOR((L'length+R'length-1) downto 0) :=
      (others => '0');
    variable ADVAL  : BTERN_ULOGIC_VECTOR((L'length+R'length-1) downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := TO_M2P(XL, 'X');
    RM2P := TO_M2P(XR, 'X');
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      RESULT := (others => 'X');
      return RESULT;
    end if;
    ADVAL := RESIZE(XR, RESULT'length);
    for I in 0 to L_LEFT loop
      if XL(I) = '+' then RESULT    := RESULT + ADVAL;
      elsif XL(I) = '-' then RESULT := RESULT - ADVAL;
      end if;
      ADVAL := ADVAL sll 1;
    end loop;
    return RESULT;
  end function "*";

  -----------------------------------------------------------------------

  function "*" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR is
  begin
    return L * To_BALTERN(R, L'length);
  end function "*";

  -----------------------------------------------------------------------

  function "*" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
  begin
    return To_BALTERN(L, R'length) * R;
  end function "*";

  ------------------------------------------------------------------------
  -- Overloads of the "/" predefined operator
  ------------------------------------------------------------------------

  function "/" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    alias XL         : BTERN_ULOGIC_VECTOR(L'length-1 downto 0) is L;
    alias XR         : BTERN_ULOGIC_VECTOR(R'length-1 downto 0) is R;
    variable SIZE    : INTEGER := MAXIMUM(L'length, R'length);
    variable LM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable RM2P    : BTERN_ULOGIC_VECTOR(SIZE-1 downto 0);
    variable FQUOT   : BTERN_ULOGIC_VECTOR(L'length-1 downto 0);
    variable FREMAIN : BTERN_ULOGIC_VECTOR(R'length-1 downto 0);
  begin
    if ((L'length < 1) or (R'length < 1)) then return NAC;
    end if;
    LM2P := RESIZE(TO_M2P(XL, 'X'), SIZE);
    RM2P := RESIZE(TO_M2P(XR, 'X'), SIZE);
    if ((LM2P(LM2P'left) = 'X') or (RM2P(RM2P'left) = 'X')) then
      FQUOT := (others => 'X');
      return FQUOT;
    end if;
    DIVMOD(LM2P, RM2P, FQUOT, FREMAIN);
    return FQUOT;
  end function "/";

  ------------------------------------------------------------------------

  function "/" (L : BTERN_ULOGIC_VECTOR; R : INTEGER)
    return BTERN_ULOGIC_VECTOR
  is
    constant R_LENGTH : NATURAL := MAXIMUM(L'length, NUM_TRITS(R));
    variable XR, QUOT : BTERN_ULOGIC_VECTOR(R_LENGTH-1 downto 0);
  begin
    if (L'length < 1) then return NAC;
    end if;
    if (R_LENGTH > L'length) then
      QUOT := (others => '0');
      return RESIZE(QUOT, L'length);
    end if;
    XR   := To_BALTERN(R, R_LENGTH);
    QUOT := RESIZE((L / XR), QUOT'length);
    return RESIZE(QUOT, L'length);
  end function "/";

  ------------------------------------------------------------------------

  function "/" (L : INTEGER; R : BTERN_ULOGIC_VECTOR)
    return BTERN_ULOGIC_VECTOR
  is
    constant L_LENGTH : NATURAL := MAXIMUM(NUM_TRITS(L), R'length);
    variable XL, QUOT : BTERN_ULOGIC_VECTOR(L_LENGTH-1 downto 0);
  begin
    if (R'length < 1) then return NAC;
    end if;
    if (L_LENGTH > R'length) then
      QUOT := (others => '0');
      return RESIZE(QUOT, R'length);
    end if;
    XL   := To_BALTERN(L, L_LENGTH);
    QUOT := RESIZE((XL / R), QUOT'length);
    return RESIZE(QUOT, R'length);
  end function "/";

  ------------------------------------------------------------------------

  function "abs" (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR is
    constant L_LEFT : INTEGER := L'length-1;
    alias XL        : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) is L;
    variable ZERO   : BTERN_ULOGIC_VECTOR(L_LEFT downto 0) := (others => '0');
    variable RESULT : BTERN_ULOGIC_VECTOR(L_LEFT downto 0);
  begin
    if L'length < 1 then return NAC;
    end if;
    RESULT := TO_M2P(XL, 'X');
    if (RESULT(RESULT'left) = 'X') then return RESULT;
    end if;
    if RESULT < ZERO then
      RESULT := STI(RESULT);
    end if;
    return RESULT;
  end function "abs";



end package body bal_numeric;


