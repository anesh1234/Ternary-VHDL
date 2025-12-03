library TVL;
use TVL.kleene_type.all;

entity kleene_unaryfunc_tb is
end entity;

architecture sim of kleene_unaryfunc_tb is

    -- Input signals
    signal scal_in : KLEENE;
    signal vec_in  : KLEENE_VECTOR(3 downto 0);

    -- Scalar output signals for subset of functions
    signal result_COL_s, result_NTI_s, result_STI_s, result_MTI_s : KLEENE;

    -- Vector output signals
    signal result_COL_v, result_NTI_v, result_STI_v, result_MTI_v : KLEENE_VECTOR(3 downto 0);
begin

    -- Scalar: Apply functions with resolved input to resolved result
    result_COL_s <= COL(scal_in);
    result_NTI_s <= NTI(scal_in);
    result_STI_s <= STI(scal_in);
    result_MTI_s <= MTI(scal_in);

    -- Vector: Apply functions with unresolved input to resolved result,
    result_COL_v <= COL(vec_in);
    result_NTI_v <= NTI(vec_in);
    result_STI_v <= STI(vec_in);
    result_MTI_v <= MTI(vec_in);

    -- Stimulus process
    stim_proc: process
    begin

        scal_in <= FALSE;
        vec_in  <= (FALSE, FALSE, FALSE, FALSE);
        wait for 10 ns;

        scal_in <= UNK;
        vec_in  <= (UNK, UNK, UNK, UNK);
        wait for 10 ns;

        scal_in <= TRUE;
        vec_in  <= (TRUE, TRUE, TRUE, TRUE);
        wait for 10 ns;
        wait;
    end process;

end architecture;
