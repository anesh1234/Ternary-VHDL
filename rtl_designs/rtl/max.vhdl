library TVL;
use TVL.bal_logic.all;

entity example is
    Port ( input_1 : in  BTERN_LOGIC; 
           input_2 : in  BTERN_LOGIC;
           result  : out BTERN_LOGIC );
end example;

architecture dataflow of example is
begin
    result <= MAX(input_1, input_2);
end architecture dataflow;