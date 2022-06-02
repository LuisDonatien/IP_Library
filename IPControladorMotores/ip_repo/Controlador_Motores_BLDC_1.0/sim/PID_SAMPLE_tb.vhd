library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PI_SAMPLE_tb is
--  Port ( );
end PI_SAMPLE_tb;

architecture Behavioral of PI_SAMPLE_tb is
constant   TIMES: integer range 1 to 100:= 10;
  signal CLK:   std_logic;
  signal RESET: std_logic;
  signal Enable:std_logic;
  signal Flag: std_logic;


COMPONENT PID_SAMPLE
  generic(
  TIMES: integer range 1 to 100:=5
  );
  Port ( 
  CLK:  in std_logic;
  RESET: in std_logic;
  Enable: in std_logic;
  Flag: out std_logic 
  );
END COMPONENT;

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
begin

uut_PID_SAMP: PID_SAMPLE GENERIC MAP(
  TIMES=> TIMES
  )
  PORT MAP ( 
  CLK =>CLK,
  RESET =>RESET,
  Enable =>Enable,
  Flag  =>Flag
  );

--Generacion señales-----

Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;

RESET<='1', '0' after 1ms, '1' after 1ms + 200 ns, '0' after 2 ms, '1' after 13 ms ,'0' after 13ms + 20ns;
ENABLE<='1';

end Behavioral;
