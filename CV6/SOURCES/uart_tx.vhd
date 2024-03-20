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

SIGNAL DATA: STD_LOGIC_VECTOR(9 DOWNTO 0):= (OTHERS => '0');
SIGNAL START: STD_LOGIC:= '0';
SIGNAL BUSY: STD_LOGIC:= '0';
SIGNAL POINTER: INTEGER RANGE 0 to 255:= 0;
SIGNAL SENDING: STD_LOGIC:= '0';


----------------------------------------------------------------------------------

BEGIN
----------------------------------------------------------------------------------

PROCESS (clk) BEGIN
    IF(rising_edge(clk)) THEN
        IF(TX_START = '1' AND BUSY = '0') THEN
             START <= '1';
             BUSY <= '1';
             DATA <= '1' & DATA_IN & '0';
        END IF;               
        IF(START = '1') THEN
            IF(CLK_EN = '1') THEN 
                SENDING <= '1';
                IF(SENDING = '1') THEN
                    IF(POINTER <= 9) THEN
                        TX_DATA_OUT <= DATA(POINTER);
                        POINTER <= POINTER +1;
                    ELSIF(POINTER >= 9) THEN
                        SENDING <= '0';
                        POINTER <= 0;
                        START <= '0';
                        DATA <= "0000000000";
                        BUSY <= '0';    
                    END IF;
                ELSIF(SENDING = '0') THEN
                    TX_DATA_OUT <= '1';
                END IF;
            ELSIF(START = '0') THEN
                TX_DATA_OUT <= '1'; 
        END IF;       
        END IF;
        TX_BUSY <= BUSY; 
    END IF;  
END PROCESS;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
