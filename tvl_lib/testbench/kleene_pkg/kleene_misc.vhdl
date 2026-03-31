-- --------------------------------------------------------------------
-- Title   : KLEENE_PKG Miscellaneous Functions
-- Notes   : 
-- --------------------------------------------------------------------

library vunit_lib;
context vunit_lib.vunit_context;

library TVL;
use TVL.kleene_pkg.all;

entity kleene_misc_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of kleene_misc_tb is
  signal kvec_t : KLEENE_VECTOR(2 downto 0) := (true,unk,false);
  signal kvec_u : KLEENE_VECTOR(2 downto 0) := (unk,true,false);
  signal kvec_f : KLEENE_VECTOR(2 downto 0) := (false,unk,true);

  signal kvec_tu : KLEENE_VECTOR(2 downto 0) := (unk,unk,true);
  signal kvec_fu : KLEENE_VECTOR(2 downto 0) := (unk,unk,false);

  signal kscal_t : KLEENE := true;
  signal kscal_u : KLEENE := unk;
  signal kscal_f : KLEENE := false;

begin
  test_runner : process

  begin
    test_runner_setup(runner, runner_cfg);

    if run("& operator") then
      -- only vector combinations
      check_true(kvec_t & kvec_f = KLEENE_VECTOR'(true,unk,false,false,unk,true));
      check_true(kvec_f & kvec_t = KLEENE_VECTOR'(false,unk,true,true,unk,false));

      -- only scalar combinations
      check_true(kscal_t & kscal_f = KLEENE_VECTOR'(true,false));
      check_true(kscal_f & kscal_u = KLEENE_VECTOR'(false,unk));

      -- vector and scalar combinations
      check_true(kvec_t & kscal_t = KLEENE_VECTOR'(true,unk,false,true));
      check_true(kscal_f & kvec_f = KLEENE_VECTOR'(false,false,unk,true));

    elsif run("Scalar MAXIMUM/MINIMUM") then
      check_true(MAXIMUM(kscal_t, kscal_u) = kscal_t);
      check_true(MAXIMUM(kscal_f, kscal_u) = kscal_u);

      check_true(MINIMUM(kscal_t, kscal_u) = kscal_u);
      check_true(MINIMUM(kscal_f, kscal_u) = kscal_f);

    elsif run("Double vector MAXIMUM/MINIMUM") then
      check_true(MAXIMUM(kvec_t, kvec_u) = kvec_t);
      check_true(MAXIMUM(kvec_f, kvec_u) = kvec_u);

      check_true(MINIMUM(kvec_t, kvec_u) = kvec_u);
      check_true(MINIMUM(kvec_f, kvec_u) = kvec_f);

    elsif run("Single vector MAXIMUM/MINIMUM") then
      check_true(MAXIMUM(kvec_tu) = kscal_t);
      check_true(MAXIMUM(kvec_fu) = kscal_u);

      check_true(MINIMUM(kvec_tu) = kscal_u);
      check_true(MINIMUM(kvec_fu) = kscal_f);
      
    end if;

    test_runner_cleanup(runner);
  end process;
end architecture;