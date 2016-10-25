library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity mux4 is
   port(selectinput: in std_logic_vector(1 downto 0);
	data0,data1,data2,data3,data4,data5,data6,data7: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0)
);
end entity;
architecture Struct of mux4 is 
begin	
	process(selectinput,data0,data1,data2,data3)
	begin
		case selectinput is
			when "00" => y <= data0;
			when "01" => y <= data1;
			when "10" => y <= data2;
			when "11" => y <= data3;
			when others => y <= "0000000000000000";
		end case;
	end process;
end Struct;

