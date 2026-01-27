-- --------------------------------------------------------------------
-- Title   : 
-- Purpose : Tests for resolution functions
-- ---------------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;
library TVL;
use TVL.bal_logic.all;
use TVL.kleene_pkg.all;

entity ordinary_relops_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of ordinary_relops_tb is

  signal s_m  : BTERN_LOGIC := '-';
  signal s_z  : BTERN_LOGIC := '0';
  signal s_p  : BTERN_LOGIC := '+';
  signal s_L  : BTERN_LOGIC := 'L';
  signal s_mid  : BTERN_LOGIC := 'M';
  signal s_D  : BTERN_LOGIC := 'D';

  signal v_max   : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("++++++");
  signal v_max2  : BTERN_LOGIC_VECTOR(11 downto 0) := BTERN_LOGIC_VECTOR'("000000++++++");
  signal i_max   : INTEGER := 364;
  signal v_mid   : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("00+---");
  signal i_mid   : INTEGER := 14;
  signal v_min   : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("------");
  signal i_min   : INTEGER := -364;
  signal v_Z  : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("0Z+---");
  signal v_D  : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("0D+---");
  signal v_D2  : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("00+-D-");
  signal v_empty : BTERN_LOGIC_VECTOR(-1 downto 0);
  -- strong/weak value vectors, should be evaluated as the same number
  signal v_weak1   : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("--00++");
  signal v_weak2   : BTERN_LOGIC_VECTOR(5 downto 0) := BTERN_LOGIC_VECTOR'("LLMMHH");

begin
  main : process
  begin
    test_runner_setup(runner, runner_cfg);

    --=================================================================
    -- Test matching relational operators on BTERN_LOGIC
    --=================================================================

    if run("BTERN_LOGIC ?>") then
      check((s_m ?> s_z) = '-');
      check((s_z ?> s_m) = '+');
      check((s_z ?> s_p) = '-');
      check((s_p ?> s_z) = '+');
      check((s_D ?> s_m) = 'X');
      check((s_L ?> s_D) = 'X');
      check((s_mid ?> s_mid) = '-');
    elsif run("BTERN_LOGIC ?<") then
      check((s_m ?< s_z) = '+');
      check((s_z ?< s_m) = '-');
      check((s_z ?< s_p) = '+');
      check((s_p ?< s_z) = '-');
      check((s_D ?< s_m) = 'X');
      check((s_L ?< s_D) = 'X');
      check((s_mid ?< s_mid) = '-');
    elsif run("BTERN_LOGIC ?<=") then
      check((s_m ?<= s_z) = '+');
      check((s_z ?<= s_m) = '-');
      check((s_z ?<= s_p) = '+');
      check((s_p ?<= s_z) = '-');
      check((s_D ?<= s_m) = 'X');
      check((s_L ?<= s_D) = 'X');
      check((s_mid ?<= s_mid) = '+');
    elsif run("BTERN_LOGIC ?>=") then
      check((s_m ?>= s_z) = '-');
      check((s_z ?>= s_m) = '+');
      check((s_z ?>= s_p) = '-');
      check((s_p ?>= s_z) = '+');
      check((s_D ?>= s_m) = 'X');
      check((s_L ?>= s_D) = 'X');
      check((s_mid ?>= s_mid) = '+');
    elsif run("BTERN_LOGIC ?=") then
      check((s_m ?= s_z) = '-');
      check((s_z ?= s_m) = '-');
      check((s_z ?= s_p) = '-');
      check((s_p ?= s_z) = '-');
      check((s_mid ?= s_mid) = '+');
      check((s_D ?= s_m) = '+');
      check((s_L ?= s_D) = '+');
      check((s_D ?= s_D) = '+');
    elsif run("BTERN_LOGIC ?/=") then
      check((s_m ?/= s_z) = '+');
      check((s_z ?/= s_m) = '+');
      check((s_z ?/= s_p) = '+');
      check((s_p ?/= s_z) = '+');
      check((s_mid ?/= s_mid) = '-');
      check((s_D ?/= s_m) = '-');
      check((s_L ?/= s_D) = '-');
      check((s_D ?/= s_D) = '-');
    elsif run("BTERN_LOGIC M_SPACE") then
      check(M_SPACE(s_m, s_z) = '-');
      check(M_SPACE(s_z, s_m) = '+');
    elsif run("BTERN_LOGIC M_SPACE 6") then
      check(M_SPACE(s_z, s_p) = '-');
      check(M_SPACE(s_p, s_z) = '+');
    elsif run("BTERN_LOGIC M_SPACE 9") then
      check(M_SPACE(s_D, s_m) = 'X');
      check(M_SPACE(s_L, s_D) = 'X');
      check(M_SPACE(s_D, s_D) = 'X');
    elsif run("BTERN_LOGIC M_SPACE 10") then
      check(M_SPACE(s_mid, s_mid) = '0');
      check(M_SPACE(s_p, s_p) = '0');

    --=================================================================
    -- Test ordinary relational operators on BTERN_LOGIC_VECTOR
    --=================================================================

    elsif run("BTERN_LOGIC_VECTOR >") then
      check_true(v_max  > v_mid);
      check_false(v_min > v_max);
      check_false(v_mid > v_mid);
      check_false(v_Z   > v_mid);
      check_false(v_mid > v_empty);
      check_true(i_max  > v_mid);
      check_true(v_max  > i_mid);
      check_false(i_min > v_max);

    elsif run("BTERN_LOGIC_VECTOR <") then
      check_true(v_mid  < v_max);
      check_false(v_max < v_min);
      check_false(v_mid < v_mid);
      check_false(v_mid < v_Z);
      check_false(v_mid < v_empty);
      check_true(v_mid  < i_max);
      check_true(i_mid  < v_max);
      check_false(v_max < i_max);

    elsif run("BTERN_LOGIC_VECTOR <=") then
      check_true(v_mid  <= v_max);
      check_true(v_mid  <= v_mid);
      check_false(v_max <= v_min);
      check_false(v_mid <= v_Z);
      check_false(v_mid <= v_empty);
      check_true(v_mid  <= i_max);
      check_true(i_mid  <= v_max);
      check_false(v_max <= i_mid);

    elsif run("BTERN_LOGIC_VECTOR >=") then
      check_true(v_max  >= v_mid);
      check_true(v_mid  >= v_mid);
      check_false(v_min >= v_max);
      check_false(v_Z   >= v_mid);
      check_false(v_mid >= v_empty);
      check_true(i_max  >= v_mid);      
      check_true(v_max  >= i_mid);
      check_false(v_min >= i_max);

    elsif run("BTERN_LOGIC_VECTOR =") then
      check_true(v_max    = v_max2);
      check_true(v_weak1  = v_weak2);
      check_false(v_min   = v_max);
      check_false(v_Z     = v_Z);
      check_false(v_empty = v_empty);
      check_true(i_max    = v_max);
      check_true(v_max    = i_max);
      check_false(v_min   = i_max);

    elsif run("BTERN_LOGIC_VECTOR /=") then
      check_true(v_max   /= v_mid);
      check_true(v_Z     /= v_Z);
      check_true(v_mid   /= v_Z);
      check_false(v_max2 /= v_max);
      check_true(v_empty /= v_empty);
      check_true(v_empty /= v_max);
      check_true(i_max   /= v_mid);
      check_true(v_max   /= i_min);
      check_false(v_min  /= i_min);

    elsif run("BTERN_LOGIC_VECTOR SPACE(<=>)") then
      check(SPACE(v_min, v_mid)   = false);
      check(SPACE(v_max, v_mid)   = true);
      check(SPACE(v_mid, v_mid)   = unk);
      check(SPACE(v_mid, v_empty) = false);
      check(SPACE(v_Z,   v_mid)   = false);
      check(SPACE(i_max, v_mid)   = true);
      check(SPACE(v_mid, i_max)   = false);
      check(SPACE(v_mid, i_mid)   = unk);

    --=================================================================
    -- Test matching relational operators on BTERN_LOGIC_VECTOR
    --=================================================================

    elsif run("BTERN_LOGIC_VECTOR ?>") then
      check((v_max ?> v_mid)   = '+');
      check((v_min ?> v_max)   = '-');
      check((v_mid ?> v_mid)   = '-');
      check((v_Z   ?> v_mid)   = 'X');
      check((v_mid ?> v_empty) = 'X');
      check((v_D   ?> v_D2)    = 'X');
      check((i_max ?> v_mid)   = '+');
      check((v_max ?> i_mid)   = '+');
      check((i_min ?> v_max)   = '-');

    elsif run("BTERN_LOGIC_VECTOR ?<") then
      check((v_mid ?< v_max)   = '+');
      check((v_max ?< v_min)   = '-');
      check((v_mid ?< v_mid)   = '-');
      check((v_mid ?< v_Z)     = 'X');
      check((v_D   ?< v_D2)    = 'X');
      check((v_mid ?< v_empty) = 'X');
      check((v_mid ?< i_max)   = '+');
      check((i_mid ?< v_max)   = '+');
      check((v_max ?< i_max)   = '-');

    elsif run("BTERN_LOGIC_VECTOR ?<=") then
      check((v_mid ?<= v_max)   = '+');
      check((v_mid ?<= v_mid)   = '+');
      check((v_max ?<= v_min)   = '-');
      check((v_mid ?<= v_Z)     = 'X');
      check((v_mid ?<= v_empty) = 'X');
      check((v_mid ?<= i_max)   = '+');
      check((i_mid ?<= v_max)   = '+');
      check((v_max ?<= i_mid)   = '-');

    elsif run("BTERN_LOGIC_VECTOR ?>=") then
      check((v_max  ?>= v_mid)   = '+');
      check((v_mid  ?>= v_mid)   = '+');
      check((v_min  ?>= v_max)   = '-');
      check((v_Z    ?>= v_mid)   = 'X');
      check((v_mid  ?>= v_empty) = 'X');
      check((i_max  ?>= v_mid)   = '+');      
      check((v_max  ?>= i_mid)   = '+');
      check((v_min  ?>= i_max)   = '-');

    elsif run("BTERN_LOGIC_VECTOR ?=") then
      check((v_max   ?= v_max2)  = '+');
      check((v_weak1 ?= v_weak2) = '+');
      check((v_min   ?= v_max)   = '-');
      check((v_Z     ?= v_Z)     = 'X');
      check((v_empty ?= v_empty) = 'X');
      check((i_max   ?= v_max)   = '+');
      check((v_max   ?= i_max)   = '+');
      check((v_min   ?= i_max)   = '-');

    elsif run("BTERN_LOGIC_VECTOR ?/=") then
      check((v_max   ?/= v_mid)   = '+');
      check((v_Z     ?/= v_Z)     = 'X');
      check((v_mid   ?/= v_Z)     = 'X');
      check((v_max2  ?/= v_max)   = '-');
      check((v_empty ?/= v_empty) = 'X');
      check((v_empty ?/= v_max)   = 'X');
      check((i_max   ?/= v_mid)   = '+');
      check((v_max   ?/= i_min)   = '+');
      check((v_min   ?/= i_min)   = '-');

    elsif run("BTERN_LOGIC_VECTOR M_SPACE(<=>)") then
      check(M_SPACE(v_min,  v_mid)   = '-');
      check(M_SPACE(v_max,  v_mid)   = '+');
      check(M_SPACE(v_mid,  v_mid)   = '0');
      check(M_SPACE(v_mid,  v_empty) = 'X');
      check(M_SPACE(v_Z,    v_mid)   = 'X');
      check(M_SPACE(i_max,  v_mid)   = '+');
      check(M_SPACE(v_mid,  i_max)   = '-');
      check(M_SPACE(v_mid,  i_mid)   = '0');
    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;