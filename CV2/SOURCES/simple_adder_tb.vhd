----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2024 01:49:10 PM
-- Design Name: 
-- Module Name: simple_adder_tb - Behavioral
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


entity simple_adder_tb is
end simple_adder_tb;

architecture Behavioral of simple_adder_tb is
    
    component simple_adder 
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Y : out STD_LOGIC_VECTOR (3 downto 0);
               C : out STD_LOGIC;
               Z : out STD_LOGIC);
    end component;
    
    SIGNAL a_sig : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL b_sig : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL y_sig : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL c_sig : STD_LOGIC;
    SIGNAL z_sig : STD_LOGIC;
    SIGNAL y_ref : STD_LOGIC_VECTOR(4 downto 0);

begin
    
    simple_adder_i : simple_adder
        Port map(
                   A  => a_sig,
                   B  => b_sig,
                   Y  => y_sig,
                   C  => c_sig,
                   Z  => z_sig
                 );
    
    stimulus_generator: PROCESS
          
    BEGIN 
    
        --b_sig <= "0010";
        FOR i IN 0 TO 15 LOOP
            a_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,4));
            FOR j IN 0 TO 15 LOOP
                b_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(j,4));
                WAIT FOR 10 ns;
            end LOOP;
            WAIT FOR 10 ns;
        END LOOP;

        WAIT;   
        
    END PROCESS stimulus_generator;
    
    output_checker: PROCESS
    BEGIN 
        WAIT ON a_sig, b_sig;
        y_ref <= STD_LOGIC_VECTOR("00000" + UNSIGNED(a_sig) + UNSIGNED(b_sig)); 
        WAIT FOR 2 ns;
        IF NOT(y_ref(3 downto 0) = y_sig) THEN --assert
            REPORT"Wrong result! a=" & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(a_sig))) 
            & " b=" & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(b_sig)))
            & " result= " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(y_sig(3 downto 0))))
            & " should be = " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(y_ref(3 downto 0))))
            SEVERITY WARNING; --error, failure, note
        END IF;
        ASSERT(c_sig = y_ref(4))
            REPORT"Wrong carry! a=" & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(a_sig))) 
            & " b=" & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(b_sig)))
            & " result= " & STD_LOGIC'IMAGE(c_sig)
            & " should be = " & STD_LOGIC'IMAGE(y_ref(4))
            SEVERITY WARNING;
            
        
        
        
    END PROCESS output_checker;
     
    

end Behavioral;
