library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PWM_Decoder_tb is

--Port()

end PWM_Decoder_tb;

architecture Behavioral of PWM_Decoder_tb is
	signal RESET      :  std_logic;
    signal A,As,Ass          :  std_logic;
    signal B          :  std_logic;
    signal C          :  std_logic;
    signal CLK        :  std_logic;
    signal PWM_INH    :  std_logic;
    signal PWM_INL    :  std_logic; 
    signal Sentido    :  std_logic; 
    signal PWM_AH       :  std_logic;
    signal PWM_AL       :  std_logic;
    signal PWM_BH       :  std_logic;
    signal PWM_BL       :  std_logic;
    signal PWM_CH       :  std_logic;
    signal PWM_CL       :  std_logic;
    signal ERROR      :  std_logic;

COMPONENT PWM_Decoder
Port(
	RESET      : in std_logic;
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    CLK        : in std_logic;
    PWM_INH    : in std_logic;
    PWM_INL    : in std_logic;
    Sentido    : in std_logic;
    PWM_AH       : out std_logic;
    PWM_AL       : out std_logic;
    PWM_BH       : out std_logic;
    PWM_BL       : out std_logic;
    PWM_CH       : out std_logic;
    PWM_CL       : out std_logic;
    ERROR      : out std_logic
);
END COMPONENT;   

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
    constant PERIOD: time :=400 us; --Clock period 50MHZ
    constant PWMIN: time :=10 us; --Clock period PWM

begin

uut: PWM_Decoder PORT MAP(
	RESET =>RESET,
    A       =>A,
    B       =>B,
    C       =>C,
    CLK     =>CLK,
    PWM_INH =>PWM_INH,
    PWM_INL =>PWM_INL,
    Sentido =>Sentido,
    PWM_AH  =>PWM_AH,
    PWM_AL  =>PWM_AL,
    PWM_BH  =>PWM_BH,
    PWM_BL  =>PWM_BL,
    PWM_CH  =>PWM_CH,
    PWM_CL  =>PWM_CL,
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


Generar_Reloj_PWM: process
begin
         PWM_INH<='1';
    wait for (PWMIN/2);
         PWM_INH<='0';
    wait for (PWMIN/2);
end process;

RESET<='1', '0' after 1ms, '1' after 1ms + 200 ns, '0' after 2 ms, '1' after 13 ms ,'0' after 13ms + 20ns;

 clockA : process
    begin 
PWM_INL<='0';        
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

Sentido<='0','1'after 50 ms ,'0' after 100ms;
end architecture;