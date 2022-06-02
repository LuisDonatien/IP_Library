library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity TOP_PI_tb is
--  Port ( );
end TOP_PI_tb;

architecture Behavioral of TOP_PI_tb is
  constant TIMES: integer range 1 to 100:= 100;
  constant Duty_SIZE:integer range 10 to 12:=10;
  constant KP: integer range 0 to 255:=40;
  constant KI: integer range 0 to 255:=0;
    signal CLK:     std_logic;
    signal RESET:   std_logic;
    signal A,As,Ass:       std_logic;
    signal B:       std_logic;
    signal C:       std_logic;
    signal ExternalP:  std_logic;
    signal ExternalI:  std_logic;
    signal Set_Point:  std_logic_vector(19 downto 0);
    signal Proportional:  std_logic_vector(7 downto 0);
    signal Integral    :  std_logic_vector(7 downto 0);
    signal Output:  std_logic_vector(Duty_SIZE-1 downto 0);
    signal ERROR:   std_logic;
    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
    constant PERIOD: time :=5ms; --Clock period 50MHZ --Sensores HALL
    COMPONENT TOP_PID
  Generic(
  TIMES: integer range 1 to 100:= 100; --100ms de enable muestreo
  Duty_SIZE:integer range 10 to 12:=10;
  KP: integer range 0 to 255:=0;
  KI: integer range 0 to 255:=0
  );
  Port ( 
    CLK:    in std_logic;
    RESET:  in std_logic;
    A:      in std_logic;
    B:      in std_logic;
    C:      in std_logic;
    ExternalP: in std_logic;
    ExternalI: in std_logic;
    Set_Point:  in std_logic_vector(19 downto 0);
    Proportional: in std_logic_vector(7 downto 0);
    Integral    : in std_logic_vector(7 downto 0);
    Output: out std_logic_vector(Duty_SIZE-1 downto 0);
    ERROR:  out std_logic
    );
END COMPONENT;
begin

uutPID: TOP_PID GENERIC MAP(
  TIMES =>TIMES
)
PORT MAP(
    CLK        =>CLK,
    RESET      =>RESET,
    A          =>A,
    B          =>B,
    C          =>C,
    ExternalP   =>ExternalP,
    ExternalI   =>ExternalI,
    Set_Point     =>Set_Point,
    Proportional  =>Proportional,
    Integral      =>Integral,
    Output  =>Output,
    ERROR   =>ERROR
  );
--Generacion señales-----

Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;


RESET<='1', '0' after 1ms, '1' after 1ms + 200 ns, '0' after 2 ms, '1' after 13 ms ,'0' after 15ms + 20ns;

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

SET_POINT<=conv_std_logic_vector(166666, 20),conv_std_logic_vector(52083,20) after 16ms ;
Proportional<=conv_std_logic_vector(40, 8);
EXTERNALP<='1';
EXTERNALI<='0';
INTEGRAL<=(others=>'0');
end Behavioral;