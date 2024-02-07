----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2024 01:53:28 PM
-- Design Name: 
-- Module Name: LED_demo - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED_demo is
    Port ( SW : in STD_LOGIC_VECTOR (1 to 4);
           BTN : in STD_LOGIC_VECTOR (1 to 4);
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end LED_demo;

architecture Behavioral of LED_demo is

begin

    
    LED(7 downto 1) <= "0000000";
    
    
    LED(0) <= '1' when ((BTN="0110") AND (SW="1001")) 
        else '0'; 
    
    
    
    





end Behavioral;
