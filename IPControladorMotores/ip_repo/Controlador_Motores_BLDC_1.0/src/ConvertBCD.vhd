library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.std_logic_arith.all;


entity ConvertBCD is
  Port ( 
  Number: in std_logic_vector(11 downto 0);
  Digit0: out std_logic_vector(6 downto 0);
  Digit1: out std_logic_vector(6 downto 0);
  Digit2: out std_logic_vector(6 downto 0);
  Digit3: out std_logic_vector(6 downto 0)
  );
end ConvertBCD;

architecture Behavioral of ConvertBCD is
begin
Digit0 <= conv_std_logic_vector(conv_integer(unsigned(Number))/1000,7);
Digit1 <= conv_std_logic_vector((conv_integer(unsigned(Number))/100) - ((conv_integer(unsigned(Number))/ 1000)*10),7);
Digit2 <= conv_std_logic_vector((conv_integer(unsigned(Number))/10) - ((conv_integer(unsigned(Number))/ 100) * 10),7);
Digit3 <= conv_std_logic_vector(conv_integer(unsigned(Number)) - ((conv_integer(unsigned(Number))/ 10) * 10),7) ;
end Behavioral;
