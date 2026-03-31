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

  signal s_f : KLEENE := false;
  signal s_u : KLEENE := unk;
  signal s_t : KLEENE := true;

  signal v_max   : KLEENE_VECTOR(4 downto 0) := (true, unk, false, false, false);
  signal v_mid   : KLEENE_VECTOR(5 downto 0) := (unk, unk, true, unk, false, false);
  signal v_min   : KLEENE_VECTOR(6 downto 0) := (unk, unk, unk, unk, true, unk, false);
  signal v_empty : KLEENE_VECTOR(-1 downto 0);

begin
  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);

    --=================================================================
    -- Test ordinary relational operators on KLEENE
    --=================================================================

    if run("Vector >") then
      check_true(v_max  > v_mid);
      check_true(v_mid  > v_min);
      check_false(v_min > v_max);
      check_false(v_mid > v_mid);

    elsif run("Scalar >") then
      check_true(s_t  > s_u);
      check_true(s_u  > s_f);
      check_false(s_f > s_t);
      check_false(s_u > s_u);

    elsif run("Vector <") then
      check_false(v_max < v_mid);
      check_false(v_mid < v_min);
      check_true(v_min  < v_max);
      check_false(v_mid < v_mid);

    elsif run("Scalar <") then
      check_false(s_t < s_u);
      check_false(s_u < s_f);
      check_true(s_f  < s_t);
      check_false(s_u < s_u);

    elsif run("Vector <=") then
      check_false(v_max <= v_mid);
      check_false(v_mid <= v_min);
      check_true(v_min  <= v_max);
      check_true(v_mid  <= v_mid);

    elsif run("Scalar <=") then
      check_false(s_t <= s_u);
      check_false(s_u <= s_f);
      check_true(s_f  <= s_t);
      check_true(s_u  <= s_u);

    elsif run("Vector >=") then
      check_true(v_max  >= v_mid);
      check_true(v_mid  >= v_min);
      check_false(v_min >= v_max);
      check_true(v_mid  >= v_mid);

    elsif run("Scalar >=") then
      check_true(s_t  >= s_u);
      check_true(s_u  >= s_f);
      check_false(s_f >= s_t);
      check_true(s_u  >= s_u);

    elsif run("Vector =") then
      check_false(v_max = v_mid);
      check_false(v_mid = v_min);
      check_false(v_min = v_max);
      check_true(v_mid  = v_mid);

    elsif run("Scalar =") then
      check_false(s_t = s_u);
      check_false(s_u = s_f);
      check_false(s_f = s_t);
      check_true(s_u  = s_u);
    
    elsif run("Vector /=") then
      check_true(v_max  /= v_mid);
      check_true(v_mid  /= v_min);
      check_true(v_min  /= v_max);
      check_false(v_mid /= v_mid);

    elsif run("Scalar /=") then
      check_true(s_t  /= s_u);
      check_true(s_u  /= s_f);
      check_true(s_f  /= s_t);
      check_false(s_u /= s_u);

    elsif run("Vector SPACE(<=>)") then
      check_equal(TO_STRING(SPACE(v_max, v_mid)), TO_STRING(KLEENE'(TRUE)));
      check_equal(TO_STRING(SPACE(v_mid, v_min)), TO_STRING(KLEENE'(TRUE)));
      check_equal(TO_STRING(SPACE(v_min, v_max)), TO_STRING(KLEENE'(FALSE)));
      check_equal(TO_STRING(SPACE(v_mid, v_mid)), TO_STRING(KLEENE'(UNK)));

    elsif run("Scalar SPACE(<=>)") then
      check_equal(TO_STRING(SPACE(s_t, s_u)), TO_STRING(KLEENE'(TRUE)));
      check_equal(TO_STRING(SPACE(s_u, s_f)), TO_STRING(KLEENE'(TRUE)));
      check_equal(TO_STRING(SPACE(s_f, s_t)), TO_STRING(KLEENE'(FALSE)));
      check_equal(TO_STRING(SPACE(s_u, s_u)), TO_STRING(KLEENE'(UNK)));

    --=================================================================
    -- Test matching relational operators on KLEENE_VECTOR
    --=================================================================

    elsif run("Vector ?=") then
      check_true((v_max   ?= v_mid)   = KLEENE'(false));
      check_true((v_mid   ?= v_min)   = KLEENE'(false));
      check_true((v_min   ?= v_max)   = KLEENE'(false));
      check_true((v_mid   ?= v_mid)   = KLEENE'(true));
      check_true((v_empty ?= v_mid)   = KLEENE'(unk));
      check_true((v_mid   ?= v_empty) = KLEENE'(unk));

    elsif run("Vector ?/=") then
      check_true((v_max   ?/= v_mid)   = KLEENE'(true));
      check_true((v_mid   ?/= v_min)   = KLEENE'(true));
      check_true((v_min   ?/= v_max)   = KLEENE'(true));
      check_true((v_mid   ?/= v_mid)   = KLEENE'(false));
      check_true((v_empty ?/= v_mid)   = KLEENE'(unk));
      check_true((v_mid   ?/= v_empty) = KLEENE'(unk));
      
    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;