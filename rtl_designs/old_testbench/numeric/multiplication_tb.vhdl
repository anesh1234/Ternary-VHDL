library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity multiplication_tb is
end entity;

architecture sim of multiplication_tb is

    -- Input signals, decimal +10, -10
    signal v_num1 : BTERN_LOGIC_VECTOR(3 downto 0) := BTERN_ULOGIC_VECTOR'("0+0+");
    signal v_num2 : BTERN_LOGIC_VECTOR(3 downto 0) := BTERN_ULOGIC_VECTOR'("0-0-");
    signal int    : INTEGER                       := 25;

    -- Addition output signals
    signal result_mult_v_v  : BTERN_LOGIC_VECTOR(7 downto 0);
    signal result_mult_v_v2 : BTERN_LOGIC_VECTOR(7 downto 0);
    signal result_mult_v_i  : BTERN_LOGIC_VECTOR(7 downto 0);
    signal result_mult_i_v  : BTERN_LOGIC_VECTOR(7 downto 0);

    

begin
    -- Stimulus process
    stim_proc: process
    begin
        result_mult_v_v  <= v_num1 * v_num1;
        result_mult_v_v2 <= v_num1 * v_num2;
        result_mult_v_i  <= v_num1 * int;
        result_mult_i_v  <= int * v_num1;
        wait for 5 ns;
        wait;
    end process;

end architecture;
