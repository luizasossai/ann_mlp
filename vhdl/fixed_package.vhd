--Aluno: Gustavo Simoes Belote / NUSP: 10748584
--Aluna: Luiza Sossai de Souza / NUSP: 10748441

PACKAGE fixed_package IS

	CONSTANT MAX_IND : integer := 15;
	CONSTANT MIN_IND : integer := -15;
	SUBTYPE fixed_range IS integer RANGE MIN_IND TO MAX_IND;
	TYPE fixed IS ARRAY (fixed_range RANGE <>) OF bit;
	TYPE matrix IS ARRAY (natural RANGE <>, natural RANGE <>) OF bit;
	function to_fixed (arg_L: integer; max_range: fixed_range := MAX_IND; min_range: fixed_range := 0) return fixed;
	function to_fixed (arg_L: real; max_range: fixed_range := MAX_IND; min_range: fixed_range := MIN_IND) return fixed;
	function to_integer (arg_L: fixed) return integer;
	function to_real (arg_L: fixed) return real;
	function "+"(arg_L, arg_R: fixed) return fixed;
	function "-"(arg_L, arg_R: fixed) return fixed;
	function "+"(arg_L: fixed; arg_R: integer) return fixed;
	function "+"(arg_L: integer; arg_R: fixed) return fixed;
	function "-"(arg_L: fixed; arg_R: integer) return fixed;
	function "-"(arg_L: integer; arg_R: fixed) return fixed;
	function "*"(arg_L, arg_R: fixed) return fixed;
	function "*"(arg_L: fixed; arg_R: integer) return fixed;
	function "*"(arg_L: integer; arg_R: fixed) return fixed;
	function "+"(arg_L: fixed; arg_R: real) return fixed;
	function "+"(arg_L: real; arg_R: fixed) return fixed;
	function "-"(arg_L: fixed; arg_R: real) return fixed;
	function "-"(arg_L: real; arg_R: fixed) return fixed;
	function "*"(arg_L: fixed; arg_R: real) return fixed;
	function "*"(arg_L: real; arg_R: fixed) return fixed;

END fixed_package;

PACKAGE BODY fixed_package IS
--MAXIMO
	FUNCTION MAXIMO (arg_L, arg_R: integer) RETURN integer IS
		BEGIN 
			IF arg_L > arg_R THEN RETURN arg_L;
			ELSE 						 RETURN arg_R;		
			END IF;
	END MAXIMO;
--MINIMO
	FUNCTION MINIMO (arg_L, arg_R: integer) RETURN integer IS
		BEGIN
			IF arg_L > arg_R THEN RETURN arg_R;
			ELSE 						 RETURN arg_L;		
			END IF;		
	END MINIMO;
	
--COMP1_FIXED
	FUNCTION COMP1_FIXED (arg_L: fixed) RETURN fixed IS
		VARIABLE s : fixed(arg_L'LEFT DOWNTO arg_L'RIGHT);
		BEGIN
			comp: FOR i IN arg_L'LEFT DOWNTO arg_L'RIGHT LOOP
				s(i) := NOT arg_L(i);
			END LOOP comp;
		RETURN s;
	END COMP1_FIXED;
	
--ADD_SUB_FIXED
	FUNCTION ADD_SUB_FIXED (arg_L, arg_R: fixed; c: bit) RETURN fixed IS
		VARIABLE v : bit := '0';
		VARIABLE s : fixed(arg_L'LEFT DOWNTO arg_L'RIGHT);
		BEGIN
			FOR i IN arg_L'RIGHT TO  arg_L'LEFT LOOP
				s(i) := arg_L(i) xor arg_R(i) xor v;
				v    := (arg_L(i) AND arg_R(i)) OR (arg_L(i) AND v) OR (arg_R(i) AND v);
			END LOOP;
			RETURN s;
	END ADD_SUB_FIXED;
	
--COMP2_FIXED
	FUNCTION COMP2_FIXED(arg_L: fixed) RETURN fixed IS
		VARIABLE s : fixed(arg_L'LEFT DOWNTO arg_L'RIGHT);
		VARIABLE v,temp : bit;
		BEGIN
			v := '1';
			s := COMP1_FIXED(arg_L);
			comp2: for i in arg_L'RIGHT TO arg_L'LEFT LOOP
				temp := v;
				v := s(i) AND v;
				s(i) := s(i) XOR temp;
				END LOOP comp2;
			RETURN s;
	END COMP2_FIXED;
	
--mult_bit
	FUNCTION mult_bit (a, b: bit_vector) RETURN bit_vector IS
	
		constant m: integer := a'length;
		constant n: integer := b'length;
	
	--Mi,j
		variable Mij: matrix(0 to m-1, 0 to m+n-1);
	--Ci,j
		variable Cij: matrix(0 to m-1, 0 to m+n);
	--Pi,j
		variable Pij: matrix(0 to m, 0 to m+n);
	--blinha
		variable blinha: bit_vector(m+n-1 downto 0);
	--p (resultado)
		variable p: bit_vector (m+n-1 downto 0);
		
	BEGIN
		blinha := (m+n-1 downto n => '0') & b;
		
		initCij: for i in 0 to m-1 loop
			Cij(i,0) := '0';
		END loop initCij;
		
		initPijcol: for i in 0 to m loop
			Pij(i,0) := '0';
		END loop initPijcol;
		
		initPijrow: for j in 1 to m+n-1 loop
			Pij(m,j) := '0';
		END loop initPijrow;
		
		Mijcol: for i in m-1 downto 0 loop
			Mijrow: for j in m+n-1 downto 0 loop
				Mij(i,j) := a(i) and blinha(j);
			end loop Mijrow;
		end loop Mijcol;
		
		Pijrow: for j in 0 to m+n-1 loop
			Pijcol: for i in 0 to m-1 loop
				Pij(i,j+1) := Pij(i+1,j) xor Mij(i,j) xor Cij(i,j);
				Cij(i,j+1) := (Pij(i+1,j) and (Mij(i,j) or Cij(i,j))) or (Mij(i,j) and Cij(i,j));
			end loop Pijcol;
		end loop Pijrow;
	
		gen_pi: for i in m+n-1 downto 0 loop
			p(i) := Pij(0,i+1);
		end loop gen_pi;
		
		return p;
	
	END mult_bit;
	
--mult_fixed
--entradas devem ter o mesmo Q format
	FUNCTION mult_fixed (x1, x2: fixed) RETURN fixed IS
		
		constant MSB: fixed_range := x1'left;
		constant LSB: fixed_range := x1'right;
		
		variable x1_mod : fixed(MSB downto LSB);
		variable x2_mod : fixed(MSB downto LSB);
		
	--arg_L e arg_R não levam em consideração o bit de sinal
		variable arg_L: bit_vector(x1'length-2 downto 0);
		variable arg_R: bit_vector(x2'length-2 downto 0);
	
		constant m: integer := arg_L'length;
		constant n: integer := arg_R'length;
	
		variable p, p1: bit_vector(m+n-1 downto 0);
		variable y: fixed (MSB downto LSB);
		
	BEGIN
		if x1(MSB) = '1' then x1_mod := comp2_fixed(x1);
		else x1_mod := x1;
		end if;
		
		if x2(MSB) = '1' then x2_mod := comp2_fixed(x2);
		else x2_mod := x2;
		end if;
		
		fixed_to_vector: for i in 0 to m-1 loop
			arg_L(i) := x1_mod(LSB + i);
			arg_R(i) := x2_mod(LSB + i);
		end loop fixed_to_vector;
		
		p := mult_bit(arg_L,arg_R);
		
		vector_to_fixed: for i in 0 to m-1 loop
			y(i+LSB) := p(i-LSB);
		end loop vector_to_fixed;
		y(MSB) := '0';
		
		if ((x1(MSB) = '1') and (x2(MSB) = '1')) or ((x1(MSB) = '0') and (x2(MSB) = '0')) then
			y := y;
		else y := comp2_fixed(y);
		end if;
		
		return y;
	
	END mult_fixed;

 --to_fixed
    function to_fixed (arg_L: integer; max_range: fixed_range:= MAX_IND; min_range: fixed_range := 0) return fixed is
        variable d : integer range 0 to 2**max_range-1 := abs(arg_L);
        variable s : fixed(max_range downto 0);
        variable valor_bit : integer range 0 to 1;
    begin
        for i in min_range to max_range-1 loop
            valor_bit := d rem 2;
            d := d/2;
            if valor_bit = 0 then s(i) := '0';
            else s(i) := '1';
            end if;
        end loop;
        s(max_range) := '0';
        if arg_L < 0 then return comp2_fixed(s);
        else return s;
        end if;
    end to_fixed;

	
--to_integer
function to_integer (arg_L: fixed) return integer is
	variable int : integer range -2**15 to 2**15-1;
	variable temp   : fixed(arg_L'left downto arg_L'right);
	begin
	int := 0;
	if arg_L(arg_L'left) ='1' then temp := COMP2_FIXED(arg_L);
	else temp:= arg_L;
	end if;
	abc: for i in arg_L'left-1 downto 0 loop
		if temp(i) ='1' then
			int := int + (2**i);
		else int := int;
		end if;
	end loop abc;
	if arg_L(arg_L'left) ='1' then int := -int;
	else int := int;
	end if;
	return int;
end to_integer;

--"+"
function "+"(arg_L, arg_R: fixed) return fixed is
	VARIABLE s: fixed(arg_L'LEFT DOWNTO arg_L'RIGHT);
	VARIABLE s1 : fixed(arg_R'LEFT DOWNTO arg_R'RIGHT);
	begin
		 if (arg_L'left = arg_R'left) then
		 return ADD_SUB_FIXED(arg_L, arg_R, '0');
		 elsif arg_L'left > arg_R'left then
			if arg_R(arg_R'left) = '1' then
				s := (arg_L'LEFT downto arg_R'LEFT =>'0', others => '0');
				s1:= comp2_fixed(arg_R);
				abc: for i in arg_R'LEFT downto arg_L'RIGHT loop
							s(i) := s1(i);
				end loop abc;
				s := comp2_fixed(s);
			else 
			s  := (arg_L'LEFT downto arg_R'LEFT =>'0', others => '0');
			s1 := arg_R;
			ppp: for i in arg_R'LEFT downto arg_L'RIGHT loop
							s(i) := arg_R(i);
			end loop ppp;
			end if;
			return ADD_SUB_FIXED(arg_L, s, '0');
		
		else 
			if arg_L(arg_L'left) = '1' then
				s1 := (arg_R'LEFT downto arg_L'LEFT =>'1', others => '0');
				s:= comp2_fixed(arg_L);
				def: for i in arg_L'LEFT downto arg_R'RIGHT loop
							s1(i) := s(i);
				end loop def;
				s1 := comp2_fixed(s1);
			else 
				s1 := (arg_R'LEFT downto arg_L'LEFT =>'0', others => '0');
				ghi: for i in arg_L'LEFT downto arg_R'RIGHT loop
							s1(i) := arg_L(i);
				end loop ghi;
			end if;
			return ADD_SUB_FIXED(arg_R, s1, '0');
		end if;
END "+";

--"-"
function "-"(arg_L, arg_R: fixed) return fixed IS
	variable comp : fixed(arg_R'left downto arg_R'right);
	begin
		comp := COMP2_FIXED(arg_R);
		return ARG_L + comp;
END "-";

function "+"(arg_L: fixed; arg_R: integer) return fixed is
	variable saida, fix : fixed(arg_L'left downto arg_L'right);
	variable int : fixed(arg_L'left downto 0);
	begin
		int  := to_fixed(arg_R, arg_L'left,0);
		if arg_L'right<0 then
			abc: for i in arg_L'left downto 0 loop
					fix(i) := int(i);
			end loop abc;
			def: for i in -1 downto arg_L'right loop
					fix(i) := '0';
			end loop def;
		else 
			fix := int;
		end if;
		
		saida := arg_L + fix;
		return saida;
end "+";
	
function "+"(arg_L: integer; arg_R: fixed) return fixed is
	variable saida, fix : fixed(arg_R'left downto arg_R'right);
	variable int              : fixed(arg_R'left downto 0);
	begin
		int  := to_fixed(arg_L, arg_R'left,0);
		if arg_R'right<0 then
			abc: for i in arg_R'left downto 0 loop
					fix(i) := int(i);
			end loop abc;
			def: for i in -1 downto arg_R'right loop
					fix(i) := '0';
			end loop def;
		else 
			fix := int;
		end if;
		
		saida := arg_R + fix;
		return saida;
end "+";	

function "-"(arg_L: fixed; arg_R: integer) return fixed is
	variable saida : fixed(arg_L'left downto arg_L'right);
	variable int: integer range -2**15 to 2**15-1;
	begin
		int := -arg_R;
		saida := int + arg_L;
		return saida;
end "-";
	
function "-"(arg_L: integer; arg_R: fixed) return fixed is
	variable saida, fix : fixed(arg_R'left downto arg_R'right);
	begin
		fix := comp2_FIXED(arg_R);
		saida := fix + arg_L;
		return saida;
end "-";


function "*"(arg_L, arg_R: fixed) return fixed is
	VARIABLE s: fixed(arg_L'LEFT DOWNTO arg_L'RIGHT);
	VARIABLE s1 : fixed(arg_R'LEFT DOWNTO arg_R'RIGHT);
	begin
		 if (arg_L'left = arg_R'left) then
		 return mult_fixed(arg_L, arg_R);
		 elsif arg_L'left > arg_R'left then
			if arg_R(arg_R'left) = '1' then
				s := (arg_L'LEFT downto arg_R'LEFT =>'0', others => '0');
				s1:= comp2_fixed(arg_R);
				abc: for i in arg_R'LEFT downto arg_L'RIGHT loop
							s(i) := s1(i);
				end loop abc;
				s := comp2_fixed(s);
			else 
			s  := (arg_L'LEFT downto arg_R'LEFT =>'0', others => '0');
			s1 := arg_R;
			ppp: for i in arg_R'LEFT downto arg_L'RIGHT loop
							s(i) := arg_R(i);
			end loop ppp;
			end if;
			return mult_fixed(arg_L, s);
		
		else 
			if arg_L(arg_L'left) = '1' then
				s1 := (arg_R'LEFT downto arg_L'LEFT =>'1', others => '0');
				s:= comp2_fixed(arg_L);
				ghi: for i in arg_L'LEFT downto arg_R'RIGHT loop
							s1(i) := s(i);
				end loop ghi;
				s1 := comp2_fixed(s1);
			else 
				s1 := (arg_R'LEFT downto arg_L'LEFT =>'0', others => '0');
				def: for i in arg_L'LEFT downto arg_R'RIGHT loop
							s1(i) := arg_L(i);
				end loop def;
			end if;
			return mult_fixed(arg_R, s1);
		end if;
END "*";

function "*"(arg_L: fixed; arg_R: integer) return fixed is
	variable saida, fix : fixed(arg_L'left downto arg_L'right);
	variable int : fixed(arg_L'left downto 0);
	begin
		int  := to_fixed(arg_R, arg_L'left,0);
		if arg_L'right<0 then
			abc: for i in arg_L'left downto 0 loop
					fix(i) := int(i);
			end loop abc;
			def: for i in -1 downto arg_L'right loop
					fix(i) := '0';
			end loop def;
		else 
			fix := int;
		end if;
		
		saida := arg_L * fix;
		return saida;
end "*";

function "*"(arg_L: integer; arg_R: fixed) return fixed is
	variable saida, fix : fixed(arg_R'left downto arg_R'right);
	variable int              : fixed(arg_R'left downto 0);
	begin
		int  := to_fixed(arg_L, arg_R'left,0);
		if arg_R'right<0 then
			abc: for i in arg_R'left downto 0 loop
					fix(i) := int(i);
			end loop abc;
			def: for i in -1 downto arg_R'right loop
					fix(i) := '0';
			end loop def;
		else 
			fix := int;
		end if;
		
		saida := arg_R * fix;
		return saida;
end "*";	

function to_fixed (arg_L: real; max_range: fixed_range:= MAX_IND; min_range: fixed_range:= MIN_IND) return fixed is
	variable d : real range -2.0**(max_range) to 2.0**(max_range);
	variable a : real range -2.0**(max_range) to 2.0**(max_range);
   variable s : fixed(max_range downto min_range);
   begin
		d := abs(arg_L);
		for i in max_range-1 DOWNTO min_range loop
			a := 2.0**(i);
			if d >= a then 
				s(i) := '1';
				d := d-2.0**i;
			else s(i) := '0';
			end if;
      end loop;		
      s(max_range) := '0';
      if arg_L < 0.0 then return comp2_fixed(s);
      else return s;
      end if;
end to_fixed;

function to_real (arg_L: fixed) return real is
	variable int : real range -2.0**(arg_L'left) to 2.0**(arg_L'left);
	variable temp   : fixed(arg_L'left downto arg_L'right);
	begin
	int := 0.0;
	if arg_L(arg_L'left) ='1' then temp := COMP2_FIXED(arg_L);
	else temp:= arg_L;
	end if;
	abc: for i in arg_L'left-1 downto arg_L'right loop
		if temp(i) ='1' then
			int := int + (2.0**i);
		else int := int;
		end if;
	end loop abc;
	if arg_L(arg_L'left) ='1' then int := -int;
	else int := int;
	end if;
	return int;
end to_real;

function "+"(arg_L: fixed; arg_R: real) return fixed is
variable saida, int : fixed(arg_L'left downto arg_L'right);
	begin
		int   := to_fixed(arg_R, arg_L'left,arg_L'right);
		saida := arg_L + int;
		return saida;
end "+";

function "+"(arg_L: real; arg_R: fixed) return fixed is
variable saida, int : fixed(arg_R'left downto arg_R'right);
	begin
		int   := to_fixed(arg_L, arg_R'left,arg_R'right);
		saida := arg_R + int;
		return saida;
end "+";

function "-"(arg_L: fixed; arg_R: real) return fixed is
	variable saida, int : fixed(arg_L'left downto arg_L'right);
	begin
		int   := to_fixed(arg_R, arg_L'left,arg_L'right);
		saida := arg_L - int;
		return saida;
end "-";

function "-"(arg_L: real; arg_R: fixed) return fixed is
	variable saida, int : fixed(arg_R'left downto arg_R'right);
	begin
		int   := to_fixed(arg_L, arg_R'left,arg_R'right);
		saida := int - arg_R;
		return saida;
end "-";

function "*"(arg_L: fixed; arg_R: real) return fixed is
	variable saida, int : fixed(arg_L'left downto arg_L'right);
	begin
		int   := to_fixed(arg_R, arg_L'left,arg_L'right);
		saida := int*arg_L;
		return saida;
end "*";

function "*"(arg_L: real; arg_R: fixed) return fixed is
	variable saida, int : fixed(arg_R'left downto arg_R'right);
	begin
		int   := to_fixed(arg_L, arg_R'left,arg_R'right);
		saida := int*arg_R;
		return saida;
end "*";
END fixed_package;