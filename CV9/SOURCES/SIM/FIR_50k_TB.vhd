----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE std.textio.ALL;
----------------------------------------------------------------------------------
entity FIR_50k_TB is
end FIR_50k_TB;
----------------------------------------------------------------------------------
architecture tb of FIR_50k_TB is
----------------------------------------------------------------------------------

  COMPONENT FIR_50k_wrapper IS
  GENERIC (
    SIM_MODEL                           : BOOLEAN := TRUE
  );
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC;
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
  END COMPONENT FIR_50k_wrapper;

  -----------------------------------------------------------------------

  SIGNAL sig_SIM_finished               : BOOLEAN := FALSE;     -- assert when all test vectors has been applied

  CONSTANT C_aclk_period                : time := 20 ns;
  SIGNAL aclk                           : STD_LOGIC := '0';

  SIGNAL s_axis_data_tvalid             : STD_LOGIC := '0';
  SIGNAL s_axis_data_tready             : STD_LOGIC;
  SIGNAL s_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL m_axis_data_tvalid             : STD_LOGIC;
  SIGNAL m_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL errors                         : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0');

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------


  --------------------------------------------------------------------------------
  -- Clock process definitions
  --------------------------------------------------------------------------------

  P_aclk: PROCESS
  BEGIN
    aclk <= '0'; WAIT FOR C_aclk_period/2;
    aclk <= '1'; WAIT FOR C_aclk_period/2;
    IF sig_SIM_finished THEN WAIT; END IF;
  END PROCESS P_aclk;


  -----------------------------------------------------------------------
  -- Instantiate the DUT
  -----------------------------------------------------------------------

  FIR_50k_wrapper_i : FIR_50k_wrapper
  GENERIC MAP(
    SIM_MODEL           => TRUE
  )
  PORT MAP(
    aclk                => aclk,
    s_axis_data_tvalid  => s_axis_data_tvalid,
    s_axis_data_tready  => s_axis_data_tready,
    s_axis_data_tdata   => s_axis_data_tdata,
    m_axis_data_tvalid  => m_axis_data_tvalid,
    m_axis_data_tdata   => m_axis_data_tdata
  );

  -----------------------------------------------------------------------
  -- FIR input
  --    read FIR_data_in.txt
  --    feed the FIR filter with the data from file
  -----------------------------------------------------------------------
read_txt: PROCESS
     FILE FIR_IN : TEXT;
     VARIABLE line_in : LINE;
     VARIABLE v_number : INTEGER;

BEGIN
     FILE_OPEN(FIR_IN, "C:\Temp\xsvece00\PLD\CV9\SOURCES\FIR_data\FIR_data_in.txt", READ_MODE);
     WAIT UNTIL falling_edge(aclk); -- synchronization
     WHILE NOT ENDFILE(FIR_IN) LOOP
         READLINE(FIR_IN, line_in);
         READ(line_in, v_number);      
         
         WHILE s_axis_data_tready /= '1' LOOP
            WAIT FOR C_aclk_period;
         END LOOP;
          
         s_axis_data_tdata <= STD_LOGIC_VECTOR(TO_SIGNED(v_number,16));
         s_axis_data_tvalid <= '1'; WAIT FOR C_aclk_period * 1;         
         s_axis_data_tvalid <= '0'; WAIT FOR C_aclk_period * 3;
         
     END LOOP;
     FILE_CLOSE(FIR_IN);
     sig_SIM_finished <= TRUE;
     WAIT;
END PROCESS read_txt;




  -----------------------------------------------------------------------
  -- FIR output data check
  --    read reference data from FIR_data_out.txt
  --    compare the reference and actual data
  --    report any discrepancy (both a text LOG file and simulator console)
  --    report overall test result
  -----------------------------------------------------------------------
compare_txt: PROCESS
     FILE FIR_OUT : TEXT;
     VARIABLE line_in : LINE;
     VARIABLE v_number : INTEGER;
     
     FILE TEST_OUT : TEXT;
     VARIABLE line_out : LINE;     

BEGIN
     FILE_OPEN(FIR_OUT, "C:\Temp\xsvece00\PLD\CV9\SOURCES\FIR_data\FIR_data_out.txt", READ_MODE);
     FILE_OPEN(TEST_OUT, "C:\Temp\xsvece00\PLD\CV9\SOURCES\FIR_data\test_out.txt", WRITE_MODE);
     WAIT UNTIL falling_edge(aclk); -- synchronization
     WHILE NOT sig_SIM_finished LOOP
                                 
         IF m_axis_data_tvalid = '1' THEN
             
             READLINE(FIR_OUT, line_in);
             READ(line_in, v_number);
                          
             IF m_axis_data_tdata /= STD_LOGIC_VECTOR(TO_SIGNED(v_number,16)) THEN
                 WRITE (line_out, STRING'("Simulation time: "));
                 WRITE (line_out, TIME'image(NOW));
                 WRITE (line_out, STRING'(", output data (decimal): "));
                 WRITE (line_out, INTEGER'image(TO_INTEGER(SIGNED(m_axis_data_tdata))));
                 WRITE (line_out, STRING'(", should be (decimal): "));
                 WRITE (line_out, INTEGER'image(v_number));
                 REPORT line_out.ALL SEVERITY WARNING;
                 WRITELINE (TEST_OUT, line_out);
                 errors <= errors + 1;
             ELSE
                 WRITE (line_out, STRING'("Simulation time: "));
                 WRITE (line_out, TIME'image(NOW));
                 WRITE (line_out, STRING'(", output data (decimal): "));
                 WRITE (line_out, INTEGER'image(TO_INTEGER(SIGNED(m_axis_data_tdata))));
                 REPORT line_out.ALL SEVERITY NOTE;
                 WRITELINE (TEST_OUT, line_out);
             END IF;
     
        END IF;
           
        WAIT FOR C_aclk_period;   
     END LOOP;
     WRITE (line_out, STRING'("Number of errors: "));
     WRITE (line_out, INTEGER'image(TO_INTEGER(SIGNED(errors))));
     WRITELINE (TEST_OUT, line_out);
     
     FILE_CLOSE(FIR_OUT);
     FILE_CLOSE(TEST_OUT);
     
     WAIT;
     
END PROCESS compare_txt;



----------------------------------------------------------------------------------
end tb;
----------------------------------------------------------------------------------
