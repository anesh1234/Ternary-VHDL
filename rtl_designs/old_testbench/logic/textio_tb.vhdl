library TVL;
use TVL.bal_logic.all;

entity textio_tb is
end entity;

architecture sim of textio_tb is
    -- input signals
    signal scal : BTERN_LOGIC := '+';
    signal vec  : BTERN_LOGIC_VECTOR(5 downto 0) := "++0++0";

    -- output signals
    signal str_scal : STRING(1 to 1);
    signal str_vec  : STRING(6 downto 1);

begin

    -- Stimulus process
    stim_proc: process
    begin
        str_scal <= TO_STRING(scal);
        str_vec  <= TO_STRING(vec);
        wait for 5 ns;
        wait;
    end process;


end architecture;
