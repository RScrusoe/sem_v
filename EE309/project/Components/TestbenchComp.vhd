library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TestbenchComp is

end entity;


architecture Behave of TestbenchComp is
component RegisterFile is   
    port
    (
        D1  : out std_logic_vector(15 downto 0);
        D2  : out std_logic_vector(15 downto 0);
        D3  : in  std_logic_vector(15 downto 0);
	PC_Write_data1:in std_logic_vector(15 downto 0);

        A1  : in  std_logic_vector(2 downto 0);
        A2  : in  std_logic_vector(2 downto 0);
        A3  : in  std_logic_vector(2 downto 0);
        
        In_RF_Write_en_1   : in std_logic;
        clk   ,reset, PCwrite        : in std_logic);

	
end component;

  signal A1,A2,A3: std_logic_vector(2 downto 0);
  signal D1,D2,D3: std_logic_vector(15 downto 0);
  signal clk: std_logic := '0';
  function to_std_logic (x: bit) return std_logic is
  begin
  if(x = '1') then return ('1');
  else return('0'); end if;
  end to_std_logic;


  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_bit_vector(x: std_logic_vector) return bit_vector is
    alias lx: std_logic_vector(1 to x'length) is x;
    variable ret_var : bit_vector(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
  end if;
     end loop;
     return(ret_var);
  end to_bit_vector;


begin


  clk <= not clk after 10 ns;
  -- rudimentary test..
  -- apply reset,a,a,b,b,a,b
  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "Tracefile.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";
    variable A1_bv,A2_bv,A3_bv: bit_vector (1 to 3);
    variable D1_bv,D2_bv,D3_bv: bit_vector (1 to 16);

    variable output_bv: bit;

    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
  
    variable clk_bit: bit;
  begin 

    clk <= not clk after 5 ns;

    while not endfile(INFILE) loop 
    report "here";
          -- clock = '0', inputs should be changed here.
          LINE_COUNT := LINE_COUNT + 1;
          readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, A1_bv);
          read (INPUT_LINE, A2_bv);
          read (INPUT_LINE, A3_bv);
          read (INPUT_LINE, D3_bv);

          for i in 0 to 2 loop
            A1(i) <= to_std_logic(A1_bv(3-i));
            A2(i) <= to_std_logic(A2_bv(3-i));
            A3(i) <= to_std_logic(A3_bv(3-i));
          end loop;
          for i in 0 to 15 loop
            D3(i) <= to_std_logic(D3_bv(16-i));
          end loop;

  
    wait for 500 ns;

    
            --if (D3(1) /= to_std_logic(D3_bv(1))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);

            write(OUTPUT_LINE, to_bit_vector(A1));
             write(OUTPUT_LINE,to_string(" "));

             write(OUTPUT_LINE, to_bit_vector(D1));
             write(OUTPUT_LINE,to_string(" "));

              write(OUTPUT_LINE, to_bit_vector(A2));
             write(OUTPUT_LINE,to_string(" "));

             write(OUTPUT_LINE, to_bit_vector(D2));
             write(OUTPUT_LINE,to_string(" "));

              write(OUTPUT_LINE, to_bit_vector(A3));
             write(OUTPUT_LINE,to_string(" "));

             write(OUTPUT_LINE, to_bit_vector(D3));
             write(OUTPUT_LINE,to_string(" "));
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          --end if; 


    if(endfile(INFILE)) then
    exit;
    end if;

    
        end loop;
    
  assert (err_flag) report "SUCCESS, all tests passed." severity note;
      assert (not err_flag) report "FAILURE, some tests failed." severity error;
  
  wait;
  end process;
  

  dut:RegisterFile port map(  D1 =>D1,D2=>D2,D3=>D3,A1=>A1,A2=>A2,A3=>A3,In_RF_Write_en_1=>'1', clk=>clk, reset =>'0', PCwrite => '0',PC_Write_data1 => "1010101010101010");
end Behave;
