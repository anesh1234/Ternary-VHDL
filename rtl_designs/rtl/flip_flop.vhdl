library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
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
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                q_reg <= '0';   
            else
                q_reg <= d_in;  
            end if;
        end if;
    end process;
    q_out <= q_reg;
end architecture behavioral;
 