-- --------------------------------------------------------------------
-- Title   : 
-- Purpose :
-- Notes   :
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.kleene_pkg.all;

entity kleene_shift_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of kleene_shift_tb is
begin
  main : process
    --=================================================================
    -- test procedures to call shift functions and make assertions
    --=================================================================

    procedure T_SLL(L : in KLEENE_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in KLEENE_VECTOR) is
    begin
        assert (L sll NUM) = RESULT severity FAILURE;
    end T_SLL;

    procedure T_SRL(L : in KLEENE_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in KLEENE_VECTOR) is
    begin
        assert (L srl NUM) = RESULT severity FAILURE;
    end T_SRL;

    procedure T_ROL(L : in KLEENE_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in KLEENE_VECTOR) is
    begin
        assert (L rol NUM) = RESULT severity FAILURE;
    end T_ROL;

    procedure T_ROR(L : in KLEENE_VECTOR;
                    NUM : in INTEGER;
                    RESULT : in KLEENE_VECTOR) is
    begin
        assert (L ror NUM) = RESULT severity FAILURE;
    end T_ROR;

  begin
    test_runner_setup(runner, runner_cfg);

    -- Tests first a simple shift/roll of one, then
    -- with zero, then -1, lastly with 5.
    -- This ensures coverage of all branches in the functions

    if run("KLEENE_VECTOR SLL") then
      T_SLL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              1,
            (unk, unk, unk, unk, true, false, unk,  unk, unk, unk, unk, unk));

      T_SLL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              0,
            (unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk));

      T_SLL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              -1,
            (unk, unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk));

      T_SLL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              5,
            (true, false, unk, unk, unk, unk, unk, unk, unk, unk, unk, unk));

    elsif run("KLEENE_VECTOR SRL") then
      T_SRL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              1,
            (unk, unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk));

      T_SRL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              0,
            (unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk));

      T_SRL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              -1,
            (unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk, unk));

      T_SRL((unk, unk, unk, unk, unk, true, false, unk, unk, unk, unk, unk),
              5,
            (unk, unk, unk, unk, unk, unk, unk, unk, unk, unk, true, false));

    elsif run("KLEENE_VECTOR ROL") then
      T_ROL((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              1,
            (false, unk, unk, unk, true, false, unk, unk, unk, true, true, false));

      T_ROL((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              0,
            (false, false, unk, unk, unk, true, false, unk, unk, unk, true, true));

      T_ROL((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              -1,
            (true, false, false, unk, unk, unk, true, false, unk, unk, unk, true));

      T_ROL((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              5,
            (true, false, unk, unk, unk, true, true, false, false, unk, unk, unk));

    elsif run("KLEENE_VECTOR ROR") then
      T_ROR((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              1,
            (true, false, false, unk, unk, unk, true, false, unk, unk, unk, true));

      T_ROR((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              0,
            (false, false, unk, unk, unk, true, false, unk, unk, unk, true, true));

      T_ROR((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              -1,
            (false, unk, unk, unk, true, false, unk, unk, unk, true, true, false));

      T_ROR((false, false, unk, unk, unk, true, false, unk, unk, unk, true, true),
              5,
            (unk, unk, unk, true, true, false, false, unk, unk, unk, true, false));
    

    end if;
    test_runner_cleanup(runner);
  end process;
end architecture;