------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------------------------
entity uart_tx_tb is
end uart_tx_tb;
------------------------------------------------------------------------------------------------------------
architecture Behavioral of uart_tx_tb is
------------------------------------------------------------------------------------------------------------

  COMPONENT uart_tx
  PORT(
    CLK                 : IN  STD_LOGIC;
    TX_START            : IN  STD_LOGIC;
    CLK_EN              : IN  STD_LOGIC;
    DATA_IN             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    TX_BUSY             : OUT STD_LOGIC;
    TX_DATA_OUT         : OUT STD_LOGIC
  );
  END COMPONENT;

------------------------------------------------------------------------------------------------------------

  COMPONENT ce_gen
  GENERIC (
    G_DIV_FACT          : POSITIVE := 2
  );
  PORT (
    CLK                 : IN  STD_LOGIC;
    SRST                : IN  STD_LOGIC;
    CE                  : IN  STD_LOGIC;
    CE_O                : OUT STD_LOGIC
  );
  END COMPONENT ce_gen;

  ----------------------------------------------------------------------------------------------------------

  CONSTANT C_CLK_PERIOD    : TIME := 20 ns;
  SIGNAL clk               : STD_LOGIC := '0';

  -- UUT inputs
  SIGNAL tx_start           : STD_LOGIC := '0';
  SIGNAL data_in            : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL clk_en             : STD_LOGIC;

  -- UUT outputs
  SIGNAL tx_data_out        : STD_LOGIC;
  SIGNAL tx_busy            : STD_LOGIC;


------------------------------------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------------------------------------

  -- clk_gen
  proc_clk_gen: PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR C_CLK_PERIOD/2;
    clk <= '1';
    WAIT FOR C_CLK_PERIOD/2;
  END PROCESS proc_clk_gen;

  ----------------------------------------------------------------------------------------------------------

  -- uart_tx
  uart_tx_i : uart_tx
  PORT MAP(
    CLK                 => clk,
    TX_START            => tx_start,
    CLK_EN              => clk_en,
    DATA_IN             => data_in,
    TX_DATA_OUT         => tx_data_out,
    TX_BUSY             => tx_busy
  );

  ----------------------------------------------------------------------------------------------------------

  -- clock enable generator
  ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 20
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE                          => '1',
    CE_O                        => clk_en
  );

  ----------------------------------------------------------------------------------------------------------

  proc_uart_tx_stimuli: PROCESS
  BEGIN

    data_in  <= X"00";
    tx_start <= '0';
    WAIT FOR C_CLK_PERIOD * 35;

    data_in  <= X"14";
    tx_start <= '1';
    WAIT FOR C_CLK_PERIOD * 500;
    
    data_in  <= X"0F";
    tx_start <= '1';
    WAIT FOR C_CLK_PERIOD * 500;

    data_in  <= X"0F";
    tx_start <= '0';
    WAIT FOR C_CLK_PERIOD * 500;
    
    -- insert your stimuli



    REPORT "================================================================" SEVERITY NOTE;
    REPORT "Simulation finished!" SEVERITY NOTE;
    REPORT "================================================================" SEVERITY FAILURE;
  END PROCESS proc_uart_tx_stimuli;

---------------------------------------------------------------------------------
end Behavioral;
---------------------------------------------------------------------------------

