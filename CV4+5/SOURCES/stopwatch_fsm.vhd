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
TYPE t_state IS (st_Idle, st_Run, st_Lap, st_Refresh, st_Stop);
SIGNAL pres_st : t_state := st_Idle;
SIGNAL next_st : t_state;

SIGNAL cnt_reset_c      : STD_LOGIC;                
SIGNAL cnt_enable_c     : STD_LOGIC;             
SIGNAL disp_enable_c    : STD_LOGIC;   

SIGNAL cnt_enable_REG : STD_LOGIC := '0';
SIGNAL cnt_reset_REG : STD_LOGIC := '0';
SIGNAL disp_enable_REG : STD_LOGIC := '0';
 
--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
PROCESS (clk) BEGIN 
    IF rising_edge (clk)THEN 
        pres_st <= next_st;                
    END IF;    
END PROCESS;

PROCESS (pres_st, btn_S_S, btn_L_C) BEGIN 
    CASE pres_st IS
        WHEN st_Idle => IF btn_S_S = '1' THEN next_st <= st_Run;
                        ELSIF btn_L_C = '1' THEN next_st <= st_Idle;
                        ELSE next_st <= st_Idle;
                        END IF;
        WHEN st_Run => IF btn_S_S = '1' THEN next_st <= st_Stop;
                       ELSIF btn_L_C = '1' THEN next_st <= st_Lap;
                       ELSE next_st <= st_Run;
                       END IF;
        WHEN st_Lap => IF btn_S_S = '1' THEN next_st <= st_Run;    
                       ELSIF btn_L_C = '1' THEN next_st <= st_Refresh;
                       ELSE next_st <= st_Lap;
                       END IF;
        WHEN st_Refresh => IF btn_S_S = '1' THEN next_st <= st_Lap;
                       ELSIF btn_L_C = '1' THEN next_st <= st_Lap;
                       ELSE next_st <= st_Lap;
                       END IF;
        WHEN st_Stop => IF btn_S_S = '1' THEN next_st <= st_Run;    
                       ELSIF btn_L_C = '1' THEN next_st <= st_Idle;
                       ELSE next_st <= st_Stop;
                       END IF;
        END CASE;
END PROCESS;

PROCESS (clk) BEGIN 
    IF rising_edge (clk)THEN 
         CASE pres_st IS
             WHEN st_Idle => cnt_enable_c  <= '0';
                          cnt_reset_c   <= '1';
                          disp_enable_c <= '1';
             WHEN st_Run => cnt_enable_c  <= '1';
                          cnt_reset_c   <= '0';
                          disp_enable_c <= '1';
             WHEN st_Lap => cnt_enable_c  <= '1';
                          cnt_reset_c   <= '0';
                          disp_enable_c <= '0';
             WHEN st_Refresh => cnt_enable_c  <= '1';
                          cnt_reset_c   <= '0';
                          disp_enable_c <= '1';
             WHEN st_Stop => cnt_enable_c  <= '0';
                          cnt_reset_c   <= '0';
                          disp_enable_c <= '1';
             END CASE;      
    END IF;    
END PROCESS;

PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
        cnt_enable_REG <= cnt_enable_c;
        cnt_reset_REG <= cnt_reset_c;
        disp_enable_REG <= disp_enable_c;
    END IF;
END PROCESS;

cnt_enable <= cnt_enable_REG;
cnt_reset <= cnt_reset_REG;
disp_enable <= disp_enable_REG;


--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
--------------------------------------------------------------------------------
