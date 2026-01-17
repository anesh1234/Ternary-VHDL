library TVL;
use TVL.bal_logic.all;

entity binaryfunc_tb is
end entity;

architecture sim of binaryfunc_tb is

    -- Scalar input
    signal logic_in   : BTERN_LOGIC;
    signal logic_in2  : BTERN_LOGIC;

    -- Vector input
    signal logic_vec_in   : BTERN_LOGIC_VECTOR(5 downto 0);
    signal logic_vec_in2  : BTERN_LOGIC_VECTOR(5 downto 0);

    -- scalar and vectorized result signals per function
    signal result_sum_s : BTERN_LOGIC;
    signal result_sum_v, result_sum_v_s, result_sum_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
    
    signal result_con_s : BTERN_LOGIC;
    signal result_con_v, result_con_v_s, result_con_s_v : BTERN_LOGIC_VECTOR(5 downto 0);

    signal result_nco_s : BTERN_LOGIC;
    signal result_nco_v, result_nco_v_s, result_nco_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_min_s : BTERN_LOGIC;
    signal result_min_v, result_min_v_s, result_min_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_max_s : BTERN_LOGIC;
    signal result_max_v, result_max_v_s, result_max_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_nmi_s : BTERN_LOGIC;
    signal result_nmi_v, result_nmi_v_s, result_nmi_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_nma_s : BTERN_LOGIC;
    signal result_nma_v, result_nma_v_s, result_nma_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_xor_s : BTERN_LOGIC;
    signal result_xor_v, result_xor_v_s, result_xor_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_mul_s : BTERN_LOGIC;
    signal result_mul_v, result_mul_v_s, result_mul_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_imp_s : BTERN_LOGIC;
    signal result_imp_v, result_imp_v_s, result_imp_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_any_s : BTERN_LOGIC;
    signal result_any_v, result_any_v_s, result_any_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_nan_s : BTERN_LOGIC;
    signal result_nan_v, result_nan_v_s, result_nan_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_mle_s : BTERN_LOGIC;
    signal result_mle_v, result_mle_v_s, result_mle_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_ena_s : BTERN_LOGIC;
    signal result_ena_v, result_ena_v_s, result_ena_s_v : BTERN_LOGIC_VECTOR(5 downto 0);
        
    signal result_des_s : BTERN_LOGIC;
    signal result_des_v, result_des_v_s, result_des_s_v : BTERN_LOGIC_VECTOR(5 downto 0);

begin

    -- Apply input signals to all logical function overloads
    result_sum_s <= SUM(logic_in, logic_in2);
    result_sum_v <= SUM(logic_vec_in, logic_vec_in2);
    result_sum_v_s <= SUM(logic_vec_in, logic_in);
    result_sum_s_v <= SUM(logic_in, logic_vec_in);

    result_con_s <= CON(logic_in, logic_in2);
    result_CON_v <= CON(logic_vec_in, logic_vec_in2);
    result_CON_v_s <= CON(logic_vec_in, logic_in);
    result_CON_s_v <= CON(logic_in, logic_vec_in);
    
    result_NCO_s <= NCO(logic_in, logic_in2);
    result_NCO_v <= NCO(logic_vec_in, logic_vec_in2);
    result_NCO_v_s <= NCO(logic_vec_in, logic_in);
    result_NCO_s_v <= NCO(logic_in, logic_vec_in);
    
    result_MIN_s <= MINI(logic_in, logic_in2);
    result_MIN_v <= MINI(logic_vec_in, logic_vec_in2);
    result_MIN_v_s <= MINI(logic_vec_in, logic_in);
    result_MIN_s_v <= MINI(logic_in, logic_vec_in);
    
    result_MAX_s <= MAX(logic_in, logic_in2);
    result_MAX_v <= MAX(logic_vec_in, logic_vec_in2);
    result_MAX_v_s <= MAX(logic_vec_in, logic_in);
    result_MAX_s_v <= MAX(logic_in, logic_vec_in);
    
    result_NMI_s <= NMI(logic_in, logic_in2);
    result_NMI_v <= NMI(logic_vec_in, logic_vec_in2);
    result_NMI_v_s <= NMI(logic_vec_in, logic_in);
    result_NMI_s_v <= NMI(logic_in, logic_vec_in);
    
    result_NMA_s <= NMA(logic_in, logic_in2);
    result_NMA_v <= NMA(logic_vec_in, logic_vec_in2);
    result_NMA_v_s <= NMA(logic_vec_in, logic_in);
    result_NMA_s_v <= NMA(logic_in, logic_vec_in);
    
    result_XOR_s <= logic_in xor logic_in2;
    result_XOR_v <= logic_vec_in xor logic_vec_in2;
    result_XOR_v_s <= logic_vec_in xor logic_in;
    result_XOR_s_v <= logic_in xor logic_vec_in;
    
    result_MUL_s <= MUL(logic_in, logic_in2);
    result_MUL_v <= MUL(logic_vec_in, logic_vec_in2);
    result_MUL_v_s <= MUL(logic_vec_in, logic_in);
    result_MUL_s_v <= MUL(logic_in, logic_vec_in);
    
    result_IMP_s <= IMP(logic_in, logic_in2);
    result_IMP_v <= IMP(logic_vec_in, logic_vec_in2);
    result_IMP_v_s <= IMP(logic_vec_in, logic_in);
    result_IMP_s_v <= IMP(logic_in, logic_vec_in);
    
    result_ANY_s <= ANY(logic_in, logic_in2);
    result_ANY_v <= ANY(logic_vec_in, logic_vec_in2);
    result_ANY_v_s <= ANY(logic_vec_in, logic_in);
    result_ANY_s_v <= ANY(logic_in, logic_vec_in);
    
    result_NAN_s <= NAN(logic_in, logic_in2);
    result_NAN_v <= NAN(logic_vec_in, logic_vec_in2);
    result_NAN_v_s <= NAN(logic_vec_in, logic_in);
    result_NAN_s_v <= NAN(logic_in, logic_vec_in);
    
    result_MLE_s <= MLE(logic_in, logic_in2);
    result_MLE_v <= MLE(logic_vec_in, logic_vec_in2);
    result_MLE_v_s <= MLE(logic_vec_in, logic_in);
    result_MLE_s_v <= MLE(logic_in, logic_vec_in);
    
    result_ENA_s <= ENA(logic_in, logic_in2);
    result_ENA_v <= ENA(logic_vec_in, logic_vec_in2);
    result_ENA_v_s <= ENA(logic_vec_in, logic_in);
    result_ENA_s_v <= ENA(logic_in, logic_vec_in);
    
    result_DES_s <= DES(logic_in, logic_in2);
    result_DES_v <= DES(logic_vec_in, logic_vec_in2);
    result_DES_v_s <= DES(logic_vec_in, logic_in);
    result_DES_s_v <= DES(logic_in, logic_vec_in);

    -- Stimulus process
    stim_proc: process
    begin

        logic_in <= '-';
        logic_in2 <= '-';
        logic_vec_in <= "------";
        logic_vec_in2 <= "000000";

        wait for 10 ns;

        logic_in <= '-';
        logic_in2 <= '0';
        logic_vec_in <= "000000";
        logic_vec_in2 <= "++++++";

        wait for 10 ns;

        logic_in <= '-';
        logic_in2 <= '+';
        logic_vec_in <= "++++++";
        logic_vec_in2 <= "------";

        wait for 10 ns;
        wait;
    end process;

end architecture;
