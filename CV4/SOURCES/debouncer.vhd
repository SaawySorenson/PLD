----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );    
  PORT( 
    clk                 : IN    STD_LOGIC;
    ce                  : IN    STD_LOGIC;
    btn_in              : IN    STD_LOGIC;
    btn_out             : OUT   STD_LOGIC
  );
END ENTITY debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------
SIGNAL lock : INTEGER RANGE 0 to 255 := 0;
SIGNAL per_cnt : INTEGER RANGE 0 to 255 := 5;
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN  
        IF lock = 0 THEN
            btn_out <= btn_in;
                lock <= per_cnt;                
        ELSE 
            lock <= lock -1; 
        END IF;
    END IF;    
END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
