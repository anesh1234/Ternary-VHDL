library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;
use TVL.kleene_pkg.all;
library STD;
use STD.standard.all;

entity tests_tb is
end entity;

architecture Behavioral of tests_tb is
    -- Inputs
    signal a : BOOLEAN_VECTOR(3 downto 0) := (true,false,true,false);
    signal b : KLEENE := unk;
    -- Outputs
    signal res1 : STRING(1 to 18);
    signal res2 : STRING(1 to 3);
begin
    process
    begin
        res1 <= To_STRING(a);
        res2 <= To_STRING(b);
        wait for 10 ns;
        wait;
    end process;
end architecture;
