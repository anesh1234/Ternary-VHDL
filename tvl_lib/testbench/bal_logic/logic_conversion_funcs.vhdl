-- --------------------------------------------------------------------
-- Title   : BAL_LOGIC Conversion Functions Testbench
-- Notes   : Focuses on testing all branches, not very extensive in 
--           regards to test vector coverage.
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;
use TVL.kleene_pkg.all;

entity logic_conversion_funcs_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of logic_conversion_funcs_tb is
    signal s_p  : BTERN_LOGIC := '+';
    signal s_L  : BTERN_LOGIC := 'L';
    signal s_D  : BTERN_LOGIC := 'D';

    signal v_empty : BTERN_LOGIC_VECTOR(-1 downto 0);
    signal T_NAC : BTERN_ULOGIC_VECTOR (0 downto 1) := (others => '0');

begin
  main : process
  begin
    test_runner_setup(runner, runner_cfg);

    if run("RESIZE with single BTERN_LOGIC_VECTOR") then

        check(TO_STRING(RESIZE("--00++", 0)) = TO_STRING(T_NAC));
        check(TO_STRING(RESIZE(v_empty, 5)) = "00000");
        check(TO_STRING(RESIZE("--00++", 4)) = "00++");
        check(TO_STRING(RESIZE("--00++", 10)) = "0000--00++");

    elsif run("TO_BALTERN") then

        check(TO_STRING(TO_BALTERN(5, 0)) = TO_STRING(T_NAC));
        check(TO_BALTERN(-1, 1) = "-");
        check(TO_BALTERN(0, 1)  = "0");
        check(TO_BALTERN(1, 1)  = "+");

        check(TO_BALTERN(2147483647, 21)  = "+-0--0-000--+++-+-+0+");
        check(TO_BALTERN(-2147483647, 21) = "-+0++0+000++---+-+-0-");

        -- Should fail elsewhere because of "VECTOR TRUNCATED" assertion in TVL. 
        -- Does not fail here because of --assert-level=none in run.py
        check(TO_BALTERN(5, 1)  = "-");

    elsif run("TO_INTEGER") then

        check(TO_INTEGER(v_empty) = 0);
        check(TO_INTEGER("-") = -1);
        check(TO_INTEGER("0") = 0);
        check(TO_INTEGER("+") = 1);

        check(TO_INTEGER("+-0--0-000--+++-+-+0+") = 2147483647);
        check(TO_INTEGER("-+0++0+000++---+-+-0-") = -2147483647);

        -- Should fail elsewhere because of assertion in TVL. 
        -- Does not fail here because of --assert-level=none in run.py
        check(TO_INTEGER("-++-D+Z") = 0);


    elsif run("TO_Tern(U)LogicVector") then

        check(TO_BternLogicVector("--00++00000++00--") 
                               = "--00++00000++00--");
        check(TO_BternULogicVector("--00++00000++00--")
                                = "--00++00000++00--");
        check(TO_BLV("--00++00000++00--") 
                   = "--00++00000++00--");
        check(TO_BULV("--00++00000++00--")
                    = "--00++00000++00--");

    elsif run("TO_M2P - BTERN_LOGIC(_VECTOR)") then

        check(TO_STRING(TO_M2P("--00++LLMMHH")) = "--00++--00++");
        check(TO_STRING(TO_M2P("--XX++LLMMHH")) = "000000000000");
        check(TO_STRING(TO_M2P("--XX++LLMMHH", 'D')) = "DDDDDDDDDDDD");

        check(TO_STRING(TO_M2P(BTERN_LOGIC'('L'))) = "-");
        check(TO_STRING(TO_M2P(BTERN_LOGIC'('Z'))) = "0");
        check(TO_STRING(TO_M2P(BTERN_LOGIC'('X'), BTERN_LOGIC'('D'))) = "D");

    elsif run("TO_X2P, X2Z, U2P - BTERN_LOGIC_VECTOR") then

        -- simple checks here to confirm that the tables are working
        check(TO_STRING(TO_X2P("UX-0+ZWLMHD")) = "XX-0+XX-0+X");
        check(TO_STRING(TO_X2Z("UX-0+ZWLMHD")) = "XX-0+ZX-0+X");
        check(TO_STRING(TO_U2P("UX-0+ZWLMHD")) = "UX-0+XX-0+X");

    elsif run("?? - BTERN_LOGIC)") then

        check(TO_STRING(KLEENE'(??s_L)) = TO_STRING(KLEENE'(false)));
        check(TO_STRING(KLEENE'(??s_p)) = TO_STRING(KLEENE'(true)));
        check(TO_STRING(KLEENE'(??s_D)) = TO_STRING(KLEENE'(unk)));

    elsif run("TO_STRING - BTERN_LOGIC(_VECTOR), KLEENE") then

        check("00--++DDZZ" = TO_STRING(BTERN_LOGIC_VECTOR'("00--++DDZZ")));
        check("D" = TO_STRING(BTERN_LOGIC'('D')));
        check("unk" = TO_STRING(KLEENE'(unk)));

    elsif run("IS_X - BTERN_LOGIC(_VECTOR)") then

        check(IS_X("UX-0+ZWLMHD") = true);
        check(IS_X("--00++") = false);
        check(IS_X("--00+D") = true);

        check(IS_X(BTERN_LOGIC'('Z')) = true);
        check(IS_X(BTERN_LOGIC'('+')) = false);
        check(IS_X(BTERN_LOGIC'('U')) = true);

    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;