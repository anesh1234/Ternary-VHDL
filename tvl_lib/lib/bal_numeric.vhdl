-- -----------------------------------------------------------------
--
--   Title     :  Standard ternary logic package
--             :  (BAL_NUMERIC package declaration)
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
use TVL.bal_logic.all;

package bal_numeric is

  -------------------------------------------------------------------
  -- Arithmetic operators for simplification
  -------------------------------------------------------------------

  function "abs" (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "-" (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Overloads of the "+" predefined operator.
  -------------------------------------------------------------------
  -- As in the IEEE library, the arithmetic functions + and – returns
  -- a value with the same number of elements (trits) as the larger 
  -- of the two operands. If one operand is BTERN_(U)LOGIC_VECTOR and
  -- the other is INTEGER, the function returns a value with the same 
  -- number of elements as the vector operand. Thus, these functions do 
  -- not return an extra trit to represent a carry, borrow, or overflow 
  -- value, nor do they generate a warning if a carry, borrow, or 
  -- overflow occurs. Returns a null-vector if one operand is a null
  -- vector, in all overloads.

  function "+" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "+" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function "+" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "+" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "+" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Overloads of the "-" predefined operator.
  -------------------------------------------------------------------
  -- See note on the "+" operator for more info.

  function "-" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "-" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  function "-" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "-" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "-" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  
  -------------------------------------------------------------------
  -- Overloads of the "*" predefined operator
  -------------------------------------------------------------------
  -- Multiplies vectors of possibly different lengths, returns a vector
  -- of width L'length + R'length - 1. When using integers, the integers
  -- are first converted to BTERN_ULOGIC_VECTORs, forced to the same 
  -- size as the vector argument, thus making overflow possible. 
  -- This is the same behavior as in IEEE.numeric_std.

  function "*" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "*" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "*" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Overloads of the "/" predefined operator
  -------------------------------------------------------------------
  -- Returns the integer quotient of the same length as the dividend 
  -- when both operands are btern, or the largest of the two when 
  -- converting the integer to btern.

  function "/" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "/" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "/" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Overloads of "rem" operator.
  -------------------------------------------------------------------
  -- Returns the remainder of division forced to the same sign as 
  -- the dividend, equivalent to remainder of Truncating division.
  -- When called with integer and vector, the result is
  -- truncated to the vector's length. If the divisor is zero,
  -- a severity level of ERROR is issued.

  function "rem" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "rem" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "rem" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Overloads of "mod" operator.
  -------------------------------------------------------------------
  -- Returns the remainder of division forced to the same sign as 
  -- the divisor, equivalent to remainder of Flooring division. 
  -- When called with integer and vector, the result is
  -- truncated to the vector's length. If the divisor is zero,
  -- a severity level of ERROR is issued.

  function "mod" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function "mod" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function "mod" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Functions for use like the "/" predefined operator. 
  -- Returns the quotient of Euclidean division.
  -------------------------------------------------------------------

  function BTEDIV (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function BTEDIV (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function BTEDIV (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Functions for use like the "rem" or "mod" predefined operators. 
  -- Returns the remainder of Euclidean division.
  -------------------------------------------------------------------

  function BTEMOD (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  function BTEMOD (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  function BTEMOD (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Other attempts of division, and VHDL-versions of the 
  -- algorithms proposed by Jones.
  -------------------------------------------------------------------

  procedure JONES1 (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                     XQUO, XREM : out BTERN_ULOGIC_VECTOR);

  procedure JONES2 (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                    XQUO, XREM : out BTERN_ULOGIC_VECTOR);

  procedure DIV_TESTING (DIVIDEND, DIVISOR : BTERN_ULOGIC_VECTOR;
                    XQUO, XREM : out BTERN_ULOGIC_VECTOR);

  -------------------------------------------------------------------
  -- find_ functions
  -------------------------------------------------------------------
  -- Finds the leftmost occurrence of the value of Y in ARG.
  -- Returns the index of the occurrence if it exists,
  -- returns -1 otherwise.

  function find_leftmost (ARG : BTERN_ULOGIC_VECTOR; Y : BTERN_ULOGIC) return INTEGER;
  function find_rightmost (ARG : BTERN_ULOGIC_VECTOR; Y : BTERN_ULOGIC) return INTEGER;

  -------------------------------------------------------------------
  -- MINIMUM and MAXIMUM functions
  -------------------------------------------------------------------
  
  function MINIMUM (L, R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MINIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MINIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR;

  function MAXIMUM (L, R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MAXIMUM (L : INTEGER; R : BTERN_ULOGIC_VECTOR) 
  return BTERN_ULOGIC_VECTOR;

  function MAXIMUM (L : BTERN_ULOGIC_VECTOR; R : INTEGER) 
  return BTERN_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- Local subprograms
  -------------------------------------------------------------------
  -- Visible here only for verification purposes, 
  -- should maybe not be visible?

  -- Returns the leftmost non-zero element's value i.e., 
  -- the sign-trit
  function LEFTMOST_NZ (ARG : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC;

  -- Returns the number of balanced trits necessary to 
  -- express any decimal integer.
  function NUM_BTRITS (ARG : INTEGER) return NATURAL;

  -------------------------------------------------------------------
  -- STD_MATCH functions
  -------------------------------------------------------------------
  -- provides “don’t care” or “wild card” testing of values based on the
  -- BTERN_ULOGIC type.

  function STD_MATCH (L, R : BTERN_ULOGIC) return BOOLEAN;
  function STD_MATCH (L, R : BTERN_ULOGIC_VECTOR) return BOOLEAN;


end package bal_numeric;