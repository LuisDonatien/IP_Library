library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity PID_TIMER is
  Port ( 
  CLK   : in std_logic;
  RESET : in std_logic;
  Input : in std_logic;
  Count : out std_logic_vector(19 downto 0) 
  );
end PID_TIMER;

architecture Behavioral of PID_TIMER is
signal Count_s: unsigned(19 downto 0);
signal N_Input: unsigned(2 downto 0);
signal N_Average: unsigned(21 downto 0);
signal Marca: std_logic_vector(19 downto 0):=(others=>'1');
---Señales para la division---
    constant COUNT_SIZE  : integer:=19;
    constant RESULT_SIZE : integer:=19;
    constant CONST_DIV_SIZE : integer:=10;
    constant Division: integer:=9;
    constant Value_CONST_DIV : integer:=85;
signal Valin_x_Constant: unsigned(22+10-1 downto 0);
 signal DivConstant : unsigned(CONST_DIV_SIZE-1 downto 0):=TO_UNSIGNED(Value_Const_Div,10);
----------------------------------
signal Flag,Flag_d: std_logic;
begin

counter_time: process(CLK)
begin
    if rising_edge(CLK) then
        if RESET='1' then
        Count_s<=(others=>'0');
        Count<=(others=>'1');
        N_Input<=(others=>'0');
        Valin_x_Constant<=(others=>'0');
        N_Average<=(others=>'0');
        Flag_d<='0';
        else
            if Input='1' AND Flag='0' then
                
                N_Average<=N_Average+Count_s;
                Count_s<=(others=>'0');
                Flag<='1';
                N_Input<=N_input+1;
            elsif Count_s=unsigned(Marca) then
                Count<=std_logic_vector(Marca);
                N_Input<=(others=>'0');
                N_Average<=(others=>'0');
            else
                Count_s<=(Count_s)+1;
                Flag<=Input;    --Con esto se resetea el valor de flag permitiendo volver a detectar el flanco.
            end if;
--Tratamiento de Tiempos detectados-----
            if N_input>=5 then
                Valin_x_Constant <= N_Average*DivConstant;   
                Flag_d<='1';
                N_input<=(others=>'0');
            elsif flag_d='1' then
                Count <= std_logic_vector(Valin_x_Constant(COUNT_SIZE+CONST_DIV_SIZE -1 downto Division));   
                N_Average<="00" & Valin_x_Constant(COUNT_SIZE+CONST_DIV_SIZE -1 downto Division);  
                --N_Average<=(others=>'0');
                Flag_d<='0';
            end if;               
        end if;
    end if;
end process;


end Behavioral;
