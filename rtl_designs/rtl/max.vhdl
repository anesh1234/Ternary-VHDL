library TVL;
use TVL.bal_logic.all;

entity top is
    Port ( input_1 : in  BTERN_LOGIC; 
           input_2 : in  BTERN_LOGIC;
           result  : out BTERN_LOGIC );
end top;

architecture dataflow of top is
begin
    result <= MAX(input_1, input_2);
end architecture dataflow;

architecture structural of top is
    component comp1
        Port (a : in BTERN_LOGIC;
              b : in BTERN_LOGIC;
              c : out BTERN_LOGIC );
    end component;
begin
    instance : comp1
        Port map (a => input_1,
                  b => input_2);
end architecture structural;