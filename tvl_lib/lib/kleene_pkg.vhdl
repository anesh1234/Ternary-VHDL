-- -----------------------------------------------------------------
--
--   Title     :  Kleene package (declaration)
--             :
--   Library   :  This package shall be compiled into a library
--             :  symbolically named TVL.
--             :
--   Developers:  Anders Mørk Minde, University of South Eastern Norway
--             :
--   Purpose   :  This packages defines the type KLEENE
--             :
--   Limitation:  
--             :
--   Note      :  
--             :
-- --------------------------------------------------------------------
-- $Revision: 1 $
-- $Date: 2025-07-10 (Tue, 10 Oct 2025) $
-- --------------------------------------------------------------------

package kleene_pkg is

  type KLEENE is (FALSE, UNK, TRUE);
  type KLEENE_VECTOR is array (NATURAL range <>) of KLEENE;

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

  function COL (L : KLEENE) return KLEENE;
  function NTI (L : KLEENE) return KLEENE;
  function STI (L : KLEENE) return KLEENE;
  function MTI (L : KLEENE) return KLEENE;
  function INC (L : KLEENE) return KLEENE;
  function PTI (L : KLEENE) return KLEENE;
  function DEC (L : KLEENE) return KLEENE;
  function CLD (L : KLEENE) return KLEENE;
  function COM (L : KLEENE) return KLEENE;
  function IPT (L : KLEENE) return KLEENE;
  function IMT (L : KLEENE) return KLEENE;
  function BUF (L : KLEENE) return KLEENE;
  function CLU (L : KLEENE) return KLEENE;
  function INT (L : KLEENE) return KLEENE;
  function COH (L : KLEENE) return KLEENE;

  --------------------------------------------------------------------------------
  -- Vectorized 1-arity logical functions
  --------------------------------------------------------------------------------
  function COL (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NTI (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function STI (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MTI (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function INC (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function PTI (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function DEC (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function CLD (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function COM (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function IPT (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function IMT (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function BUF (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function CLU (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function INT (L : KLEENE_VECTOR) return KLEENE_VECTOR;
  function COH (L : KLEENE_VECTOR) return KLEENE_VECTOR;

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
  -- [5DP] XOR, already predefined for binary logic, thus overloading
  -- [PD5] MULTIPLY (MUL), DIVIDE (div/0 is 0)
  -- [PRZ] IMPLICATION (IMP), Kleene Logic version
  -- [XP9] ANY 
  -- [15H] NANY (NAN)
  -- [H51] COMPARE, MORE,LESS,EQUAL (MLE)
  -- [RD4] ENABLE (ENA), ENABLE w/ binary
  -- [VP0] DESELECT (DES), A or B, with one being !ENABLE
  --------------------------------------------------------------------------------
  function SUM   (L, R : KLEENE) return KLEENE;
  function CON   (L, R : KLEENE) return KLEENE;
  function NCO   (L, R : KLEENE) return KLEENE;
  function MINI  (L, R : KLEENE) return KLEENE;
  function MAX   (L, R : KLEENE) return KLEENE;
  function NMI   (L, R : KLEENE) return KLEENE;
  function NMA   (L, R : KLEENE) return KLEENE;
  function "XOR" (L, R : KLEENE) return KLEENE;
  function MUL   (L, R : KLEENE) return KLEENE;
  function IMP   (L, R : KLEENE) return KLEENE;
  function ANY   (L, R : KLEENE) return KLEENE;
  function NAN   (L, R : KLEENE) return KLEENE;
  function MLE   (L, R : KLEENE) return KLEENE;
  function ENA   (L, R : KLEENE) return KLEENE;
  function DES   (L, R : KLEENE) return KLEENE;

  -------------------------------------------------------------------
  -- Vectorized 2-arity logical functions
  -------------------------------------------------------------------
  function SUM (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function SUM (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function SUM (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function CON (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function CON (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function CON (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function NCO (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NCO (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function NCO (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MINI (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MINI (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function MINI (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MAX (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MAX (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function MAX (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function NMI (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NMI (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function NMI (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function NMA (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NMA (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function NMA (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function "XOR" (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function "XOR" (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function "XOR" (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MUL (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MUL (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function MUL (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function IMP (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function IMP (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function IMP (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function ANY (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function ANY (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function ANY (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;
  
  function NAN (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NAN (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function NAN (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MLE (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MLE (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function MLE (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function ENA (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function ENA (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function ENA (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  function DES (L, R : KLEENE_VECTOR) return KLEENE_VECTOR;
  function DES (L : KLEENE_VECTOR; R : KLEENE) return KLEENE_VECTOR;
  function DES (L : KLEENE; R : KLEENE_VECTOR) return KLEENE_VECTOR;

  -------------------------------------------------------------------
  -- The "spaceship" operator
  -- Must be called as SPACE(A, B) as of now, but should ideally
  -- be callable as A <=> B in future implementations.
  -- For this to be possible, the symbols "<=>" must first be
  -- defined in a compiler as an operator, then that operator 
  -- can be overloaded here.
  -------------------------------------------------------------------

  function SPACE (L, R : KLEENE) return KLEENE;
  function SPACE (L, R : KLEENE_VECTOR) return KLEENE;

  --=================================================================
  -- Overloads of matching relational operators
  --=================================================================

  function "?=" (L, R  : KLEENE_VECTOR) return KLEENE;
  function "?/=" (L, R  : KLEENE_VECTOR) return KLEENE;

  -------------------------------------------------------------------
  -- shift operators
  -- sll - shift left logical, shifts the vector left by amount R
  -- srl - shift right logical, shifts the vector right by amount R
  -- sla/sra is skipped, they are not needed in balanced ternary
  -- rol - rotate left
  -- ror - rotate right
  -------------------------------------------------------------------

  function "sll" (L : KLEENE_VECTOR; R : INTEGER) return KLEENE_VECTOR;
  function "srl" (L : KLEENE_VECTOR; R : INTEGER) return KLEENE_VECTOR;
  function "rol" (L : KLEENE_VECTOR; R : INTEGER) return KLEENE_VECTOR;
  function "ror" (L : KLEENE_VECTOR; R : INTEGER) return KLEENE_VECTOR;

  -------------------------------------------------------------------
  -- edge detection
  -- mz - minus to zero
  -- pm - plus to minus
  -- Only interested in true/false, therefore returning BOOLEAN.
  -- This decision also makes the functions compatible 
  -- with if-tests and assertions
  -------------------------------------------------------------------

  function any_rising_edge (signal S : KLEENE) return BOOLEAN;
  function mz_rising_edge  (signal S : KLEENE) return BOOLEAN;
  function zp_rising_edge  (signal S : KLEENE) return BOOLEAN;
  function mp_rising_edge  (signal S : KLEENE) return BOOLEAN;

  function any_falling_edge (signal S : KLEENE) return BOOLEAN;
  function pz_falling_edge  (signal S : KLEENE) return BOOLEAN;
  function zm_falling_edge  (signal S : KLEENE) return BOOLEAN;
  function pm_falling_edge  (signal S : KLEENE) return BOOLEAN;

  -------------------------------------------------------------------
  -- conversion functions
  -------------------------------------------------------------------

  function TO_KLEENE (ARG : BOOLEAN) return KLEENE;
  function TO_KLEENE (ARG : BOOLEAN_VECTOR) return KLEENE_VECTOR;

  -- Lossy conversion warning; if encountered, 
  -- these convert UNK to FALSE 
  function TO_BOOLEAN (ARG : KLEENE) return BOOLEAN;
  function TO_BOOLEAN (ARG : KLEENE_VECTOR) return BOOLEAN_VECTOR;

end package kleene_pkg;