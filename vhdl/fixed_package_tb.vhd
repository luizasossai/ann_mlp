--library std;
use std.textio.all;
--library work;
use work.fixed_package.all;

entity fixed_package_tb is
end entity fixed_package_tb;

architecture testbench of fixed_package_tb is
	-- Auxiliary functions for testbench
	function fixed2str(arg_L: fixed) return string is
		variable fixed_str: string (arg_L'length downto 1) := (others => '0');
	begin
		for i in arg_L'length downto 1 loop
			if arg_L(i-1+arg_L'right) = '0' then
				fixed_str(i) := '0';
			else
				fixed_str(i) := '1';
			end if;
		end loop;
		return fixed_str;
	end function;
	
	function "="(arg_L, arg_R: fixed) return boolean is
	begin
		if (arg_L'length /= arg_R'length) then
			report "Different size comparison" severity error;
			return false;
		end if;
		
		for i in arg_L'range loop
			if arg_L(i) /= arg_R(i) then
				return false;
			end if;
		end loop;
		return true;
	end function;
	
begin
	tester: process
		variable read_line_OK : boolean := true;
		variable char: character;
		variable int1, int2: integer;
		variable real1, real2: real;
		variable Q15_0a, Q15_0b, Q15_0r, Q15_0e: fixed(15 downto 0);
		variable Q10_5a, Q10_5b, Q10_5r, Q10_5e: fixed(10 downto -5);
		variable Q5_10a, Q5_10b, Q5_10r, Q5_10e: fixed(5 downto -10);
		variable Q0_15a, Q0_15b, Q0_15r, Q0_15e: fixed(0 downto -15);
	begin
		int1 := 10; int2 := 0;
			report "Testing MAXIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MAXIMO(int1, int2) = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
		int1 := 10; int2 := -10;
			report "Testing MAXIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MAXIMO(int1, int2) = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
		int1 := -10; int2 := 10;
			report "Testing MAXIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MAXIMO(int1, int2) = int2 report LF & HT & "Expected "& integer'image(int2) & " and obtained " & integer'image(int1)
				severity error;
		int1 := 0; int2 := 10;
			report "Testing MAXIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MAXIMO(int1, int2) = int2 report LF & HT & "Expected "& integer'image(int2) & " and obtained " & integer'image(int1)
				severity error;
				
		--function MINIMUM (arg_L, arg_R: integer) return integer;
		int1 := 10; int2 := 0;
			report "Testing MINIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MINIMO(int1, int2) = int2 report LF & HT & "Expected "& integer'image(int2) & " and obtained " & integer'image(int1)
				severity error;
		int1 := 10; int2 := -10;
			report "Testing MINIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MINIMO(int1, int2) = int2 report LF & HT & "Expected "& integer'image(int2) & " and obtained " & integer'image(int1)
				severity error;
		int1 := -10; int2 := 10;
			report "Testing MINIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MINIMO(int1, int2) = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
		int1 := 0; int2 := 10;
			report "Testing MINIMUM(" & integer'image(int1) & "," & integer'image(int2) & ")"
				severity note;
			assert MINIMO(int1, int2) = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
				
		--function COMP1_FIXED (arg_L: fixed) return fixed is 
		Q15_0a := "0000000000001101"; Q15_0e := "1111111111110010";
			report "Testing COMP1_FIXED(""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := COMP1_FIXED(Q15_0a);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "1111111111110010"; Q15_0e := "0000000000001101";
			report "Testing COMP1_FIXED(""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := COMP1_FIXED(Q15_0a);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
				
		--function ADD_SUB_FIXED (arg_L, arg_R: fixed; c: bit := '0') return fixed;
		Q15_0a := "0000000000000000"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000001101";
			report "Testing ADD_SUB_FIXED(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """, 0)"
				severity note;
			Q15_0r := ADD_SUB_FIXED(Q15_0a, Q15_0b, '0');
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000011010";
			report "Testing ADD_SUB_FIXED(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """, 0)"
				severity note;
			Q15_0r := ADD_SUB_FIXED(Q15_0a, Q15_0b, '0');
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q15_0b := "1111111111110011"; Q15_0e := "0000000000000000";
			report "Testing ADD_SUB_FIXED(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """, 0)"
				severity note;
			Q15_0r := ADD_SUB_FIXED(Q15_0a, Q15_0b, '0');
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000000000";
			report "Testing ADD_SUB_FIXED(""" & fixed2str(Q15_0a) & """, COMP1_FIXED(""" & fixed2str(Q15_0b) & """), 1)"
				severity note;
			Q15_0r := ADD_SUB_FIXED(Q15_0a, COMP1_FIXED(Q15_0b), '1');
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q15_0b := "1111111111110011"; Q15_0e := "0000000000011010";
			report "Testing ADD_SUB_FIXED(""" & fixed2str(Q15_0a) & """, COMP1_FIXED(""" & fixed2str(Q15_0b) & """), 1)"
				severity note;
			Q15_0r := ADD_SUB_FIXED(Q15_0a, COMP1_FIXED(Q15_0b), '1');
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "1111111111110011"; Q15_0b := "0000000000001101"; Q15_0e := "1111111111100110";
			report "Testing ADD_SUB_FIXED(""" & fixed2str(Q15_0a) & """, COMP1_FIXED(""" & fixed2str(Q15_0b) & """), 1)"
				severity note;
			Q15_0r := ADD_SUB_FIXED(Q15_0a, COMP1_FIXED(Q15_0b), '1');
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
				
		--function MULT_FIXED (arg_L, arg_R: fixed) return fixed;
		Q15_0a := "0000000000000000"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000000000";
			report "Testing MULT_FIXED(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := MULT_FIXED(Q15_0a, Q15_0b);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q15_0b := "0000000000001101"; Q15_0e := "0000000010101001";
			report "Testing MULT_FIXED(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := MULT_FIXED(Q15_0a, Q15_0b);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q15_0b := "1111111111110011"; Q15_0e := "1111111101010111";
			report "Testing MULT_FIXED(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := MULT_FIXED(Q15_0a, Q15_0b);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000110100001"; Q10_5b := "0000000110100000"; Q10_5e := "0001010100101101";
			report "Testing MULT_FIXED(""" & fixed2str(Q10_5a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q10_5r := MULT_FIXED(Q10_5a, Q10_5b);
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000110100000"; Q10_5b := "0000000110100000"; Q10_5e := "0001010100100000";
			report "Testing MULT_FIXED(""" & fixed2str(Q10_5a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q10_5r := MULT_FIXED(Q10_5a, Q10_5b);
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000110100000"; Q10_5b := "1111111001100000"; Q10_5e := "1110101011100000";
			report "Testing MULT_FIXED(""" & fixed2str(Q10_5a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q10_5r := MULT_FIXED(Q10_5a, Q10_5b);
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;

		--to_fixed
		--function to_fixed (arg_L: integer; max_range: fixed_range := MAX_IND; min_range: fixed_range := 0) return fixed;
		int1 := 3341; Q15_0e := "0000110100001101";
			report "Testing TO_FIXED(" & integer'image(int1) & ")"
				severity note;
			Q15_0r := to_fixed(int1);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		int1 := -3341; Q15_0e := "1111001011110011";
			report "Testing TO_FIXED(" & integer'image(int1) & ")"
				severity note;
			Q15_0r := to_fixed(int1);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		int1 := 104; Q10_5e := "0000110100000000";
			report "Testing TO_FIXED(" & integer'image(int1) & ", 10, -5)"
				severity note;
			Q10_5r := to_fixed(int1, 10, -5);
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		int1 := -105; Q10_5e := "1111001011100000";
			report "Testing TO_FIXED(" & integer'image(int1) & ", 10, -5)"
				severity note;
			Q10_5r := to_fixed(int1, 10, -5);
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		 int1 := 1; Q5_10e := "0000010000000000";
			report "Testing TO_FIXED(" & integer'image(int1) & ", 5, -10)"
				severity note;
			Q5_10r := to_fixed(int1, 5, -10);
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function to_fixed (arg_L: real; max_range, min_range: fixed_range) return fixed;
		real1 := 3341.4; Q15_0e := "0000110100001101";
			report "Testing TO_FIXED(" & real'image(real1) & ", 15, 0)"
				severity note;
			Q15_0r := to_fixed(real1, 15, 0);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		real1 := -3341.9; Q15_0e := "1111001011110011";
			report "Testing TO_FIXED(" & real'image(real1) & ", 15, 0)"
				severity note;
			Q15_0r := to_fixed(real1, 15, 0);
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		real1 := 104.8125; Q10_5e := "0000110100011010";
			report "Testing TO_FIXED(" & real'image(real1) & ", 10, -5)"
				severity note;
			Q10_5r := to_fixed(real1, 10, -5);
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		real1 := -104.1875; Q10_5e := "1111001011111010";
			report "Testing TO_FIXED(" & real'image(real1) & ", 10, -5)"
				severity note;
			Q10_5r := to_fixed(real1, 10, -5);
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		 real1 := 0.94921875; Q0_15e := "0111100110000000";
			report "Testing TO_FIXED(" & real'image(real1) & ", 0, -15)"
				severity note;
			Q0_15r := to_fixed(real1, 0, -15);
			assert Q0_15r = Q0_15e report LF & HT & "Expected """& fixed2str(Q0_15e) & """ and obtained """ & fixed2str(Q0_15r) & """"
				severity error;
		 real1 := -0.94921875; Q0_15e := "1000011010000000";
			report "Testing TO_FIXED(" & real'image(real1) & ", 0, -15)"
				severity note;
			Q0_15r := to_fixed(real1, 0, -15);
			assert Q0_15r = Q0_15e report LF & HT & "Expected """& fixed2str(Q0_15e) & """ and obtained """ & fixed2str(Q0_15r) & """"
				severity error;
				
		--to_integer
		--function to_integer (arg_L: fixed) return integer;
		Q15_0a := "0000110100001101"; int1 := 3341;
			report "Testing TO_INTEGER(""" & fixed2str(Q15_0a) & """)"
				severity note;
			int2 := to_integer(Q15_0a);
			assert int2 = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
		Q15_0a := "1111001011110011"; int1 := -3341;
			report "Testing TO_INTEGER(""" & fixed2str(Q15_0a) & """)"
				severity note;
			int2 := to_integer(Q15_0a);
			assert int2 = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
		Q10_5a := "0000110100001101"; int1 := 104;
			report "Testing TO_INTEGER(""" & fixed2str(Q10_5a) & """)"
				severity note;
			int2 := to_integer(Q10_5a);
			assert int2 = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
		Q10_5a := "1111001011110011"; int1 := -104;
			report "Testing TO_INTEGER(""" & fixed2str(Q10_5a) & """)"
				severity note;
			int2 := to_integer(Q10_5a);
			assert int2 = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
		Q5_10a := "0000110100001101"; int1 := 3;
			report "Testing TO_INTEGER(""" & fixed2str(Q5_10a) & """)"
				severity note;
			int2 := to_integer(Q5_10a);
			assert int2 = int1 report LF & HT & "Expected "& integer'image(int1) & " and obtained " & integer'image(int2)
				severity error;
				
		--to_real
		--function to_real (arg_L: fixed) return real;
		Q10_5a := "0000110100001101"; real1 := 104.40625;
			report "Testing TO_REAL(""" & fixed2str(Q10_5a) & """)"
				severity note;
			real2 := to_real(Q10_5a);
			assert real2 = real1 report LF & HT & "Expected "& real'image(real1) & " and obtained " & real'image(real2)
				severity error;
		Q10_5a := "1111001011110011"; real1 := -104.40625;
			report "Testing TO_REAL(""" & fixed2str(Q10_5a) & """)"
				severity note;
			real2 := to_real(Q10_5a);
			assert real2 = real1 report LF & HT & "Expected "& real'image(real1) & " and obtained " & real'image(real2)
				severity error;
		Q5_10a := "0000110100001101"; real1 := 3.2626953125;
			report "Testing TO_REAL(""" & fixed2str(Q5_10a) & """)"
				severity note;
			real2 := to_real(Q5_10a);
			assert real2 = real1 report LF & HT & "Expected "& real'image(real1) & " and obtained " & real'image(real2)
				severity error;
		Q5_10a := "1111001011110011"; real1 := -3.2626953125;
			report "Testing TO_REAL(""" & fixed2str(Q5_10a) & """)"
				severity note;
			real2 := to_real(Q5_10a);
			assert real2 = real1 report LF & HT & "Expected "& real'image(real1) & " and obtained " & real'image(real2)
				severity error;
		Q0_15a := "0000110100001101"; real1 := 0.101959228515625;
			report "Testing TO_REAL(""" & fixed2str(Q0_15a) & """)"
				severity note;
			real2 := to_real(Q0_15a);
			assert real2 = real1 report LF & HT & "Expected "& real'image(real1) & " and obtained " & real'image(real2)
				severity error;	
		Q0_15a := "1111001011110011"; real1 := -0.101959228515625;
			report "Testing TO_REAL(""" & fixed2str(Q0_15a) & """)"
				severity note;
			real2 := to_real(Q0_15a);
			assert real2 = real1 report LF & HT & "Expected "& real'image(real1) & " and obtained " & real'image(real2)
				severity error;
				
		--Aritmeticas
		--"+"
		--function "+"(arg_L, arg_R: fixed) return fixed;
		Q15_0a := "0000000000000000"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000001101";
			report "Testing +(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := Q15_0a + Q15_0b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000011010";
			report "Testing +(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := Q15_0a + Q15_0b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q10_5b := "0000000000111101"; Q15_0e := "0000000000001110";
			report "Testing +(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q15_0r := Q15_0a + Q10_5b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; Q10_5b := "1111111111110011"; Q10_5e := "0000000000000000";
			report "Testing +(""" & fixed2str(Q10_5a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q10_5r := Q10_5a + Q10_5b;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000000000001101"; Q5_10b := "0100000000100000"; Q5_10e := "0100000000101101";
			report "Testing +(""" & fixed2str(Q5_10a) & """, """ & fixed2str(Q5_10b) & """)"
				severity note;
			Q5_10r := Q5_10a + Q5_10b;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "+"(arg_L: fixed; arg_R: integer) return fixed;
		Q15_0a := "0000000000000000"; int1 := 13; Q15_0e := "0000000000001101";
			report "Testing +(""" & fixed2str(Q15_0a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q15_0r := Q15_0a + int1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; int1 := 13; Q15_0e := "0000000000011010";
			report "Testing +(""" & fixed2str(Q15_0a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q15_0r := Q15_0a + int1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; int1 := 1; Q10_5e := "0000000000101101";
			report "Testing +(""" & fixed2str(Q10_5a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q10_5r := Q10_5a + int1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000001101101"; int1 := -2; Q10_5e := "0000000000101101";
			report "Testing +(""" & fixed2str(Q10_5a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q10_5r := Q10_5a + int1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "1111110000000000"; int1 := 1; Q5_10e := "0000000000000000";
			report "Testing +(""" & fixed2str(Q5_10a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q5_10r := Q5_10a + int1;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "+"(arg_L: integer; arg_R: fixed) return fixed;
		Q15_0a := "0000000000000000"; int1 := 13; Q15_0e := "0000000000001101";
			report "Testing +(""" & integer'image(int1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := int1 + Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; int1 := 13; Q15_0e := "0000000000011010";
			report "Testing +(""" & integer'image(int1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := int1 + Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; int1 := 1; Q10_5e := "0000000000101101";
			report "Testing +(""" & integer'image(int1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := int1 + Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000001101101"; int1 := -2; Q10_5e := "0000000000101101";
			report "Testing +(""" & integer'image(int1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := int1 + Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "1111110000000000"; int1 := 1; Q5_10e := "0000000000000000";
			report "Testing +(""" & integer'image(int1) & """,""" & fixed2str(Q5_10a) & """)"
				severity note;
			Q5_10r := int1 + Q5_10a;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "+"(arg_L: fixed; arg_R: real) return fixed;
		Q15_0a := "0000000000000000"; real1 := 13.0; Q15_0e := "0000000000001101";
			report "Testing +(""" & fixed2str(Q15_0a) & """,""" & real'image(real1) & """)"
				severity note;
			Q15_0r := Q15_0a + real1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := 0.40625; Q10_5e := "0000000000011010";
			report "Testing +(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a + real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := -0.40625; Q10_5e := "0000000000000000";
			report "Testing +(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a + real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "1111111111110000"; real1 := 0.5; Q10_5e := "0000000000000000";
			report "Testing +(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a + real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000000000001101"; real1 := 16.03125; Q5_10e := "0100000000101101";
			report "Testing +(""" & fixed2str(Q5_10a) & """, """ & real'image(real1) & """)"
				severity note;
			Q5_10r := Q5_10a + real1;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10r) & """ and obtained """ & fixed2str(Q5_10e) & """"
				severity error;
				
		--function "+"(arg_L: real; arg_R: fixed) return fixed;
		Q15_0a := "0000000000000000"; real1 := 13.0; Q15_0e := "0000000000001101";
			report "Testing +(""" & real'image(real1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := real1 + Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := 0.40625; Q10_5e := "0000000000011010";
			report "Testing +(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 + Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := -0.40625; Q10_5e := "0000000000000000";
			report "Testing +(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 + Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "1111111111110000"; real1 := 0.5; Q10_5e := "0000000000000000";
			report "Testing +(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 + Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000000000001101"; real1 := 16.03125; Q5_10e := "0100000000101101";
			report "Testing +(""" & real'image(real1) & """,""" & fixed2str(Q5_10a) & """)"
				severity note;
			Q5_10r := real1 + Q5_10a;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--"-"
		--function "-"(arg_L, arg_R: fixed) return fixed;
		Q15_0a := "0000000000001101"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000000000";
			report "Testing -(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := Q15_0a - Q15_0b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000000000"; Q15_0b := "0000000000001101"; Q15_0e := "1111111111110011";
			report "Testing -(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := Q15_0a - Q15_0b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q10_5b := "0000000110100000"; Q15_0e := "0000000000000000";
			report "Testing -(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q15_0r := Q15_0a - Q10_5b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; Q10_5b := "1111111111110011"; Q10_5e := "0000000000011010";
			report "Testing -(""" & fixed2str(Q10_5a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q10_5r := Q10_5a - Q10_5b;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000000100001000"; Q5_10b := "0000000100000000"; Q5_10e := "0000000000001000";
			report "Testing -(""" & fixed2str(Q5_10a) & """, """ & fixed2str(Q5_10b) & """)"
				severity note;
			Q5_10r := Q5_10a - Q5_10b;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "-"(arg_L: fixed; arg_R: integer) return fixed;
		Q15_0a := "0000000000000000"; int1 := 13; Q15_0e := "1111111111110011";
			report "Testing -(""" & fixed2str(Q15_0a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q15_0r := Q15_0a - int1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; int1 := 13; Q15_0e := "0000000000000000";
			report "Testing -(""" & fixed2str(Q15_0a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q15_0r := Q15_0a - int1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000101101"; int1 := 1; Q10_5e := "0000000000001101";
			report "Testing -(""" & fixed2str(Q10_5a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q10_5r := Q10_5a - int1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; int1 := -2; Q10_5e := "0000000001001101";
			report "Testing -(""" & fixed2str(Q10_5a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q10_5r := Q10_5a - int1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "1111110000000000"; int1 := 1; Q5_10e := "1111100000000000";
			report "Testing -(""" & fixed2str(Q5_10a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q5_10r := Q5_10a - int1;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "-"(arg_L: integer; arg_R: fixed) return fixed;
		Q15_0a := "0000000000001101"; int1 := 0; Q15_0e := "1111111111110011";
			report "Testing -(""" & integer'image(int1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := int1 - Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; int1 := 13; Q15_0e := "0000000000000000";
			report "Testing -(""" & integer'image(int1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := int1 - Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000101101"; int1 := 1; Q10_5e := "1111111111110011";
			report "Testing -(""" & integer'image(int1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := int1 - Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; int1 := -2; Q10_5e := "1111111110110011";
			report "Testing -(""" & integer'image(int1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := int1 - Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "1111110000000000"; int1 := 1; Q5_10e := "0000100000000000";
			report "Testing -(""" & integer'image(int1) & """,""" & fixed2str(Q5_10a) & """)"
				severity note;
			Q5_10r := int1 - Q5_10a;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "-"(arg_L: fixed; arg_R: real) return fixed;
		Q15_0a := "0000000000000000"; real1 := 13.0; Q15_0e := "1111111111110011";
			report "Testing -(""" & fixed2str(Q15_0a) & """,""" & real'image(real1) & """)"
				severity note;
			Q15_0r := Q15_0a - real1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := 0.40625; Q10_5e := "0000000000000000";
			report "Testing -(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a - real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := -0.40625; Q10_5e := "0000000000011010";
			report "Testing -(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a - real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "1111111111110000"; real1 := 0.5; Q10_5e := "1111111111100000";
			report "Testing -(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a - real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000011000000000"; real1 := 1.5; Q5_10e := "0000000000000000";
			report "Testing -(""" & fixed2str(Q5_10a) & """, """ & real'image(real1) & """)"
				severity note;
			Q5_10r := Q5_10a - real1;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "-"(arg_L: real; arg_R: fixed) return fixed;
		Q15_0a := "0000000000001101"; real1 := 13.0; Q15_0e := "0000000000000000";
			report "Testing -(""" & real'image(real1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := real1 - Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := 0.0; Q10_5e := "1111111111110011";
			report "Testing -(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 - Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; real1 := -0.40625; Q10_5e := "1111111111100110";
			report "Testing -(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 - Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "1111111111110000"; real1 := 0.5; Q10_5e := "0000000000100000";
			report "Testing -(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 - Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000011000000000"; real1 := 1.5; Q5_10e := "0000000000000000";
			report "Testing -(""" & real'image(real1) & """,""" & fixed2str(Q5_10a) & """)"
				severity note;
			Q5_10r := real1 - Q5_10a;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--"*"
		--function "*"(arg_L, arg_R: fixed) return fixed;
		Q15_0a := "0000000000000000"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000000000";
			report "Testing *(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := Q15_0a * Q15_0b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000000001"; Q15_0b := "0000000000001101"; Q15_0e := "0000000000001101";
			report "Testing *(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q15_0b) & """)"
				severity note;
			Q15_0r := Q15_0a * Q15_0b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; Q10_5b := "0000000000100000"; Q15_0e := "0000000000001101";
			report "Testing *(""" & fixed2str(Q15_0a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q15_0r := Q15_0a * Q10_5b;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000100000"; Q10_5b := "1111111111110011"; Q10_5e := "1111111111110011";
			report "Testing *(""" & fixed2str(Q10_5a) & """,""" & fixed2str(Q10_5b) & """)"
				severity note;
			Q10_5r := Q10_5a * Q10_5b;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0100000000000000"; Q5_10b := "0000000100000000"; Q5_10e := "0001000000000000";
			report "Testing *(""" & fixed2str(Q5_10a) & """, """ & fixed2str(Q5_10b) & """)"
				severity note;
			Q5_10r := Q5_10a * Q5_10b;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "*"(arg_L: fixed; arg_R: integer) return fixed;
		Q15_0a := "0000000000000000"; int1 := 13; Q15_0e := "0000000000000000";
			report "Testing *(""" & fixed2str(Q15_0a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q15_0r := Q15_0a * int1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; int1 := 13; Q15_0e := "0000000010101001";
			report "Testing *(""" & fixed2str(Q15_0a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q15_0r := Q15_0a * int1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000101101"; int1 := 1; Q10_5e := "0000000000101101";
			report "Testing *(""" & fixed2str(Q10_5a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q10_5r := Q10_5a * int1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; int1 := -1; Q10_5e := "1111111111110011";
			report "Testing *(""" & fixed2str(Q10_5a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q10_5r := Q10_5a * int1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "1111110000000000"; int1 := -1; Q5_10e := "0000010000000000";
			report "Testing *(""" & fixed2str(Q5_10a) & """,""" & integer'image(int1) & """)"
				severity note;
			Q5_10r := Q5_10a * int1;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "*"(arg_L: integer; arg_R: fixed) return fixed;
		Q15_0a := "0000000000000000"; int1 := 13; Q15_0e := "0000000000000000";
			report "Testing *(""" & integer'image(int1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := int1 * Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q15_0a := "0000000000001101"; int1 := 13; Q15_0e := "0000000010101001";
			report "Testing *(""" & integer'image(int1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := int1 * Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000000101101"; int1 := 1; Q10_5e := "0000000000101101";
			report "Testing *("""& integer'image(int1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := int1 * Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000000001101"; int1 := -1; Q10_5e := "1111111111110011";
			report "Testing *(""" & integer'image(int1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := int1 * Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "1111110000000000"; int1 := -1; Q5_10e := "0000010000000000";
			report "Testing *(""" & integer'image(int1) & """,""" & fixed2str(Q5_10a) & """)"
				severity note;
			Q5_10r := int1 * Q5_10a;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "*"(arg_L: fixed; arg_R: real) return fixed;
		Q15_0a := "0000000000000000"; real1 := 13.0; Q15_0e := "0000000000000000";
			report "Testing *(""" & fixed2str(Q15_0a) & """,""" & real'image(real1) & """)"
				severity note;
			Q15_0r := Q15_0a * real1;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000001010000"; real1 := 0.5; Q10_5e := "0000000000101000";
			report "Testing *(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a * real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000001010000"; real1 := -0.5; Q10_5e := "1111111111011000";
			report "Testing *(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a * real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "1111111111000000"; real1 := -1.75; Q10_5e := "0000000001110000";
			report "Testing *(""" & fixed2str(Q10_5a) & """,""" & real'image(real1) & """)"
				severity note;
			Q10_5r := Q10_5a * real1;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000011000000000"; real1 := 1.5; Q5_10e := "0000100100000000";
			report "Testing *(""" & fixed2str(Q5_10a) & """, """ & real'image(real1) & """)"
				severity note;
			Q5_10r := Q5_10a * real1;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
				
		--function "*"(arg_L: real; arg_R: fixed) return fixed;
		Q15_0a := "0000000000000000"; real1 := 13.0; Q15_0e := "0000000000000000";
			report "Testing *(""" & real'image(real1) & """,""" & fixed2str(Q15_0a) & """)"
				severity note;
			Q15_0r := real1 * Q15_0a;
			assert Q15_0r = Q15_0e report LF & HT & "Expected """& fixed2str(Q15_0e) & """ and obtained """ & fixed2str(Q15_0r) & """"
				severity error;
		Q10_5a := "0000000001010000"; real1 := 0.5; Q10_5e := "0000000000101000";
			report "Testing *(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) &""")"
				severity note;
			Q10_5r := real1 * Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "0000000001010000"; real1 := -0.5; Q10_5e := "1111111111011000";
			report "Testing *(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 * Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q10_5a := "1111111111000000"; real1 := -1.75; Q10_5e := "0000000001110000";
			report "Testing *(""" & real'image(real1) & """,""" & fixed2str(Q10_5a) & """)"
				severity note;
			Q10_5r := real1 * Q10_5a;
			assert Q10_5r = Q10_5e report LF & HT & "Expected """& fixed2str(Q10_5e) & """ and obtained """ & fixed2str(Q10_5r) & """"
				severity error;
		Q5_10a := "0000011000000000"; real1 := 1.5; Q5_10e := "0000100100000000";
			report "Testing *(""" & real'image(real1) & """,""" & fixed2str(Q5_10a) & """)"
				severity note;
			Q5_10r := real1 * Q5_10a;
			assert Q5_10r = Q5_10e report LF & HT & "Expected """& fixed2str(Q5_10e) & """ and obtained """ & fixed2str(Q5_10r) & """"
				severity error;
		wait;
	end process;
	
end testbench;