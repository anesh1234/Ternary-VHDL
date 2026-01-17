library TVL;
use TVL.bal_logic.all;

entity ternary_ex is
    port(data1, data2 : in BTERN_LOGIC; 
        q : out BTERN_LOGIC );
    end;

architecture RTL of ternary_ex is
begin
    q <= MINI(data1, data2);
end RTL;
