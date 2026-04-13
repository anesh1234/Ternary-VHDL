library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;
use TVL.kleene_pkg.all;

entity arith_logops_examples_tb is
end entity;

architecture sim of arith_logops_examples_tb is

    -----------------------------------------------
    -- input signals
    -----------------------------------------------
    signal space_input_1 : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000000");
    signal space_input_2 : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000000");

    signal logop_input_1 : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000000");
    signal logop_input_2 : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000000");

    signal arith_input_1 : BTERN_ULOGIC_VECTOR(23 downto 0) := BTERN_ULOGIC_VECTOR'("000000000000000000000000");
    signal arith_input_2 : BTERN_ULOGIC_VECTOR(2 downto 0)  := BTERN_ULOGIC_VECTOR'("000");

    signal div_input_1 : BTERN_ULOGIC_VECTOR(23 downto 0) := BTERN_ULOGIC_VECTOR'("000000000000000000000000");
    signal div_input_2 : BTERN_ULOGIC_VECTOR(23 downto 0) := BTERN_ULOGIC_VECTOR'("00000000000000000000000+");

    -----------------------------------------------
    -- output signals
    -----------------------------------------------
    -- spaceship operator
    signal res_kleene : KLEENE;
    signal res_ulogic : BTERN_ULOGIC;

    -- logical operators
    signal res_min : BTERN_ULOGIC_VECTOR(5 downto 0);
    signal res_max : BTERN_ULOGIC_VECTOR(5 downto 0);
    signal res_sti : BTERN_ULOGIC_VECTOR(5 downto 0);

    -- +,- and *
    signal res_add  : BTERN_ULOGIC_VECTOR(23 downto 0);
    signal res_sub  : BTERN_ULOGIC_VECTOR(23 downto 0);
    signal res_mult : BTERN_ULOGIC_VECTOR(26 downto 0);

    -- truncating /, rem and mod
    signal res_div_trunc : BTERN_ULOGIC_VECTOR(23 downto 0);
    signal res_rem_trunc : BTERN_ULOGIC_VECTOR(23 downto 0);
    signal res_mod_trunc : BTERN_ULOGIC_VECTOR(23 downto 0);

    -- Euclidean div and mod
    signal res_div_euc : BTERN_ULOGIC_VECTOR(23 downto 0);
    signal res_mod_euc : BTERN_ULOGIC_VECTOR(23 downto 0);

begin
    -- Stimulus process
    stim_proc: process
    begin
        space_input_1 <= "00000+";
        space_input_2 <= "000+-+";

        logop_input_1 <= "------";
        logop_input_2 <= "000000";

        arith_input_1 <= "00000000++++++++--------";
        arith_input_2 <= "+++";

        div_input_1 <= "++++++++++++++++++++++++";
        div_input_2 <= "00000000--------++++++++";

        wait for 10 ns;

        space_input_1 <= "000+-+";
        space_input_2 <= "000+-+";

        logop_input_1 <= "000000";
        logop_input_2 <= "++++++";

        arith_input_1 <= "000000000000000000000000";
        arith_input_2 <= "000";

        div_input_1 <= "000000000000000000000000";
        div_input_2 <= "00000000000000000000000+";

        wait for 10 ns;

        space_input_1 <= "++++++";
        space_input_2 <= "000+-+";

        logop_input_1 <= "++++++";
        logop_input_2 <= "------";
        
        wait for 10 ns;
        wait;
    end process;

    -- Assignment process
    assign_proc: process(space_input_1,space_input_2,logop_input_1,logop_input_2,arith_input_1,arith_input_2,div_input_1,div_input_2)
    begin
        -- Spaceship operator ordinary/matching
        res_kleene <= SPACE(space_input_1, space_input_2);
        res_ulogic <= M_SPACE(space_input_1, space_input_2);

        -- MIN/MAX/STI
        res_min  <= MINI(logop_input_1, logop_input_2);
        res_max  <= MAX(logop_input_1, logop_input_2);
        res_sti  <= STI(logop_input_1);

        -- +/-/*
        res_add  <= arith_input_1 + arith_input_2;
        res_sub  <= arith_input_1 - arith_input_2;
        res_mult <= arith_input_1 * arith_input_2;

        -- truncating /, rem and mod
        res_div_trunc <= div_input_1 / div_input_2;
        res_rem_trunc <= div_input_1 rem div_input_2;
        res_mod_trunc <= div_input_1 mod div_input_2;

        -- Euclidean div and mod
        res_div_euc <= BTEDIV(div_input_1, div_input_2);
        res_mod_euc <= BTEMOD(div_input_1, div_input_2);
    end process;

end architecture;
