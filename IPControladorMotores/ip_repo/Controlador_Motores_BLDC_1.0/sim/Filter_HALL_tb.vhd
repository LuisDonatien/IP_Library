
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Filter_HALL_tb is
--  Port ( );
end Filter_HALL_tb;

architecture Behavioral of Filter_HALL_tb is
  constant Delay: integer:= 10;           -- Delay*10

  signal CLK:    std_logic;
  signal INPUT:  std_logic;
  signal OUTPUT: std_logic;
  
  COMPONENT Filter_HALL
  Generic(
  Delay: integer:= 10           -- Delay*10^3
  );
  Port ( 
  CLK: in std_logic;
  INPUT: in std_logic;
  OUTPUT: out std_logic
  );
  END COMPONENT;

      constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
begin

uut: Filter_HALL PORT MAP(
  CLK   =>CLK,
  INPUT =>INPUT,
  OUTPUT=>OUTPUT
);


--Generacion de señales---
Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;

--Señal Asincrona de entrada--

INPUT<='1','0' after 1ms, '1' after 1ms + 5ns, '0' after 1ms + 32ns , '1' after 1ms +48 ns,'0' after 1ms+ 54ns;

end Behavioral;
