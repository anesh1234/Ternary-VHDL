library TVL;
use TVL.bal_logic.all;

entity ord_relops_tb is
end entity;

architecture sim of ord_relops_tb is

    -- Input signals
    signal s_1 : BTERN_ULOGIC := '-';
    signal s_2 : BTERN_ULOGIC := '0';
    signal s_3 : BTERN_ULOGIC := '+';

    -- v_num1 = 13 (dec)
    signal v_num1      : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000+++");
    signal v_num2      : BTERN_ULOGIC_VECTOR(2 downto 0) := BTERN_ULOGIC_VECTOR'("+++");
    signal v_num3      : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("000+--");
    signal v_num_error : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("00Z+--");
    signal empty_vec   : BTERN_ULOGIC_VECTOR(-1 downto 0);
    signal int         : INTEGER := 35;

    -- Output signals
    signal result_more1    : BOOLEAN;
    signal result_more2    : BOOLEAN;
    signal result_more3    : BOOLEAN;
    signal result_more4    : BOOLEAN;
    signal result_more5    : BOOLEAN;
    signal result_more_v_i : BOOLEAN;
    signal result_more_i_v : BOOLEAN;

    signal result_less1    : BOOLEAN;
    signal result_less2    : BOOLEAN;
    signal result_less3    : BOOLEAN;
    signal result_less4    : BOOLEAN;
    signal result_less_v_i : BOOLEAN;
    signal result_less_i_v : BOOLEAN;

    signal result_leq1    : BOOLEAN;
    signal result_leq2    : BOOLEAN;
    signal result_leq3    : BOOLEAN;
    signal result_leq4    : BOOLEAN;
    signal result_leq_v_i : BOOLEAN;
    signal result_leq_i_v : BOOLEAN;

    signal result_meq1    : BOOLEAN;
    signal result_meq2    : BOOLEAN;
    signal result_meq3    : BOOLEAN;
    signal result_meq4    : BOOLEAN;
    signal result_meq_v_i : BOOLEAN;
    signal result_meq_i_v : BOOLEAN;

    signal result_neq1    : BOOLEAN;
    signal result_neq2    : BOOLEAN;
    signal result_neq3    : BOOLEAN;
    signal result_neq4    : BOOLEAN;
    signal result_neq_v_i : BOOLEAN;
    signal result_neq_i_v : BOOLEAN;

    signal result_eq1    : BOOLEAN;
    signal result_eq2    : BOOLEAN;
    signal result_eq3    : BOOLEAN;
    signal result_eq4    : BOOLEAN;
    signal result_eq_v_i : BOOLEAN;
    signal result_eq_i_v : BOOLEAN;

begin
    -- Stimulus process
    stim_proc: process
    begin

        result_more1    <= v_num1 > v_num2;
        result_more2    <= v_num1 > v_num3;
        result_more3    <= v_num3 > v_num1;
        result_more4    <= v_num3 > v_num_error;
        result_more5    <= v_num3 > empty_vec;
        result_more_v_i <= v_num1 > int;
        result_more_i_v <= int    > v_num1;

        result_less1    <= v_num1 < v_num2;
        result_less2    <= v_num1 < v_num3;
        result_less3    <= v_num3 < v_num1;
        result_less4    <= v_num3 < v_num_error;
        result_less_v_i <= v_num1 < int;
        result_less_i_v <= int    < v_num1;

        result_leq1    <= v_num1 <= v_num2;
        result_leq2    <= v_num1 <= v_num3;
        result_leq3    <= v_num3 <= v_num1;
        result_leq4    <= v_num3 <= v_num_error;
        result_leq_v_i <= v_num1 <= int;
        result_leq_i_v <= int    <= v_num1;

        result_meq1    <= v_num1 >= v_num2;
        result_meq2    <= v_num1 >= v_num3;
        result_meq3    <= v_num3 >= v_num1;
        result_meq4    <= v_num3 >= v_num_error;
        result_meq_v_i <= v_num1 >= int;
        result_meq_i_v <= int    >= v_num1;

        result_neq1    <= v_num1 /= v_num2;
        result_neq2    <= v_num1 /= v_num3;
        result_neq3    <= v_num3 /= v_num1;
        result_neq4    <= v_num3 /= v_num_error;
        result_neq_v_i <= v_num1 /= int;
        result_neq_i_v <= int    /= v_num1;
        
        result_eq1    <= v_num1 = v_num2;
        result_eq2    <= v_num1 = v_num3;
        result_eq3    <= v_num3 = v_num1;
        result_eq4    <= v_num3 = v_num_error;
        result_eq_v_i <= v_num1 = int;
        result_eq_i_v <= int    = v_num1;

        wait for 5 ns;
        wait;
    end process;

end architecture;
