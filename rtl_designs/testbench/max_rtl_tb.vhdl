library TVL;
use TVL.bal_logic.all;
use TVL.bal_numeric.all;

entity max_rtl_tb is
end entity;

architecture sim of max_rtl_tb is

    -- Input signals
    signal input_data_1   : BTERN_LOGIC := '0';
    signal input_data_2   : BTERN_LOGIC := '0';

    signal input_struct_1 : BTERN_LOGIC := '0';
    signal input_struct_2 : BTERN_LOGIC := '0';

    -- Output signals
    signal res_data   : BTERN_LOGIC;
    signal res_struct : BTERN_LOGIC;

begin
    -- Stimulus process
    stim_proc: process
    begin
        input_data_1 <= '-';
        input_data_2 <= '-';

        input_struct_1 <= '-';
        input_struct_2 <= '-';

        wait for 10 ns;

        input_data_1 <= '-';
        input_data_2 <= '0';

        input_struct_1 <= '-';
        input_struct_2 <= '0';

        wait for 10 ns;

        input_data_1 <= '0';
        input_data_2 <= '+';

        input_struct_1 <= '0';
        input_struct_2 <= '+';
        
        wait for 10 ns;
        wait;
    end process;

  uut1: entity work.example(dataflow)
    port map (
      input_1 => input_data_1,
      input_2 => input_data_2,
      result  => res_data
    );

  uut2: entity work.top(structural)
    port map (
      a => input_struct_1,
      b => input_struct_2,
      c  => res_struct
    );


end architecture;
