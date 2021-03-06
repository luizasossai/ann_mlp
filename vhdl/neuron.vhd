use work.neuron_pkg.all;
use work.fixed_package.all;

entity neuron is
	generic (
		  dendritos : integer := 9;
		  q_left    : integer := 3;
		  q_right   : integer := -12);
	port(
		  X : in fixed_vector(dendritos-1 downto 0);
		  W : in fixed_vector(dendritos-1 downto 0);
		  B : in fixed(q_left downto q_right);
		  Y : out fixed(q_left downto q_right));
end entity;

architecture structural of neuron is
begin
	process(X, W, B)
		variable soma : fixed(q_left downto q_right);
	begin	
		soma := (others => '0');
		abc: for i in dendritos-1 downto 0 loop
			soma := soma + X(i)*W(i); 
		end loop abc;
		soma := soma - B;
		Y <= activation1(soma);
	end process;
end structural;
	
