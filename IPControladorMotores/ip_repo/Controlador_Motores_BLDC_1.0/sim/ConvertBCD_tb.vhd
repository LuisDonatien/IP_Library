library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity ConvertBCD_tb is
--  Port ( );
end ConvertBCD_tb;

architecture Behavioral of ConvertBCD_tb is
  signal Number:  std_logic_vector(11 downto 0);
  signal Digit0:  std_logic_vector(6 downto 0);
  signal Digit1:  std_logic_vector(6 downto 0);
  signal Digit2:  std_logic_vector(6 downto 0);
  signal Digit3:  std_logic_vector(6 downto 0);
  
  COMPONENT ConvertBCD
  Port ( 
  Number: in std_logic_vector(11 downto 0);
  Digit0: out std_logic_vector(6 downto 0);
  Digit1: out std_logic_vector(6 downto 0);
  Digit2: out std_logic_vector(6 downto 0);
  Digit3: out std_logic_vector(6 downto 0)
  );  
  END COMPONENT;
begin

uut: ConvertBCD PORT MAP(
  Number    =>Number,
  Digit0    =>Digit0,
  Digit1    =>Digit1,
  Digit2    =>Digit2,
  Digit3    =>Digit3
);


Number<=std_logic_vector(to_unsigned(4320,12)),std_logic_vector(to_unsigned(1278,12)) after 10ms +986 us,std_logic_vector(to_unsigned(2038,12)) after 12ms + 500ns, std_logic_vector(to_unsigned(24,12)) after 17ms + 350us+10ns;
end Behavioral;
