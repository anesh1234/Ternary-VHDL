library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.bal_logic.all;

entity full_adder_tb is
    generic (runner_cfg : string);
end entity full_adder_tb;

architecture sim of full_adder_tb is

    component btern_full_adder is
        port (
            a     : in  btern_logic;
            b     : in  btern_logic;
            c     : in  btern_logic;
            sum   : out btern_logic;
            carry : out btern_logic
        );
    end component;

    signal a, b, c, sum, carry : btern_logic;

begin

    -- Instantiate the design under test
    DUT : btern_full_adder
        port map (
                a     => a, 
                b     => b, 
                c     => c, 
                sum   => sum, 
                carry => carry
            );

    -- Apply all nine input combinations
    main : process
        procedure test_adder (arg1, arg2, arg3, sum_exp, car_exp : btern_logic) is
        begin
            a <= arg1; 
            b <= arg2; 
            c <= arg3; 

            wait for 10 ns;

            check_equal(TO_STRING(sum),   TO_STRING(sum_exp));
            check_equal(TO_STRING(carry), TO_STRING(car_exp));
            
        end procedure;
    begin
        test_runner_setup(runner, runner_cfg);

        if run("RTL Full Adder C=-1") then

            -- arguments are: 
            --          | arg1 | arg2 | carry in | expected sum | expected carry |

            test_adder(   '-',   '-',    '-',          '0',            '-');
            test_adder(   '-',   '0',    '-',          '+',            '-');
            test_adder(   '-',   '+',    '-',          '-',            '0');
            test_adder(   '0',   '-',    '-',          '+',            '-');
            test_adder(   '0',   '0',    '-',          '-',            '0');
            test_adder(   '0',   '+',    '-',          '0',            '0');
            test_adder(   '+',   '-',    '-',          '-',            '0');
            test_adder(   '+',   '0',    '-',          '0',            '0');
            test_adder(   '+',   '+',    '-',          '+',            '0');


        elsif run("RTL Full Adder C=0") then

            -- arguments are: 
            --          | arg1 | arg2 | carry in | expected sum | expected carry |

            test_adder(   '-',   '-',    '0',          '+',            '-');
            test_adder(   '-',   '0',    '0',          '-',            '0');
            test_adder(   '-',   '+',    '0',          '0',            '0');
            test_adder(   '0',   '-',    '0',          '-',            '0');
            test_adder(   '0',   '0',    '0',          '0',            '0');
            test_adder(   '0',   '+',    '0',          '+',            '0');
            test_adder(   '+',   '-',    '0',          '0',            '0');
            test_adder(   '+',   '0',    '0',          '+',            '0');
            test_adder(   '+',   '+',    '0',          '-',            '+');

        elsif run("RTL Full Adder C=1") then

            -- arguments are: 
            --          | arg1 | arg2 | carry in | expected sum | expected carry |

            test_adder(   '-',   '-',    '+',          '-',            '0');
            test_adder(   '-',   '0',    '+',          '0',            '0');
            test_adder(   '-',   '+',    '+',          '+',            '0');
            test_adder(   '0',   '-',    '+',          '0',            '0');
            test_adder(   '0',   '0',    '+',          '+',            '0');
            test_adder(   '0',   '+',    '+',          '-',            '+');
            test_adder(   '+',   '-',    '+',          '+',            '0');
            test_adder(   '+',   '0',    '+',          '-',            '+');
            test_adder(   '+',   '+',    '+',          '0',            '+');

        end if;

        wait for 10 ns;

        test_runner_cleanup(runner);

    end process;
end architecture sim;
