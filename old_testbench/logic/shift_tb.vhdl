library TVL;
use TVL.bal_logic.all;

entity shift_tb is
end entity;

architecture sim of shift_tb is
    signal input_vec : BTERN_LOGIC_VECTOR(5 downto 0) := "++0++0";

    signal out_sll : BTERN_LOGIC_VECTOR(5 downto 0);
    signal out_srl : BTERN_LOGIC_VECTOR(5 downto 0);
    signal out_rol : BTERN_LOGIC_VECTOR(5 downto 0);
    signal out_ror : BTERN_LOGIC_VECTOR(5 downto 0);

begin

    -- Stimulus process
    stim_proc: process
    begin
        out_sll <= input_vec sll 1;
        out_srl <= input_vec srl 1;
        out_rol <= input_vec rol 1;
        out_ror <= input_vec ror 1;

        wait for 10 ns;

        -- Test for negative integers
        out_sll <= input_vec sll -1;
        out_srl <= input_vec srl -1;
        out_rol <= input_vec rol -1;
        out_ror <= input_vec ror -1;

        wait for 10 ns;
        wait;
    end process;


end architecture;
