library IEEE;
use IEEE.std_logic_1164.all;
library TVL;
use TVL.bal_logic.all;

entity flip_flop is
    Port (clk   : in  STD_LOGIC; -- binary signal
          reset : in  STD_LOGIC;
          d_in  : in  BTERN_LOGIC; -- ternary signal
          q_out : out BTERN_LOGIC);
end flip_flop;

architecture behavioral of flip_flop is
    signal q_reg : BTERN_LOGIC := '0';
begin

    -- Behavioral description (process)
    process (clk, reset)
    begin
        if reset = '1' then
            q_reg <= '0';   
        elsif rising_edge(clk) then
            q_reg <= d_in;  
        end if;
    end process;

    -- Dataflow description (signal assignment)
    q_out <= q_reg;

end architecture behavioral;
 