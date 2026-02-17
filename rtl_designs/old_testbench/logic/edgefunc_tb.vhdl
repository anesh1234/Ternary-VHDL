library TVL;
use TVL.bal_logic.all;

entity edgefunc_tb is
end entity;

architecture sim of edgefunc_tb is

    -- Inputs
    signal input_signal : BTERN_LOGIC;

    -- Outputs
    signal any_rising : BTERN_LOGIC;
    signal any_falling : BTERN_LOGIC;

    signal out_mz : BTERN_LOGIC;
    signal out_zp : BTERN_LOGIC;
    signal out_mp : BTERN_LOGIC;
    signal out_pz : BTERN_LOGIC;
    signal out_zm : BTERN_LOGIC;
    signal out_pm : BTERN_LOGIC;
begin

    -- Stimulus process
    stim_proc: process
    begin
        input_signal <= '-';
        wait for 5 ns;
        input_signal <= '0';
        wait for 5 ns;
        input_signal <= '+';
        wait for 5 ns;
        input_signal <= '-';
        wait for 5 ns;
        input_signal <= '+';
        wait for 5 ns;
        input_signal <= '0';
        wait for 5 ns;
        input_signal <= '-';
        wait for 5 ns;
        wait;
    end process;
    
    -- Once a signal has been set in a VHDL process, it retains its value until changed.
    -- As wait statements cannot be used in a sensitized process,
    -- this creates some challenges when creating this testbench.
    -- The choice was made to only make sure that no rising edge signals
    -- could be positive when the input signal was falling and vice versa.
    process(input_signal)
    begin
        -- React to rising edges
        if any_rising_edge(input_signal) then
            any_rising <= '+';
            any_falling <= '0';
            out_pz <= '0';
            out_zm <= '0';
            out_pm <= '0';
        end if;
        if mz_rising_edge(input_signal) then
            out_mz <= '+';
        end if;
        if zp_rising_edge(input_signal) then
            out_zp <= '+';
        end if;
        if mp_rising_edge(input_signal) then
            out_mp <= '+';
        end if;
        
        -- React to falling edges
        if any_falling_edge(input_signal) then
            any_falling <= '+';
            any_rising <= '0';
            out_mz <= '0';
            out_zp <= '0';
            out_mp <= '0';
        end if;
        if pz_falling_edge(input_signal) then
            out_pz <= '+';
        end if;
        if zm_falling_edge(input_signal) then
            out_zm <= '+';
        end if;
        if pm_falling_edge(input_signal) then
            out_pm <= '+';
        end if;
    end process;

end architecture;