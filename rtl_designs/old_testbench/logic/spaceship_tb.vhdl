library TVL;
use TVL.bal_logic.all;
use TVL.kleene_pkg.all;

entity spaceship_tb is
end entity;

architecture sim of spaceship_tb is

    -- Input signals
    signal s_1 : BTERN_ULOGIC := '+';
    signal s_2 : BTERN_ULOGIC := '0';
    signal s_3 : BTERN_ULOGIC := '-';

    -- v_num1 = 40 (dec)
    -- v_num2 = 35 (dec)
    -- v_num3 = 5 (dec)
    signal v_1       : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("00++++");
    signal v_2       : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("00++0-");
    signal v_3       : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000+--");
    signal v_error   : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("00Z+--");
    signal empty_vec : BTERN_ULOGIC_VECTOR(-1 downto 0);
    signal int       : INTEGER := 35;

    -- Output signals
    signal res_s_s : KLEENE;
    signal res_v_v : KLEENE;
    signal res_v_i : KLEENE;
    signal res_i_v : KLEENE;

begin
    -- Stimulus process
    stim_proc: process
    begin
        res_s_s <= SPACE(s_3, s_1);

        res_v_v <= SPACE(v_3, v_1);
        res_v_i <= SPACE(v_3, int);
        res_i_v <= SPACE(int, v_1);

        wait for 5 ns;

        res_s_s <= SPACE(s_1, s_1);

        res_v_v <= SPACE(v_1, v_1);
        res_v_i <= SPACE(v_3, v_3);
        res_i_v <= SPACE(int, v_2);

        wait for 5 ns;

        res_s_s <= SPACE(s_1, s_3);

        res_v_v <= SPACE(v_1, v_3);
        res_v_i <= SPACE(v_1, int);
        res_i_v <= SPACE(int, v_3);

        wait for 5 ns;

        -- Test with empty vector
        res_v_v <= SPACE(empty_vec, v_3);
        res_v_i <= SPACE(empty_vec, int);
        res_i_v <= SPACE(int, empty_vec);

        wait for 5 ns;
        wait;
    end process;

end architecture;
