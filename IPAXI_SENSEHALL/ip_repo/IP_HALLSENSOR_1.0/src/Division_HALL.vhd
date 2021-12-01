library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Division_HALL is
Generic(
    COUNT_SIZE  : integer:=15;
    RESULT_SIZE : integer:=15;
    CONST_DIV_SIZE : integer:=15;
    Value_CONST_DIV : integer:=3276
);
Port ( 
    CLK:        in std_logic;
    RESET:      in std_logic;
    DIVIDE:     in std_logic;
    COUNT:      in std_logic_vector(COUNT_SIZE-1 downto 0);
    DIVISION_DONE:  out std_logic;
    RESULT:     out std_logic_vector(RESULT_SIZE-1 downto 0)
     
);
end Division_HALL;

architecture Behavioral of Division_HALL is
    signal flag: std_logic;
    signal result_s : unsigned(RESULT_SIZE-1downto 0);
    signal Valin_x_Constant : unsigned(CONST_DIV_SIZE+COUNT_SIZE -1 downto 0);
    signal DivConstant : unsigned(CONST_DIV_SIZE-1 downto 0);
begin

div: process(CLK,RESET)
begin
    if RESET='1' then
        flag<='0';
        result_s <=to_unsigned(0,RESULT_SIZE);       
        Valin_x_Constant<=to_unsigned(0,COUNT_SIZE+CONST_DIV_SIZE);
        DIVISION_DONE<='0';
    elsif rising_edge(CLK) then
        if DIVIDE='1' then
            if flag='0' then
                Valin_x_Constant <= unsigned(COUNT)*DivConstant + (2**CONST_DIV_SIZE);   
                flag<='1';
                DIVISION_DONE<='0';
            elsif flag='1' then
                result_s <= Valin_x_Constant(COUNT_SIZE+CONST_DIV_SIZE -1 downto CONST_DIV_SIZE);   
                DIVISION_DONE<='1';
            end if;
        else
            flag<='0';
            DIVISION_DONE<='0'; 
           
        end if;     
    end if;
end process;

RESULT<=std_logic_vector(result_s);
DivConstant<=to_unsigned(Value_CONST_DIV,CONST_DIV_SIZE); 
end Behavioral;
