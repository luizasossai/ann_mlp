-------------------------------------------------------------------------------
-- Activation_function_tb.vhd
-- Testbench for Activation functions
-- Input
-- 		File "data_activ.dat" with X values from -8 to 8 in Q3.11 format*.
-- Output
-- 		File "result_activ.csv" with X, Y1 and Y2 values in real format.
--		X_real, Y1_real and Y2_real in real format for visualization
-- Author
-- 		Prof. Dr. Maximiliam Luppe
-- Date
-- 		11/07/2020
-- Version
-- 		0.1		
-------------------------------------------------------------------------------
-- *Qm.f: The unambiguous form of the "Q" notation. Since the entire word is a 
-- 2's complement integer, a sign bit is implied. For example, Q1.30 describes 
-- a number with 1 integer bit and 30 fractional bits stored as a 32-bit 2's
-- complement. Source: https://en.wikipedia.org/wiki/Fixed-point_arithmetic
-------------------------------------------------------------------------------

use work.fixed_package.all;
use std.textio.all;

entity activation_function_tb is
	generic (
		LEFT_in : fixed_range := 3
		);
	port (
		X_real, Y1_real, Y2_real: out	real
		);
end entity;

architecture testbench of activation_function_tb is
	-- Funcao de Transferencia (ou Ativacao), baseada no trabalho:
	--  I. Tsmots, O. Skorokhoda and V. Rabyk, "Hardware Implementation of Sigmoid Activation Functions using
	--  FPGA", IEEE 15th Int. Conf. on the Experience of Designing and Application of CAD Systems (CADSM),
	--  Polyana, Ukraine, 2019, pp. 34-38, doi: 10.1109/CADSM.2019.8779253.
	--  ref: https://ieeexplore.ieee.org/abstract/document/8779253
	--  
	-- Parametro de entrada:
	-- 	X : fixed [0,1]
	-- Parametro de saida:
	-- 	SIG : fixed [0,1]
	-- Retorna:
	--  / Se      X < -4	SIG =  0.0
	--  | Se -4 < X < 0 	SIG = +0.03125*X**2+0.25*X+0.5
	-- <  Se      X = 0 	SIG = +0.5
	--  | Se  0 < X < 4 	SIG = -0.03125*X**2+0.25*X+0.5
	--  \ Se      X >= 4 	SIG = +1.0
		
	function Activation1 (X : fixed) return fixed is
		constant X_LEFT: integer := X'left;
		constant X_RIGHT: integer := X'right;
		constant a2p: fixed(X'range) := to_fixed(0.03125, X_LEFT, X_RIGHT);
		constant a2n: fixed(X'range) := to_fixed(-0.03125, X_LEFT, X_RIGHT);
		constant a1: fixed(X'range) := to_fixed(0.25000, X_LEFT, X_RIGHT);
		constant a0: fixed(X'range) := to_fixed(0.50000, X_LEFT, X_RIGHT);
		constant maxSIG: fixed(X'range) := to_fixed(0.99997, X_LEFT, X_RIGHT);
		constant minSIG: fixed(X'range) := to_fixed(0.00000, X_LEFT, X_RIGHT);
		variable SIG: fixed(X'range);
	begin
		if to_integer(X) >= 4 then		-- Se      X >= 4 SIG = +1.0
			SIG := maxSIG;
		elsif to_integer(X) < -4 then	-- Se      X < -4 SIG =  0.0
			SIG := minSIG;
		elsif to_integer(X) < 0 then	-- Se -4 < X < 0  SIG = (+0.03125*X+0.25)*X+0.5
			SIG := (((a2p * X) + a1) * X) + a0;
		else							-- Se  0 < X < 4  SIG = (-0.03125*X+0.25)*X+0.5
			SIG := (((a2n * X )+ a1) * X) + a0;			
		end if;
		return SIG;
	end; 	

	-- Funcao de Transferencia (ou Ativacao), adaptada do trabalho:
	--  I. Tsmots, O. Skorokhoda and V. Rabyk, "Hardware Implementation of Sigmoid Activation Functions using FPGA,", 2019
	--  IEEE 15th Int. Conf. on the Experience of Designing and Application of CAD Systems (CADSM), Polyana, Ukraine, 2019
	--  pp. 34-38, doi: 10.1109/CADSM.2019.8779253.
	--  ref: https://ieeexplore.ieee.org/abstract/document/8779253
	-- Parametro de entrada:
	-- 	X : fixed
	-- Parametro de saida:
	-- 	SIG : fixed
	-- Retorna:
	--  / Se      X < -4	SIG = -1.0
	--  | Se -4 < X < 0 	SIG = +0.0625*X**2+0.5*X
	-- <  Se      X = 0 	SIG =  0.0
	--  | Se  0 < X < 4 	SIG = -0.0625*X**2+0.5*X
	--  \ Se      X > 4 	SIG = +1.0
	function Activation2 (X : fixed) return fixed is
		constant X_LEFT: integer := X'left;
		constant X_RIGHT: integer := X'right;
		constant a2p: fixed(X'range) := to_fixed(0.0625, X_LEFT, X_RIGHT);
		constant a2n: fixed(X'range) := to_fixed(-0.0625, X_LEFT, X_RIGHT);
		constant a1: fixed(X'range) := to_fixed(0.50000, X_LEFT, X_RIGHT);
		constant maxSIG: fixed(X'range) := to_fixed(1.00000, X_LEFT, X_RIGHT);
		constant minSIG: fixed(X'range) := to_fixed(-1.00000, X_LEFT, X_RIGHT);
		variable SIG: fixed(X'range);
	begin
		if to_integer(X) >= 4 then	-- Se      X >= 4 SIG = +1.0
			SIG := maxSIG;
		elsif to_integer(X) < -4 then	-- Se      X < -4 SIG = -1.0
			SIG := minSIG;
		elsif to_integer(X) < 0 then	-- Se -4 < X < 0  SIG = (+0.0625*X+0.5)*X
			SIG := (a2p * X + a1) * X;
		else				-- Se  0 < X < 4  SIG = (-0.0625*X+0.5)*X
			SIG := (a2n * X + a1) * X;			
		end if;
		return SIG;
	end; 

begin
	activ_tb: process
		constant	header_X:		CHARACTER := 'X';
		constant	header_ACTIV1:	STRING(1 to 14) := "Activation1(X)";
		constant	header_ACTIV2:	STRING(1 to 14) := "Activation2(X)";
		file		data_in:		TEXT open Read_Mode is "..\ann_mlp\data\data_activ.dat";
		file		data_out:		TEXT open Write_Mode is "..\ann_mlp\data\result_activ.csv";
		variable	rd_line:		LINE;
		variable	wr_line:		LINE;
		variable	read_ok:		BOOLEAN;
		variable	str_value:		STRING(16 downto 1);
		variable	X_var:			fixed(LEFT_in downto LEFT_in-MAX_IND);
		variable	X_real_tmp:		real;
		variable	Y1_real_tmp:	real;
		variable	Y2_real_tmp: 	real;

	begin
			-- Generate output header data file
			write(wr_line, header_X);
			write(wr_line, ';');
			write(wr_line, header_ACTIV1);
			write(wr_line, ';');
			write(wr_line, header_ACTIV2);
			writeline(data_out, wr_line);

		for i in 1 to 256 loop
			-- Read buffer
			readline(data_in, rd_line);
			-- Read data from buffer (STRING format)
			read(rd_line, str_value, read_ok);
				assert read_ok report "Reading DATA ERROR!" severity ERROR;
			-- Convert data: STRING to FIXED
			for j in X_var'range loop
				if str_value(j+MAX_IND-LEFT_in+1)='0' then 
					X_var(j) := '0';
				else
					X_var(j) := '1';
				end if;
			end loop;

			-- Call convertion and activations functions
			X_real_tmp := to_real(X_var);
			Y1_real_tmp := to_real(Activation1(X_var));
			Y2_real_tmp := to_real(Activation2(X_var));

			-- Generate output data file
			write(wr_line, X_real_tmp);
			write(wr_line, ';');
			write(wr_line, Y1_real_tmp);
			write(wr_line, ';');
			write(wr_line, Y2_real_tmp);
			writeline(data_out, wr_line);

			-- Genereta output visualization data
			X_real <= X_real_tmp;
			Y1_real <= Y1_real_tmp;
			Y2_real <= Y2_real_tmp;

			wait for 100 ns;
		end loop;
		wait;
	end process activ_tb;
end testbench;
