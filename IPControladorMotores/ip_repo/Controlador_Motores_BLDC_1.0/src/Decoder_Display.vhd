library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.std_logic_arith.all;

entity Decoder_Display is
  Port ( 
  BCD:  in   std_logic_vector(6 downto 0);
  Segment: out  std_logic_vector(6 downto 0) 
  );
end Decoder_Display;

architecture Behavioral of Decoder_Display is

begin
ENCODER_PROC : process(BCD)
begin

  case conv_integer(unsigned(BCD)) is
 
    when 0 => 
        Segment <= "0111111";
    when 1 => 
        Segment <= "0000110";
    when 2 => 
        Segment <= "1011011";
    when 3 => 
        Segment <= "1001111";
    when 4 => 
        Segment <= "1100110";
    when 5 => 
        Segment <= "1101101";
    when 6 => 
        Segment <= "1111101";
    when 7 => 
        Segment <= "0000111";
    when 8 => 
        Segment <= "1111111";
    when 9 => 
        Segment <= "1101111";
   when others=>
        Segment <=  "0000000";
    end case;
end process;

end Behavioral;
