library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity mux2 is
   port(PCwrite: in std_logic;
	RFdata,PCdata: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0)
);
end entity;
architecture Struct of mux2 is 
begin	
	process(PCwrite,RFdata,PCdata)
	begin
		case PCwrite is
			when '0' => y <= PCdata;
			when '1' => y <= RFdata;
			when others => y <= "0000000000000000";
		end case;
	end process;
end Struct;

