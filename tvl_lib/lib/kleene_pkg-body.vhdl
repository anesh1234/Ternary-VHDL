-- -----------------------------------------------------------------
--
--   Title     :  Kleene package (body)
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
package body kleene_pkg is
  -------------------------------------------------------------------
  -- local types
  -------------------------------------------------------------------
  type kleene_1d is array (KLEENE) of KLEENE;
  type kleene_table is array(KLEENE, KLEENE) of KLEENE;

  --=================================================================
  -- Tables for 1-arity logical functions, preceded by 
  -- their respective heptavintimal index in brackets []
  --=================================================================

  -- truth table for [0], CONST_LOW
  constant col_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (FALSE, FALSE, FALSE);
  
  -- truth table for [2], Negative Ternary Inverter
  constant nti_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (TRUE,  FALSE, FALSE);

  -- truth table for [5], Standard Ternary Inverter
  constant sti_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (TRUE,  UNK,   FALSE);

  -- truth table for [6], Middle Toggling Inverter, DETECT_MIDDLE
  constant mti_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (FALSE, TRUE,  FALSE);

  -- truth table for [7], Increment, NEXT, SUCCESSOR
  constant inc_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (UNK,   TRUE,  FALSE);

  -- truth table for [8], Positive Ternary Inverter
  constant pti_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (TRUE,  TRUE,  FALSE);

  -- truth table for [B], DECREMENT, PREV, PREDECESSOR
  constant dec_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (TRUE,  FALSE, UNK);

  -- truth table for [C], CLAMP_DOWN
  constant cld_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (FALSE, UNK,   UNK);

  -- truth table for [D], CONST_MIDDLE
  constant com_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (UNK,   UNK,   UNK);

  -- truth table for [K], Inverted PTI, DETECT_HIGH
  constant ipt_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (FALSE, FALSE, TRUE);

  -- truth table for [N], Inverted MTI, inverted DETECT_MIDDLE
  constant imt_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (TRUE,  FALSE, TRUE);

  -- truth table for [P], BUFFER
  constant buf_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (FALSE, UNK,   TRUE);

  -- truth table for [R], CLAMP_UP
  constant clu_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (UNK,   UNK,   TRUE);

  -- truth table for [V], Inverted NTI
  constant int_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (FALSE, TRUE,  TRUE);

  -- truth table for [Z], CONST_HIGH
  constant coh_table : kleene_1d :=
    -- -----------------------------
    -- |  FALSE    UNK      TRUE  |
    -- -----------------------------  
        (TRUE,  TRUE,  TRUE);

  --=================================================================
  -- Tables for 2-arity logical functions, preceded by 
  -- their respective heptavintimal index in brackets []
  --=================================================================
 
  -- [7PB] (SUM), TRISHIFT (DEC,BUF,INC)
  constant sum_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------    
         (TRUE,  FALSE, UNK  ),  -- | FALSE |
         (FALSE, UNK,   TRUE ),  -- | UNK   |
         (UNK,   TRUE,  FALSE)   -- | TRUE  |
         );

  -- [RDC] CONSENSUS (CON)
  constant con_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------      
         (FALSE, UNK,   UNK  ),  -- | FALSE |
         (UNK,   UNK,   UNK  ),  -- | UNK   |
         (UNK,   UNK,   TRUE )   -- | TRUE  |
         );

  -- [4DE] NCONS (NCO)
  constant nco_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------     
         (TRUE,  UNK,   UNK  ),  -- | FALSE |
         (UNK,   UNK,   UNK  ),  -- | UNK   |
         (UNK,   UNK,   FALSE)   -- | TRUE  |
         );
 
  -- [PC0] Minimum (MINI), Ternary A 
  constant min_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------     
         (FALSE, FALSE, FALSE),  -- | FALSE |
         (FALSE, UNK,   UNK  ),  -- | UNK   |
         (FALSE, UNK,   TRUE )   -- | TRUE  |
         ); 
 
  -- [ZRP] Maximum (MAX), Ternary OR
  constant max_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------     
         (FALSE, UNK,   TRUE ),  -- | FALSE |
         (UNK,   UNK,   TRUE ),  -- | UNK   |
         (TRUE,  TRUE,  TRUE )   -- | TRUE  |
         ); 

  -- [045] NMIN (NMI)
  constant nmi_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------    
         (TRUE,  UNK,   FALSE),  -- | FALSE |
         (UNK,   UNK,   FALSE),  -- | UNK   |
         (FALSE, FALSE, FALSE)   -- | TRUE  |
         ); 

  -- [5EZ] NMAX (NMA)
  constant nma_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------      
         (TRUE,  TRUE,  TRUE ),  -- | FALSE |
         (TRUE,  UNK,   UNK  ),  -- | UNK   |
         (TRUE,  UNK,   FALSE)   -- | TRUE  |
         ); 

  -- [5DP] XOR
  constant tern_xor_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------    
         (FALSE, UNK,   TRUE ),  -- | FALSE |
         (UNK,   UNK,   UNK  ),  -- | UNK   |
         (TRUE,  UNK,   FALSE)   -- | TRUE  |
         );

  -- [PD5] MULTIPLY (MUL)
  constant mul_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------      
         (TRUE,  UNK,   FALSE),  -- | FALSE |
         (UNK,   UNK,   UNK  ),  -- | UNK   |
         (FALSE, UNK,   TRUE )   -- | TRUE  |
         );

  -- [PRZ] IMPLICATION (IMP)
  constant imp_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------    
         (TRUE,  TRUE,  TRUE ),  -- | FALSE |
         (UNK,   UNK,   TRUE ),  -- | UNK   |
         (FALSE, UNK,   TRUE )   -- | TRUE  |
         ); 

  -- [XP9] ANY
  constant any_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------     
         (FALSE, FALSE, UNK  ),  -- | FALSE |
         (FALSE, UNK,   TRUE ),  -- | UNK   |
         (UNK,   TRUE,  TRUE )   -- | TRUE  |
         ); 

  -- [15H] NANY (NAN)
  constant nan_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------     
         (TRUE,  TRUE,  UNK  ),  -- | FALSE |
         (TRUE,  UNK,   FALSE),  -- | UNK   |
         (UNK,   FALSE, FALSE)   -- | TRUE  |
         ); 

  -- [H51] COMPARE, MORE,LESS,EQUAL (MLE)
  constant mle_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------     
         (UNK,   FALSE, FALSE),  -- | FALSE |
         (TRUE,  UNK,   FALSE),  -- | UNK   |
         (TRUE,  TRUE,  UNK  )   -- | TRUE  |
         ); 

  -- [RD4] ENABLE (ENA)
  constant ena_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------      
         (UNK,   UNK,   FALSE),  -- | FALSE |
         (UNK,   UNK,   UNK  ),  -- | UNK   |
         (UNK,   UNK,   TRUE )   -- | TRUE  |
         ); 

  -- [VP0] DESELECT (DES)
  constant des_table : kleene_table := (
    -- -----------------------------
    -- |   FALSE    UNK      TRUE  |
    -- -----------------------------     
         (FALSE, FALSE, FALSE),  -- | FALSE |
         (FALSE, UNK,   TRUE ),  -- | UNK   |
         (FALSE, TRUE,  TRUE )   -- | TRUE  |
         ); 

  --=================================================================
  -- Ternary 1-arity logical functions for scalar and vector types, 
  -- preceded by their respective heptavintimal index in brackets [].
  --=================================================================

  -------------------------------------------------------------------
  -- [0], CONST_LOW
  -------------------------------------------------------------------
  function COL (l : KLEENE) return KLEENE is
  begin
    return (col_table(l));
  end function COL;
  ------------------------------------------------------------------- 
  function COL (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := col_table(lv(i));
    end loop;
    return result;
  end function COL;

  -------------------------------------------------------------------
  -- [2], Negative Ternary Inverter, DETECT_LOW
  -------------------------------------------------------------------
  function NTI (l : KLEENE) return KLEENE is
  begin
    return (nti_table(l));
  end function NTI;
  -------------------------------------------------------------------
  function NTI (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nti_table(lv(i));
    end loop;
    return result;
  end function NTI;

  -------------------------------------------------------------------
  -- [5], Standard Ternary Inverter
  -------------------------------------------------------------------
  function STI (l : KLEENE) return KLEENE is
  begin
    return (sti_table(l));
  end function STI;
  -------------------------------------------------------------------
  function STI (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := sti_table(lv(i));
    end loop;
    return result;
  end function STI;

  -------------------------------------------------------------------
  -- [6], Middle Toggling Inverter, DETECT_MIDDLE
  -------------------------------------------------------------------
  function MTI (l : KLEENE) return KLEENE is
  begin
    return (mti_table(l));
  end function MTI;
  -------------------------------------------------------------------
  function MTI (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := mti_table(lv(i));
    end loop;
    return result;
  end function MTI;

  -------------------------------------------------------------------
  -- [7], Increment, NEXT, SUCCESSOR
  -------------------------------------------------------------------
  function INC (l : KLEENE) return KLEENE is
  begin
    return (inc_table(l));
  end function INC;
  -------------------------------------------------------------------
  function INC (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := inc_table(lv(i));
    end loop;
    return result;
  end function INC;

  -------------------------------------------------------------------
  -- [8], Positive Ternary Inverter
  -------------------------------------------------------------------
  function PTI (l : KLEENE) return KLEENE is
  begin
    return (pti_table(l));
  end function PTI;
  -------------------------------------------------------------------
  function PTI (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := pti_table(lv(i));
    end loop;
    return result;
  end function PTI;

  -------------------------------------------------------------------
  -- [B], DECREMENT, PREV, PREDECESSOR
  -------------------------------------------------------------------
  function DEC (l : KLEENE) return KLEENE is
  begin
    return (dec_table(l));
  end function DEC;
  -------------------------------------------------------------------
  function DEC (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := dec_table(lv(i));
    end loop;
    return result;
  end function DEC;

  -------------------------------------------------------------------
  -- [C], CLAMP_DOWN
  -------------------------------------------------------------------
  function CLD (l : KLEENE) return KLEENE is
  begin
    return (cld_table(l));
  end function CLD;
  -------------------------------------------------------------------
  function CLD (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := cld_table(lv(i));
    end loop;
    return result;
  end function CLD;

  -------------------------------------------------------------------
  -- [D], CONST_MIDDLE
  -------------------------------------------------------------------
  function COM (l : KLEENE) return KLEENE is
  begin
    return (com_table(l));
  end function COM;
  -------------------------------------------------------------------
  function COM (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := com_table(lv(i));
    end loop;
    return result;
  end function COM;

  -------------------------------------------------------------------
  -- [K], Inverted PTI, DETECT_HIGH
  -------------------------------------------------------------------
  function IPT (l : KLEENE) return KLEENE is
  begin
    return (ipt_table(l));
  end function IPT;
  -------------------------------------------------------------------
  function IPT (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := ipt_table(lv(i));
    end loop;
    return result;
  end function IPT;

  -------------------------------------------------------------------
  -- [N], Inverted MTI, inverted DETECT_MIDDLE
  -------------------------------------------------------------------
  function IMT (l : KLEENE) return KLEENE is
  begin
    return (imt_table(l));
  end function IMT;
  -------------------------------------------------------------------
  function IMT (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := imt_table(lv(i));
    end loop;
    return result;
  end function IMT;

  -------------------------------------------------------------------
  -- [P], BUFFER
  -------------------------------------------------------------------
  function BUF (l : KLEENE) return KLEENE is
  begin
    return (buf_table(l));
  end function BUF;
  -------------------------------------------------------------------
  function BUF (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := buf_table(lv(i));
    end loop;
    return result;
  end function BUF;

  -------------------------------------------------------------------
  -- [R], CLAMP_UP
  -------------------------------------------------------------------
  function CLU (l : KLEENE) return KLEENE is
  begin
    return (clu_table(l));
  end function CLU;
  -------------------------------------------------------------------
  function CLU (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := clu_table(lv(i));
    end loop;
    return result;
  end function CLU;

  -------------------------------------------------------------------
  -- [V], Inverted NTI
  -------------------------------------------------------------------
  function INT (l : KLEENE) return KLEENE is
  begin
    return (int_table(l));
  end function INT;
  -------------------------------------------------------------------
  function INT (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := int_table(lv(i));
    end loop;
    return result;
  end function INT;

  -------------------------------------------------------------------
  -- [Z], CONST_HIGH
  -------------------------------------------------------------------
  function COH (l : KLEENE) return KLEENE is
  begin
    return (coh_table(l));
  end function COH;
  -------------------------------------------------------------------
  function COH (l : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := coh_table(lv(i));
    end loop;
    return result;
  end function COH;

  --=================================================================
  -- Ternary 2-arity logical functions for scalar and vector types, 
  -- preceded by their respective heptavintimal index in brackets [].
  --=================================================================

  -------------------------------------------------------------------
  -- [7PB] SUM, TRISHIFT (DEC,BUF,INC)
  -------------------------------------------------------------------

  function SUM (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (sum_table(l, r));
  end function SUM;
  -------------------------------------------------------------------

  function SUM (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.SUM: "
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

  function SUM (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := sum_table (lv(i), r);
    end loop;
    return result;
  end function SUM;
  -------------------------------------------------------------------

  function SUM (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := sum_table (l, rv(i));
    end loop;
    return result;
  end function SUM;

  -------------------------------------------------------------------
  -- [RDC] CONSENSUS (CON)
  -------------------------------------------------------------------

  function CON (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (con_table(l, r));
  end function CON;
  -------------------------------------------------------------------

  function CON (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.CON: "
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

  function CON (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := con_table (lv(i), r);
    end loop;
    return result;
  end function CON;
  -------------------------------------------------------------------

  function CON (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := con_table (l, rv(i));
    end loop;
    return result;
  end function CON;

  -------------------------------------------------------------------
  -- [4DE] NCONS (NCO)
  -------------------------------------------------------------------

  function NCO (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (nco_table(l, r));
  end function NCO;
  -------------------------------------------------------------------

  function NCO (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.NCO: "
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

  function NCO (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nco_table (lv(i), r);
    end loop;
    return result;
  end function NCO;
  -------------------------------------------------------------------

  function NCO (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nco_table (l, rv(i));
    end loop;
    return result;
  end function NCO;

  -------------------------------------------------------------------
  -- [PC0] Minimum (MINI)
  -------------------------------------------------------------------

  function MINI (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (min_table(l, r));
  end function MINI;
  -------------------------------------------------------------------

  function MINI (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.MINI: "
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

  function MINI (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := min_table (lv(i), r);
    end loop;
    return result;
  end function MINI;
  -------------------------------------------------------------------

  function MINI (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := min_table (l, rv(i));
    end loop;
    return result;
  end function MINI;

  -------------------------------------------------------------------
  -- [ZRP] Maximum (MAX)
  -------------------------------------------------------------------

  function MAX (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (max_table(l, r));
  end function MAX;
  -------------------------------------------------------------------

  function MAX (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.MAX: "
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

  function MAX (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := max_table (lv(i), r);
    end loop;
    return result;
  end function MAX;
  -------------------------------------------------------------------

  function MAX (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := max_table (l, rv(i));
    end loop;
    return result;
  end function MAX;

  -------------------------------------------------------------------
  -- [045] NMIN (NMI)
  -------------------------------------------------------------------

  function NMI (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (nmi_table(l, r));
  end function NMI;
  -------------------------------------------------------------------

  function NMI (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.NMI: "
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

  function NMI (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nmi_table (lv(i), r);
    end loop;
    return result;
  end function NMI;
  -------------------------------------------------------------------

  function NMI (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nmi_table (l, rv(i));
    end loop;
    return result;
  end function NMI;

  -------------------------------------------------------------------
  -- [5EZ] NMAX (NMA)
  -------------------------------------------------------------------

  function NMA (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (nma_table(l, r));
  end function NMA;
  -------------------------------------------------------------------

  function NMA (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.NMA: "
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

  function NMA (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nma_table (lv(i), r);
    end loop;
    return result;
  end function NMA;
  -------------------------------------------------------------------

  function NMA (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nma_table (l, rv(i));
    end loop;
    return result;
  end function NMA;

  -------------------------------------------------------------------
  -- [5DP] XOR
  -------------------------------------------------------------------
  function "XOR" (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (tern_xor_table(l, r));
  end function "XOR";
  -------------------------------------------------------------------
  function "XOR" (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.""XOR"": "
        & "arguments of ""XOR"" function are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := tern_xor_table (lv(i), rv(i));
      end loop;
    end if;
    return result;
  end function "XOR";
  -------------------------------------------------------------------
  function "XOR" (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := tern_xor_table (lv(i), r);
    end loop;
    return result;
  end function "XOR";
  -------------------------------------------------------------------
  function "XOR" (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := tern_xor_table (l, rv(i));
    end loop;
    return result;
  end function "XOR";

  -------------------------------------------------------------------
  -- [PD5] MULTIPLY (MUL)
  -------------------------------------------------------------------
  function MUL (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (mul_table(l, r));
  end function MUL;
  -------------------------------------------------------------------
  function MUL (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.MUL: "
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
  function MUL (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := mul_table (lv(i), r);
    end loop;
    return result;
  end function MUL;
  -------------------------------------------------------------------
  function MUL (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := mul_table (l, rv(i));
    end loop;
    return result;
  end function MUL;

  -------------------------------------------------------------------
  -- [PRZ] IMPLICATION (IMP)
  -------------------------------------------------------------------
  function IMP (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (imp_table(l, r));
  end function IMP;
  -------------------------------------------------------------------
  function IMP (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.IMP: "
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
  function IMP (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := imp_table (lv(i), r);
    end loop;
    return result;
  end function IMP;
  -------------------------------------------------------------------
  function IMP (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := imp_table (l, rv(i));
    end loop;
    return result;
  end function IMP;

  -------------------------------------------------------------------
  -- [XP9] ANY
  -------------------------------------------------------------------
  function ANY (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (any_table(l, r));
  end function ANY;
  -------------------------------------------------------------------
  function ANY (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.ANY: "
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
  function ANY (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := any_table (lv(i), r);
    end loop;
    return result;
  end function ANY;
  -------------------------------------------------------------------
  function ANY (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := any_table (l, rv(i));
    end loop;
    return result;
  end function ANY;

  -------------------------------------------------------------------
  -- [15H] NANY (NAN)
  -------------------------------------------------------------------
  function NAN (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (nan_table(l, r));
  end function NAN;
  -------------------------------------------------------------------
  function NAN (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.NAN: "
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
  function NAN (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := nan_table (lv(i), r);
    end loop;
    return result;
  end function NAN;
  -------------------------------------------------------------------
  function NAN (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := nan_table (l, rv(i));
    end loop;
    return result;
  end function NAN;

  -------------------------------------------------------------------
  -- [H51] COMPARE, MORE,LESS,EQUAL (MLE)
  -------------------------------------------------------------------
  function MLE (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (mle_table(l, r));
  end function MLE;
  -------------------------------------------------------------------
  function MLE (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.MLE: "
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
  function MLE (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := mle_table (lv(i), r);
    end loop;
    return result;
  end function MLE;
  -------------------------------------------------------------------
  function MLE (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := mle_table (l, rv(i));
    end loop;
    return result;
  end function MLE;

  -------------------------------------------------------------------
  -- [RD4] ENABLE (ENA)
  -------------------------------------------------------------------
  function ENA (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (ena_table(l, r));
  end function ENA;
  -------------------------------------------------------------------
  function ENA (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.ENA: "
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
  function ENA (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := ena_table (lv(i), r);
    end loop;
    return result;
  end function ENA;
  -------------------------------------------------------------------
  function ENA (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := ena_table (l, rv(i));
    end loop;
    return result;
  end function ENA;

  -------------------------------------------------------------------
  -- [VP0] DESELECT (DES)
  -------------------------------------------------------------------

  function DES (l : KLEENE; r : KLEENE) return KLEENE is
  begin
    return (des_table(l, r));
  end function DES;
  -------------------------------------------------------------------
  function DES (l, r : KLEENE_VECTOR) return KLEENE_VECTOR is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "KLEENE.DES: "
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
  function DES (l : KLEENE_VECTOR; r : KLEENE)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := des_table (lv(i), r);
    end loop;
    return result;
  end function DES;
  -------------------------------------------------------------------
  function DES (l : KLEENE; r : KLEENE_VECTOR)
    return KLEENE_VECTOR
  is
    alias rv        : KLEENE_VECTOR (1 to r'length) is r;
    variable result : KLEENE_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := des_table (l, rv(i));
    end loop;
    return result;
  end function DES;

  --=================================================================
  -- Shift operator overloads
  --=================================================================
  -------------------------------------------------------------------
  -- sll
  -------------------------------------------------------------------
  function "sll" (l : KLEENE_VECTOR; r : INTEGER)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length) := (others => UNK);
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
  function "srl" (l : KLEENE_VECTOR; r : INTEGER)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length) := (others => UNK);
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
  function "rol" (l : KLEENE_VECTOR; r : INTEGER)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length);
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
  function "ror" (l : KLEENE_VECTOR; r : INTEGER)
    return KLEENE_VECTOR
  is
    alias lv        : KLEENE_VECTOR (1 to l'length) is l;
    variable result : KLEENE_VECTOR (1 to l'length) := (others => UNK);
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

end package body kleene_pkg;