library TVL;
use TVL.bal_logic.all;
use TVL.kleene_type.all;

entity test_tb is
end entity;

architecture sim of test_tb is

    -- Input signals
    signal s_1 : BTERN_ULOGIC := '+';
    signal s_2 : BTERN_ULOGIC := '0';
    signal s_3 : BTERN_ULOGIC := '-';
    signal s_4 : BTERN_ULOGIC := 'H';
    signal s_5 : BTERN_ULOGIC := 'D';

    -- Output signals
    signal res_1 : BTERN_ULOGIC := '+';
    signal res_2 : BTERN_ULOGIC := '0';
    signal res_3 : BTERN_ULOGIC := '-';

begin
    -- Stimulus process
    stim_proc: process
    begin
        res_1 <= MAXIMUM(s_1, s_2);
        res_2 <= MAXIMUM(s_1, s_4);
        res_3 <= MAXIMUM(s_1, s_5);
        wait for 5 ns;
        wait;
    end process;

end architecture;
