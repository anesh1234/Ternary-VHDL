-- --------------------------------------------------------------------
-- Title   : 
-- Purpose :
-- Notes   :
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.kleene_pkg.all;

entity kleene_relops_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of kleene_relops_tb is

  signal s_f   : KLEENE := false;
  signal s_u   : KLEENE := unk;
  signal s_t   : KLEENE := true;

  signal v_max   : KLEENE_VECTOR(4 downto 0) := (true, true,true,true,true);
  signal v_mid   : KLEENE_VECTOR(4 downto 0) := (unk,  true,true,true,true);
  signal v_min   : KLEENE_VECTOR(4 downto 0) := (false,unk, unk, unk, unk);

begin
  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);
    --=================================================================
    -- Test ordinary relational operators on KLEENE
    --=================================================================

    if run("KLEENE VECTOR >") then
      check_true(v_max  > v_mid);
      check_true(v_mid  > v_min);
      check_false(v_min > v_max);
      check_false(v_mid > v_mid);

    elsif run("KLEENE SCALAR >") then
      check_true(s_t  > s_u);
      check_true(s_u  > s_f);
      check_false(s_f > s_t);
      check_false(s_u > s_u);

    elsif run("KLEENE VECTOR <") then
      check_false(v_max < v_mid);
      check_false(v_mid < v_min);
      check_true(v_min  < v_max);
      check_false(v_mid < v_mid);

    elsif run("KLEENE SCALAR <") then
      check_false(s_t < s_u);
      check_false(s_u < s_f);
      check_true(s_f  < s_t);
      check_false(s_u < s_u);

    elsif run("KLEENE VECTOR <=") then
      check_false(v_max <= v_mid);
      check_false(v_mid <= v_min);
      check_true(v_min  <= v_max);
      check_true(v_mid  <= v_mid);

    elsif run("KLEENE SCALAR <=") then
      check_false(s_t <= s_u);
      check_false(s_u <= s_f);
      check_true(s_f  <= s_t);
      check_true(s_u  <= s_u);

    elsif run("KLEENE VECTOR >=") then
    elsif run("KLEENE SCALAR >=") then

    elsif run("KLEENE VECTOR =") then
    elsif run("KLEENE SCALAR =") then
    
    elsif run("KLEENE VECTOR /=") then
    elsif run("KLEENE SCALAR /=") then

    elsif run("KLEENE SPACE(<=>)") then


    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;