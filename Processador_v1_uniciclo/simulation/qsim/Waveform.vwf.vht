-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/29/2018 12:28:31"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          DataPath
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY DataPath_vhd_vec_tst IS
END DataPath_vhd_vec_tst;
ARCHITECTURE DataPath_arch OF DataPath_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL Clock_Sistema : STD_LOGIC;
COMPONENT DataPath
	PORT (
	Clock_Sistema : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : DataPath
	PORT MAP (
-- list connections between master ports and signals
	Clock_Sistema => Clock_Sistema
	);

-- Clock_Sistema
t_prcs_Clock_Sistema: PROCESS
BEGIN
LOOP
	Clock_Sistema <= '0';
	WAIT FOR 5000 ps;
	Clock_Sistema <= '1';
	WAIT FOR 5000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_Clock_Sistema;
END DataPath_arch;
