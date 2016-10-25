library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity mux2_16 is
   port(selectinp: in std_logic;
	D0,D1: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0)
);
end entity;
architecture Struct of mux2_16 is 
begin	
	process(select_inp,D0,D1)
	begin
		case PCwrite is
			when '0' => y <= D0;
			when '1' => y <= D1;
			when others => y <= "0000000000000000";
		end case;
	end process;
end Struct;

