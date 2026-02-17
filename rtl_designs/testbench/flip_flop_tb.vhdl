library ieee;
use ieee.std_logic_1164.all;

library tvl;
use tvl.bal_logic.all;

entity flip_flop_tb is
end entity;

architecture tb of flip_flop_tb is
  -- DUT ports
  signal clk   : STD_LOGIC := '0';    -- binary clock
  signal reset : STD_LOGIC := '1';    -- synchronous reset (start asserted)
  signal d_in  : BTERN_LOGIC := '0';  -- ternary input
  signal q_out : BTERN_LOGIC;         -- ternary output

  -- Clock period constant
  constant Tclk : time := 10 ns;

begin
  ----------------------------------------------------------------------
  -- Clock generation: 100 MHz (10 ns period)
  ----------------------------------------------------------------------
  p_clk : process
  begin
    reset <= '0';
    clk <= '0';
    wait for Tclk/2;
    clk <= '1';
    wait for Tclk/2;
  end process;

  ----------------------------------------------------------------------
  -- DUT instantiation (direct entity instantiation)
  ----------------------------------------------------------------------
  dut: entity work.flip_flop
    port map (
      clk   => clk,
      reset => reset,
      d_in  => d_in,
      q_out => q_out
    );

  ----------------------------------------------------------------------
  -- 4) Stimulus & checks:
  ----------------------------------------------------------------------
  p_stim : process
  begin
    d_in <= '-';  
    wait until rising_edge(clk);

    d_in <= '+';  
    wait until rising_edge(clk);

    d_in <= '0';

    wait;
  end process;

end architecture;
