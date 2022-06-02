library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity PI_tb is
--  Port ( );
end PI_tb;

architecture Behavioral of PI_tb is
  constant Duty_SIZE:integer range 10 to 12:=10;
  constant KP: integer range 0 to 255:=10;
  constant KI: integer range 0 to 255:=1;
    signal CLK:     std_logic;
    signal RESET:   std_logic;
    signal Enable:  std_logic;
    signal Sensor :  std_logic_vector(19 downto 0);
    signal ExternalP:  std_logic;
    signal ExternalI:  std_logic;
    signal Set_Point:  std_logic_vector(19 downto 0);
    signal Proportional:  std_logic_vector(7 downto 0);
    signal Integral    :  std_logic_vector(7 downto 0);
    signal Output:  std_logic_vector(Duty_SIZE-1 downto 0);
--Referencia para simular---
signal set_s:  std_logic_vector(15 downto 0);
signal sensor_s:  std_logic_vector(15 downto 0);
COMPONENT PID_PID
GENERIC (
  Duty_SIZE:integer range 10 to 12:=10;
  KP: integer range 0 to 255:=10;
  KI: integer range 0 to 255:=4
);
PORT(
    CLK:    in std_logic;
    RESET:  in std_logic;
    Enable: in std_logic;
    Sensor : in std_logic_vector(19 downto 0);
    ExternalP: in std_logic;
    ExternalI: in std_logic;
    Set_Point:  in std_logic_vector(19 downto 0);
    Proportional: in std_logic_vector(7 downto 0);
    Integral    : in std_logic_vector(7 downto 0);
    Output: out std_logic_vector(Duty_SIZE-1 downto 0)
);
END COMPONENT;

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
    constant CLK_ENABLE : time := 1 ms; --Clock period 100MHz  
begin

uut_PID: PID_PID PORT MAP(
    CLK     =>CLK,
    RESET   =>RESET,
    Enable  =>Enable,
    Sensor  =>Sensor,
    ExternalP =>ExternalP,
    ExternalI =>ExternalI,
    Set_Point   =>Set_Point,
    Proportional =>Proportional,
    Integral     =>Integral,
    Output      =>Output
);
--Generacion señales-----

Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;

ENABLE<='0','1' after 3ms+20ns,'0' after 3ms+30ns, '1' after 3ms+200ns, '0' after 3ms+220ns,'1' after 3ms+320ns,'0' after 3ms+340ns, '1' after 3ms+450ns,'0' after 3ms+460ns,'1' after 3ms+620ns,'0' after 3ms+600ns;

RESET<='1', '0' after 1ms, '1' after 1ms + 200 ns, '0' after 2 ms,'1' after 3ms ,'0' after 3ms+20ns, '1' after 13 ms ,'0' after 13ms + 20ns;

SET_POINT<=conv_std_logic_vector(166666, 20),conv_std_logic_vector(52083,20) after 4ms ;
Sensor<=conv_std_logic_vector(166661, 20),conv_std_logic_vector(166666, 20) after 1ms+400ns ,(others=>'1')  after 2ms,  conv_std_logic_vector(186266,20) after 3ms+190ns, conv_std_logic_vector(135200,20) after 3ms+290ns, conv_std_logic_vector(165562,20) after 3ms+445ns ;
set_s<=SET_POINT(19 downto 4);
sensor_s<=SENSOR(19 downto 4);
Proportional<=conv_std_logic_vector(40, 8);
EXTERNALP<='0'; --Para activar variables externas PI
EXTERNALI<='0';
INTEGRAL<=(others=>'0');
end Behavioral;