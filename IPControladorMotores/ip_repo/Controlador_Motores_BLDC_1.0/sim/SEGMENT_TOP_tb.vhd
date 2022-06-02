
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity SEGMENT_TOP_tb is
--  Port ( );
end SEGMENT_TOP_tb;

architecture Behavioral of SEGMENT_TOP_tb is
  signal CLK :      std_logic;
  signal COUNT:     std_logic_vector(11 downto 0);
  signal Segment:   std_logic_vector(6 downto 0);
  signal Display:   std_logic_vector(3 downto 0);
  
 COMPONENT SEGMENT_TOP
  Port ( 
  CLK : in std_logic;
  COUNT: in std_logic_vector(11 downto 0);
  Segment: out std_logic_vector(6 downto 0);
  Display: out std_logic_vector(3 downto 0)
  ); 
 END COMPONENT;
        constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
begin
uut: SEGMENT_TOP PORT MAP(
  CLK       =>CLK, 
  COUNT     =>COUNT,
  Segment   =>Segment,
  Display   =>Display
);

--Generacion Señales--
Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;
COUNT<=std_logic_vector(to_unsigned(4320,12)),std_logic_vector(to_unsigned(1278,12)) after 50ms +986 us,std_logic_vector(to_unsigned(2038,12)) after 100ms + 500ns, std_logic_vector(to_unsigned(24,12)) after 150ms + 350us+10ns;
end Behavioral;
