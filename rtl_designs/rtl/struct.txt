library TVL;
use TVL.bal_logic.all;

entity top is
    Port ( a : in  BTERN_LOGIC; 
           b : in  BTERN_LOGIC;
           c  : out BTERN_LOGIC );
end top;

architecture structural of top is
    component example
        Port ( input_1 : in BTERN_LOGIC;
               input_2 : in BTERN_LOGIC;
               result  : out BTERN_LOGIC );
    end component;
begin
    instance : example
        Port map (input_1 => a,
                  input_2 => b,
                  result  => c);
end architecture structural;