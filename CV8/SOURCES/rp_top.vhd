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
    DISP_DIG            : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
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
  
  COMPONENT pwm_driver
  PORT (
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
  END COMPONENT;


COMPONENT ILA_PWM

PORT (
	clk : IN STD_LOGIC;

	probe0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	probe1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT  ;

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out5 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out6 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out7 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out8 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    probe_out9 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    probe_out10 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    probe_out11 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 
  );
END COMPONENT;

COMPONENT ILA_BTN_SW

PORT (
	clk : IN STD_LOGIC;



	probe0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	probe1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END COMPONENT  ;

  ------------------------------------------------------------------------------



  SIGNAL ce_100hz       : STD_LOGIC;

  SIGNAL btn_debounced  : STD_LOGIC_VECTOR(1 TO 4);
  SIGNAL btn_edge_pos   : STD_LOGIC_VECTOR(1 TO 4);
  SIGNAL btn_edge_neg   : STD_LOGIC_VECTOR(1 TO 4);
  SIGNAL btn_edge_any   : STD_LOGIC_VECTOR(1 TO 4);
  
  SIGNAL C_PWM_REF_7  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL C_PWM_REF_6  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL C_PWM_REF_5  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL C_PWM_REF_4  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL C_PWM_REF_3  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL C_PWM_REF_2  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL C_PWM_REF_1  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL C_PWM_REF_0  : STD_LOGIC_VECTOR(0 TO 7);
  
  SIGNAL C_DIG_1  : STD_LOGIC_VECTOR(0 TO 3);
  SIGNAL C_DIG_2  : STD_LOGIC_VECTOR(0 TO 3);
  SIGNAL C_DIG_3  : STD_LOGIC_VECTOR(0 TO 3);
  SIGNAL C_DIG_4  : STD_LOGIC_VECTOR(0 TO 3);
  
  SIGNAL pwm_out  : STD_LOGIC_VECTOR(0 TO 7);
  SIGNAL cnt_out  : STD_LOGIC_VECTOR(0 TO 7);
  
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
    DIG_1               => C_DIG_1,
    DIG_2               => C_DIG_2,
    DIG_3               => C_DIG_3,
    DIG_4               => C_DIG_4,
    DP                  => "0000",
    DOTS                => "000",
    DISP_SEG            => DISP_SEG,
    DISP_DIG            => DISP_DIG
  );


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
  -- ILA
  
  ila_pwm_i : ILA_PWM
PORT MAP (
	clk => CLK,

	probe0 => pwm_out,
	probe1 => cnt_out
);

--VIO

vio_i : vio_0
  PORT MAP (
    clk => CLK,
    probe_in0 => pwm_out,
    probe_in1 => cnt_out,
    probe_out0 => C_PWM_REF_0,
    probe_out1 => C_PWM_REF_1,
    probe_out2 => C_PWM_REF_2,
    probe_out3 => C_PWM_REF_3,
    probe_out4 => C_PWM_REF_4,
    probe_out5 => C_PWM_REF_5,
    probe_out6 => C_PWM_REF_6,
    probe_out7 => C_PWM_REF_7,
    probe_out8 => C_DIG_1,
    probe_out9 => C_DIG_2,
    probe_out10 => C_DIG_3,
    probe_out11 => C_DIG_4
  );


ila_btn_i : ILA_BTN_SW
PORT MAP (
	clk => CLK,

	probe0 => BTN,
	probe1 => SW
);
  ----------------------------------------------------------------------------------------------------------
  -- PWM driver

pwm_driver_i: pwm_driver
  PORT MAP (
    CLK                =>   CLK,
    PWM_REF_7          =>   C_PWM_REF_7,
    PWM_REF_6          =>   C_PWM_REF_6,
    PWM_REF_5          =>   C_PWM_REF_5,
    PWM_REF_4          =>   C_PWM_REF_4,
    PWM_REF_3          =>   C_PWM_REF_3,
    PWM_REF_2          =>   C_PWM_REF_2,
    PWM_REF_1          =>   C_PWM_REF_1,
    PWM_REF_0          =>   C_PWM_REF_0, 
    PWM_OUT            =>   pwm_out,
    CNT_OUT            =>   cnt_out
  );

--LED

LED <= pwm_out;
----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
