library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Veeru_Components.all;
entity DataPath is


   port(clk: in std_logic;
        Zout, PE_zero, CFlag, ZFlag : out std_logic;
	T4_write,T5_write: in std_logic;
	T4_select: in std_logic;
	T3_write: in std_logic;
	T3_select: in std_logic_vector(1 downto 0);
        T2_write: in std_logic;
	T1_write: in std_logic;
	T1_select: in std_logic;
	Mem_select1: in  std_logic_vector(1 downto 0);
	Mem_select2: in  std_logic_vector(1 downto 0);
	RF_select1,RF_select3,RF_select5,RF_write,PC_write: in std_logic;
	RF_select2,RF_select4: in std_logic_vector(1 downto 0);
	Mem_Write,mem_en,Mem_select3: in std_logic;
	IR_write,AluSE_select,Cwrite,Zwrite : in std_logic;
	ALU_select1,ALU_select2,alu_op: in  std_logic_vector(1 downto 0);
	reset: in std_logic
);
end entity;
architecture Struct of DataPath is 
signal memOut,PC_out,T4_in,T4_out,T3_in,T3_out,T2_in,T2_out,none,alu_out,T3SE7,PEdecout,D2_out,D1_out,T1_in,T1_out,I,D3Buf_out,PC_in,MemAdd,MemDin,IRout,
RF_mux5out, D3_buffer, op2, AluSE, op1, aluSE10, aluSE7 : std_logic_vector(15 downto 0);
signal T5_Out, A2_in, RF_mux3out, PEout, T5out, A3_in : std_logic_vector(2 downto 0);
signal Cout : std_logic;
begin
------------------------------Registers------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------



T4muxMap : mux2_16 port map(	selectinp => T4_select,
			    	D0 => memOut,
				D1 => PC_out,
				y => T4_in				  );

T4Map: Register16 port map(	x => T4_in,
				y => T4_out,
				clk => clk,
				reset => reset,
				write => T4_write 		  	  );

T3muxMap: mux4 port map(	selectinput => T3_select,
				data0 => none,
				data1 => alu_out,
				data2 => T3SE7,
				data3 => PEdecout,
				y => T3_in				  );

T3Map: Register16 port map(	x => T3_in,
				y => T3_out,
				clk => clk,
				reset => reset,
				write => T3_write 			  );

T3SEmap: SBE7 port map(		x => I(8 downto 0),
				s => T3SE7 				  );

T2Map: Register16 port map(	x => D2_out,
				y => T2_out,
				clk => clk,
				reset => reset,
				write => T2_write 			  );

T1muxMap: mux2_16 port map(	selectinp => T1_select,
				D0 => D1_out,
				D1 => alu_out,
				y => T1_in				  );

T1Map: Register16 port map(	x => T1_in,
				y => T1_out,
				clk => clk,
				reset => reset,
				write => T1_write 			  );
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
MemmuxMap1: mux4 port map(	selectinput => Mem_select1,
				data0 => "0000000000000000",
				data1 => alu_out,data2 => D3Buf_out,
				data3 => T2_out,
				y => PC_in				);

MemmuxMap2: mux4 port map(	selectinput => Mem_select2,
				data0 => none,
				data1 => PC_out,
				data2 => T3_out,
				data3 => T1_out,
				y => MemAdd				);

MemMap: Code_Memory port map(	clk => clk,
				Address => MemAdd,
				DataRead => MemOut,
				DataWrite => MemDin,
				Mem_Write => mem_en			);

IR: Register16 port map(	x => MemOut,
				y => IRout,
				clk => clk,
				reset => reset,
				write => IR_write			);

MemmuxMap3: mux2_16 port map(	selectinp => Mem_select3,
				D0 => T1_out,
				D1 => T2_out,
				y => MemDin				);

----------------------------RF-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
RFmuxMap1: mux2_3 port map(	selectinp => RF_select1,
				D0 => I(8 downto 6),
				D1 => T5_Out,
				y => A2_in				);

RFmuxMap2: mux4_3 port map(	selectinput => RF_select2,
				data0 => I(5 downto 3),
				data1 => I(8 downto 6),
				data2 => RF_mux3out,
				data3 => T5_out,
				y => A3_in				);

RFmuxMap3: mux2_3 port map(	selectinp => RF_select3,
				D0 => "111",
				D1 => I(11 downto 9),
				y => RF_mux3out				);

RFmuxMap4: mux4 port map(	selectinput => RF_select4,
				data0 => "0000000000000000",
				data1 => T3_out,
				data2 => T4_out,
				data3 => RF_mux5out,
				y => D3_buffer				);  

BufferD3Map: Register16 port map(x => RF_mux5out,
				reset => reset, 
				clk => clk,
				write =>'1',
				y=> D3Buf_out				);

RFmuxMap5: mux2_16 port map(	selectinp => RF_select5,
				D0 => alu_out,
				D1 => T2_out,
				y => RF_mux5out				);

RFMap: RegisterFile port map(	A1 => I(11 downto 9),
				A2 => A2_in,
				A3 => A3_in,
				D1 => D1_out,
				D2 => D2_out,
				clk => clk,
				reset => reset,
				In_RF_Write_en_1 => RF_write,
				PCwrite =>PC_write,
				PC_Write_data1 => PC_in 		);
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ALU=-------------------------------------------------------------------------------



ALUmuxMap1: mux4 port map(	selectinput => ALU_select1,
				data0 => T1_out,
				data1 => "0000000000000000",
				data2 => T2_out,
				data3 =>T4_out,
				y => op2				);

ALUmuxMap2: mux4 port map(	selectinput => ALU_select2,
				data0 => "0000000000000000",
				data1 => AluSE,
				data2 => PC_out,
				data3 =>T1_out,
				y => op1				);

AluSEMuxMap: mux2_16 port map(	selectinp => AluSE_select,
				D0 => aluSE10,
				D1 => aluSE7,
				y => AluSE				);

AluSE10Map: SBE10 port map(	x => I(5 downto 0),
				s => aluSE10				);

AluSE7Map: SBE7 port map(	x => I(8 downto 0),
				s => aluSE7				);

ALUMap: alu_16 port map(	op1 => op1,
				op2 => op2,
				op_sel => alu_op,
				c_out => Cout,
				z_out =>Zout				);

CarryMap: Register1 port map(	Din => Cout,
				Dout => CFlag,
				clk => clk,
				enable => Cwrite			);

ZeroMap: Register1 port map(	Din => Zout,
				Dout => ZFlag,
				clk => clk,
				enable => Zwrite			);
-------------------------------------------------------------------------------------------------------------------------------------
------------------------------PE-----------------------------------------------------------------------------------------------------
T5Map: Register3 port map(	Din => PEout,
				clk => clk,
				enable => T5_write,
				Dout => T5out				);

--PEdecOutMap: decoder_8_3 port map(din => PEout,dout => PEdecout);
--PEMap: Priority_encoder port map(x => T3(7 downto 0),y =>PEout);
PEMap: priority_block port map(	din => T3(7 downto 0),
				aout => PEout,
				zero_out =>, PE_zero
				dout => PEdecout			); 

end Struct;



