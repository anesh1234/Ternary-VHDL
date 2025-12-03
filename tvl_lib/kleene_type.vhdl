-- -----------------------------------------------------------------
--
--   Title     :  Type KLEENE package
--             :  (kleene package declaration)
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
package kleene_type is

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

  function COL (l : KLEENE) return KLEENE;
  function NTI (l : KLEENE) return KLEENE;
  function STI (l : KLEENE) return KLEENE;
  function MTI (l : KLEENE) return KLEENE;
  function INC (l : KLEENE) return KLEENE;
  function PTI (l : KLEENE) return KLEENE;
  function DEC (l : KLEENE) return KLEENE;
  function CLD (l : KLEENE) return KLEENE;
  function COM (l : KLEENE) return KLEENE;
  function IPT (l : KLEENE) return KLEENE;
  function IMT (l : KLEENE) return KLEENE;
  function BUF (l : KLEENE) return KLEENE;
  function CLU (l : KLEENE) return KLEENE;
  function INT (l : KLEENE) return KLEENE;
  function COH (l : KLEENE) return KLEENE;

  --------------------------------------------------------------------------------
  -- Vectorized 1-arity logical functions
  --------------------------------------------------------------------------------
  function COL (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NTI (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function STI (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MTI (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function INC (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function PTI (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function DEC (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function CLD (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function COM (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function IPT (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function IMT (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function BUF (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function CLU (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function INT (l : KLEENE_VECTOR) return KLEENE_VECTOR;
  function COH (l : KLEENE_VECTOR) return KLEENE_VECTOR;

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
  function SUM (l : KLEENE; r : KLEENE) return KLEENE;
  function CON (l : KLEENE; r : KLEENE) return KLEENE;
  function NCO (l : KLEENE; r : KLEENE) return KLEENE;
  function MINI (l : KLEENE; r : KLEENE) return KLEENE;
  function MAX (l : KLEENE; r : KLEENE) return KLEENE;
  function NMI (l : KLEENE; r : KLEENE) return KLEENE;
  function NMA (l : KLEENE; r : KLEENE) return KLEENE;
  function "XOR" (l : KLEENE; r : KLEENE) return KLEENE;
  function MUL (l : KLEENE; r : KLEENE) return KLEENE;
  function IMP (l : KLEENE; r : KLEENE) return KLEENE;
  function ANY (l : KLEENE; r : KLEENE) return KLEENE;
  function NAN (l : KLEENE; r : KLEENE) return KLEENE;
  function MLE (l : KLEENE; r : KLEENE) return KLEENE;
  function ENA (l : KLEENE; r : KLEENE) return KLEENE;
  function DES (l : KLEENE; r : KLEENE) return KLEENE;

  -------------------------------------------------------------------
  -- Vectorized 2-arity logical functions
  -------------------------------------------------------------------
  function SUM (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function SUM (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function SUM (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function CON (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function CON (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function CON (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function NCO (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NCO (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function NCO (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MINI (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MINI (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function MINI (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MAX (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MAX (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function MAX (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function NMI (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NMI (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function NMI (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function NMA (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NMA (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function NMA (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function "XOR" (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function "XOR" (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function "XOR" (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MUL (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MUL (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function MUL (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function IMP (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function IMP (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function IMP (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function ANY (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function ANY (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function ANY (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;
  
  function NAN (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function NAN (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function NAN (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function MLE (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function MLE (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function MLE (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function ENA (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function ENA (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function ENA (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  function DES (l, r : KLEENE_VECTOR) return KLEENE_VECTOR;
  function DES (l : KLEENE_VECTOR; r : KLEENE) return KLEENE_VECTOR;
  function DES (l : KLEENE; r : KLEENE_VECTOR) return KLEENE_VECTOR;

  -------------------------------------------------------------------
  -- shift operators
  -- sll - shift left logical, shifts the vector left by amount r
  -- srl - shift right logical, shifts the vector right by amount r
  -- sla/sra is skipped, they are not needed in balanced ternary
  -- rol - rotate left
  -- ror - rotate right
  -------------------------------------------------------------------

  function "sll" (l : KLEENE_VECTOR; r : INTEGER) return KLEENE_VECTOR;
  function "srl" (l : KLEENE_VECTOR; r : INTEGER) return KLEENE_VECTOR;
  function "rol" (l : KLEENE_VECTOR; r : INTEGER) return KLEENE_VECTOR;
  function "ror" (l : KLEENE_VECTOR; r : INTEGER) return KLEENE_VECTOR;

end package kleene_type;