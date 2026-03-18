library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

library TVL;
USE TVL.bal_logic.all;

entity generic_stimulus_tb is
end entity generic_stimulus_tb;

architecture Behavioral of generic_stimulus_tb is
    -- Component declaration (replace with your actual component)
    component TDEC1_3
       PORT (x     : IN  bal_logic;
             a     : OUT std_logic;
             b     : OUT std_logic;
             c     : OUT std_logic);
    end component;
    
    -- Input and output signals (adjust to match your component)
    signal x              : bal_logic; -- VCD can't see these
    signal a, b, c        : std_logic; -- VCD sees these
    signal xl             : std_logic; -- these are displayed in VCD

    -- Stimulation record type (adjust as needed)
    type stim_record is record
        step_num   : integer;
        state      : string(1 to 1);  -- Adjust size as needed
        inputs     : string(1 to 1);  -- Adjust size as needed
        outputs    : string(1 to 3);  -- Adjust size as needed
        next_state : string(1 to 1);  -- Adjust size as needed
    end record;
    -- Array to hold the stimulation records
    type stim_array is array (natural range <>) of stim_record;
    -- Example stimulation data (replace with your actual data)
    constant stim_data : stim_array := (
    --             x    abc
        ( 1, "X", "-", "100", "X"), -- Step numbers go 1,2,3,...
        ( 2, "X", "0", "010", "X"),
        ( 3, "X", "+", "001", "X")   
 --( 4, "X", "2", "200", "X"),
        --( 5, "X", "2", "200", "X"),
        --( 6, "X", "0", "000", "X"),
        --( 7, "X", "0", "100", "X"),
        --( 8, "X", "1", "200", "X"),
        --( 9, "X", "2", "110", "X"), 
        --(10, "X", "1", "010", "X"),
        --(11, "X", "1", "200", "X")  
    );

    -- Function to convert string (one char at a time) to bal_logic
    function to_bal_logic (ch : character) return bal_logic is
    begin
        case ch is
            when '-' => return '-';
            when '0' => return '0';
            when '+' => return '+';
            when 'X' | ' ' => return 'U';  -- Treat spaces as 'X' for don't care states
            when others => assert false 
                           report "Invalid character in stimulus data" severity failure; return 'U';
        end case;
    end function;

    -- Kludge to make ternary show up in VCD
    function to_std (i : bal_logic) return std_logic is
    begin
        CASE i IS
            WHEN '-'    => RETURN '0';
            WHEN '0'    => RETURN 'Z'; -- visible in VCD, halfway
            WHEN '+'    => RETURN '1';
            WHEN OTHERS => RETURN 'U'; -- Returns 'U' for 'U' (invalid state)
        END CASE;
    end to_std;


begin
    -- Instantiate the unit under test
    uut : TDEC1_3 port map(x => x, a => a, b => b, c => c );
    -- Main test process
    test_process : process
    begin
        for i in stim_data'range loop
            -- Extract current stimulus
            x <= to_bal_logic(stim_data(i).inputs(1));
            -- b <= to_t_logic(stim_data(i).inputs(2));
            -- enable <= to_std_logic(stim_data(i).inputs(3));
            -- Wait for one nanosecond for the system to stabilize
            wait for 1 ns;
            xl <= to_std(x);  -- kludge for VCD 

            -- Verify outputs
            -- Output a
            if stim_data(i).outputs(1) /= 'X' then  -- Only check if it's not a don't care ('X')
                assert a = to_std_logic(stim_data(i).outputs(1))
                report "Output a error: observed " & std_logic'image(a) & " expected " & stim_data(i).outputs(1) & " at timestep " & integer'image(stim_data(i).step_num)
                severity warning;
            end if;
            -- Output b
            if stim_data(i).outputs(2) /= 'X' then  -- Only check if it's not a don't care ('X')
                assert b = to_std_logic(stim_data(i).outputs(2))
                report "Output b error: observed " & std_logic'image(b) & " expected " & stim_data(i).outputs(2) & " at timestep " & integer'image(stim_data(i).step_num)
                severity warning;
            end if;

            -- Output c
            if stim_data(i).outputs(3) /= 'X' then  -- Only check if it's not a don't care ('X')
                assert c = to_std_logic(stim_data(i).outputs(3))
                report "Output c error: observed " & std_logic'image(c) & " expected " & stim_data(i).outputs(3) & " at timestep " & integer'image(stim_data(i).step_num)
                severity warning;
            end if;
        end loop;
        -- Test finished
        wait;
    end process test_process;
end architecture Behavioral;