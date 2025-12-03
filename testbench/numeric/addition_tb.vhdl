library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity addition_tb is
end entity;

architecture sim of addition_tb is

    -- Input signals, decimal +10, -10 and 1
    signal v_num1 : BTERN_LOGIC_VECTOR(3 downto 0) := BTERN_ULOGIC_VECTOR'("0+0+");
    signal v_num2 : BTERN_LOGIC_VECTOR(3 downto 0) := BTERN_ULOGIC_VECTOR'("0-0-");
    signal s_num  : BTERN_LOGIC := '+';
    signal int    : INTEGER := 25;

    -- Addition output signals
    signal result_plus_v_v : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_plus_v_s : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_plus_v_i : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_plus_i_v : BTERN_LOGIC_VECTOR(3 downto 0);

    -- Subtraction output signals   
    signal result_minus_v_v_1 : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_minus_v_v_2 : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_minus_v_s   : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_minus_v_i   : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_minus_i_v   : BTERN_LOGIC_VECTOR(3 downto 0);
    

begin
    -- Stimulus process
    stim_proc: process
    begin
        result_plus_v_i <= v_num1 + int;
        result_plus_i_v <= int + v_num1;

        result_minus_v_i <= v_num1 - int;
        result_minus_i_v <= int - v_num1;
        wait for 5 ns;
        wait;
    end process;

end architecture;
