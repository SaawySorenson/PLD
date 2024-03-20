----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    CLK                 : IN  STD_LOGIC;
    BTN                 : IN  STD_LOGIC_VECTOR (1 TO 4);
    SW                  : IN  STD_LOGIC_VECTOR (1 TO 4);
    LED                 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG            : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG            : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    UART_TXD            : OUT STD_LOGIC
  );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT(
    CLK                 : IN  STD_LOGIC;
    DIG_1               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_2               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_3               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_4               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DP                  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    DOTS                : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    DISP_SEG            : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG            : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT seg_disp_driver;

  ------------------------------------------------------------------------------

  COMPONENT btn_in
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
  PORT(
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN                 : IN    STD_LOGIC;
    BTN_DEBOUNCED       : OUT   STD_LOGIC;
    BTN_EDGE_POS        : OUT   STD_LOGIC;
    BTN_EDGE_NEG        : OUT   STD_LOGIC;
    BTN_EDGE_ANY        : OUT   STD_LOGIC
  );
  END COMPONENT btn_in;

  ------------------------------------------------------------------------------

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

  ------------------------------------------------------------------------------

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

  ------------------------------------------------------------------------------

  SIGNAL ce_100hz       : STD_LOGIC;

  SIGNAL btn_debounced  : STD_LOGIC_VECTOR(1 TO 4);
  SIGNAL btn_edge_pos   : STD_LOGIC_VECTOR(1 TO 4);
  SIGNAL btn_edge_neg   : STD_LOGIC_VECTOR(1 TO 4);
  SIGNAL btn_edge_any   : STD_LOGIC_VECTOR(1 TO 4);

  SIGNAL ce_uart        : STD_LOGIC;
  SIGNAL tx_busy        : STD_LOGIC;
  SIGNAL data_in_uart   : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL dp             : STD_LOGIC_VECTOR(3 DOWNTO 0);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- display driver
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP(
    CLK                 => CLK,
    DIG_1               => "0000",
    DIG_2               => "0000",
    DIG_3               => data_in_uart(7 DOWNTO 4),
    DIG_4               => data_in_uart(3 DOWNTO 0),
    DP                  => dp,
    DOTS                => "000",
    DISP_SEG            => DISP_SEG,
    DISP_DIG            => DISP_DIG
  );


  dp <= BTN OR SW;


  --------------------------------------------------------------------------------
  -- 100 Hz clock enable generator

  ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT          => 500000
  )
  PORT MAP(
    CLK                 => CLK,
    SRST                => '0',
    CE                  => '1',
    CE_O                => ce_100hz
  );


  --------------------------------------------------------------------------------
  -- button input module

  gen_btn_in: FOR i IN 1 TO 4 GENERATE
    btn_in_i : btn_in
    GENERIC MAP(
      G_DEB_PERIOD        => 5
    )
    PORT MAP(
      CLK                 => CLK,
      CE                  => ce_100hz,
      BTN                 => BTN(i),
      BTN_DEBOUNCED       => btn_debounced(i),
      BTN_EDGE_POS        => btn_edge_pos(i),
      BTN_EDGE_NEG        => btn_edge_neg(i),
      BTN_EDGE_ANY        => btn_edge_any(i)
    );
  END GENERATE gen_btn_in;


  --------------------------------------------------------------------------------
  -- LED connection

  LED <= "0000000" & tx_busy;


  ----------------------------------------------------------------------------------------------------------

  -- UART clock enable generator
  ce_gen_uart : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 434
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE                          => '1',
    CE_O                        => ce_uart
  );


  --------------------------------------------------------------------------------
  -- UART module

  data_in_uart <= X"3" & SW;

  uart_tx_i : uart_tx
  PORT MAP(
    CLK                 => clk,
    TX_START            => btn_edge_pos(1),
    CLK_EN              => ce_uart,
    DATA_IN             => data_in_uart,
    TX_DATA_OUT         => UART_TXD,
    TX_BUSY             => tx_busy
  );


----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
