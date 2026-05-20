library TVL;
use TVL.bal_logic.all;
library IEEE;
use IEEE.std_logic_1164.all;

entity convfunc_tb is
end entity;

architecture sim of convfunc_tb is
    -- Inputs
    -- Binary signals were used here to verify the functionality
    -- of the To_01 function, which is To_M2P in ternary
    signal input_vec_bin : STD_LOGIC_VECTOR(10 downto 0) := "0000Z111111";

    signal input_s : BTERN_ULOGIC := 'H';

    signal input_vec_all : BTERN_LOGIC_VECTOR(10 downto 0) := "UX-0+ZWLMHD";
    signal input_vec_wf : BTERN_LOGIC_VECTOR(5 downto 0) := "-L0M+H";        
    signal input_vec_isx : BTERN_LOGIC_VECTOR(5 downto 0) := "++++++";       

    -- Outputs
    signal out_bin : STD_LOGIC_VECTOR(10 downto 0);

    signal out_s_m2p : BTERN_LOGIC;
    signal out_vec_m2p : BTERN_LOGIC_VECTOR(5 downto 0);
    signal out_vec_all_m2p : BTERN_LOGIC_VECTOR(10 downto 0);

    -- These use conversion tables allowing all values,
    -- therefore need larger vectors
    signal out_s_x2p : BTERN_LOGIC;
    signal out_vec_x2p: BTERN_LOGIC_VECTOR(10 downto 0);

    signal out_s_x2z : BTERN_LOGIC;
    signal out_vec_x2z : BTERN_LOGIC_VECTOR(10 downto 0);

    signal out_s_u2p : BTERN_LOGIC;
    signal out_vec_u2p : BTERN_LOGIC_VECTOR(10 downto 0);

    -- Test of Is_X functions
    signal out_bool_isx : BOOLEAN;

begin

    -- Stimulus process
    stim_proc: process
    begin
        out_bin <= To_01(input_vec_bin, '1');

        out_s_m2p <= To_M2P(input_s);
        out_vec_m2p <= To_M2P(input_vec_wf);
        out_vec_all_m2p <= To_M2P(input_vec_all);

        out_s_x2p <= To_X2P(input_s);
        out_vec_x2p <= To_X2P(input_vec_all);

        out_s_x2z <= To_X2Z(input_s);
        out_vec_x2z <= To_X2Z(input_vec_all);

        out_s_u2p <= To_U2P(input_s);
        out_vec_u2p <= To_U2P(input_vec_all);

        out_bool_isx <= Is_X(input_vec_all);
        wait for 10 ns;

        out_bool_isx <= Is_X(input_vec_isx);
        wait for 10 ns;
        wait;
    end process;


end architecture;