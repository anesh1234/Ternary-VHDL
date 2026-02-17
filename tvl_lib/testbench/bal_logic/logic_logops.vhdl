-- --------------------------------------------------------------------
-- Title   : BAL_LOGIC Logical Operators/Functions
-- Notes   : All 1-and-2-arity operators are tested for every 
--           combination of single trits. Test vectors ensure also the
--           weak values are tested. The testbench's structure is based on 
--           "numeric_std_tb5.vhd" by IEEE.
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;

entity logic_logops_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of logic_logops_tb is
  -- Strings to test handling of metalogical -and weak values.
  -- Until defined in future work, these should all be evaluated to X's 
  signal meta_vec1 : BTERN_LOGIC_VECTOR(65 downto 0) := "UXZWDZWDUXUXUXZWDDZWDUXUXUXZWDZWDUXUXUXZWXZWDZWDUXUXUXZWDDZWDUXUXU";
  signal meta_vec2 : BTERN_LOGIC_VECTOR(65 downto 0) := "DUXUXUXZWDZWDUXUXUXZWUXZWDZWDUXUXUXZWDDZWZWDUXUXUXZWDDZWZWDUXUXUXZ";
  signal verif_str : STRING(1 to 66) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
begin
  main : process

    --=================================================================
    -- 1-arity (Unary) logical function calls. 
    --=================================================================

    procedure U_COL(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert COL(LEFT) = RESULT severity FAILURE;
    end U_COL;

    procedure U_NTI(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert NTI(LEFT) = RESULT severity FAILURE;
    end U_NTI;

    procedure U_STI(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert STI(LEFT) = RESULT severity FAILURE;
    end U_STI;

    procedure U_MTI(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert MTI(LEFT) = RESULT severity FAILURE;
    end U_MTI;

    procedure U_INC(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert INC(LEFT) = RESULT severity FAILURE;
    end U_INC;

    procedure U_PTI(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert PTI(LEFT) = RESULT severity FAILURE;
    end U_PTI;

    procedure U_DEC(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert DEC(LEFT) = RESULT severity FAILURE;
    end U_DEC;

    procedure U_CLD(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert CLD(LEFT) = RESULT severity FAILURE;
    end U_CLD;

    procedure U_COM(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert COM(LEFT) = RESULT severity FAILURE;
    end U_COM;

    procedure U_IPT(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert IPT(LEFT) = RESULT severity FAILURE;
    end U_IPT;

    procedure U_IMT(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert IMT(LEFT) = RESULT severity FAILURE;
    end U_IMT;

    procedure U_BUF(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert BUF(LEFT) = RESULT severity FAILURE;
    end U_BUF;

    procedure U_CLU(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert CLU(LEFT) = RESULT severity FAILURE;
    end U_CLU;

    procedure U_INT(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert INT(LEFT) = RESULT severity FAILURE;
    end U_INT;

    procedure U_COH(LEFT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert COH(LEFT) = RESULT severity FAILURE;
    end U_COH;

    --=================================================================
    -- 2-arity (Diadic) logical function calls. 
    --=================================================================

    procedure D_SUM(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert SUM(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_SUM;
    
    procedure D_CON(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert CON(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_CON;

    procedure D_NCO(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert NCO(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NCO;

    procedure D_MINI(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert MINI(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MINI;

    procedure D_MAX(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert MAX(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MAX;

    procedure D_NMI(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert NMI(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NMI;

    procedure D_NMA(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert NMA(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NMA;

    -- Call to XOR must be different from the others due to the 
    -- existence of predefined operator XOR
    procedure D_XOR(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert (LEFT XOR RIGHT) = RESULT severity FAILURE;
    end D_XOR;

    procedure D_MUL(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert MUL(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MUL;

    procedure D_IMP(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert IMP(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_IMP;

    procedure D_ANY(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert ANY(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_ANY;

    procedure D_NAN(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert NAN(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_NAN;

    procedure D_MLE(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert MLE(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_MLE;

    procedure D_ENA(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert ENA(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_ENA;

    procedure D_DES(LEFT, RIGHT, RESULT: in BTERN_LOGIC_VECTOR) is
    begin
      assert DES(LEFT, RIGHT) = RESULT severity FAILURE;
    end D_DES;

  begin
    test_runner_setup(runner, runner_cfg);
    
    -- The first 3/9 lines (1/2-arity) checks for every 
    -- combination of single forcing-valued trits.
    -- Then vectors of mixed weak -and forcing values are tested,
    -- covering all possible input combinations which are defined.
    -- Lastly, vectors containing metalogical values are tested.

    --=================================================================
    -- Test vectors for 1-arity logops
    --=================================================================

    if run("Test 1-arity COL") then
      U_COL("-", "-");
      U_COL("0", "-");
      U_COL("+", "-");
      U_COL("-0+LMH",
            "------");
      check_equal(TO_STRING(COL(meta_vec1)), verif_str);

    elsif run("Test 1-arity NTI") then
      U_NTI("-", "+");
      U_NTI("0", "-");
      U_NTI("+", "-");
      U_NTI("-0+LMH",
            "+--+--");
      check_equal(TO_STRING(NTI(meta_vec1)), verif_str);

    elsif run("Test 1-arity STI") then
      U_STI("-", "+");
      U_STI("0", "0");
      U_STI("+", "-");
      U_STI("-0+LMH",
            "+0-+0-");
      check_equal(TO_STRING(STI(meta_vec1)), verif_str);

    elsif run("Test 1-arity MTI") then
      U_MTI("-", "-");
      U_MTI("0", "+");
      U_MTI("+", "-");
      U_MTI("-0+LMH",
            "-+--+-");
      check_equal(TO_STRING(MTI(meta_vec1)), verif_str);

    elsif run("Test 1-arity INC") then
      U_INC("-", "0");
      U_INC("0", "+");
      U_INC("+", "-");
      U_INC("-0+LMH",
            "0+-0+-");
      check_equal(TO_STRING(INC(meta_vec1)), verif_str);

    elsif run("Test 1-arity PTI") then
      U_PTI("-", "+");
      U_PTI("0", "+");
      U_PTI("+", "-");
      U_PTI("-0+LMH",
            "++-++-");
      check_equal(TO_STRING(PTI(meta_vec1)), verif_str);

    elsif run("Test 1-arity DEC") then
      U_DEC("-", "+");
      U_DEC("0", "-");
      U_DEC("+", "0");
      U_DEC("-0+LMH",
            "+-0+-0");
      check_equal(TO_STRING(DEC(meta_vec1)), verif_str);

    elsif run("Test 1-arity CLD") then
      U_CLD("-", "-");
      U_CLD("0", "0");
      U_CLD("+", "0");
      U_CLD("-0+LMH",
            "-00-00");
      check_equal(TO_STRING(CLD(meta_vec1)), verif_str);

    elsif run("Test 1-arity COM") then
      U_COM("-", "0");
      U_COM("0", "0");
      U_COM("+", "0");
      U_COM("-0+LMH",
            "000000");
      check_equal(TO_STRING(COM(meta_vec1)), verif_str);

    elsif run("Test 1-arity IPT") then
      U_IPT("-", "-");
      U_IPT("0", "-");
      U_IPT("+", "+");
      U_IPT("-0+LMH",
            "--+--+");
      check_equal(TO_STRING(IPT(meta_vec1)), verif_str);

    elsif run("Test 1-arity IMT") then
      U_IMT("-", "+");
      U_IMT("0", "-");
      U_IMT("+", "+");
      U_IMT("-0+LMH",
            "+-++-+");
      check_equal(TO_STRING(IMT(meta_vec1)), verif_str);

    elsif run("Test 1-arity BUF") then
      U_BUF("-", "-");
      U_BUF("0", "0");
      U_BUF("+", "+");
      U_BUF("-0+LMH",
            "-0+-0+");
      check_equal(TO_STRING(BUF(meta_vec1)), verif_str);

    elsif run("Test 1-arity CLU") then
      U_CLU("-", "0");
      U_CLU("0", "0");
      U_CLU("+", "+");
      U_CLU("-0+LMH",
            "00+00+");
      check_equal(TO_STRING(CLU(meta_vec1)), verif_str);

    elsif run("Test 1-arity INT") then
      U_INT("-", "-");
      U_INT("0", "+");
      U_INT("+", "+");
      U_INT("-0+LMH",
            "-++-++");
      check_equal(TO_STRING(INT(meta_vec1)), verif_str);

    elsif run("Test 1-arity COH") then
      U_COH("-", "+");
      U_COH("0", "+");
      U_COH("+", "+");
      U_COH("-0+LMH",
            "++++++");
      check_equal(TO_STRING(COH(meta_vec1)), verif_str);

    --=================================================================
    -- Test vectors for 2-arity logops
    --=================================================================

    elsif run("Test 2-arity SUM") then
      D_SUM("-", "-", "+");
      D_SUM("-", "0", "-");
      D_SUM("-", "+", "0");
      D_SUM("0", "-", "-");
      D_SUM("0", "0", "0");
      D_SUM("0", "+", "+");
      D_SUM("+", "-", "0");
      D_SUM("+", "0", "+");
      D_SUM("+", "+", "-");
      D_SUM("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "+-0+-0-0+-0+0+-0+-+-0+-0-0+-0+0+-0+-");
      check_equal(TO_STRING(SUM(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity CON") then
      D_CON("-", "-", "-");
      D_CON("-", "0", "0");
      D_CON("-", "+", "0");
      D_CON("0", "-", "0");
      D_CON("0", "0", "0");
      D_CON("0", "+", "0");
      D_CON("+", "-", "0");
      D_CON("+", "0", "0");
      D_CON("+", "+", "+");
      D_CON("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "-00-0000000000+00+-00-0000000000+00+");
      check_equal(TO_STRING(CON(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity NCO") then
      D_NCO("-", "-", "+");
      D_NCO("-", "0", "0");
      D_NCO("-", "+", "0");
      D_NCO("0", "-", "0");
      D_NCO("0", "0", "0");
      D_NCO("0", "+", "0");
      D_NCO("+", "-", "0");
      D_NCO("+", "0", "0");
      D_NCO("+", "+", "-");
      D_NCO("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "+00+0000000000-00-+00+0000000000-00-");
      check_equal(TO_STRING(NCO(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity MINI") then
      D_MINI("-", "-", "-");
      D_MINI("-", "0", "-");
      D_MINI("-", "+", "-");
      D_MINI("0", "-", "-");
      D_MINI("0", "0", "0");
      D_MINI("0", "+", "0");
      D_MINI("+", "-", "-");
      D_MINI("+", "0", "0");
      D_MINI("+", "+", "+");
      D_MINI("------000000++++++LLLLLLMMMMMMHHHHHH", 
              "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
              "-------00-00-0+-0+-------00-00-0+-0+");
      check_equal(TO_STRING(MINI(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity MAX") then
      D_MAX("-", "-", "-");
      D_MAX("-", "0", "0");
      D_MAX("-", "+", "+");
      D_MAX("0", "-", "0");
      D_MAX("0", "0", "0");
      D_MAX("0", "+", "+");
      D_MAX("+", "-", "+");
      D_MAX("+", "0", "+");
      D_MAX("+", "+", "+");
      D_MAX("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "-0+-0+00+00+++++++-0+-0+00+00+++++++");
      check_equal(TO_STRING(MAX(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity NMI") then
      D_NMI("-", "-", "+");
      D_NMI("-", "0", "0");
      D_NMI("-", "+", "-");
      D_NMI("0", "-", "0");
      D_NMI("0", "0", "0");
      D_NMI("0", "+", "-");
      D_NMI("+", "-", "-");
      D_NMI("+", "0", "-");
      D_NMI("+", "+", "-");
      D_NMI("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "+0-+0-00-00-------+0-+0-00-00-------");
      check_equal(TO_STRING(NMI(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity NMA") then
      D_NMA("-", "-", "+");
      D_NMA("-", "0", "+");
      D_NMA("-", "+", "+");
      D_NMA("0", "-", "+");
      D_NMA("0", "0", "0");
      D_NMA("0", "+", "0");
      D_NMA("+", "-", "+");
      D_NMA("+", "0", "0");
      D_NMA("+", "+", "-");
      D_NMA("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "+++++++00+00+0-+0-+++++++00+00+0-+0-");
      check_equal(TO_STRING(NMA(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity XOR") then
      D_XOR("-", "-", "-");
      D_XOR("-", "0", "0");
      D_XOR("-", "+", "+");
      D_XOR("0", "-", "0");
      D_XOR("0", "0", "0");
      D_XOR("0", "+", "0");
      D_XOR("+", "-", "+");
      D_XOR("+", "0", "0");
      D_XOR("+", "+", "-");
      D_XOR("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "-0+-0+000000+0-+0--0+-0+000000+0-+0-");
      check_equal(TO_STRING(meta_vec1 XOR meta_vec2), verif_str);

    elsif run("Test 2-arity MUL") then
      D_MUL("-", "-", "+");
      D_MUL("-", "0", "0");
      D_MUL("-", "+", "-");
      D_MUL("0", "-", "0");
      D_MUL("0", "0", "0");
      D_MUL("0", "+", "0");
      D_MUL("+", "-", "-");
      D_MUL("+", "0", "0");
      D_MUL("+", "+", "+");
      D_MUL("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "+0-+0-000000-0+-0++0-+0-000000-0+-0+");
      check_equal(TO_STRING(MUL(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity IMP") then
      D_IMP("-", "-", "+");
      D_IMP("-", "0", "+");
      D_IMP("-", "+", "+");
      D_IMP("0", "-", "0");
      D_IMP("0", "0", "0");
      D_IMP("0", "+", "+");
      D_IMP("+", "-", "-");
      D_IMP("+", "0", "0");
      D_IMP("+", "+", "+");
      D_IMP("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "++++++00+00+-0+-0+++++++00+00+-0+-0+");
      check_equal(TO_STRING(IMP(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity ANY") then
      D_ANY("-", "-", "-");
      D_ANY("-", "0", "-");
      D_ANY("-", "+", "0");
      D_ANY("0", "-", "-");
      D_ANY("0", "0", "0");
      D_ANY("0", "+", "+");
      D_ANY("+", "-", "0");
      D_ANY("+", "0", "+");
      D_ANY("+", "+", "+");
      D_ANY("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "--0--0-0+-0+0++0++--0--0-0+-0+0++0++");
      check_equal(TO_STRING(ANY(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity NAN") then
      D_NAN("-", "-", "+");
      D_NAN("-", "0", "+");
      D_NAN("-", "+", "0");
      D_NAN("0", "-", "+");
      D_NAN("0", "0", "0");
      D_NAN("0", "+", "-");
      D_NAN("+", "-", "0");
      D_NAN("+", "0", "-");
      D_NAN("+", "+", "-");
      D_NAN("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "++0++0+0-+0-0--0--++0++0+0-+0-0--0--");
      check_equal(TO_STRING(NAN(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity MLE") then
      D_MLE("-", "-", "0");
      D_MLE("-", "0", "-");
      D_MLE("-", "+", "-");
      D_MLE("0", "-", "+");
      D_MLE("0", "0", "0");
      D_MLE("0", "+", "-");
      D_MLE("+", "-", "+");
      D_MLE("+", "0", "+");
      D_MLE("+", "+", "0");
      D_MLE("------000000++++++LLLLLLMMMMMMHHHHHH",
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "0--0--+0-+0-++0++00--0--+0-+0-++0++0");
      check_equal(TO_STRING(MLE(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity ENA") then
      D_ENA("-", "-", "0");
      D_ENA("-", "0", "0");
      D_ENA("-", "+", "-");
      D_ENA("0", "-", "0");
      D_ENA("0", "0", "0");
      D_ENA("0", "+", "0");
      D_ENA("+", "-", "0");
      D_ENA("+", "0", "0");
      D_ENA("+", "+", "+");
      D_ENA("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "00-00-00000000+00+00-00-00000000+00+");
      check_equal(TO_STRING(ENA(meta_vec1, meta_vec2)), verif_str);

    elsif run("Test 2-arity DES") then
      D_DES("-", "-", "-");
      D_DES("-", "0", "-");
      D_DES("-", "+", "-");
      D_DES("0", "-", "-");
      D_DES("0", "0", "0");
      D_DES("0", "+", "+");
      D_DES("+", "-", "-");
      D_DES("+", "0", "+");
      D_DES("+", "+", "+");
      D_DES("------000000++++++LLLLLLMMMMMMHHHHHH", 
            "-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH-0+LMH", 
            "-------0+-0+-++-++-------0+-0+-++-++");
      check_equal(TO_STRING(DES(meta_vec1, meta_vec2)), verif_str);
      
    end if;
    test_runner_cleanup(runner);
  end process;
end architecture;