----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
  GENERIC (
    G_DIV_FACT          : POSITIVE := 500000
  );
  PORT (
    clk                 : IN  STD_LOGIC;
    srst                : IN  STD_LOGIC;
    ce                  : IN  STD_LOGIC;
    ce_o                : OUT STD_LOGIC := '0'
  );
END ENTITY ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
----------------------------------------------------------------------------------
 --SIGNAL div  : unsigned(63 downto 0) := (OTHERS => '0');
SIGNAL div  :   INTEGER RANGE 0 TO 255 := 0;
SIGNAL hold :   STD_LOGIC := '0';
  
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
slow_proc: PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
        IF ce = '1' THEN
            div <= div + 1;
            IF div = G_DIV_FACT then
                ce_o <= '1';
                div <= 0;
            ELSE
                ce_o <= '0';
            END IF;
        END IF;
    END IF;
END PROCESS slow_proc;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
