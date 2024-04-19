----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY uart_tx IS
  PORT(
    CLK                 : IN  STD_LOGIC;
    TX_START            : IN  STD_LOGIC;
    CLK_EN              : IN  STD_LOGIC;
    DATA_IN             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    TX_BUSY             : OUT STD_LOGIC;
    TX_DATA_OUT         : OUT STD_LOGIC
  );
END uart_tx;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF uart_tx IS
----------------------------------------------------------------------------------

  TYPE t_state_uart IS (ST_IDLE, ST_PREPARE,
                        ST_START_B,
                        ST_BIT_0, ST_BIT_1, ST_BIT_2, ST_BIT_3,
                        ST_BIT_4, ST_BIT_5, ST_BIT_6, ST_BIT_7,
                        ST_STOP_B);

  SIGNAL pres_state                 : t_state_uart := ST_IDLE;
  SIGNAL next_state                 : t_state_uart;

  SIGNAL tx_busy_comb               : STD_LOGIC;
  SIGNAL tx_data_out_comb           : STD_LOGIC;

  SIGNAL tx_busy_reg                : STD_LOGIC := '0';
  SIGNAL tx_data_out_reg            : STD_LOGIC := '1';

  SIGNAL data_in_reg                : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

----------------------------------------------------------------------------------

BEGIN
----------------------------------------------------------------------------------


  --------------------------------------------------------------------------------
  -- Input data register
  --------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      IF TX_START = '1' AND pres_state = ST_IDLE THEN
        data_in_reg <= DATA_IN;
      END IF;
    END IF;
  END PROCESS;



  --------------------------------------------------------------------------------
  -- FSM next state logic
  --------------------------------------------------------------------------------

  PROCESS (pres_state, TX_START, CLK_EN) BEGIN

    -- default assignment (LATCH prevention)
    next_state <= pres_state;

    CASE pres_state IS
      WHEN ST_IDLE         => IF TX_START = '1' THEN next_state <= ST_PREPARE; END IF;
      WHEN ST_PREPARE      => IF   CLK_EN = '1' THEN next_state <= ST_START_B; END IF;
      WHEN ST_START_B      => IF   CLK_EN = '1' THEN next_state <= ST_BIT_0;   END IF;
      WHEN ST_BIT_0        => IF   CLK_EN = '1' THEN next_state <= ST_BIT_1;   END IF;
      WHEN ST_BIT_1        => IF   CLK_EN = '1' THEN next_state <= ST_BIT_2;   END IF;
      WHEN ST_BIT_2        => IF   CLK_EN = '1' THEN next_state <= ST_BIT_3;   END IF;
      WHEN ST_BIT_3        => IF   CLK_EN = '1' THEN next_state <= ST_BIT_4;   END IF;
      WHEN ST_BIT_4        => IF   CLK_EN = '1' THEN next_state <= ST_BIT_5;   END IF;
      WHEN ST_BIT_5        => IF   CLK_EN = '1' THEN next_state <= ST_BIT_6;   END IF;
      WHEN ST_BIT_6        => IF   CLK_EN = '1' THEN next_state <= ST_BIT_7;   END IF;
      WHEN ST_BIT_7        => IF   CLK_EN = '1' THEN next_state <= ST_STOP_B;  END IF;
      WHEN ST_STOP_B       => IF   CLK_EN = '1' THEN next_state <= ST_IDLE;    END IF;
    END CASE;
  END PROCESS;

  --------------------------------------------------------------------------------
  -- FSM state register
  --------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      pres_state <= next_state;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------
  -- FSM output logic
  --------------------------------------------------------------------------------

  PROCESS (pres_state, data_in_reg) BEGIN
    -- default assignment (LATCH prevention)
    tx_busy_comb     <= '1';
    tx_data_out_comb <= '1';

    CASE pres_state IS
      WHEN ST_IDLE         => tx_busy_comb <= '0';
                              tx_data_out_comb <= '1';
      WHEN ST_PREPARE      => tx_data_out_comb <= '1';
      WHEN ST_START_B      => tx_data_out_comb <= '0';
      WHEN ST_BIT_0        => tx_data_out_comb <= data_in_reg(0);
      WHEN ST_BIT_1        => tx_data_out_comb <= data_in_reg(1);
      WHEN ST_BIT_2        => tx_data_out_comb <= data_in_reg(2);
      WHEN ST_BIT_3        => tx_data_out_comb <= data_in_reg(3);
      WHEN ST_BIT_4        => tx_data_out_comb <= data_in_reg(4);
      WHEN ST_BIT_5        => tx_data_out_comb <= data_in_reg(5);
      WHEN ST_BIT_6        => tx_data_out_comb <= data_in_reg(6);
      WHEN ST_BIT_7        => tx_data_out_comb <= data_in_reg(7);
      WHEN ST_STOP_B       => tx_data_out_comb <= '1';
    END CASE;
  END PROCESS;


  --------------------------------------------------------------------------------
  -- Output registers
  --------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      tx_busy_reg     <= tx_busy_comb;
      tx_data_out_reg <= tx_data_out_comb;
    END IF;
  END PROCESS;


  --------------------------------------------------------------------------------
  -- Output
  --------------------------------------------------------------------------------

  TX_BUSY      <= tx_busy_reg;
  TX_DATA_OUT  <= tx_data_out_reg;


----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
