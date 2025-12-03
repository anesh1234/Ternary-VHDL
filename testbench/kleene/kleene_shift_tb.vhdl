library TVL;
use TVL.KLEENE_TYPE.all;

entity kleene_shift_tb is
end entity;

architecture sim of kleene_shift_tb is
    signal input_vec : KLEENE_VECTOR(3 downto 0) := (TRUE, UNK, FALSE, FALSE);

    signal out_sll : KLEENE_VECTOR(3 downto 0);
    signal out_srl : KLEENE_VECTOR(3 downto 0);
    signal out_rol : KLEENE_VECTOR(3 downto 0);
    signal out_ror : KLEENE_VECTOR(3 downto 0);

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
