library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

package Veeru_Components is

   component mux8 is
   port(selectinput: in std_logic_vector(2 downto 0);
	data0,data1,data2,data3,data4,data5,data6,data7: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0));
   end component;
   component demux is
   port(x: in std_logic_vector(2 downto 0);
        y: out std_logic_vector(7 downto 0));
   end component;

   component Register16 is
   port(x: in std_logic_vector(15 downto 0);
        y: out std_logic_vector(15 downto 0);
	--PCwrite : in std_logic;
	clk: in std_logic;
	write: in std_logic;
	reset: in std_logic);
   end component;

   component RegisterFile is
   port(A1,A2,A3: in std_logic_vector(2 downto 0);
	clk,reset, In_RF_Write_en_1,PCwrite : in std_logic;
	D3:in std_logic_vector(15 downto 0);
	PC_Write_data1:in std_logic_vector(15 downto 0);
	D1, D2 : out std_logic_vector(15 downto 0));
   end component;

   component mux2 is
   port(PCwrite: in std_logic;
	RFdata,PCdata: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0));
   end component;

 
   component Comparator is
   port(a: in std_logic_vector(14 downto 0);
        b: in std_logic_vector(14 downto 0);
	s: out std_logic_vector(3 downto 0));
   end component;

   component mux4 is
   port(selectinput: in std_logic_vector(1 downto 0);
	data0,data1,data2,data3,data4,data5,data6,data7: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0));
   end component;

   component mux2_16 is
   port(selectinp: in std_logic;
	D0,D1: in std_logic_vector(15 downto 0); 
        y: out std_logic_vector(15 downto 0));
   end component; 

type Mem is array(0 to 65535) of std_logic_vector(15 downto 0);


end Veeru_Components;
