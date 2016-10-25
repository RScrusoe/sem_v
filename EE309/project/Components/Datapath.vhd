library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity DataPath is
   port(x: in std_logic_vector(15 downto 0);
        y: out std_logic_vector(15 downto 0);
	clk: in std_logic;


	T4_write: in std_logic;
	T4_select: in std_logic;


	reset: in std_logic
);
end entity;
architecture Struct of DataPath is 
begin
signal memOut,PC,T4_in,T4_out : std_logic_vector(15 downto 0);

T4muxMap: mux2_16: port map(selectinp => T4_select,D0 => memOut,D1 => PC,y => T4_in);
T4Map: Register16: port map(x => T4_in,y => T4_out,clk => clk,reset => reset,write => T4_write );


end Struct;



library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity RegisterFile is
   port(A1,A2,A3: in std_logic_vector(2 downto 0);
	clk,reset, In_RF_Write_en_1,PCwrite : in std_logic;
	D3:in std_logic_vector(15 downto 0);
	PC_Write_data1:in std_logic_vector(15 downto 0);
	D1, D2 : out std_logic_vector(15 downto 0)
);
end entity;
architecture Struct of RegisterFile is 
signal data0,  data1,  data2,  data3,  data4,  data5,  data6,  data7,In_RF7_write_data : std_logic_vector(15 downto 0);
signal writeLinesInit, writeLines : std_logic_vector(7 downto 0);
begin
PCWriteDataa: mux2 port Map(PCwrite => PCwrite,
			    RFdata => D3,
			    PCdata => PC_Write_data1,
		            y => In_RF7_write_data);

D3RegFile :demux  port Map(x => A3,	---selects register i.e.decoder
				y => writeLinesInit);
D1RegFile :mux8 port Map( data0 => data0,   ----- gets data acc. to register no.
				   data1 => data1,
				   data2 => data2,
				   data3 => data3,
				   data4 => data4,
				   data5 => data5,
				   data6 => data6,
				   data7 => data7,
				   selectinput => A1,
				   y => D1);
D2RegFile :mux8 port Map( data0 => data0,   ----- gets data acc. to register no.
				   data1 => data1,
				   data2 => data2,
				   data3 => data3,
				   data4 => data4,
				   data5 => data5,
				   data6 => data6,
				   data7 => data7,
				   selectinput => A2,
				   y => D2);
writeLines(0) <= In_RF_Write_en_1 and writeLinesInit(0);
writeLines(1) <= In_RF_Write_en_1 and writeLinesInit(1);
writeLines(2) <= In_RF_Write_en_1 and writeLinesInit(2);
writeLines(3) <= In_RF_Write_en_1 and writeLinesInit(3);
writeLines(4) <= In_RF_Write_en_1 and writeLinesInit(4);
writeLines(5) <= In_RF_Write_en_1 and writeLinesInit(5);
writeLines(6) <= In_RF_Write_en_1 and writeLinesInit(6);
writeLines(7) <= ((In_RF_Write_en_1 and writeLinesInit(7)) or PCwrite);  -------R7 is PC
 
r0 :register16 port map(clk => clk,
			reset => reset,
			y => data0,
			x => D3,
			write => writeLines(0));
r1 :register16 port map(clk => clk,
			reset => reset,
			y => data1,
			x => D3,
			write => writeLines(1));

r2 :register16 port map(clk => clk,
			reset => reset,
			y => data2,
			x => D3,
			write => writeLines(2));

r3 :register16 port map(clk => clk,
			reset => reset,
			y => data3,
			x => D3,
			write => writeLines(3));

r4 :register16 port map(clk => clk,
			reset => reset,
			y => data4,
			x => D3,
			write => writeLines(4));

r5 :register16 port map(clk => clk,
			reset => reset,
			y => data5,
			x => D3,
			write => writeLines(5));

r6 :register16 port map(clk => clk,
			reset => reset,
			y => data6,
			x => D3,
			write => writeLines(6));

r7 :register16 port map(clk => clk,
			reset => reset,
			y => data7,
			x => In_RF7_write_data,
			write => writeLines(7));



end Struct;


