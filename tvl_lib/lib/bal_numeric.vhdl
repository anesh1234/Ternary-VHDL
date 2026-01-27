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

  ------------------------------------------------------------------------
  -- Overloads of the "+" predefined operator
  ------------------------------------------------------------------------

  function "+" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "+" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;

  function "+" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "+" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  
  function "+" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  ------------------------------------------------------------------------
  -- Overloads of the "-" predefined operator
  ------------------------------------------------------------------------

  function "-" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "-" (L : BTERN_ULOGIC_VECTOR; R : BTERN_ULOGIC) return BTERN_ULOGIC_VECTOR;
  
  function "-" (L : BTERN_ULOGIC; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  
  function "-" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;
  
  function "-" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;
  
  ------------------------------------------------------------------------
  -- Overloads of the "*" predefined operator
  ------------------------------------------------------------------------

  function "*" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "*" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;

  function "*" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  ------------------------------------------------------------------------
  -- Overloads of the "/" predefined operator
  ------------------------------------------------------------------------

  function "/" (L, R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

  function "/" (L : BTERN_ULOGIC_VECTOR; R : INTEGER) return BTERN_ULOGIC_VECTOR;

  function "/" (L : INTEGER; R : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;


  

  function "abs" (L : BTERN_ULOGIC_VECTOR) return BTERN_ULOGIC_VECTOR;

end package bal_numeric;