library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Top_Controlador_tb is
--  Port ( );
end Top_Controlador_tb;

architecture Behavioral of Top_Controlador_tb is
    constant PWM_Frecuencies: integer range 1000 to 2500:= 1000;
    constant Duty_SIZE: integer range 10 to 12:=10;
    constant PWM_DeadBand: integer range 3 to 10:=3;
    constant COMPLEMENTARIO  : boolean:=FALSE;
    constant SAMPLES: integer range 1 to 100:= 40;
    constant KP: integer range 0 to 255:=0;
    constant KI: integer range 0 to 255:=0;

    signal CLK:          std_logic;
    signal RESET:        std_logic;  
    signal A,As,Ass          :  std_logic;
    signal B          :  std_logic;
    signal C          :  std_logic;
    signal A_out       :  std_logic;
    signal B_out       :  std_logic;
    signal C_out       :  std_logic;
    signal Sentido     :  std_logic;
    signal ExternalP  :  std_logic;      
    signal ExternalI  :  std_logic;     
    signal Set_Point    :  std_logic_vector(19 downto 0);
    signal PROPORTIONAL :  std_logic_vector(7 downto 0);
    signal INTEGRAL     :  std_logic_vector(7 downto 0);
    signal PWM_AH       :  std_logic;
    signal PWM_AL       :  std_logic;
    signal PWM_BH       :  std_logic;
    signal PWM_BL       :  std_logic;
    signal PWM_CH       :  std_logic;
    signal PWM_CL       :  std_logic;
    signal PWM_HIGH    :  std_logic;
    signal PWM_LOW     :  std_logic;
    signal ERROR      :   std_logic;
    signal Duty_Led   :  std_logic_vector(Duty_SIZE-1 downto 0);
    signal Count      :  std_logic_vector(19 downto 0);

COMPONENT TOP_CONTROLADOR
  Generic(
    PWM_Frecuencies: integer range 1000 to 2500:= 1000;
    Duty_SIZE: integer range 10 to 12:=10;
    PWM_DeadBand: integer range 3 to 10:=3;
    COMPLEMENTARIO  : boolean:=FALSE;
    SAMPLES: integer range 1 to 100:= 50;
    KP: integer range 0 to 255:=0;
    KI: integer range 0 to 255:=0
    
  );
  Port ( 
    CLK:          in std_logic;
    RESET:        in std_logic;  
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    A_out       : out std_logic;
    B_out       : out std_logic;
    C_out       : out std_logic;
    Sentido     : in std_logic;
    ExternalP  : in std_logic;      
    ExternalI  : in std_logic;      
    Set_Point    : in std_logic_vector(19 downto 0);
    PROPORTIONAL : in std_logic_vector(7 downto 0);
    INTEGRAL     : in std_logic_vector(7 downto 0);
    PWM_AH       : out std_logic;
    PWM_AL       : out std_logic;
    PWM_BH       : out std_logic;
    PWM_BL       : out std_logic;
    PWM_CH       : out std_logic;
    PWM_CL       : out std_logic;
    PWM_HIGH    : out std_logic;
    PWM_LOW     : out std_logic;
    ERROR      : out std_logic;
    Duty_Led   : out std_logic_vector(Duty_SIZE-1 downto 0);
    Count      : out std_logic_vector(19 downto 0)
  );
END COMPONENT;

    constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
    constant PERIODHALL: time :=400 us; --Clock period 50MHZ
begin


uut_Controlador: TOP_CONTROLADOR 
  GENERIC MAP(
    PWM_Frecuencies =>PWM_Frecuencies,
    Duty_SIZE       =>Duty_Size,
    PWM_DeadBand    =>PWM_DeadBand,
    COMPLEMENTARIO  =>COMPLEMENTARIO,
    SAMPLES         =>SAMPLES,
    KP              =>KP,
    KI              =>KI    
  )
  PORT MAP ( 
    CLK         =>CLK,
    RESET       =>RESET,
    A           =>A,
    B           =>B,
    C           =>C,
    A_out       =>A_out,
    B_out       =>B_out,
    C_out       =>C_out,
    Sentido     =>Sentido,
    ExternalP   =>ExternalP,
    ExternalI   =>ExternalI,
    Set_Point       =>Set_Point,
    PROPORTIONAL    =>PROPORTIONAL,
    INTEGRAL    =>INTEGRAL,
    PWM_AH      =>PWM_AH,
    PWM_AL      =>PWM_AL,
    PWM_BH      =>PWM_BH,
    PWM_BL      =>PWM_BL,
    PWM_CH      =>PWM_CH,
    PWM_CL      =>PWM_CL,
    PWM_HIGH    =>PWM_HIGH,
    PWM_LOW     =>PWM_LOW,
    ERROR       =>ERROR,
    Duty_Led    =>Duty_Led,
    Count       =>Count
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


RESET<='1', '0' after 1ms, '1' after 1ms + 200 ns, '0' after 2 ms,'1' after 3ms ,'0' after 3ms+20ns, '1' after 13 ms ,'0' after 13ms + 20ns;

SET_POINT<=std_logic_vector(to_unsigned(166666, 20)),std_logic_vector(to_unsigned(52083,20)) after 20ms ;


 clockA : process
    begin 
        
        As <= '0';
        wait for 0.5*PERIODHALL;
        As <= '1' ;
        wait for 0.5*PERIODHALL;
end process;
ExternalP<='0','1' after 50 ms;
ExternalI<='0';
PROPORTIONAL<=X"71";
INTEGRAL<=(others=>'0');
Sentido<='0','1' after 100ms; --Cambio de sentido. 
---clockB
B<=transport A after 2*(PERIODHALL/6) ;
---clockC
C<= transport A after 4*(PERIODHALL/6);
A<=As OR Ass;
Ass<='0','1' after 10ms , '0' after 12ms+30 ns; --Modificar señal buscando el error
end Behavioral;
