use work.fixed_package.all;

package neuron_pkg is

	TYPE fixed_vector is array (natural range <>) OF fixed(3 downto -12);
	
	function Activation1 (X : fixed) return fixed;
	function Activation2 (X : fixed) return fixed;

end package;

package body neuron_pkg is

	-- Função de Transferência (ou Ativação), baseada no trabalho:
	--  I. Tsmots, O. Skorokhoda and V. Rabyk, "Hardware Implementation of Sigmoid Activation Functions using FPGA,", 2019
	--  IEEE 15th Int. Conf. on the Experience of Designing and Application of CAD Systems (CADSM), Polyana, Ukraine, 2019
	--  pp. 34-38, doi: 10.1109/CADSM.2019.8779253.
	--  ref: https://ieeexplore.ieee.org/abstract/document/8779253
	-- Parâmetro de entrada:
	-- 	X : fixed
	-- Parâmetro de saída:
	-- 	SIG : fixed
	-- Retorna:
	--  / Se      X < -4	SIG =  0.0
	--  | Se -4 < X < 0 	SIG = +0.03125*X**2+0.25*X+0.5
	-- <  Se      X = 0 	SIG = +0.5
	--  | Se  0 < X < 4 	SIG = -0.03125*X**2+0.25*X+0.5
	--  \ Se      X > 4 	SIG = +1.0
	function Activation1 (X : fixed) return fixed is
		constant X_LEFT: integer := X'left;
		constant X_RIGHT: integer := X'right;
		constant a2p: fixed(X'range) := to_fixed(0.03125, X_LEFT, X_RIGHT);
		constant a2n: fixed(X'range) := to_fixed(-0.03125, X_LEFT, X_RIGHT);
		constant a1: fixed(X'range) := to_fixed(0.25000, X_LEFT, X_RIGHT);
		constant a0: fixed(X'range) := to_fixed(0.50000, X_LEFT, X_RIGHT);
		constant maxSIG: fixed(X'range) := to_fixed(1.00000, X_LEFT, X_RIGHT);
		constant minSIG: fixed(X'range) := to_fixed(0.00000, X_LEFT, X_RIGHT);
		variable SIG: fixed(X'range);
	begin
		if to_real(X) >= 4.0 then		-- Se      X >= 4 SIG = +1.0
			SIG := maxSIG;
		elsif to_real(X) < -4.0 then		-- Se      X < -4 SIG =  0.0
			SIG := minSIG;
		elsif to_real(X) < 0.0 then		-- Se -4 < X < 0  SIG = (+0.03125*X+0.25)*X+0.5
			SIG := (((a2p * X) + a1) * X) + a0;
		else				-- Se  0 < X < 4  SIG = (-0.03125*X+0.25)*X+0.5
			SIG := (((a2n * X )+ a1) * X) + a0;			
		end if;
		return SIG;
	end Activation1;
	
	-- Função de Transferência (ou Ativação), adaptada do trabalho:
	
	--  I. Tsmots, O. Skorokhoda and V. Rabyk, "Hardware Implementation of Sigmoid Activation Functions using FPGA,", 2019
	--  IEEE 15th Int. Conf. on the Experience of Designing and Application of CAD Systems (CADSM), Polyana, Ukraine, 2019
	--  pp. 34-38, doi: 10.1109/CADSM.2019.8779253.
	--  ref: https://ieeexplore.ieee.org/abstract/document/8779253
	-- Parâmetro de entrada:
	-- 	X : fixed
	-- Parâmetro de saída:
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
		if to_real(X) >= 4.0 then	-- Se      X >= 4 SIG = +1.0
			SIG := maxSIG;
		elsif to_real(X) < -4.0 then	-- Se      X < -4 SIG = -1.0
			SIG := minSIG;
		elsif to_real(X) < 0.0 then	-- Se -4 < X < 0  SIG = (+0.0625*X+0.5)*X
			SIG := (a2p * X + a1) * X;
		else			-- Se  0 < X < 4  SIG = (-0.0625*X+0.5)*X
			SIG := (a2n * X + a1) * X;			
		end if;
		return SIG;
	end Activation2;

end neuron_pkg;	
