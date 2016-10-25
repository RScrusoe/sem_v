library ieee;
use ieee.std_logic_1164.all;
entity ControlPath is
  port(
    clk: in std_logic;
    PE_zero: in std_logic;		-- input to control path from datapath
    Z_out: in std_logic;		-- input to control path from datapath
    Z_flag: in std_logic;		-- input to control path from datapath
    C_flag: in std_logic;		-- input to control path from datapath
    instruction: in std_logic_vector(15 downto 0) ;   --- DEFINETHIS TYPE AND DECLARE ALL INSTRUCTIONS IN SEPARATE FILE
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
end entity;

architecture Behave of ControlPath is
   type FsmState is (S0, S1, S2, S3_add, S4_C, S3_addIm, S4_B, S3_nand, S4_A, S3_lw, S4_lw, S5_lw, S4_sw, S3_lm, S4_lm_wb, S3_sm, S4_sm, S5_sm, S3_sub, S3_beq, S3_jal, S3_jlr, S4_jlr);        -- add all state name 
   signal fsm_state : FsmState;
begin

   process(fsm_state,reset,clk,Z_out,PE_zero,C_flag, Z_flag, instruction) is            -- 
    variable next_state: FsmState;
    


    variable C_write_var, Z_write_var, SE_sel_var, T1_write_var, T1_inp_var, T2_write_var, T3_write_var,T4_write_var,T4_inp_var,T5_write_var,PC_write_con_var, RF_write_var,MEM_en_var, MEM_write_var, Mem_dataIN_var, IR_write_var, A2_inp_sel_var, A3_mux2_sel_var,  D3_mux2_sel_var: std_logic; 
    variable PC_Inp_var, A3_Inp_sel_var, ALU_opr_sel_var, ALU_op1_var, T3_Inp_var, ALU_op2_var, MEM_add_sel_var, D3_inp_sel_var,: std_logic_vector(0 to 1);
   begin
     -- defaults
     C_write_var, Z_write_var, SE_sel_var, T1_write_var, T1_inp_var, T2_write_var, T3_write_var,T4_write_var,T4_inp_var,T5_write_var,PC_write_con_var, RF_write_var,MEM_en_var, MEM_write_var, Mem_dataIN_var, IR_write_var, A2_inp_sel_var, A3_mux2_sel_var,  D3_mux2_sel_var := '0';
     PC_Inp_var, A3_Inp_sel_var, ALU_opr_sel_var, ALU_op1_var, ALU_op2_var, MEM_add_sel_var, D3_inp_sel_var, T3_Inp_var := "00";
     
     
     next_state := fsm_state;

     case fsm_state is 
    when  S0 =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '0';
      IR_write_var := '0';
      RF_write_var := '1';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '1';
      PC_Inp_var := "11";
      A3_Inp_sel_var := "10"; 
      D3_inp_sel_var := "00";

      A3_mux2_sel_var := '0';
      next_state := S1;

    when S1 =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '1';
      T4_inp_var := '1';
      T5_write_var := '0';
      
      IR_write_var := '1';
      RF_write_var := '1';
      A3_Inp_sel_var := "10";
      A3_mux2_sel_var := '0';
      D3_inp_sel_var := "11";
      D3_mux2_sel_var := '0'; 
      ALU_opr_sel_var := "01"';
      ALU_op1_var := "10";
      ALU_op2_var := "01";
      T3_write_var := '1';
      T3_Inp_var := "01";
      PC_write_con_var := '1';
      PC_Inp_var := "01";
      MEM_add_sel_var := "01";
      MEM_en_var := '1';
      MEM_write_var := '0';   

      next_state := S2;
    

    when S2 =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '1';
      T1_inp_var := '1';
      T2_write_var := '1';
      T4_write_var := '0';
      T5_write_var := '0';		
      T3_write_var := '1';
      T3_Inp_var := "10";
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      PC_Inp_var := "10";

      -- NEXT STATE LOGIC 
      case( instruction(15 downto 12) ) is
      
      	when "0000" =>
      		-- add-type
      		if instruction(1 downto 0) ="00" then
      			next_state := S3_add;
      		elsif instruction(1 downto 0) ="10"  then
      			if C_flag = '1' then
      				next_state := S3_add;
      			else
      				next_state := S1;
      			end if;
      		elsif instruction(1 downto 0) = "10" then
      			if Z_flag = '1' then
      				next_state := S3_add;
      			else
      				next_state := S1;
      			end if ;
      		else 
      			next_state := S1    			
      		end if ;
      	when "0001" =>
      		-- adi 
      		next_state := S3_addIm;
      	when "0010" =>
      		-- nand
      		if instruction(1 downto 0) ="00" then
      			next_state := S3_nand;
      		elsif instruction(1 downto 0) ="10"  then
      			if C_flag = '1' then
      				next_state := S3_nand;
      			else
      				next_state := S1;
      			end if;
      		elsif instruction(1 downto 0) = "10" then
      			if Z_flag = '1' then
      				next_state := S3_nand;
      			else
      				next_state := S1;
      			end if ;
      		else 
      			next_state := S1    			
      		end if ;
        when "0011" =>
        	-- lhi
        	next_state := S4_A;
        when "0100" =>
        	-- lw
        	next_state := S3_lw;
        when "0101" =>
        	-- sw
        	next_state := S3_lw;
        when "0110" =>
        	-- lm
        	next_state := S3_lm;
        when "0111" =>
        	-- sm
        	next_state := S3_sm;
        when "1100" =>
        	-- beq
        	next_state := S3_beq;
        when "1000" =>
        	-- jal
        	next_state := S3_jlr;
        when "1001" =>
        	--jlr
        	next_state := S3_jlr;

      	when others =>
      		next_state := S1;
      end case ;



    when S3_add =>
      ALU_opr_sel_var := "01"';
      ALU_op1_var := "11";
      ALU_op2_var := "10";
      C_write_var := '1';
      Z_write_var := '1';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '1';
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      T3_Inp_var := "01";
      PC_Inp_var := "10";
      next_state := S4_C;
    
    when S4_C =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '0';
      IR_write_var := '0';
      PC_Inp_var := "10";
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      RF_write_var := '1';
      A3_Inp_sel_var := "01";
      D3_inp_sel_var := "01";

      next_state := S1;

    when S3_addIm =>
      
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      RF_write_var := '0';

      ALU_opr_sel_var := "01";
      ALU_op1_var := "01";
      ALU_op2_var := "00";
      C_write_var := '1';
      Z_write_var := '1';
      T3_write_var := '1';
      T3_Inp_var := "01";
      PC_Inp_var := "10";

      next_state := S4_B;

    when S4_B =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '0';
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      
      RF_write_var := '1';
      A3_Inp_sel_var := "00";
      D3_inp_sel_var := "01";
      PC_Inp_var := "10"; 

      next_state := S1;

    when S3_nand =>
      C_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      RF_write_var := '0';


      ALU_opr_sel_var := "11";
      ALU_op1_var := "11";
      ALU_op2_var := "10";
      Z_write_var := '1';
      T3_write_var := '1';
      T3_Inp_var := "01";
      PC_Inp_var := "10";        

      next_state := S4_C;

    when S4_A =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '0';
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      

      PC_Inp_var := "10";
      RF_write_var := '1';
      D3_inp_sel_var := "01";
      A3_Inp_sel_var := "10";
      A3_mux2_sel_var := '1';

      next_state := S1;

    when S3_lw =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      RF_write_var := '0';

      ALU_opr_sel_var := "01";
      ALU_op1_var := "01";
      ALU_op2_var := "10";
      T3_write_var := '1';
      T3_Inp_var := "01";
      PC_Inp_var := "10";

      -- next state logic
      if instruction(15 downto 12) = "0100" then
      		-- lw
      		next_state := S4_lw;
      elsif instruction(15 downto 12 ) = "0101" then
      		--lw    		
      		next_state := S4_sw;
      	else
      		next_state := S1;
      end if ;
      
    when S4_lw =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '1';
      T5_write_var := '0';
      T3_write_var := '0';
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '1';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      PC_Inp_var := "10";
      MEM_add_sel_var := "10";

      next_state := S5_lw;

    when S5_lw =>
      C_write_var := '0';
      
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      ALU_opr_sel_var := "01";
      ALU_op1_var := "00";
      ALU_op2_var := "11"; 
      Z_write_var := '1';
      T3_write_var := '1';
      T3_Inp_var := "01";
      PC_Inp_var := "10";

      next_state := S4_A;

    when S4_sw =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '0';
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      MEM_add_sel_var := "10";
      MEM_en_var := '1';
      MEM_write_var := '1';
      PC_Inp_var := "10";

      next_state := S1;

    when S3_lm =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      
      
      T3_write_var := '0';
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      T4_write_var := '1';
      T5_write_var := '1';
      PC_Inp_var := "10";
      MEM_add_sel_var := "11";
      MEM_en_var := '1';

      If (PE_zero = '1') then
      next_state := S1;
      else 
      next_state := S4_lm_wb;
      end if;

    when => S4_lm_wb
      C_write_var := '0';
      Z_write_var := '0';
      
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      ALU_opr_sel_var := "01";
      ALU_op1_var := "11";
      ALU_op2_var := "01"; 
      T1_write_var := '1';
      T3_write_var := '1';
      T1_inp_var := '1';
      PC_Inp_var := "10";
      T3_Inp_var := "11";
      RF_write_var := '1';
      A3_Inp_sel_var := "11";
      D3_inp_sel_var := "10";

      next_state := S3_lm

    when S3_sm =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      
      T3_write_var := '0';
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      T5_write_var := '1';
      PC_Inp_var := "10";
      If (PE_zero = '1') then
      next_state := S1;
      else 
      next_state := S4_sm;
      end if; 

    when S4_sm =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      
      T4_write_var := '0';
      T5_write_var := '0';
      
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      T2_write_var := '1';
      T3_write_var := '1';
      T3_Inp_var := "11";
      PC_Inp_var := "10";
      A2_inp_sel_var := '1';

      next_state := S5_sm
      
    when S5_sm =>
      C_write_var := '0';
      Z_write_var := '0';
      
      T2_write_var := '0';
      T4_write_var := '0';
      
      IR_write_var := '0';
      RF_write_var := '0';
      
      PC_write_con_var := '0';

      ALU_opr_sel_var := "01";
      ALU_op1_var := "11";
      ALU_op2_var := "01"; 
      T1_write_var := '1';
      T3_write_var := '1';
      T1_inp_var := '1';
      T5_write_var := '1';
      PC_Inp_var := "10";
      MEM_add_sel_var := "11";
      MEM_en_var := '1';
      MEM_write_var := '1';
      Mem_dataIN_var := '1';

      If (PE_zero = '1') then
      next_state := S1;
      else 				-- what if not defined signal, or high impedance
      next_state := S4_sm;
      end if;           

    when S3_sub =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      
      IR_write_var := '0';
      RF_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      ALU_opr_sel_var := "10";
      ALU_op1_var := "11";
      ALU_op2_var := "10";          
      T3_write_var := '1';
      T3_Inp_var := "01";

      If (Z_out = '1') then       ---- Check whether Z_out gets updated in same state or not
      next_state := S1;
      else 
      next_state := S3_beq;
      end if;           

    when S3_beq =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '0';
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';
      ALU_opr_sel_var := "01";
      ALU_op1_var := "01";
      ALU_op2_var := "11";
      PC_write_con_var := '1';
      PC_Inp_var := "01";
      RF_write_var := '1';
      A3_Inp_sel_var := "10";
      D3_inp_sel_var := "11";          
      A3_mux2_sel_var := '0';

      next_state := S1

    when S3_jal =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '1';
      IR_write_var := '0';
      
      MEM_en_var := '0';
      MEM_write_var := '0';
     
      ALU_opr_sel_var := "01";
      ALU_op1_var := "01";
      ALU_op2_var := "11";
      SE_sel_var := '1';
      PC_write_con_var := '1';
      PC_Inp_var := "01";
      RF_write_var := '1';
      A3_Inp_sel_var := "10";
      D3_inp_sel_var := "11";
      A3_mux2_sel_var := '0';
      D3_mux2_sel_var := '0';
      next_state := S1;

    when S3_jlr =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '1';
      IR_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '0';

      PC_Inp_var := "10";
      RF_write_var ='1';
      A3_Inp_sel_var := "10";
      A3_mux2_sel_var := '1';
      D3_inp_sel_var := "01";

      	-- next state logic
      	if instruction(15 downto 12) = "1000" then
      		-- jal
      		next_state := S3_jal;
      	elsif instruction(15 downto 12 ) = "1001" then
      		-- jlr    		
      		next_state := S4_jlr;
      	else
      		next_state := S1;
      end if ;
     
    when S4_jlr =>
      C_write_var := '0';
      Z_write_var := '0';
      T1_write_var := '0';
      T2_write_var := '0';
      T4_write_var := '0';
      T5_write_var := '0';
      T3_write_var := '1';
      IR_write_var := '0';
      MEM_en_var := '0';
      MEM_write_var := '0';
      PC_write_con_var := '1';
      RF_write_var := '1';
      A3_Inp_sel_var := "10";
      D3_inp_sel_var := "11";
      D3_mux2_sel_var := '1';
      A3_mux2_sel_var := '0';

      next_state := S1;






   end case;

  --- Assign all variables to signals using operator <= 
 C_write <= C_write_var
  Z_write <= Z_write_var
  SE_sel <= SE_sel_var
  T5_write <= T5_write_var
  T4_write <= T4_write_var
  T3_write <= T3_write_var
  T2_write <= T2_write_var
  T1_write <= T1_write_var
  T1_inp <= T1_inp_var
  T4_inp <= T4_inp_var
  PC_write_con <= PC_write_con_var
  MEM_en <= MEM_en_var
  MEM_write <= MEM_write_var
  Mem_dataIN <= Mem_dataIN_var
  IR_write <= IR_write_var
  RF_write <= RF_write_var
  A2_inp_sel <= A2_inp_sel_var
  A3_mux2_sel <= A3_mux2_sel_var
  D3_mux2_sel <= D3_mux2_sel_var
  ALU_opr_sel <= ALU_opr_sel_var
  ALU_op1 <= ALU_op1_var
  ALU_op2 <= ALU_op2_var
  T3_Inp <= T3_Inp_var
  PC_Inp <= PC_Inp_var
  MEM_add_sel <= MEM_add_sel_var
  A3_Inp_sel <= A3_Inp_sel_var
  D3_inp_sel <= D3_inp_sel_var
  

   
  

  if(reset = '1') then
    fsm_state <= S0;
  elsif (clk'event and (clk = '1')) then
    fsm_state <= next_state;
  end if;
  
  end process;
end Behave;
