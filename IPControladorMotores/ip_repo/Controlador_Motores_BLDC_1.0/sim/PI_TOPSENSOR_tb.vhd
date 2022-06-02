library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PI_TOPSENSOR_tb is
--  Port ( );
end PI_TOPSENSOR_tb;

architecture Behavioral of PI_TOPSENSOR_tb is
  signal CLK:       std_logic;
  signal RESET:     std_logic;
  signal A,As,Ass:         std_logic;
  signal B:         std_logic;
  signal C:         std_logic;
  signal Count:     std_logic_vector(19 downto 0);
  signal ERROR:     std_logic;
COMPONENT PID_TOPSENSOR
Port(
  CLK:      in std_logic;
  RESET:    in std_logic;
  A:        in std_logic;
  B:        in std_logic;
  C:        in std_logic;
  Count:    out std_logic_vector(19 downto 0);
  ERROR:    out std_logic
);
END COMPONENT;

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
    constant PERIOD: time :=6ms+944us; --Clock period 50MHZ --Sensores HALL
begin

uut_TOP_SENSOR: PID_TOPSENSOR PORT MAP(
  CLK   =>CLK,
  RESET =>RESET,
  A     =>A,
  B     =>B,
  C     =>C,
  Count =>Count,
  ERROR =>ERROR
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

 clockA : process
    begin 
        
        As <= '0';
        wait for 0.5*PERIOD;
        As <= '1' ;
        wait for 0.5*PERIOD;
end process;

---clockB
B<=transport A after 2*(PERIOD/6) ;
---clockC
C<= transport A after 4*(PERIOD/6);
A<=As OR Ass;

Ass<='0','1' after 10ms , '0' after 12ms+30 ns; --Modificar señal buscando el error
end Behavioral;


