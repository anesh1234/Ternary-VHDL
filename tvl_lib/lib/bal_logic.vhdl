-- -----------------------------------------------------------------
--
--   Title     :  Standard ternary logic package
--             :  (BTERN_LOGIC package declaration)
--             :
--   Library   :  This package shall be compiled into a library
--             :  symbolically named BTERN.
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
library TVL;
use TVL.kleene_pkg.all;

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
                        'B',       -- Weak -
                        'L',       -- Weak 0
                        'H',       -- Weak +
                        'D'        -- Don't care
                       );
  -------------------------------------------------------------------
  -- unconstrained array of tern_ulogic for use with the resolution function
  -- and for use in declaring signal arrays of unresolved elements
  -------------------------------------------------------------------
  type BTERN_ULOGIC_VECTOR is array (NATURAL range <>) of BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- resolution function
  -------------------------------------------------------------------
  function resolved (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- logic state system  (resolved)
  -------------------------------------------------------------------
  subtype BTERN_LOGIC is resolved BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- unconstrained array of resolved BTERN_ulogic for use in declaring
  -- signal arrays of resolved elements
  -------------------------------------------------------------------
  subtype BTERN_LOGIC_VECTOR is (resolved) BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Common subtypes
  -- Named e.g, "X2P" meaning "X to Plus"
  -------------------------------------------------------------------
  subtype TRIT is BTERN_ULOGIC range '-' to '+';
  type TRIT_VECTOR is array (NATURAL range <>) of TRIT;
  subtype X2P is resolved BTERN_ULOGIC range 'X' to '+';  -- ('X','-','0','+')
  subtype X2Z is resolved BTERN_ULOGIC range 'X' to 'Z';  -- ('X','-','0','+','Z')
  subtype U2P is resolved BTERN_ULOGIC range 'U' to '+';  -- ('U','X','-','0','+')
  subtype U2Z is resolved BTERN_ULOGIC range 'U' to 'Z';  -- ('U','X','-','0','+','Z')

  --------------------------------------------------------------------------------
  -- Scalar 1-arity logical functions. 
  --------------------------------------------------------------------------------
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
  --------------------------------------------------------------------------------

  function COL (l : BTERN_ULOGIC) return U2P;
  function NTI (l : BTERN_ULOGIC) return U2P;
  function STI (l : BTERN_ULOGIC) return U2P;
  function MTI (l : BTERN_ULOGIC) return U2P;
  function INC (l : BTERN_ULOGIC) return U2P;
  function PTI (l : BTERN_ULOGIC) return U2P;
  function DEC (l : BTERN_ULOGIC) return U2P;
  function CLD (l : BTERN_ULOGIC) return U2P;
  function COM (l : BTERN_ULOGIC) return U2P;
  function IPT (l : BTERN_ULOGIC) return U2P;
  function IMT (l : BTERN_ULOGIC) return U2P;
  function BUF (l : BTERN_ULOGIC) return U2P;
  function CLU (l : BTERN_ULOGIC) return U2P;
  function INT (l : BTERN_ULOGIC) return U2P;
  function COH (l : BTERN_ULOGIC) return U2P;

  --------------------------------------------------------------------------------
  -- Overloaded vectorized 1-arity logical functions
  --------------------------------------------------------------------------------
  function COL (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NTI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function STI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MTI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function INC (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function PTI (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function DEC (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function CLD (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function COM (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function IPT (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function IMT (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function BUF (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function CLU (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function INT (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function COH (l : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  --------------------------------------------------------------------------------
  -- Scalar 2-arity logical functions. 
  --------------------------------------------------------------------------------
  -- Listed below with their respective heptavintimal index in brackets [],
  -- their function names in parenthesis (), then any aliases:

  -- [7PB] (SUM), TRISHIFT (DEC,BUF,INC)
  -- [RDC] CONSENSUS (CON) 
  -- [4DE] NCONS (NCO)
  -- [PC0] Minimum (MINI), Ternary AND
  -- [ZRP] Maximum (MAX), Ternary OR
  -- [045] NMIN (NMI) 
  -- [5EZ] NMAX (NMA)
  -- [5DP] XOR, overload of predefined logical operator
  -- [PD5] MULTIPLY (MUL), DIVIDE (div/0 is 0)
  -- [PRZ] IMPLICATION (IMP), Kleene Logic version
  -- [XP9] ANY 
  -- [15H] NANY (NAN)
  -- [H51] COMPARE, MORE,LESS,EQUAL (MLE)
  -- [RD4] ENABLE (ENA), ENABLE w/ binary
  -- [VP0] DESELECT (DES), A or B, with one being !ENABLE
  --------------------------------------------------------------------------------
  function SUM (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function CON (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function NCO (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function MINI (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function MAX (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function NMI (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function NMA (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function "XOR" (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function MUL (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function IMP (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function ANY (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function NAN (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function MLE (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function ENA (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;
  function DES (l : BTERN_ULOGIC; r : BTERN_ULOGIC) return U2P;

  -------------------------------------------------------------------
  -- Vectorized 2-arity logical functions
  -------------------------------------------------------------------
  function SUM (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function SUM (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function SUM (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function CON (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function CON (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function CON (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function NCO (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NCO (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NCO (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function MINI (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MINI (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MINI (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function MAX (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MAX (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MAX (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function NMI (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NMI (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NMI (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function NMA (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NMA (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NMA (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "XOR" (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "XOR" (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function "XOR" (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function MUL (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MUL (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MUL (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function IMP (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function IMP (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function IMP (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function ANY (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function ANY (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function ANY (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function NAN (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function NAN (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function NAN (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function MLE (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function MLE (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function MLE (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function ENA (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function ENA (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function ENA (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function DES (l, r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function DES (l : BTERN_ULOGIC_VECTOR; r : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function DES (l : BTERN_ULOGIC; r : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- shift operators
  -- sll - shift left logical, shifts the vector left by amount r
  -- srl - shift right logical, shifts the vector right by amount r
  -- sla/sra is skipped, they are not needed in balanced ternary
  -- rol - rotate left
  -- ror - rotate right
  -------------------------------------------------------------------

  function "sll" (l : BTERN_ULOGIC_VECTOR; r : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "srl" (l : BTERN_ULOGIC_VECTOR; r : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "rol" (l : BTERN_ULOGIC_VECTOR; r : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "ror" (l : BTERN_ULOGIC_VECTOR; r : INTEGER) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- conversion functions and strength strippers
  -- All functions related to the BIT type in the IEEE library
  -- have been skipped due to the absence of a completely defined
  -- TRIT type. Functions for this type can be created later if
  -- needed, but was skipped in this work.
  -------------------------------------------------------------------
  function RESIZE (ARG : BTERN_ULOGIC_VECTOR; NEW_SIZE : NATURAL)
  return BTERN_ULOGIC_VECTOR;

  function To_BALTERN (ARG : INTEGER; SIZE : NATURAL) 
  return BTERN_ULOGIC_VECTOR;

  function To_INT (ARG : BTERN_ULOGIC_VECTOR) return INTEGER;

  function To_TernLogicVector (s : BTERN_ULOGIC_VECTOR)
  return BTERN_LOGIC_VECTOR;
  function To_TernULogicVector (s : BTERN_LOGIC_VECTOR)
  return BTERN_ULOGIC_VECTOR;

  alias To_TLV is
    To_TernLogicVector[BTERN_ULOGIC_VECTOR return BTERN_LOGIC_VECTOR];

  alias To_TULV is
    To_TernULogicVector[BTERN_LOGIC_VECTOR return BTERN_ULOGIC_VECTOR];

  function To_M2P (s : BTERN_ULOGIC_VECTOR; xmap : BTERN_ULOGIC := '0')
    return BTERN_ULOGIC_VECTOR;
  function To_M2P (s : BTERN_ULOGIC; xmap : BTERN_ULOGIC := '0')
    return BTERN_ULOGIC;

  function To_X2P (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function To_X2P (s : BTERN_ULOGIC) return X2P;

  function To_X2Z (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function To_X2Z (s : BTERN_ULOGIC) return X2Z;

  function To_U2P (s : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function To_U2P (s : BTERN_ULOGIC) return U2P;

  -------------------------------------------------------------------
  -- Overload of the condition operator
  -------------------------------------------------------------------
  function "??" (l : BTERN_ULOGIC) return KLEENE;
  -- '-' or 'B' returns FALSE
  -- '+' or 'H' returns TRUE
  -- All others returns UNKNOWN
  
  -------------------------------------------------------------------
  -- edge detection
  -- mz - minus to zero
  -- pm - plus to minus
  -------------------------------------------------------------------
  function any_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN;
  function mz_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN;
  function zp_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN;
  function mp_rising_edge (signal s : BTERN_ULOGIC) return BOOLEAN;

  function any_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN;
  function pz_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN;
  function zm_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN;
  function pm_falling_edge (signal s : BTERN_ULOGIC) return BOOLEAN;

  -------------------------------------------------------------------
  -- object contains an unknown
  -------------------------------------------------------------------
  function Is_X (s : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function Is_X (s : BTERN_ULOGIC) return BOOLEAN;

  ------------------------------------------------------------------------
  -- ordinary relational operators
  ------------------------------------------------------------------------

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

  function "/=" (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "/=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BOOLEAN;
  function "/=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BOOLEAN;

  -- The "spaceship" operator
  -- Must be called as SPACE(A, B) as of now, but should ideally
  -- be callable as A <=> B in future implementations.
  -- For this to be possible, the symbols "<=>" must first be
  -- defined in the compiler as an operator, then that operator 
  -- can be overloaded here.
  function SPACE (L, R : BTERN_ULOGIC) return KLEENE;
  function SPACE (L, R : BTERN_ULOGIC_VECTOR) return KLEENE;
  function SPACE (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return KLEENE;
  function SPACE (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return KLEENE;

  -------------------------------------------------------------------
  -- matching relational operator overloads
  -------------------------------------------------------------------
  function "?>" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?<" (L, R  : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?<=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?<=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?>=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?>=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  function "?/=" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?/=" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function "?/=" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;
  
  -- Matching spaceship operator
  function M_SPACE (L, R : BTERN_ULOGIC) return BTERN_ULOGIC;
  function M_SPACE (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function M_SPACE (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;
  function M_SPACE (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC;

  -------------------------------------------------------------------
  -- MINIMUM overloads for array type
  -------------------------------------------------------------------
  
  function MINIMUM (L, R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MINIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MINIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- MAXIMUM overloads for array type
  -------------------------------------------------------------------

  function MAXIMUM (L, R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MAXIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MAXIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR;


  -------------------------------------------------------------------
  -- string conversion and read/write functions
  -------------------------------------------------------------------
  -- the following operations are predefined

  -- function TO_STRING (value : STD_ULOGIC) return STRING;
  -- function TO_STRING (value : STD_ULOGIC_VECTOR) return STRING;

  -- IEEE.std_logic_1164 uses 
  -- TO_OSTRING (VALUE : STD_ULOGIC_VECTOR) (to octal string) and
  -- TO_HSTRING (VALUE : STD_ULOGIC_VECTOR) (to hexadecimal string)
  -- then respective OREAD and HREAD procedures

  -- -- I think, for ternary, it is needed:
  -- function TO_STRING (value : BTERN_ULOGIC) return STRING;
  -- function TO_STRING (value : BTERN_ULOGIC_VECTOR) return STRING;

  -- function TO_HEPSTRING (value : BTERN_ULOGIC_VECTOR) return STRING;

  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC; GOOD : out BOOLEAN);
  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC);

  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  -- procedure READ (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR);

  -- procedure WRITE (L : inout LINE; VALUE : in BTERN_ULOGIC;
  -- --                 JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

  -- procedure WRITE (L : inout LINE; VALUE : in BTERN_ULOGIC_VECTOR;
  -- --                 JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

  -- procedure HEPREAD (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  -- procedure HEPREAD (L : inout LINE; VALUE : out BTERN_ULOGIC_VECTOR);
  -- procedure HEPWRITE (L : inout LINE; VALUE : in BTERN_ULOGIC_VECTOR;
  --                  JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);


end bal_logic;