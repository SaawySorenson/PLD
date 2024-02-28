----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity btn_in_tb is
end btn_in_tb;
----------------------------------------------------------------------------------
architecture Behavioral of btn_in_tb is
----------------------------------------------------------------------------------

  COMPONENT btn_in
  GENERIC(
    G_DEB_PERIOD                : POSITIVE := 3
  );
  PORT(
    clk                         : IN  STD_LOGIC;
    ce                          : IN  STD_LOGIC;
    btn                         : IN  STD_LOGIC;
    btn_debounced               : OUT STD_LOGIC;
    btn_edge_pos                : OUT STD_LOGIC;
    btn_edge_neg                : OUT STD_LOGIC;
    btn_edge_any                : OUT STD_LOGIC
  );
  END COMPONENT btn_in;

  --------------------------------------------------------------------------------

  COMPONENT ce_gen
  GENERIC (
    G_DIV_FACT          : POSITIVE := 2
  );
  PORT (
    clk                 : IN  STD_LOGIC;
    srst                : IN  STD_LOGIC;
    ce                  : IN  STD_LOGIC;
    ce_o                : OUT STD_LOGIC 
  );
  END COMPONENT ce_gen;

  --------------------------------------------------------------------------------

  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL ce                     : STD_LOGIC;
  SIGNAL btn                    : STD_LOGIC := '0';
  SIGNAL btn_debounced          : STD_LOGIC;
  SIGNAL btn_edge_pos           : STD_LOGIC;
  SIGNAL btn_edge_neg           : STD_LOGIC;
  SIGNAL btn_edge_any           : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS BEGIN
    clk <= '0'; WAIT FOR clk_period/2;
    clk <= '1'; WAIT FOR clk_period/2;
    IF simulation_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 5
  )
  PORT MAP(
    clk                         => clk,
    srst                        => '0',
    ce                          => '1',
    ce_o                        => ce
  );

  --------------------------------------------------------------------------------

  btn_in_i : btn_in
  GENERIC MAP(
    G_DEB_PERIOD                => 5
  )
  PORT MAP(
    clk                         => clk,
    ce                          => ce,
    btn                         => btn,
    btn_debounced               => btn_debounced,
    btn_edge_pos                => btn_edge_pos,
    btn_edge_neg                => btn_edge_neg,
    btn_edge_any                => btn_edge_any
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    ------------------------------------------------------------------------------
    -- rising edge of the btn signal
    ------------------------------------------------------------------------------
    btn <= '0'; WAIT FOR clk_period *   8;
    btn <= '1'; WAIT FOR clk_period *  10;
    btn <= '0'; WAIT FOR clk_period *  10;
    btn <= '1'; WAIT FOR clk_period *  20;
    btn <= '0'; WAIT FOR clk_period *  20;
    btn <= '1'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- falling edge of the btn signal
    ------------------------------------------------------------------------------
    btn <= '0'; WAIT FOR clk_period *   8;
    btn <= '1'; WAIT FOR clk_period *  10;
    btn <= '0'; WAIT FOR clk_period *  10;
    btn <= '1'; WAIT FOR clk_period *  20;
    btn <= '0'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- end of simulation
    ------------------------------------------------------------------------------
    WAIT FOR clk_period * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------
