library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PI_TIMER_tb is
--  Port ( );
end PI_TIMER_tb;

architecture Behavioral of PI_TIMER_tb is
  signal CLK   :  std_logic;
  signal RESET :  std_logic;
  signal Input :  std_logic;
  signal Count :  std_logic_vector(19 downto 0); 
COMPONENT PID_TIMER
  Port ( 
  CLK   : in std_logic;
  RESET : in std_logic;
  Input : in std_logic;
  Count : out std_logic_vector(19 downto 0) 
  );
END COMPONENT;

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
    constant STEPs: time :=1ms + 602us;--6ms+944us; --Clock period FSM HALL
begin

uut_PIDTime: PID_TIMER PORT MAP(
  CLK   =>CLK,
  RESET =>RESET,
  Input =>Input,
  Count =>Count 
);
--Generacion señales-----

Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;


Generar_FSMHALL: process
begin
         Input<='1';
    wait for (STEPs/2);
         Input<='0';
    wait for (STEPs/2);
end process;
RESET<='1', '0' after 1ms, '1' after 1ms + 200 ns, '0' after 2 ms, '1' after 13 ms ,'0' after 13ms + 20ns;

 

end Behavioral;
