library TVL;
use TVL.bal_logic.all;

entity sum_gate is
    port (
        a   : in  btern_logic;
        b   : in  btern_logic;
        y   : out btern_logic
    );
end entity sum_gate;

architecture rtl of sum_gate is
begin
    y <= SUM(a, b);
end architecture rtl;

library TVL;
use TVL.bal_logic.all;

entity con_gate is
    port (
        a   : in  btern_logic;
        b   : in  btern_logic;
        y   : out btern_logic
    );
end entity con_gate;

architecture rtl of con_gate is
begin
    y <= CON(a, b);
end architecture rtl;

library TVL;
use TVL.bal_logic.all;

entity any_gate is
    port (
        a   : in  btern_logic;
        b   : in  btern_logic;
        y   : out btern_logic
    );
end entity any_gate;

architecture rtl of any_gate is
begin
    y <= ANY(a, b);
end architecture rtl;

