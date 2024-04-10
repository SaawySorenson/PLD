----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
    GENERIC(
        G_DEB_PERIOD : POSITIVE := 3
    );
    PORT(
        clk : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        btn_in : IN STD_LOGIC;
        btn_out : OUT STD_LOGIC := '0'
    );
END ENTITY debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------

SIGNAL shreg : STD_LOGIC_VECTOR(G_DEB_PERIOD-1 DOWNTO 0) := (others => '0');
CONSTANT C_ALL_0 : STD_LOGIC_VECTOR(G_DEB_PERIOD-1 DOWNTO 0) := (others => '0');
CONSTANT C_ALL_1 : STD_LOGIC_VECTOR(G_DEB_PERIOD-1 DOWNTO 0) := (others => '1');
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
        IF ce = '1' THEN
            shreg <= shreg (G_DEB_PERIOD-2 DOWNTO 0) & btn_in;
        IF shreg = C_ALL_0 THEN
            btn_out <= '0';
        ELSIF shreg = C_ALL_1 THEN
            btn_out <= '1';
        END IF;
        END IF;
    END IF;
END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
---------------------------------