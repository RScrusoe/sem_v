library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

library std;
use std.standard.all;

library work;
use work.Veeru_Components.all;

entity Code_Memory is
    port (
        clk: in std_logic;
        Address:   in std_logic_vector(15 downto 0);
        DataRead:  out std_logic_vector(15 downto 0);
        DataWrite: in std_logic_vector(15 downto 0);
        registers : inout Mem;
        Mem_Write : in std_logic);

 end Code_Memory;

architecture arch of Code_Memory is
begin

    process(clk)
    begin
        
                DataRead <= registers(to_integer(unsigned(Address)));
        if falling_edge(clk) then
                if (Mem_Write = '1') then
                    registers(to_integer(unsigned(Address))) <= DataWrite  ;
                end if;
        end if;
    end process;
end arch;
