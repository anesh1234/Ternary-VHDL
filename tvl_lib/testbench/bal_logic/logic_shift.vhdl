-- --------------------------------------------------------------------
-- Title   : 
-- Purpose :
-- Notes   :
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;

entity logic_shift_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of logic_shift_tb is
begin
  main : process
    --=================================================================
    -- test procedures to call shift functions and make assertions
    --=================================================================

    procedure T_SLL(L : in BTERN_LOGIC_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in BTERN_LOGIC_VECTOR) is
    begin
        assert (L sll NUM) = RESULT severity FAILURE;
    end T_SLL;

    procedure T_SRL(L : in BTERN_LOGIC_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in BTERN_LOGIC_VECTOR) is
    begin
        assert (L srl NUM) = RESULT severity FAILURE;
    end T_SRL;

    procedure T_ROL(L : in BTERN_LOGIC_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in BTERN_LOGIC_VECTOR) is
    begin
        assert (L rol NUM) = RESULT severity FAILURE;
    end T_ROL;

    procedure T_ROR(L : in BTERN_LOGIC_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in BTERN_LOGIC_VECTOR) is
    begin
        assert (L ror NUM) = RESULT severity FAILURE;
    end T_ROR;

  begin
    test_runner_setup(runner, runner_cfg);

    -- Tests first a simple shift/roll of one, then
    -- with zero, then -1, lastly with 5.
    -- This ensures coverage of all branches in the functions

    if run("BTERN_LOGIC_VECTOR SLL") then
      T_SLL("00000+-00000",
              1,
            "0000+-000000");

      T_SLL("00000+-00000",
              0,
            "00000+-00000");

      T_SLL("00000+-00000",
              -1,
            "000000+-0000");

      T_SLL("00000+-00000",
              5,
            "+-0000000000");

    elsif run("BTERN_LOGIC_VECTOR SRL") then
      T_SRL("00000+-00000",
              1,
            "000000+-0000");

      T_SRL("00000+-00000",
              0,
            "00000+-00000");

      T_SRL("00000+-00000",
              -1,
            "0000+-000000");

      T_SRL("00000+-00000",
              5,
            "0000000000+-");

    elsif run("BTERN_LOGIC_VECTOR ROL") then
      T_ROL("--000+-000++",
              1,
            "-000+-000++-");

      T_ROL("--000+-000++",
              0,
            "--000+-000++");

      T_ROL("--000+-000++",
              -1,
            "+--000+-000+");

      T_ROL("--000+-000++",
              5,
            "+-000++--000");

    elsif run("BTERN_LOGIC_VECTOR ROR") then
      T_ROR("--000+-000++",
              1,
            "+--000+-000+");

      T_ROR("--000+-000++",
              0,
            "--000+-000++");

      T_ROR("--000+-000++",
              -1,
            "-000+-000++-");

      T_ROR("--000+-000++",
              5,
            "000++--000+-");
    

    end if;
    test_runner_cleanup(runner);
  end process;
end architecture;