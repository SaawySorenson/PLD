----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
----------------------------------------------------------------------------------
ENTITY pwm_driver IS
  PORT (
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END pwm_driver;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver IS
----------------------------------------------------------------------------------
signal cnt_PWM : unsigned(7 downto 0):= "00000000";
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

PROCESS(clk) BEGIN
    IF rising_edge(clk) THEN
        IF std_logic_vector(cnt_PWM) < PWM_ref_7 THEN
            PWM_OUT(7) <= '1';   
        ELSE
            PWM_OUT(7) <= '0';
        END IF;
        
        IF std_logic_vector(cnt_PWM) < PWM_ref_6 THEN
            PWM_OUT(6) <= '1';   
        ELSE
            PWM_OUT(6) <= '0';
        END IF;
        
        IF std_logic_vector(cnt_PWM) < PWM_ref_5 THEN
            PWM_OUT(5) <= '1';   
        ELSE
            PWM_OUT(5) <= '0';
        END IF;
        
        IF std_logic_vector(cnt_PWM) < PWM_ref_4 THEN
            PWM_OUT(4) <= '1';   
        ELSE
            PWM_OUT(4) <= '0';
        END IF;
        
        IF std_logic_vector(cnt_PWM) < PWM_ref_3 THEN
            PWM_OUT(3) <= '1';   
        ELSE
            PWM_OUT(3) <= '0';
        END IF;
        
        IF std_logic_vector(cnt_PWM) < PWM_ref_2 THEN
            PWM_OUT(2) <= '1';   
        ELSE
            PWM_OUT(2) <= '0';
        END IF;
        
        IF std_logic_vector(cnt_PWM) < PWM_ref_1 THEN
            PWM_OUT(1) <= '1';   
        ELSE
            PWM_OUT(1) <= '0';
        END IF;
        
        IF std_logic_vector(cnt_PWM) < PWM_ref_0 THEN
            PWM_OUT(0) <= '1';   
        ELSE
            PWM_OUT(0) <= '0';
        END IF;
        
        CNT_OUT <= std_logic_vector (cnt_PWM);
        cnt_PWM <= cnt_PWM + 1;
        IF cnt_PWM >= 254 THEN
            cnt_PWM <= "00000000";
        END IF;        
    END IF;


END PROCESS;



----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
