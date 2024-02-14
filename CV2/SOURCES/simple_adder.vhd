
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity simple_adder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end simple_adder;

architecture Behavioral of simple_adder is
    
    
    SIGNAL A_uns : UNSIGNED(3 downto 0);
    SIGNAL B_uns : UNSIGNED(3 downto 0);
    SIGNAL Y_uns : UNSIGNED(4 downto 0);
    
    
begin
    
    A_uns <= UNSIGNED(A);
    B_uns <= UNSIGNED(B);   
   
    Y_uns  <= "00000" + A_uns - B_uns;
    
    Y <= STD_LOGIC_VECTOR(Y_uns(3 downto 0));
    
    C <= Y_uns(4);
    Z <= '0';
    
    
    
      
   


end Behavioral;
