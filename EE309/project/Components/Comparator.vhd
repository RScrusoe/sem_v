library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity Comparator is
   port(a: in std_logic_vector(14 downto 0);
        b: in std_logic_vector(14 downto 0);
	s: out std_logic_vector(3 downto 0)
);
end entity;
architecture Struct of Comparator is 
begin		
	process (a,b) is
	variable equal,greater,lower: std_logic;
	begin
        	if (a=b) then
        	    equal := '1';
        	    greater := '0';
        	    lower := '0';
        	elsif (a<b) then
        	    equal := '0';
        	    greater := '0';
        	    lower := '1';
        	else
        	    equal := '0';
        	    greater := '1';
        	    lower := '0';
        end if;
	s(0) <= lower;
	s(1) <= equal;
	s(2) <= greater;
    end process;
end Struct;
