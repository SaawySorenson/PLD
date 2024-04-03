-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Wed Apr  3 13:24:53 2024
-- Host        : PC-079 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub c:/Temp/xsvece00/PLD/CV8/SOURCES/ips/ILA_PWM/ILA_PWM_stub.vhdl
-- Design      : ILA_PWM
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ILA_PWM is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end ILA_PWM;

architecture stub of ILA_PWM is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[7:0],probe1[7:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "ila,Vivado 2022.1";
begin
end;
