----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY sync_reg IS
  PORT(
    clk                 : IN    STD_LOGIC;
    sig_in              : IN    STD_LOGIC;
    sig_out             : OUT   STD_LOGIC
  );
  
END ENTITY sync_reg;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF sync_reg IS
----------------------------------------------------------------------------------

SIGNAL sig_reg : STD_LOGIC;
attribute SHREG_EXTRACT : string;
attribute SHREG_EXTRACT of sig_reg : signal is "NO";
attribute SHREG_EXTRACT of sig_out : signal is "NO";
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
        sig_out <= sig_reg;
        sig_reg <= sig_in;  
    END IF;
       
END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
