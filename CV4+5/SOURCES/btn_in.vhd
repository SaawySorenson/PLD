----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY btn_in IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
  PORT(
    clk                 : IN    STD_LOGIC;
    ce                  : IN    STD_LOGIC;
    btn                 : IN    STD_LOGIC;
    btn_debounced       : OUT   STD_LOGIC;
    btn_edge_pos        : OUT   STD_LOGIC;
    btn_edge_neg        : OUT   STD_LOGIC;
    btn_edge_any        : OUT   STD_LOGIC
  );
  
END ENTITY btn_in;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF btn_in IS
----------------------------------------------------------------------------------

  COMPONENT sync_reg
  PORT(
    clk                 : IN    STD_LOGIC;
    sig_in              : IN    STD_LOGIC;
    sig_out             : OUT   STD_LOGIC
  );
  
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT debouncer
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
  PORT(
    clk                 : IN    STD_LOGIC;
    ce                  : IN    STD_LOGIC;
    btn_in              : IN    STD_LOGIC;
    btn_out             : OUT   STD_LOGIC
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT edge_detector
  PORT(
    clk                 : IN    STD_LOGIC;
    sig_in              : IN    STD_LOGIC;
    edge_pos            : OUT   STD_LOGIC;
    edge_neg            : OUT   STD_LOGIC;
    edge_any            : OUT   STD_LOGIC
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

  SIGNAL btn_nm         : STD_LOGIC;
  SIGNAL btn_deb        : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  sync_reg_i : sync_reg
  PORT MAP(
    clk             => clk,
    sig_in          => btn,
    sig_out         => btn_nm
  );

  --------------------------------------------------------------------------------

  debouncer_i : debouncer
  GENERIC MAP(
    G_DEB_PERIOD    => G_DEB_PERIOD)
  PORT MAP(
    clk             => clk,
    ce              => ce,
    btn_in          => btn_nm,
    btn_out         => btn_deb
  );

  btn_debounced <= btn_deb;

  --------------------------------------------------------------------------------

  edge_detector_i : edge_detector
  PORT MAP(
    clk             => clk,
    sig_in          => btn_deb,
    edge_pos        => btn_edge_pos,
    edge_neg        => btn_edge_neg,
    edge_any        => btn_edge_any
  );

----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
