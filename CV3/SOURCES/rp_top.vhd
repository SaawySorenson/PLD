----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT (
    CLK             : IN  STD_LOGIC;
    BTN             : IN  STD_LOGIC_VECTOR (4 DOWNTO 1);
    SW              : IN  STD_LOGIC_VECTOR (4 DOWNTO 1);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)    
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

 SIGNAL CNT_SIG            : STD_LOGIC_VECTOR (31 DOWNTO 0);
 

  COMPONENT seg_disp_driver
  PORT (
    clk             : IN  STD_LOGIC;
    dig_1_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_2_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_3_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_4_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dp_i            : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    dots_i          : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT;
  
  COMPONENT cnt_bin
  PORT(
    CLK                : IN STD_LOGIC;
    SRST               : IN STD_LOGIC;
    CE                 : IN STD_LOGIC;
    CNT_LOAD           : IN STD_LOGIC;
    CNT_UP             : IN STD_LOGIC;
    CNT                : OUT STD_LOGIC_VECTOR(31 downto 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------




----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    LED  <= CNT_SIG(31 downto 24);
  --------------------------------------------------------------------------------
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
  PORT MAP (
    clk                 => CLK,
    dig_1_i             => CNT_SIG(31 downto 28),
    dig_2_i             => CNT_SIG(27 downto 24),
    dig_3_i             => CNT_SIG(27 downto 24),
    dig_4_i             => CNT_SIG(23 downto 20),
    dp_i                => "0000", 
    dots_i              => "000",
    disp_seg_o          => DISP_SEG,
    disp_dig_o          => DISP_DIG
  );

  --------------------------------------------------------------------------------

  cnt_bin_i : cnt_bin
  PORT MAP (
    CLK                 => CLK,
    CE                  => SW(2),
    SRST                => BTN(2),
    CNT_LOAD            => BTN(1),
    CNT_UP              => SW(3),
    CNT                 => CNT_SIG 
            
  );

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
