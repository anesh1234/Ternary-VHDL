library TVL;
use TVL.bal_logic.all;

entity btern_full_adder is
    port (
        a     : in  btern_logic;
        b     : in  btern_logic;
        c     : in  btern_logic;
        sum   : out btern_logic;
        carry : out btern_logic
    );
end entity btern_full_adder;

-- Structural architecture: no logic here, only component wiring
architecture structural of btern_full_adder is

    -- Step 1: Declare the components we want to use
    component any_gate is
        port (
            a   : in  btern_logic;
            b   : in  btern_logic;
            y   : out btern_logic
        );
    end component;

    component con_gate is
        port (
            a   : in  btern_logic;
            b   : in  btern_logic;
            y   : out btern_logic
        );
    end component;

    component sum_gate is
        port (
            a   : in  btern_logic;
            b   : in  btern_logic;
            y   : out btern_logic
        );
    end component;

    -- connecting signals
    signal s1_out : btern_logic;
    signal c1_out : btern_logic;
    signal c2_out : btern_logic;

begin

    -- Step 2: Instantiate (wire up) the components
    S1 : sum_gate
        port map (
            a => a,
            b => b,
            y => s1_out
        );

    S2 : sum_gate
        port map (
            a => c,
            b => s1_out,
            y => sum
        );

    C1 : con_gate
        port map (
            a => a,
            b => b,
            y => c1_out
        );

    C2 : con_gate
        port map (
            a => c,
            b => s1_out,
            y => c2_out
        );

    A1 : any_gate
        port map (
            a => c2_out,
            b => c1_out,
            y => carry
        );

end architecture structural;
