library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel is
  port (
         CLK : in std_logic; -- Test clock
         RST : in std_logic -- Test reset
       );
end TopLevel;
-----------------------------------instruction type is not defined and port is not mapped------------------------
architecture Struct of TopLevel is
  component DataPath is
  port( clk: in std_logic;
        Zout,PE_zero, CFlag, ZFlag: out std_logic;
	T4_write,T5_write: in std_logic;
	T4_select: in std_logic;
	T3_write: in std_logic;
	T3_select: in std_logic_vector(1 downto 0);
        T2_write: in std_logic;
	T1_write: in std_logic;
	T1_select: in std_logic;
	Mem_select1: in  std_logic_vector(1 downto 0);
	Mem_select2: in  std_logic_vector(1 downto 0);
	RF_select1,  RF_select3,  RF_select5,  RF_write,  PC_write: in std_logic;
	RF_select2,  RF_select4: in std_logic_vector(1 downto 0);
	Mem_Write,  mem_en,  Mem_select3: in std_logic;
	IR_write,  AluSE_select,  Cwrite,  Zwrite : in std_logic;
	ALU_select1,  ALU_select2,  alu_op: in  std_logic_vector(1 downto 0);
	reset: in std_logic
);
  end component;

  -- declare Scan-chain component.
  component ControlPath is
  port( clk: in std_logic;
        PE_zero: in std_logic;
        Z_out: in std_logic;
        Z_flag: in std_logic;
        C_flag: in std_logic;
        --instruction: in INSTRUCTION ;   --- DEFINETHIS TYPE AND DECLARE ALL INSTRUCTIONS IN SEPARATE FILE
        C_write: out std_logic;
        Z_write: out std_logic;
        SE_sel: out std_logic;
        T5_write: out std_logic;
        T4_write: out std_logic;
        T3_write: out std_logic;
        T2_write: out std_logic;
        T1_write: out std_logic;
        T1_inp: out std_logic;
        T4_inp: out std_logic;
        PC_write_con: out std_logic;
        MEM_en: out std_logic;
        MEM_write: out std_logic;
        Mem_dataIN: out std_logic;
        IR_write: out std_logic;
        RF_write: out std_logic;
        A2_inp_sel: out std_logic;
        A3_mux2_sel: out std_logic;
        D3_mux2_sel: out std_logic;

        ALU_opr_sel: out std_logic_vector(0 to 1);
        ALU_op1: out std_logic_vector(0 to 1);
        ALU_op2: out std_logic_vector(0 to 1);
        T3_Inp: out std_logic_vector(0 to 1);
        PC_Inp: out std_logic_vector(0 to 1);
        MEM_add_sel: out std_logic_vector(0 to 1);
        A3_Inp_sel: out std_logic_vector(0 to 1);
        D3_inp_sel: out std_logic_vector(0 to 1);
    --reset is not predefined in system -- need to define 
        reset: in std_logic
);
  end component;

signal	Zout,PE_zero, CFlag, ZFlag :  std_logic;
signal  T4_write,T5_write: std_logic;
signal	T4_select: std_logic;
signal	T3_write: std_logic;
signal	T3_select: std_logic_vector(1 downto 0);
signal  T2_write: std_logic;
signal	T1_write: std_logic;
signal	T1_select: std_logic;
signal	Mem_select1: std_logic_vector(1 downto 0);
signal	Mem_select2: std_logic_vector(1 downto 0);
signal	RF_select1,RF_select3,RF_select5,RF_write,PC_write: std_logic;
signal	RF_select2,RF_select4:  std_logic_vector(1 downto 0);
signal	Mem_Write,mem_en,Mem_select3: std_logic;
signal	IR_write,AluSE_select,Cwrite,Zwrite: std_logic;
signal	ALU_select1,ALU_select2,alu_op: std_logic_vector(1 downto 0);

begin
  D: DataPath
  port map (	CLK,
		Zout, 
		PE_zero, 
		CFlag, 
		ZFlag,
		T4_write,
		T5_write,
		T4_select,
  		T3_write,
		T3_select,
        	T2_write,
		T1_write,
		T1_select,
		Mem_select1 ,
		Mem_select2 ,
		RF_select1,
		RF_select3, 
		RF_select5, 
		RF_write, 
		PC_write ,
		RF_select2, 
		RF_select4 ,
		Mem_Write, 
		mem_en, 
		Mem_select3 ,
		IR_write, 
		AluSE_select, 
		Cwrite, 
		Zwrite ,
		ALU_select1, 
		ALU_select2, 
		alu_op,
		RST 				);
  

  C: ControlPath
  port map(	CLK,
		PE_zero, 
		Zout, --------------------------------------Define and map 'instruction'-----------------------
		ZFlag, 
		CFlag, 
		Cwrite, 
		Zwrite, 
		AluSE_select, 
		T5_write,
		T4_write,
		T3_write,
		T2_write,
		T1_write, 
		T1_select, 
		T4_select, 
		PC_write, 
		mem_en, 
		Mem_Write, 
		Mem_select3, 
		IR_write, 
		RF_write, 
		RF_select1, 
		RF_select3, 
		RF_select5, 
		alu_op,
		ALU_select1, 
		ALU_select2, 
		T3_select, 
		Mem_select1, 
		Mem_select2, 
		RF_select2, 
		RF_select4,
		RST			 );
  
  end Struct;
