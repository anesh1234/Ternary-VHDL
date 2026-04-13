-- -----------------------------------------------------------------
--
--   Title     :  Standard ternary logic package
--             :  (BAL_LOGIC package declaration)
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
-- ------------------------------------------------------------------
-- $Revision: 1 $
-- $Date: 2025-07-10 (Tue, 10 Oct 2025) $
-- ------------------------------------------------------------------

library TVL;
use TVL.kleene_pkg.all;

-- IEEE library types needed for mixed-radix
-- conversion functions
library IEEE;
use IEEE.std_logic_1164.STD_ULOGIC;
use IEEE.std_logic_1164.STD_ULOGIC_VECTOR;
use IEEE.std_logic_1164.STD_LOGIC;
use IEEE.std_logic_1164.STD_LOGIC_VECTOR;

package bal_logic is

  -------------------------------------------------------------------
  -- logic state system  (unresolved)
  ------------------------------------------------------------------- 

  type BTERN_ULOGIC is ('U',       -- Uninitialized
                        'X',       -- Forcing Unknown
                        '-',       -- Forcing -
                        '0',       -- Forcing 0
                        '+',       -- Forcing +
                        'Z',       -- High Impedance
                        'W',       -- Weak Unknown
                        'L',       -- Weak -
                        'M',       -- Weak 0
                        'H',       -- Weak +
                        'D'        -- Don't care
                       );

  -------------------------------------------------------------------
  -- unconstrained array of btern_ulogic for use with the resolution 
  -- function and for use in declaring signal arrays of 
  -- unresolved elements
  -------------------------------------------------------------------

  type BTERN_ULOGIC_VECTOR is array (NATURAL range <>) of BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- resolution function
  -------------------------------------------------------------------

  function resolved (S : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- logic state system  (resolved)
  -------------------------------------------------------------------

  subtype BTERN_LOGIC is resolved BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- unconstrained array of resolved btern_ulogic for use in 
  -- declaring signal arrays of resolved elements
  -------------------------------------------------------------------

  subtype BTERN_LOGIC_VECTOR is (resolved) BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Common subtypes
  -------------------------------------------------------------------
  -- Named e.g, "X2P" meaning "X to Plus"
  
  type BTRIT is ('-', '0', '+');
  type BTRIT_VECTOR is array (NATURAL range <>) of BTRIT;
  subtype X2P is resolved BTERN_ULOGIC range 'X' to '+';  -- ('X','-','0','+')
  subtype X2Z is resolved BTERN_ULOGIC range 'X' to 'Z';  -- ('X','-','0','+','Z')
  subtype U2P is resolved BTERN_ULOGIC range 'U' to '+';  -- ('U','X','-','0','+')
  subtype U2Z is resolved BTERN_ULOGIC range 'U' to 'Z';  -- ('U','X','-','0','+','Z')

  -------------------------------------------------------------------
  -- scalar 1-arity logical functions. 
  -------------------------------------------------------------------
  -- Listed below with their respective heptavintimal index in brackets [],
  -- their function names in parenthesis (), then any aliases:

  -- [0], CONST_LOW (COL)
  -- [2], Negative Ternary Inverter (NTI), DETECT_LOW
  -- [5], Standard Ternary Inverter (STI)
  -- [6], Middle Toggling Inverter (MTI), DETECT_MIDDLE
  -- [7], Increment (INC), NEXT, SUCCESSOR
  -- [8], Positive Ternary Inverter (PTI)
  -- [B], DECREMENT (DEC), PREV, PREDECESSOR
  -- [C], CLAMP_DOWN (CLD)
  -- [D], CONST_MIDDLE (COM)
  -- [K], Inverted PTI (IPT), DETECT_HIGH
  -- [N], Inverted MTI (IMT), inverted DETECT_MIDDLE
  -- [P], BUFFER (BUF)
  -- [R], CLAMP_UP (CLU)
  -- [V], Inverted NTI (INT)
  -- [Z], CONST_HIGH (COH)
  -------------------------------------------------------------------

  function COL (L : BTERN_ULOGIC) return U2P;
  function NTI (L : BTERN_ULOGIC) return U2P;
  function STI (L : BTERN_ULOGIC) return U2P;
  function MTI (L : BTERN_ULOGIC) return U2P;
  function INC (L : BTERN_ULOGIC) return U2P;
  function PTI (L : BTERN_ULOGIC) return U2P;
  function DEC (L : BTERN_ULOGIC) return U2P;
  function CLD (L : BTERN_ULOGIC) return U2P;
  function COM (L : BTERN_ULOGIC) return U2P;
  function IPT (L : BTERN_ULOGIC) return U2P;
  function IMT (L : BTERN_ULOGIC) return U2P;
  function BUF (L : BTERN_ULOGIC) return U2P;
  function CLU (L : BTERN_ULOGIC) return U2P;
  function INT (L : BTERN_ULOGIC) return U2P;
  function COH (L : BTERN_ULOGIC) return U2P;

  -------------------------------------------------------------------
  -- vectorized 1-arity logical functions
  -------------------------------------------------------------------

  function COL (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NTI (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function STI (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MTI (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function INC (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function PTI (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function DEC (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function CLD (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function COM (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function IPT (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function IMT (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function BUF (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function CLU (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function INT (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function COH (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- scalar 2-arity logical functions. 
  -------------------------------------------------------------------
  -- Listed below with their respective heptavintimal index in brackets [],
  -- their function names in parenthesis (), then any aliases:

  -- [7PB] (SUM), TRISHIFT (DEC,BUF,INC)
  -- [RDC] CONSENSUS (CON) 
  -- [4DE] NCONS (NCO)
  -- [PC0] Minimum (MINI), Ternary AND
  -- [ZRP] Maximum (MAX), Ternary OR
  -- [045] NMAX (NMA)
  -- [5EZ] NMIN (NMI) 
  -- [5DP] XOR, overload of predefined logical operator
  -- [PD5] MULTIPLY (MUL), DIVIDE (div/0 is 0)
  -- [PRZ] IMPLICATION (IMP), Kleene Logic version
  -- [XP9] ANY 
  -- [15H] NANY (NAN)
  -- [H51] COMPARE, MORE,LESS,EQUAL (MLE)
  -- [RD4] ENABLE (ENA), ENABLE w/ binary
  -- [VP0] DESELECT (DES), A or B, with one being !ENABLE
  -------------------------------------------------------------------

  function SUM   (L, R : BTERN_ULOGIC) return U2P;
  function CON   (L, R : BTERN_ULOGIC) return U2P;
  function NCO   (L, R : BTERN_ULOGIC) return U2P;
  function MINI  (L, R : BTERN_ULOGIC) return U2P;
  function MAX   (L, R : BTERN_ULOGIC) return U2P;
  function NMI   (L, R : BTERN_ULOGIC) return U2P;
  function NMA   (L, R : BTERN_ULOGIC) return U2P;
  function "XOR" (L, R : BTERN_ULOGIC) return U2P;
  function MUL   (L, R : BTERN_ULOGIC) return U2P;
  function IMP   (L, R : BTERN_ULOGIC) return U2P;
  function ANY   (L, R : BTERN_ULOGIC) return U2P;
  function NAN   (L, R : BTERN_ULOGIC) return U2P;
  function MLE   (L, R : BTERN_ULOGIC) return U2P;
  function ENA   (L, R : BTERN_ULOGIC) return U2P;
  function DES   (L, R : BTERN_ULOGIC) return U2P;

  -------------------------------------------------------------------
  -- Vectorized 2-arity logical functions
  -------------------------------------------------------------------

  function SUM   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function SUM   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function SUM   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function CON   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function CON   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function CON   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function NCO   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NCO   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NCO   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function MINI  (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MINI  (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MINI  (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MAX   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MAX   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MAX   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function NMI   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NMI   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NMI   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function NMA   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NMA   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NMA   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "XOR" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "XOR" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function "XOR" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function MUL   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MUL   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MUL   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function IMP   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function IMP   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function IMP   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function ANY   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function ANY   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function ANY   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function NAN   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NAN   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NAN   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function MLE   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MLE   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MLE   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function ENA   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function ENA   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function ENA   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
 
  function DES   (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function DES   (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function DES   (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Shift operator overloads
  -------------------------------------------------------------------

  function "sll" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "srl" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "rol" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "ror" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Resize functions.
  -------------------------------------------------------------------
  -- These are not part of std_logic_1164, but are needed here
  -- for the relational operator overloads.

  function RESIZE (ARG : BTERN_ULOGIC_VECTOR; NEW_SIZE : NATURAL)
  return BTERN_ULOGIC_VECTOR;
  function RESIZE (ARG, NEW_SIZE : BTERN_ULOGIC_VECTOR) return
  BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Conversion functions and strength strippers
  -------------------------------------------------------------------

  function To_btrit       (ARG : BTERN_ULOGIC; xmap : BTRIT := '0')
  return BTRIT;
  function To_btritvector (ARG : BTERN_ULOGIC_VECTOR; xmap : BTRIT := '0')
  return BTRIT_VECTOR;

  function TO_BternLogicVector (S : BTERN_ULOGIC_VECTOR)
  return BTERN_LOGIC_VECTOR;
  function TO_BternULogicVector (S : BTERN_LOGIC_VECTOR)
  return BTERN_ULOGIC_VECTOR;

  alias TO_BLV is
    TO_BternLogicVector[BTERN_ULOGIC_VECTOR return BTERN_LOGIC_VECTOR];

  alias TO_BULV is
    TO_BternULogicVector[BTERN_LOGIC_VECTOR return BTERN_ULOGIC_VECTOR];

  function TO_M2P (S : BTERN_ULOGIC_VECTOR; xmap : BTERN_ULOGIC := '0')
    return BTERN_ULOGIC_VECTOR;
  function TO_M2P (S : BTERN_ULOGIC; xmap : BTERN_ULOGIC := '0')
    return BTERN_ULOGIC;

  function TO_X2P (S : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function TO_X2P (S : BTERN_ULOGIC) return X2P;
  function TO_X2Z (S : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function TO_X2Z (S : BTERN_ULOGIC) return X2Z;
  function TO_U2P (S : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function TO_U2P (S : BTERN_ULOGIC) return U2P;

  -- This kind of function is not part of std_logic_1164, 
  -- but is needed here for the matching relational operators.
  -- Converts an integer to a balanced ternary vector of the given size.
  -- Does not guard against overflow.
  function TO_BALTERN (ARG : INTEGER; SIZE : NATURAL) 
  return BTERN_ULOGIC_VECTOR;

  -- This kind of function is not part of std_logic_1164, 
  -- but has been kept here for convenience because the TO_BALTERN 
  -- function was forced here.
  -- Converts a BTERN_(U)LOGIC(_VECTOR) to an integer.
  -- As it is the norm to not protect against overflows in 
  -- the IEEE library, the same is true here.
  function TO_INTEGER (ARG : BTERN_ULOGIC_VECTOR) return INTEGER;
  function TO_INTEGER (ARG : BTERN_ULOGIC) return INTEGER;

  -- overload of the condition operator
  function "??" (L : BTERN_ULOGIC) return KLEENE;
  -- '-' or 'L' returns FALSE
  -- '+' or 'H' returns TRUE
  -- All others returns UNKNOWN

  -------------------------------------------------------------------
  -- Mixed-radix conversion functions 
  -------------------------------------------------------------------
  -- These are dependent upon the IEEE library.

  -- The following converts the forcing and weak values of 
  -- M/0/H/+ to L/0/H/1. The values U, W/X, "Don't care" and Z 
  -- are propagated. Other values issue severity failure.
  function TO_STD_LOGIC (ARG : BTERN_ULOGIC) return STD_LOGIC;
  function TO_STD_LOGIC (ARG : BTERN_ULOGIC_VECTOR) return STD_LOGIC_VECTOR;

  function TO_STD_ULOGIC (ARG : BTERN_ULOGIC) return STD_ULOGIC;
  function TO_STD_ULOGIC (ARG : BTERN_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;

  -- The following converts the forcing and weak values of 
  -- L/0/H/1 to M/0/H/+. The values U, W/X, "Don't care" and Z
  -- are propagated.
  function TO_BTERN_LOGIC (ARG : STD_ULOGIC) return BTERN_LOGIC;
  function TO_BTERN_LOGIC (ARG : STD_ULOGIC_VECTOR) return BTERN_LOGIC_VECTOR;

  function TO_BTERN_ULOGIC (ARG : STD_ULOGIC) return BTERN_ULOGIC;
  function TO_BTERN_ULOGIC (ARG : STD_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  
  -------------------------------------------------------------------
  -- Edge detection functions
  -------------------------------------------------------------------
  -- mz - minus to zero
  -- pm - plus to minus
  -- Only interested in true/false, therefore returning BOOLEAN.
  -- This decision also makes the functions compatible 
  -- with if-tests and assertions.

  function any_rising_edge (signal S : BTERN_ULOGIC) return BOOLEAN;
  function mz_rising_edge  (signal S : BTERN_ULOGIC) return BOOLEAN;
  function zp_rising_edge  (signal S : BTERN_ULOGIC) return BOOLEAN;
  function mp_rising_edge  (signal S : BTERN_ULOGIC) return BOOLEAN;

  function any_falling_edge (signal S : BTERN_ULOGIC) return BOOLEAN;
  function pz_falling_edge  (signal S : BTERN_ULOGIC) return BOOLEAN;
  function zm_falling_edge  (signal S : BTERN_ULOGIC) return BOOLEAN;
  function pm_falling_edge  (signal S : BTERN_ULOGIC) return BOOLEAN;

  -------------------------------------------------------------------
  -- object contains an unknown
  -------------------------------------------------------------------
  -- Only interested in true/false, therefore returning BOOLEAN.
  -- This decision also makes the functions compatible 
  -- with if-tests and assertions

  function Is_X (S : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function Is_X (S : BTERN_ULOGIC) return BOOLEAN;

  -------------------------------------------------------------------
  -- ordinary relational operators
  -------------------------------------------------------------------
  -- Only interested in true/false, therefore returning BOOLEAN.
  -- This decision also makes the functions compatible 
  -- with if-tests and assertions

  function ">" (L, R  : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function ">" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function ">" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN;

  function "<" (L, R  : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "<" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "<" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN;

  function "<=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "<=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "<=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN;

  function ">=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function ">=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function ">=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN;

  function "=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN;

  -- Unlike the other relational operators, the "not equal" function 
  -- should return TRUE if: 
  -- * either operand contains a metalogical or high-impedance value
  -- * either operand has length < 1
  function "/=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "/=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "/=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN;

  -- The "spaceship" operator
  -- Must be called as SPACE(A, B) as of now, but should ideally
  -- be callable as A <=> B in future implementations.
  -- For this to be possible, the symbols "<=>" must first be
  -- defined in a compiler as an operator, then that operator 
  -- can be overloaded here.

  function SPACE (L, R : BTERN_ULOGIC) return KLEENE;
  function SPACE (L, R : BTERN_ULOGIC_VECTOR) return KLEENE;
  function SPACE (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return KLEENE;
  function SPACE (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return KLEENE;

  -------------------------------------------------------------------
  -- Matching relational operator overloads
  -------------------------------------------------------------------
  -- Just like in the IEEE library, these do not 
  -- guard against overflow.
  -- Errors when "Don't care" values are present has been
  -- inherited from the IEEE library.

  function "?>" (L, R  : BTERN_ULOGIC) return BTERN_ULOGIC;
  function "?>" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?<" (L, R  : BTERN_ULOGIC) return BTERN_ULOGIC;
  function "?<" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?<=" (L, R  : BTERN_ULOGIC) return BTERN_ULOGIC;
  function "?<=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?>=" (L, R  : BTERN_ULOGIC) return BTERN_ULOGIC;
  function "?>=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?=" (L, R  : BTERN_ULOGIC) return BTERN_ULOGIC;
  function "?=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?/=" (L, R  : BTERN_ULOGIC) return BTERN_ULOGIC;
  function "?/=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?/=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?/=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;
  
  -- Matching spaceship operator
  function M_SPACE (L, R : BTERN_ULOGIC) return BTERN_ULOGIC;
  function M_SPACE (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function M_SPACE (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function M_SPACE (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- string conversion and read/write functions
  -------------------------------------------------------------------
  -- the following operations are predefined, and are verified to 
  -- work with the new balanced ternary types:

  -- function TO_STRING (value : BTERN_ULOGIC) return STRING;
  -- function TO_STRING (value : BTERN_ULOGIC_VECTOR) return STRING;

  -- Read/write functions were skipped in this initial work

end bal_logic;