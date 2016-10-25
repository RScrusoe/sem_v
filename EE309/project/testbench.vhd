library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.components.all;

entity testbench is
end entity;
architecture Behave of testbench is

component TopLevel is
   port(clk,reset: in std_logic);
end component;

  signal clk: std_logic := '0';
  signal reset: std_logic := '1';

 begin
  clk <= not clk after 5 ns; -- assume 10ns clock.

  -- reset process
  process
  begin

     reset <= '0' after 28 ns;
     wait;
  end process;

  dut: toplevel  
     port map(clk => clk,reset => reset);
end Behave;

