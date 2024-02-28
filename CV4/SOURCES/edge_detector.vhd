----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
  PORT(
    clk                 : IN    STD_LOGIC;
    sig_in              : IN    STD_LOGIC;
    edge_pos            : OUT   STD_LOGIC;
    edge_neg            : OUT   STD_LOGIC;
    edge_any            : OUT   STD_LOGIC
  );
END ENTITY edge_detector;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF edge_detector IS
----------------------------------------------------------------------------------
SIGNAL sig_in_del : STD_LOGIC := '0';
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
PROCESS BEGIN 
    IF rising_edge(clk) THEN 
        IF sig_in_del = '1' AND sig_in = '0' THEN 
            edge_any <= '1';
            edge_neg <= '1';
            edge_pos <= '0'; 
        ELSIF sig_in_del = '0' AND sig_in = '1' THEN
            edge_any <= '1';
            edge_neg <= '0';
            edge_pos <= '1';
        ELSE 
            edge_any <= '0';
            edge_neg <= '0';
            edge_pos <= '0';            
        END IF;        
    END IF;
    sig_in_del <= sig_in;
END PROCESS;




----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
