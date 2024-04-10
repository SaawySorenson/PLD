----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    clk             : IN  STD_LOGIC;
    btn_i           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    sw_i            : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    led_o           : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT(
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
  END COMPONENT seg_disp_driver;

  ------------------------------------------------------------------------------

  SIGNAL cnt_0              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_1              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_2              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_3              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  
  SIGNAL ceo_s               : STD_LOGIC;
  SIGNAL btn_ss              : STD_LOGIC;
  SIGNAL btn_lc              : STD_LOGIC;
  
  SIGNAL cnt_en_s            : STD_LOGIC;
  SIGNAL disp_en_s            : STD_LOGIC;
  SIGNAL cnt_rs_s            : STD_LOGIC;
  

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
  
----------------------------------------------------------------------------------
 COMPONENT stopwatch
  PORT (
    CLK                         : IN  STD_LOGIC;
    CE_100HZ                    : IN  STD_LOGIC;
    CNT_ENABLE                  : IN  STD_LOGIC;
    DISP_ENABLE                 : IN  STD_LOGIC;
    CNT_RESET                   : IN  STD_LOGIC;
    CNT_0                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_1                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_2                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_3                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)
  );
  END COMPONENT stopwatch;
----------------------------------------------------------------------------------
COMPONENT stopwatch_fsm
  PORT (
    CLK                 : IN    STD_LOGIC;
    BTN_S_S             : IN    STD_LOGIC;
    BTN_L_C             : IN    STD_LOGIC;
    CNT_RESET           : OUT   STD_LOGIC;
    CNT_ENABLE          : OUT   STD_LOGIC;
    DISP_ENABLE         : OUT   STD_LOGIC
  );
  END COMPONENT stopwatch_fsm;
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
    clk                 => clk,
    dig_1_i             => cnt_3,
    dig_2_i             => cnt_2,
    dig_3_i             => cnt_1,
    dig_4_i             => cnt_0,
    dp_i                => "0000",
    dots_i              => "011",
    disp_seg_o          => disp_seg_o,
    disp_dig_o          => disp_dig_o
  );

  --------------------------------------------------------------------------------
  -- clock enable generator
  ce_gen_i : ce_gen
  PORT MAP(
    clk     =>    clk,            
    srst    =>    btn_i(2),      
    ce      =>    btn_i(1),        
    ce_o    =>    ceo_s       
  );
  
  --------------------------------------------------------------------------------
  -- button input module
btn_in_1: btn_in
GENERIC MAP(
    G_DEB_PERIOD => 500000
)
  PORT MAP(
    clk              => clk,            
    ce               => ceo_s,          
    btn              => btn_i(0),          
    btn_debounced    => OPEN,           
    btn_edge_pos     => btn_ss,          
    btn_edge_neg     => OPEN,        
    btn_edge_any     => OPEN          
  );
 
btn_in_2: btn_in
GENERIC MAP(
    G_DEB_PERIOD => 500000
)
  PORT MAP(
    clk              => clk,            
    ce               => ceo_s,          
    btn              => btn_i(3),          
    btn_debounced    => OPEN,           
    btn_edge_pos     => btn_lc,          
    btn_edge_neg     => OPEN,        
    btn_edge_any     => OPEN          
  );
  --------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
stopwatch_i: stopwatch
  PORT MAP(
    CLK             =>     clk,         
    CE_100HZ        =>     ceo_s,       
    CNT_ENABLE      =>     cnt_en_s,        
    DISP_ENABLE     =>     disp_en_s,      
    CNT_RESET       =>     cnt_rs_s,       
    CNT_0           =>     cnt_0,      
    CNT_1           =>     cnt_1,       
    CNT_2           =>     cnt_2,        
    CNT_3           =>     cnt_3       
  );

  --------------------------------------------------------------------------------
  -- stopwatch control FSM
stopwatch_fsm_i: stopwatch_fsm
  PORT MAP(
    CLK                =>   clk,      
    BTN_S_S            =>   btn_ss, 
    BTN_L_C            =>   btn_lc, 
    CNT_RESET          =>   cnt_rs_s, 
    CNT_ENABLE         =>   cnt_en_s, 
    DISP_ENABLE        =>   disp_en_s  
  );



  --------------------------------------------------------------------------------
  -- LED connection

  led_o <= cnt_3 & cnt_2;


----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
