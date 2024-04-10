----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity ce_gen_tb is
end ce_gen_tb;
----------------------------------------------------------------------------------
architecture Behavioral of ce_gen_tb is
----------------------------------------------------------------------------------

  COMPONENT ce_gen
  GENERIC (
    G_DIV_FACT          : POSITIVE := 500000
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
  SIGNAL srst                   : STD_LOGIC := '0';
  SIGNAL ce                     : STD_LOGIC := '0';
  SIGNAL ce_o                   : STD_LOGIC;

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
    G_DIV_FACT                  => 500000
  )
  PORT MAP(
    clk                         => clk,
    srst                        => srst,
    ce                          => ce,
    ce_o                        => ce_o
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    srst  <= '1';
    ce <= '0';
    WAIT FOR clk_period * 5;
    srst  <= '0';
    WAIT FOR clk_period * 5;
    ce <= '1';
    WAIT FOR clk_period * 50;
    srst  <= '0';
    WAIT FOR clk_period * 10000000;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------
