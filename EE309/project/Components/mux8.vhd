library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity mux8 is
   port(selectinput: in std_logic_vector(2 downto 0);
	data0,data1,data2,data3,data4,data5,data6,data7: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0)
);
end entity;
architecture Struct of mux8 is 
begin	
	process(selectinput,data0,data1,data2,data3,data4,data5,data6,data7)
	begin
		case selectinput is
			when "000" => y <= data0;
			when "001" => y <= data1;
			when "010" => y <= data2;
			when "011" => y <= data3;
			when "100" => y <= data4;
			when "101" => y <= data5;
			when "110" => y <= data6;
			when "111" =>  y <= data7;
			when others => y <= "0000000000000000";
		end case;
	end process;
end Struct;

