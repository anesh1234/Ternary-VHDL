library IEEE;
use IEEE.std_logic_1164.all;

entity nor_gate is
    port (
        a   : in  std_logic;
        b   : in  std_logic;
        y   : out std_logic
    );
end entity nor_gate;

architecture rtl of nor_gate is
begin
    y <= a nor b;
end architecture rtl;