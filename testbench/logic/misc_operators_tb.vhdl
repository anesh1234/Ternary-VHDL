library TVL;
use TVL.bal_logic.all;
use TVL.kleene_type.all;

entity misc_operators_tb is
end entity;

architecture sim of misc_operators_tb is
    -- Input signals
    signal s_num1 : BTERN_LOGIC := '+';
    signal s_num2 : BTERN_LOGIC := '+';
    signal s_num3 : BTERN_LOGIC := '-';
    signal s_num4 : BTERN_LOGIC := 'Z';

    signal v_num1 : BTERN_LOGIC_VECTOR(3 downto 0) := BTERN_ULOGIC_VECTOR'("0+0+");
    signal v_num2 : BTERN_LOGIC_VECTOR(3 downto 0) := BTERN_ULOGIC_VECTOR'("0+0+");
    signal v_num3 : BTERN_LOGIC_VECTOR(3 downto 0) := BTERN_ULOGIC_VECTOR'("0-0-");

    -- Output signals
    signal res_qq : KLEENE;

    -- Scalar output signals
    signal eq_bool_s : BOOLEAN := FALSE;
    signal ineq_bool_s : BOOLEAN := FALSE;
    signal les_bool_s : BOOLEAN := FALSE;
    signal leq_bool_s : BOOLEAN := FALSE;
    signal lar_bool_s : BOOLEAN := FALSE;
    signal lareq_bool_s : BOOLEAN := FALSE;

    --Vectorized output signals
    signal eq_bool_v : BOOLEAN := FALSE;
    signal ineq_bool_v : BOOLEAN := FALSE;
    signal les_bool_v : BOOLEAN := FALSE;
    signal leq_bool_v : BOOLEAN := FALSE;
    signal lar_bool_v : BOOLEAN := FALSE;
    signal lareq_bool_v : BOOLEAN := FALSE;

begin
    -- Stimulus process
    stim_proc: process
    begin
        res_qq <= ?? s_num3;

        eq_bool_s <= (s_num1 = s_num2);
        eq_bool_v <= (v_num1 = v_num2);

        ineq_bool_s <= (s_num1 /= s_num2);
        ineq_bool_v <= (v_num1 /= v_num2);

        les_bool_s <= (s_num1 < s_num2);
        les_bool_v <= (v_num1 < v_num2);

        wait for 10 ns;
        
        res_qq <= ?? s_num4;

        eq_bool_s <= (s_num1 = s_num3);
        eq_bool_v <= (v_num1 = v_num3);

        ineq_bool_s <= (s_num1 /= s_num3);
        ineq_bool_v <= (v_num1 /= v_num3);

        les_bool_s <= (s_num3 < s_num1);
        les_bool_v <= (v_num3 < v_num1);
        wait for 10 ns;
        wait;
    end process;

end architecture;
