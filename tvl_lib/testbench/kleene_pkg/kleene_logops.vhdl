-- --------------------------------------------------------------------
-- Title   : 
-- Purpose :
-- Notes   :
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.kleene_pkg.all;

entity kleene_logops_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of kleene_logops_tb is
begin
  main : process

    --=================================================================
    -- 1-arity (Unary) logical function calls
    --=================================================================

    procedure U_COL(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert COL(LEFT) = RESULT severity FAILURE;
    end U_COL;

    procedure U_NTI(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert NTI(LEFT) = RESULT severity FAILURE;
    end U_NTI;

    procedure U_STI(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert STI(LEFT) = RESULT severity FAILURE;
    end U_STI;

    procedure U_MTI(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert MTI(LEFT) = RESULT severity FAILURE;
    end U_MTI;

    procedure U_INC(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert INC(LEFT) = RESULT severity FAILURE;
    end U_INC;

    procedure U_PTI(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert PTI(LEFT) = RESULT severity FAILURE;
    end U_PTI;

    procedure U_DEC(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert DEC(LEFT) = RESULT severity FAILURE;
    end U_DEC;

    procedure U_CLD(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert CLD(LEFT) = RESULT severity FAILURE;
    end U_CLD;

    procedure U_COM(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert COM(LEFT) = RESULT severity FAILURE;
    end U_COM;

    procedure U_IPT(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert IPT(LEFT) = RESULT severity FAILURE;
    end U_IPT;

    procedure U_IMT(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert IMT(LEFT) = RESULT severity FAILURE;
    end U_IMT;

    procedure U_BUF(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert BUF(LEFT) = RESULT severity FAILURE;
    end U_BUF;

    procedure U_CLU(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert CLU(LEFT) = RESULT severity FAILURE;
    end U_CLU;

    procedure U_INT(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert INT(LEFT) = RESULT severity FAILURE;
    end U_INT;

    procedure U_COH(LEFT, RESULT: in KLEENE_VECTOR) is
    begin
      assert COH(LEFT) = RESULT severity FAILURE;
    end U_COH;

    --=================================================================
    -- 2-arity (Diadic) logical function calls. 
    --=================================================================

    procedure D_SUM(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert SUM(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_SUM;
    
    procedure D_CON(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert CON(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_CON;

    procedure D_NCO(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert NCO(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NCO;

    procedure D_MINI(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert MINI(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MINI;

    procedure D_MAX(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert MAX(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MAX;

    procedure D_NMI(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert NMI(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NMI;

    procedure D_NMA(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert NMA(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NMA;

    -- Call to XOR must be different from the others due to the 
    -- existence of predefined operator XOR
    procedure D_XOR(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert (LEFT XOR RIGHT) = RESULT severity FAILURE;
    end D_XOR;

    procedure D_MUL(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert MUL(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MUL;

    procedure D_IMP(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert IMP(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_IMP;

    procedure D_ANY(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert ANY(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_ANY;

    procedure D_NAN(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert NAN(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NAN;

    procedure D_MLE(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert MLE(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MLE;

    procedure D_ENA(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert ENA(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_ENA;

    procedure D_DES(LEFT, RIGHT, RESULT: in KLEENE_VECTOR) is
    begin
      assert DES(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_DES;

  begin
    test_runner_setup(runner, runner_cfg);
    
    -- Input vectors check for every combination of identifiers
    -- (1 vector for 1-arity, 2 for 2-arity) and the last vector 
    -- is the expected result of the evaluation.

    --=================================================================
    -- Test vectors for 1-arity logops
    --=================================================================

    if run("Test 1-arity COL") then
      U_COL((false, unk,   true),
            (false, false, false));

    elsif run("Test 1-arity NTI") then
      U_NTI((false, unk,   true),
            (true,  false, false));

    elsif run("Test 1-arity STI") then
      U_STI((false, unk, true),
            (true,  unk, false));

    elsif run("Test 1-arity MTI") then
      U_MTI((false, unk,  true),
            (false, true, false));

    elsif run("Test 1-arity INC") then
      U_INC((false, unk,  true),
            (unk,   true, false));

    elsif run("Test 1-arity PTI") then
      U_PTI((false, unk,  true),
            (true,  true, false));

    elsif run("Test 1-arity DEC") then
      U_DEC((false, unk,   true),
            (true,  false, unk));

    elsif run("Test 1-arity CLD") then
      U_CLD((false, unk, true),
            (false, unk, unk));

    elsif run("Test 1-arity COM") then
      U_COM((false, unk, true),
            (unk,   unk, unk));

    elsif run("Test 1-arity IPT") then
      U_IPT((false, unk,   true),
            (false, false, true));

    elsif run("Test 1-arity IMT") then
      U_IMT((false, unk, true),
            (true, false, true));

    elsif run("Test 1-arity BUF") then
      U_BUF((false, unk, true),
            (false, unk, true));

    elsif run("Test 1-arity CLU") then
      U_CLU((false, unk, true),
            (unk, unk, true));

    elsif run("Test 1-arity INT") then
      U_INT((false, unk,  true),
            (false, true, true));

    elsif run("Test 1-arity COH") then
      U_COH((false, unk,  true),
            (true,  true, true));

    --=================================================================
    -- Test vectors for 2-arity logops
    --=================================================================

    elsif run("Test 2-arity SUM") then
      D_SUM((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true), 
            (true,  false, unk,   false, unk, true, unk,   true, false));

    elsif run("Test 2-arity CON") then
      D_CON((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true), 
            (false, unk,   unk,   unk,   unk, unk,  unk,   unk,  true));

    elsif run("Test 2-arity NCO") then
      D_NCO((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true), 
            (true,  unk,   unk,   unk,   unk, unk,  unk,   unk,  false));

    elsif run("Test 2-arity MINI") then
      D_MINI((false, false, false, unk,   unk, unk,  true,  true, true), 
             (false, unk,   true,  false, unk, true, false, unk,  true),  
             (false, false, false, false, unk, unk,  false, unk,  true));

    elsif run("Test 2-arity MAX") then
      D_MAX((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true), 
            (false, unk,   true,  unk,   unk, true, true,  true, true));

    elsif run("Test 2-arity NMI") then
      D_NMI((false, false, false, unk,   unk, unk,   true,  true,  true), 
            (false, unk,   true,  false, unk, true,  false, unk,   true), 
            (true,  unk,   false, unk,   unk, false, false, false, false));

    elsif run("Test 2-arity NMA") then
      D_NMA((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true),  
            (true,  true,  true,  true,  unk, unk,  true,  unk,  false));

    elsif run("Test 2-arity XOR") then
      D_XOR((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true),  
            (false, unk,   true,  unk,   unk, unk,  true,  unk,  false));

    elsif run("Test 2-arity MUL") then
      D_MUL((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true),  
            (true,  unk,   false, unk,   unk, unk,  false, unk,  true));

    elsif run("Test 2-arity IMP") then
      D_IMP((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true),  
            (true,  true,  true,  unk,   unk, true, false, unk,  true));

    elsif run("Test 2-arity ANY") then
      D_ANY((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true),  
            (false, false, unk,   false, unk, true, unk,   true, true));

    elsif run("Test 2-arity NAN") then
      D_NAN((false, false, false, unk,   unk, unk,   true,  true,  true), 
            (false, unk,   true,  false, unk, true,  false, unk,   true),  
            (true,  true,  unk,   true,  unk, false, unk,   false, false));

    elsif run("Test 2-arity MLE") then
      D_MLE((false, false, false, unk,   unk, unk,   true,  true, true), 
            (false, unk,   true,  false, unk, true,  false, unk,  true),  
            (unk,   false, false, true,  unk, false, true,  true, unk));

    elsif run("Test 2-arity ENA") then
      D_ENA((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true),  
            (unk,   unk,   false, unk,   unk, unk,  unk,   unk,  true));

    elsif run("Test 2-arity DES") then
      D_DES((false, false, false, unk,   unk, unk,  true,  true, true), 
            (false, unk,   true,  false, unk, true, false, unk,  true),  
            (false, false, false, false, unk, true, false, true, true));
      
    end if;
    test_runner_cleanup(runner);
  end process;
end architecture;