library IEEE;
use IEEE.Std_Logic_1164.all;

entity binary_ex is
    port(data1, data2 : in std_logic; 
        q : out std_logic );
    end;

architecture RTL of binary_ex is
begin
    q <= data1 and data2;
end RTL;
