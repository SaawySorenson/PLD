--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
ENTITY stopwatch_fsm IS
  PORT (
    clk                 : IN    STD_LOGIC;
    btn_S_S             : IN    STD_LOGIC;
    btn_L_C             : IN    STD_LOGIC;
    cnt_reset           : OUT   STD_LOGIC;
    cnt_enable          : OUT   STD_LOGIC;
    disp_enable         : OUT   STD_LOGIC
  );
END ENTITY stopwatch_fsm;
--------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF stopwatch_fsm IS
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
--------------------------------------------------------------------------------