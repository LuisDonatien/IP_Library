library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity PWM_Generator_tb is

end PWM_Generator_tb;

architecture Behavioral of PWM_Generator_tb is
  constant Duty_SIZE: integer range 10 to 12:=10;
  constant COMPLEMENTARIO: boolean:=TRUE;
  signal CLK:           std_logic;
  signal RESET:         std_logic;
  signal Duty:          std_logic_vector(Duty_SIZE-1 downto 0);
  signal PWM_H:         std_logic;
  signal PWM_L:         std_logic;


COMPONENT PWM_Generator
Generic(
    Frecuencies: integer range 1000 to 2500:= 1000;
    DeadBand: integer range 3 to 10:=4;
    COMPLEMENTARIO: boolean:=FALSE;
    Duty_SIZE: integer range 10 to 12:=10
);
  Port ( 
  CLK:          in std_logic;
  RESET:        in std_logic;
  Duty:         in std_logic_vector(Duty_SIZE-1 downto 0);
  PWM_H:        out std_logic;
  PWM_L:        out std_logic
  );
END COMPONENT;

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
begin

uut: PWM_GENERATOR PORT MAP(
  CLK   =>CLK,
  RESET =>RESET,
  Duty  =>Duty,
  PWM_H =>PWM_H,
  PWM_L =>PWM_L
);
--Generacion señales---
    
    Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;

RESET<='1', '0' after 1ms, '1' after 1ms + 200 ns, '0' after 2 ms, '1' after 13 ms ,'0' after 13ms + 20ns;

Duty<=std_logic_vector(to_unsigned(400,Duty_SIZE)),std_logic_vector(to_unsigned(1000,Duty_SIZE)) after 10ms +986 us,std_logic_vector(to_unsigned(500,Duty_SIZE)) after 12ms + 500ns, std_logic_vector(to_unsigned(0,Duty_SIZE)) after 17ms + 350us+10ns, 
std_logic_vector(to_unsigned(300,Duty_SIZE)) after 17ms +380us , std_logic_vector(to_unsigned(10,Duty_SIZE)) after 18ms + 500ns ,std_logic_vector(to_unsigned(500,Duty_SIZE)) after 20ms + 500ns ;
end Behavioral;