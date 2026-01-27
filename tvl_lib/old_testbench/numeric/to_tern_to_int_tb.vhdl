library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity to_tern_to_int_tb is
end entity;

architecture sim of to_tern_to_int_tb is
    -- Input signals
    signal int     : INTEGER := 364;
    signal ternvec : BTERN_ULOGIC_VECTOR(5 downto 0) := BTERN_ULOGIC_VECTOR'("++++++");

    -- Output signals
    signal result_int     : INTEGER;
    signal result_ternvec : BTERN_ULOGIC_VECTOR(5 downto 0);

begin
    -- Stimulus process
    stim_proc: process
    begin
        int     <= 364;
        ternvec <= "++++++";
        wait for 5 ns;
        int     <= 2;
        ternvec <= "0000+-";
        wait for 5 ns;
        int     <= 1;
        ternvec <= "00000+";
        wait for 5 ns;
        int     <= 0;
        ternvec <= "000000";
        wait for 5 ns;
        int     <= -1;
        ternvec <= "00000-";
        wait for 5 ns;
        int     <= -2;
        ternvec <= "0000-+";
        wait for 5 ns;
        int     <= -364;
        ternvec <= "------";
        wait for 5 ns;
        wait;
    end process;

    process(int, ternvec)
    begin
        result_int     <= TO_INT(ternvec);
        result_ternvec <= TO_BALTERN(int, result_ternvec'length);
    end process;

end architecture;
