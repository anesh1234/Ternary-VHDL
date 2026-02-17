library TVL;
use TVL.kleene_pkg.all;

entity kleene_binaryfunc_tb is
end entity;

architecture sim of kleene_binaryfunc_tb is

    -- Input signals
    signal scal_in_1 : KLEENE;
    signal scal_in_2 : KLEENE;
    signal vec_in_1  : KLEENE_VECTOR(3 downto 0);
    signal vec_in_2  : KLEENE_VECTOR(3 downto 0);

    -- scalar and vectorized output signals per function
    signal result_sum_s : KLEENE;
    signal result_sum_v, result_sum_v_s : KLEENE_VECTOR(3 downto 0);
    
    signal result_con_s : KLEENE;
    signal result_con_v, result_con_v_s : KLEENE_VECTOR(3 downto 0);

    signal result_nco_s : KLEENE;
    signal result_nco_v, result_nco_v_s : KLEENE_VECTOR(3 downto 0);
        
    signal result_min_s : KLEENE;
    signal result_min_v, result_min_v_s : KLEENE_VECTOR(3 downto 0);

begin

    -- Apply input signals to subset of functions
    result_sum_s <= SUM(scal_in_1, scal_in_2);
    result_sum_v <= SUM(vec_in_1, vec_in_2);
    result_sum_v_s <= SUM(vec_in_1, scal_in_1);

    result_con_s <= CON(scal_in_1, scal_in_2);
    result_CON_v <= CON(vec_in_1, vec_in_2);
    result_CON_v_s <= CON(vec_in_1, scal_in_1);
    
    result_NCO_s <= NCO(scal_in_1, scal_in_2);
    result_NCO_v <= NCO(vec_in_1, vec_in_2);
    result_NCO_v_s <= NCO(vec_in_1, scal_in_1);
    
    result_MIN_s <= MINI(scal_in_1, scal_in_2);
    result_MIN_v <= MINI(vec_in_1, vec_in_2);
    result_MIN_v_s <= MINI(vec_in_1, scal_in_1);

    -- Stimulus process
    stim_proc: process
    begin

        scal_in_1 <= FALSE;
        vec_in_1 <= (FALSE, FALSE, FALSE, FALSE);
        scal_in_2 <= FALSE;
        vec_in_2 <= (FALSE, FALSE, FALSE, FALSE);

        wait for 10 ns;

        scal_in_1 <= FALSE;
        vec_in_1 <= (FALSE, FALSE, FALSE, FALSE);
        scal_in_2 <= UNK;
        vec_in_2 <= (UNK, UNK, UNK, UNK);

        wait for 10 ns;

        scal_in_1 <= FALSE;
        vec_in_1 <= (FALSE, FALSE, FALSE, FALSE);
        scal_in_2 <= TRUE;
        vec_in_2 <= (TRUE, TRUE, TRUE, TRUE);
        
        wait for 10 ns;
        wait;
    end process;

end architecture;
