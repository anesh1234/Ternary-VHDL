library IEEE;
use IEEE.std_logic_1164.all;

library TVL;
use TVL.bal_logic.all;

entity TDEC_1_3 is
    PORT (x       : IN  btern_logic;
          a, b, c : OUT std_logic);
end entity;

architecture structural of TDEC_1_3 is
    -- Component declaration
    component nor_gate is
        port (
            a, b : in  std_logic;
            c    : out std_logic 
        );
    end component;

    signal a1, b1, c1 : std_logic;
begin
    -- Instantiate arity-2 NOR gate
    NOR1 : nor_gate 
        port map(
            a => a1, 
            b => c1, 
            c => b1 );

    process(x)
    begin
        a1 <= to_std_logic(NTI(x));
        c1 <= to_std_logic(NTI(PTI(x)));
    end process;

    a <= a1; 
    b <= b1; 
    c <= c1;

end architecture;