----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2024 01:25:34 PM
-- Design Name: 
-- Module Name: cnt_bin - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_bin is
    Port ( cnt : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           srst : in STD_LOGIC;
           ce : in STD_LOGIC;
           cnt_load : in STD_LOGIC;
           cnt_up : in STD_LOGIC);
end cnt_bin;
    


architecture Behavioral of cnt_bin is
    
    SIGNAL count : UNSIGNED(31 downto 0) := (OTHERS => '0');
       
begin

    PROCESS (clk) BEGIN   
    
        IF rising_edge(clk) THEN
            IF srst = '1' THEN --reset
                count <= X"00000000";
            ELSIF ce = '1' AND cnt_load = '1' THEN --load adr
                count <= X"55555555";
            ELSIF srst = '0' THEN --counting
                IF cnt_up = '1' AND ce = '1' THEN --count up
                    count <= count + 1;              
                ELSIF cnt_up = '0' AND ce = '1' THEN --count down    
                    count <= count - 1;
                END IF;
            END IF;
        END IF;
        
        cnt <= STD_LOGIC_VECTOR(count(31 downto 0)); --set output

    END PROCESS;

end Behavioral;
