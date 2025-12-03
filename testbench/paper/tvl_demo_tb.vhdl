library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;
use TVL.kleene_type.all;

entity tvl_demo_tb is
end entity;

architecture Behavioral of tvl_demo_tb is
    -- Inputs
    signal a      : BTERN_LOGIC := '+';
    signal b      : BTERN_LOGIC := '-';
    signal v1     : BTERN_LOGIC_VECTOR(23 downto 0) := BTERN_LOGIC_VECTOR'("--------00000000++++++++");
    signal v2     : BTERN_LOGIC_VECTOR(2 downto 0) := BTERN_LOGIC_VECTOR'("+++");
    -- Outputs
    signal res1 : BTERN_LOGIC;
    signal res2 : BTERN_LOGIC_VECTOR(23 downto 0);
    signal res3 : KLEENE;
begin
    process
    begin
        res1 <= MAX(a, b);   -- 2-arity MAX operator
        res2 <= v1 + v2;     -- Overloaded '+'
        res3 <= SPACE(a, b); -- Spaceship operator
        wait for 10 ns;
        wait;
    end process;
end architecture;
