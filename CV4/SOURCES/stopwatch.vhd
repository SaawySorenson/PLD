----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY stopwatch IS
  PORT(
    clk                 : IN    STD_LOGIC;      -- clock signal
    ce_100hz            : IN    STD_LOGIC;      -- 100 Hz clock enable
    cnt_reset           : IN    STD_LOGIC;      -- counter reset
    cnt_enable          : IN    STD_LOGIC;      -- counter enable
    disp_enable         : IN    STD_LOGIC;      -- enable display update
    cnt_0               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    cnt_1               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    cnt_2               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    cnt_3               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY stopwatch;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF stopwatch IS
----------------------------------------------------------------------------------
SIGNAL counter_0 : INTEGER RANGE 0 to 255 := 0;
SIGNAL counter_1 : INTEGER RANGE 0 to 255 := 0;
SIGNAL counter_2 : INTEGER RANGE 0 to 255 := 0;
SIGNAL counter_3 : INTEGER RANGE 0 to 255 := 0;
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  -- BCD counter
PROCESS (clk) BEGIN 
    IF rising_edge(clk) THEN 
        IF ce_100hz = '1' THEN
            IF cnt_reset = '1' THEN 
                counter_0 <= 0;
                counter_1 <= 0;
                counter_2 <= 0;
                counter_3 <= 0;
             ELSE
                IF cnt_enable = '1' THEN 
                      counter_0  <= counter_0 + 1;
                      IF counter_0 = 9 THEN 
                          counter_0 <= 0;
                          counter_1 <= counter_1 + 1;
                      END IF;
                      IF counter_1 = 9 THEN 
                          counter_1 <= 0;
                          counter_2 <= counter_2 + 1;
                      END IF;
                      IF counter_2 = 9 THEN 
                          counter_2 <= 0;
                          counter_3 <= counter_3 + 1;
                      END IF;
                      IF counter_3 = 6 THEN 
                          counter_3 <= 0;
                      END IF;    
                END IF;
            END IF; 
            
            IF disp_enable = '1' THEN 
                cnt_0 <= std_logic_vector(TO_UNSIGNED(counter_0,4)); 
                cnt_1 <= std_logic_vector(TO_UNSIGNED(counter_1,4));
                cnt_2 <= std_logic_vector(TO_UNSIGNED(counter_2,4));
                cnt_3 <= std_logic_vector(TO_UNSIGNED(counter_3,4));
            END IF;
            
        END IF;  
    END IF;         
END PROCESS;

  --------------------------------------------------------------------------------
  -- Output (display) register


----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
