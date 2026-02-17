library TVL;
use TVL.bal_logic.all;

entity unaryfunc_tb is
end entity;

architecture sim of unaryfunc_tb is

    -- Scalar inputs
    signal ulogic_in     : BTERN_ULOGIC;
    signal logic_in      : BTERN_LOGIC;

    -- Vector inputs
    signal ulogic_vec_in : BTERN_ULOGIC_VECTOR(3 downto 0);
    signal logic_vec_in  : BTERN_LOGIC_VECTOR(3 downto 0);

    -- Resolved scalar output signals
    signal result_COL_s, result_NTI_s, result_STI_s, result_MTI_s : BTERN_LOGIC;
    signal result_INC_s, result_PTI_s, result_DEC_s, result_CLD_s : BTERN_LOGIC;
    signal result_COM_s, result_IPT_s, result_IMT_s, result_BUF_s : BTERN_LOGIC;
    signal result_CLU_s, result_INT_s, result_COH_s               : BTERN_LOGIC;

    -- Unresolved scalar output signals
    signal result_COL_s_U, result_NTI_s_U, result_STI_s_U, result_MTI_s_U : BTERN_ULOGIC;
    signal result_INC_s_U, result_PTI_s_U, result_DEC_s_U, result_CLD_s_U : BTERN_ULOGIC;
    signal result_COM_s_U, result_IPT_s_U, result_IMT_s_U, result_BUF_s_U : BTERN_ULOGIC;
    signal result_CLU_s_U, result_INT_s_U, result_COH_s_U               : BTERN_ULOGIC;

    -- Resolved vector output signals
    signal result_COL_v, result_NTI_v, result_STI_v, result_MTI_v : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_INC_v, result_PTI_v, result_DEC_v, result_CLD_v : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_COM_v, result_IPT_v, result_IMT_v, result_BUF_v : BTERN_LOGIC_VECTOR(3 downto 0);
    signal result_CLU_v, result_INT_v, result_COH_v               : BTERN_LOGIC_VECTOR(3 downto 0);

    -- Unresolved vector output signals
    signal result_COL_v_U, result_NTI_v_U, result_STI_v_U, result_MTI_v_U : BTERN_ULOGIC_VECTOR(3 downto 0);
    signal result_INC_v_U, result_PTI_v_U, result_DEC_v_U, result_CLD_v_U : BTERN_ULOGIC_VECTOR(3 downto 0);
    signal result_COM_v_U, result_IPT_v_U, result_IMT_v_U, result_BUF_v_U : BTERN_ULOGIC_VECTOR(3 downto 0);
    signal result_CLU_v_U, result_INT_v_U, result_COH_v_U               : BTERN_ULOGIC_VECTOR(3 downto 0);

begin

    -- Scalar: Apply functions with unresolved input to unresolved result
    -- Commented out after error ocurred due to multiple drivers for same source
    -- result_COL_s_U <= COL(ulogic_in);
    -- result_NTI_s_U <= NTI(ulogic_in);
    -- result_STI_s_U <= STI(ulogic_in);
    -- result_MTI_s_U <= MTI(ulogic_in);
    -- result_INC_s_U <= INC(ulogic_in);
    -- result_PTI_s_U <= PTI(ulogic_in);
    -- result_DEC_s_U <= DEC(ulogic_in);
    -- result_CLD_s_U <= CLD(ulogic_in);
    -- result_COM_s_U <= COM(ulogic_in);
    -- result_IPT_s_U <= IPT(ulogic_in);
    -- result_IMT_s_U <= IMT(ulogic_in);
    -- result_BUF_s_U <= BUF(ulogic_in);
    -- result_CLU_s_U <= CLU(ulogic_in);
    -- result_INT_s_U <= INT(ulogic_in);
    -- result_COH_s_U <= COH(ulogic_in);

    -- Scalar: Apply functions with resolved input to unresolved result
    result_COL_s_U <= COL(logic_in);
    result_NTI_s_U <= NTI(logic_in);
    result_STI_s_U <= STI(logic_in);
    result_MTI_s_U <= MTI(logic_in);
    result_INC_s_U <= INC(logic_in);
    result_PTI_s_U <= PTI(logic_in);
    result_DEC_s_U <= DEC(logic_in);
    result_CLD_s_U <= CLD(logic_in);
    result_COM_s_U <= COM(logic_in);
    result_IPT_s_U <= IPT(logic_in);
    result_IMT_s_U <= IMT(logic_in);
    result_BUF_s_U <= BUF(logic_in);
    result_CLU_s_U <= CLU(logic_in);
    result_INT_s_U <= INT(logic_in);
    result_COH_s_U <= COH(logic_in);

    -- Scalar: Apply functions with resolved input to resolved result,
    -- to verify both logical functions and that multiple resolved input signals 
    -- can drive one resolved output.
    -- Commented out after successful verification of the former
    result_COL_s <= COL(logic_in);
    result_NTI_s <= NTI(logic_in);
    result_STI_s <= STI(logic_in);
    result_MTI_s <= MTI(logic_in);
    result_INC_s <= INC(logic_in);
    result_PTI_s <= PTI(logic_in);
    result_DEC_s <= DEC(logic_in);
    result_CLD_s <= CLD(logic_in);
    result_COM_s <= COM(logic_in);
    result_IPT_s <= IPT(logic_in);
    result_IMT_s <= IMT(logic_in);
    result_BUF_s <= BUF(logic_in);
    result_CLU_s <= CLU(logic_in);
    result_INT_s <= INT(logic_in);
    result_COH_s <= COH(logic_in);

    -- Scalar: Apply functions with resolved input to resolved result
    -- To verify both logical functions and that multiple resolved input signals 
    -- can drive one resolved output.
    result_COL_s <= COL(logic_in);
    result_NTI_s <= NTI(logic_in);
    result_STI_s <= STI(logic_in);
    result_MTI_s <= MTI(logic_in);
    result_INC_s <= INC(logic_in);
    result_PTI_s <= PTI(logic_in);
    result_DEC_s <= DEC(logic_in);
    result_CLD_s <= CLD(logic_in);
    result_COM_s <= COM(logic_in);
    result_IPT_s <= IPT(logic_in);
    result_IMT_s <= IMT(logic_in);
    result_BUF_s <= BUF(logic_in);
    result_CLU_s <= CLU(logic_in);
    result_INT_s <= INT(logic_in);
    result_COH_s <= COH(logic_in);

    -- Vector: Apply functions with unresolved input to unresolved result
    result_COL_v_U <= COL(ulogic_vec_in);
    result_NTI_v_U <= NTI(ulogic_vec_in);
    result_STI_v_U <= STI(ulogic_vec_in);
    result_MTI_v_U <= MTI(ulogic_vec_in);
    result_INC_v_U <= INC(ulogic_vec_in);
    result_PTI_v_U <= PTI(ulogic_vec_in);
    result_DEC_v_U <= DEC(ulogic_vec_in);
    result_CLD_v_U <= CLD(ulogic_vec_in);
    result_COM_v_U <= COM(ulogic_vec_in);
    result_IPT_v_U <= IPT(ulogic_vec_in);
    result_IMT_v_U <= IMT(ulogic_vec_in);
    result_BUF_v_U <= BUF(ulogic_vec_in);
    result_CLU_v_U <= CLU(ulogic_vec_in);
    result_INT_v_U <= INT(ulogic_vec_in);
    result_COH_v_U <= COH(ulogic_vec_in);

    -- Vector: Apply functions with resolved input to unresolved result
    -- Commented out after error ocurred due to multiple drivers for same source
    -- result_COL_v_U <= COL(logic_vec_in);
    -- result_NTI_v_U <= NTI(logic_vec_in);
    -- result_STI_v_U <= STI(logic_vec_in);
    -- result_MTI_v_U <= MTI(logic_vec_in);
    -- result_INC_v_U <= INC(logic_vec_in);
    -- result_PTI_v_U <= PTI(logic_vec_in);
    -- result_DEC_v_U <= DEC(logic_vec_in);
    -- result_CLD_v_U <= CLD(logic_vec_in);
    -- result_COM_v_U <= COM(logic_vec_in);
    -- result_IPT_v_U <= IPT(logic_vec_in);
    -- result_IMT_v_U <= IMT(logic_vec_in);
    -- result_BUF_v_U <= BUF(logic_vec_in);
    -- result_CLU_v_U <= CLU(logic_vec_in);
    -- result_INT_v_U <= INT(logic_vec_in);
    -- result_COH_v_U <= COH(logic_vec_in);

    -- Vector: Apply functions with unresolved input to resolved result,
    -- to verify both logical functions and that multiple resolved input signals 
    -- can drive one resolved output.
    -- Commented out after successful verification of the former
    result_COL_v <= COL(logic_vec_in);
    result_NTI_v <= NTI(logic_vec_in);
    result_STI_v <= STI(logic_vec_in);
    result_MTI_v <= MTI(logic_vec_in);
    result_INC_v <= INC(logic_vec_in);
    result_PTI_v <= PTI(logic_vec_in);
    result_DEC_v <= DEC(logic_vec_in);
    result_CLD_v <= CLD(logic_vec_in);
    result_COM_v <= COM(logic_vec_in);
    result_IPT_v <= IPT(logic_vec_in);
    result_IMT_v <= IMT(logic_vec_in);
    result_BUF_v <= BUF(logic_vec_in);
    result_CLU_v <= CLU(logic_vec_in);
    result_INT_v <= INT(logic_vec_in);
    result_COH_v <= COH(logic_vec_in);

    -- Vector: Apply functions with resolved input to resolved result,
    -- to verify both logical functions and that multiple resolved input signals 
    -- can drive one resolved output.
    result_COL_v <= COL(logic_vec_in);
    result_NTI_v <= NTI(logic_vec_in);
    result_STI_v <= STI(logic_vec_in);
    result_MTI_v <= MTI(logic_vec_in);
    result_INC_v <= INC(logic_vec_in);
    result_PTI_v <= PTI(logic_vec_in);
    result_DEC_v <= DEC(logic_vec_in);
    result_CLD_v <= CLD(logic_vec_in);
    result_COM_v <= COM(logic_vec_in);
    result_IPT_v <= IPT(logic_vec_in);
    result_IMT_v <= IMT(logic_vec_in);
    result_BUF_v <= BUF(logic_vec_in);
    result_CLU_v <= CLU(logic_vec_in);
    result_INT_v <= INT(logic_vec_in);
    result_COH_v <= COH(logic_vec_in);

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply '-' for 50 ns
        ulogic_in <= '-';
        logic_in <= '-';
        ulogic_vec_in <= ('-', '-', '-', '-');
        logic_vec_in <= ('-', '-', '-', '-');
        wait for 50 ns;

        -- Apply '0' for 50 ns
        ulogic_in <= '0';
        logic_in <= '0';
        ulogic_vec_in <= ('0', '0', '0', '0');
        logic_vec_in <= ('0', '0', '0', '0');
        wait for 50 ns;

        -- Apply '+' for 50 ns
        ulogic_in <= '+';
        logic_in <= '+';
        ulogic_vec_in <= ('+', '+', '+', '+');
        logic_vec_in <= ('+', '+', '+', '+');
        wait for 50 ns;

        -- Apply 'X' for 50 ns
        ulogic_in <= 'X';
        logic_in <= 'X';
        ulogic_vec_in <= ('X', 'X', 'X', 'X');
        logic_vec_in <= ('X', 'X', 'X', 'X');
        wait for 50 ns;

        -- Apply 'U' for 50 ns
        ulogic_in <= 'U';
        logic_in <= 'U';
        ulogic_vec_in <= ('U', 'U', 'U', 'U');
        logic_vec_in <= ('U', 'U', 'U', 'U');
        wait for 50 ns;

        wait;
    end process;

end architecture;
