library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity division_tb is
end entity;

architecture sim of division_tb is

    -- Input signals
    signal input_1 : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000000");
    signal input_2 : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000000");
    signal int_1   : INTEGER := 0;
    signal int_2   : INTEGER := 0;
    -- output signals
    signal res_v_v  : BTERN_LOGIC_VECTOR(5 downto 0);
    signal res_i_v  : BTERN_LOGIC_VECTOR(5 downto 0);
    signal res_v_i  : BTERN_LOGIC_VECTOR(5 downto 0);

begin
    -- Stimulus process
    stim_proc: process
    begin
        -- 13 / 13
        input_1 <= "000+++";
        input_2 <= "000+++";
        int_1   <= 13;
        int_2   <= 13;

        wait for 10 ns;
        -- 13 / 0
        input_1 <= "000+++";
        input_2 <= "000000";
        int_1   <= 13;
        int_2   <= 0;

        wait for 10 ns;
        -- 13 / 1
        input_1 <= "000+++";
        input_2 <= "00000+";
        int_1   <= 13;
        int_2   <= 1;

        wait for 10 ns;
        -- 13 / 2, check rounding
        input_1 <= "000+++";
        input_2 <= "0000+-";
        int_1   <= 13;
        int_2   <= 2;

        wait for 10 ns;
        -- -13 / 13
        input_1 <= "000---";
        input_2 <= "000+++";
        int_1   <= -13;
        int_2   <= 13;

        wait for 10 ns;
        -- 13 / -13
        input_1 <= "000+++";
        input_2 <= "000---";
        int_1   <= 13;
        int_2   <= -13;

        wait for 10 ns;
        -- -13 / -13, 00000+
        input_1 <= "000---";
        input_2 <= "000---";
        int_1   <= -13;
        int_2   <= -13;

        wait for 10 ns;
        -- 364/27, 000+++
        input_1 <= "++++++";
        input_2 <= "00+000";
        int_1   <= 364;
        int_2   <= 27;

        wait for 10 ns;
        wait;
    end process;

    process(input_1, input_2)
    begin
        res_v_v <= input_1 / input_2;
        res_i_v <= int_1 / input_2;
        res_v_i <= input_1 / int_2;
    end process;

end architecture;
