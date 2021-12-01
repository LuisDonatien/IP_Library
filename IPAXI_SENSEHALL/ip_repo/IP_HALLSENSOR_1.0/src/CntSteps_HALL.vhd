
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity CntSteps_HALL is
Generic(
 SIZE : integer   --Size of Vector COUNT 
);
Port ( 
    CLK :   in std_logic;
    RESET : in std_logic;  -- Double reset: one from lector/calculator rpm and the other from general reset.
    INPUT : in std_logic;
    COUNT : out std_logic_vector(SIZE-1 downto 0)
);
end CntSteps_HALL;

architecture Behavioral of CntSteps_HALL is
    signal Count_sig : unsigned(SIZE-1 downto 0);
    signal CODE: std_logic_vector(16-1 downto 0):=std_logic_vector(to_unsigned(34464,16));
begin

Counting_pulse:process(CLK,RESET)

begin 
    if RESET= '1' then
        Count_sig<=to_unsigned(0,SIZE);
    elsif rising_edge(CLK) then
        if INPUT='1' then
           Count_sig<=Count_sig+1;
        end if;
    end if;
    
end process;
COUNT<=std_logic_vector(Count_sig);
end Behavioral;
