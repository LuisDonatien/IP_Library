library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PI_HALLFSM_tb is
--  Port ( );
end PI_HALLFSM_tb;

architecture Behavioral of PI_HALLFSM_tb is
	signal RESET      :  std_logic;
    signal A,As,Ass          :  std_logic;
    signal B          :  std_logic;
    signal C          :  std_logic;
    signal CLK        :  std_logic;
    signal STEP       :  std_logic;
    signal ERROR      :  std_logic;
COMPONENT PID_HALLFSM
Port(
	RESET      : in std_logic;
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    CLK        : in std_logic;
    STEP       : out std_logic;
    ERROR      : out std_logic
);
END COMPONENT;

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
    constant PERIOD: time :=400 us; --Clock period 50MHZ --Sensores HALL
begin


uut_PID_HALLSENSE: PID_HALLFSM PORT MAP(
	RESET      =>RESET,
    A          =>A,
    B          =>B,
    C          =>C,
    CLK        =>CLK,
    STEP       =>STEP,
    ERROR      =>ERROR
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
