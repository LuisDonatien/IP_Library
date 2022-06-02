library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLOCK_DISPLAY_tb is
--  Port ( );
end CLOCK_DISPLAY_tb;

architecture Behavioral of CLOCK_DISPLAY_tb is
signal   CLK:  std_logic;
signal   STEP: std_logic_vector(1 downto 0);

COMPONENT CLOCK_DISPLAY
  Port ( 
  CLK: in std_logic;
  STEP: out std_logic_vector(1 downto 0)
  );
END COMPONENT;
        constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
begin
uut: CLOCK_DISPLAY PORT MAP(
  CLK   =>CLK,
  STEP  =>STEP
);

--Generacion Señales--
Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;

end Behavioral;
