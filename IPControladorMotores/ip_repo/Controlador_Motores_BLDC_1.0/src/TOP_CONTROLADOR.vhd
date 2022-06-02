library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity TOP_CONTROLADOR  is
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
    ExternalP  : in std_logic;      --Flag de uso de constante externa y no generica
    ExternalI  : in std_logic;      --Flag de uso de constante externa y no generica
    --A_PMOD      : out std_logic;
    --B_PMOD      : out std_logic;
    --C_PMOD      : out std_logic;
    --Switch     : in std_logic_vector(10 downto 0);
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
end TOP_CONTROLADOR ;

architecture Behavioral of TOP_CONTROLADOR is
COMPONENT Top_PWM
Generic(
    Frecuencies: integer range 1000 to 2500:= 1000;
    Duty_SIZE: integer range 10 to 12:=10;
    DeadBand: integer range 3 to 10:=5;
    COMPLEMENTARIO  : boolean:=FALSE;
    Delay_States: integer range 4 to 10:=5
);
  Port ( 
    CLK:          in std_logic;
    RESET:        in std_logic;
    Duty:         in std_logic_vector(Duty_Size-1 downto 0);
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    Sentido    : in std_logic;
    PWM_AH       : out std_logic;
    PWM_AL       : out std_logic;
    PWM_BH       : out std_logic;
    PWM_BL       : out std_logic;
    PWM_CH       : out std_logic;
    PWM_CL       : out std_logic;
    PWM_HIGH    : out std_logic;
    PWM_LOW     : out std_logic;
    ERROR      : out std_logic     
);
END COMPONENT;

COMPONENT Filter_HALL 
  Generic(
  Delay: integer:= 10      -- Delay*10^3
  );
  Port ( 
  CLK: in std_logic;
  INPUT: in std_logic;
  OUTPUT: out std_logic
  );
END COMPONENT;

COMPONENT TOP_PID
  Generic(
  TIMES: integer range 1 to 100:= 100;
  Duty_SIZE: integer range 10 to 12:=10;
  KP: integer range 0 to 255:=0;
  KI: integer range 0 to 255:=0
  );
  Port ( 
    CLK:    in std_logic;
    RESET:  in std_logic;
    A:      in std_logic;
    B:      in std_logic;
    C:      in std_logic;
    ExternalP  : in std_logic;      --Flag de uso de constante externa y no generica
    ExternalI  : in std_logic;      --Flag de uso de constante externa y no generica
    Set_Point:  in std_logic_vector(19 downto 0);
    Proportional: in std_logic_vector(7 downto 0);
    Integral    : in std_logic_vector(7 downto 0);
    Output: out std_logic_vector(Duty_SIZE-1 downto 0);
    Count: out std_logic_vector(19 downto 0);
    ERROR:  out std_logic
    );
END COMPONENT;

signal As,Bs,Cs: std_logic;
signal Duty_s: std_logic_vector(Duty_Size-1 downto 0);
signal SENSE_s,ERROR_s,ERROR_ss: std_logic;
signal HALL_s: std_logic_vector(2 downto 0);
signal Count_s:std_logic_vector(19 downto 0);
signal Set_Point_s:  std_logic_vector(19 downto 0);
signal Proportional_s: std_logic_vector(15 downto 0);
--signal Set_Point    :  std_logic_vector(19 downto 0);
--signal PROPORTIONAL :  std_logic_vector(7 downto 0);
--signal INTEGRAL :  std_logic_vector(7 downto 0);
--signal ExternalP  :  std_logic;      --Flag de uso de constante externa y no generica
--signal ExternalI  :  std_logic;      --Flag de uso de constante externa y no generica
begin

uu0_Top_PWM: Top_PWM 
GENERIC MAP(
    Frecuencies =>PWM_Frecuencies,
    DeadBand    =>PWM_DeadBand,
    Duty_SIZE   =>Duty_SIZE,
    COMPLEMENTARIO       =>COMPLEMENTARIO  
)
PORT MAP(
    CLK             =>CLK,
    RESET           =>RESET,
    Duty            =>Duty_s,
    A               =>As,
    B               =>Bs,
    C               =>Cs,
    Sentido         =>Sentido,
    PWM_AH          =>PWM_AH,
    PWM_AL          =>PWM_AL,
    PWM_BH          =>PWM_BH,
    PWM_BL          =>PWM_BL,
    PWM_CH          =>PWM_CH,
    PWM_CL          =>PWM_CL,
    PWM_HIGH        =>PWM_HIGH,
    PWM_LOW         =>PWM_LOW,
    ERROR           =>ERROR
);
uut1_Filter: Filter_HALL PORT MAP(
  CLK       =>CLK,
  INPUT     =>A,
  OUTPUT    =>As
);
uut2_Filter: Filter_HALL PORT MAP(
  CLK       =>CLK,
  INPUT     =>B,
  OUTPUT    =>Bs
);
uut3_Filter: Filter_HALL PORT MAP(
  CLK       =>CLK,
  INPUT     =>C,
  OUTPUT    =>Cs
);

uut5: TOP_PID GENERIC MAP(
  TIMES     =>SAMPLES,
  Duty_SIZE =>Duty_SIZE,
  KP    =>KP,
  KI    =>KI
)
PORT MAP(
    CLK        =>CLK,
    RESET      =>RESET,
    A          =>As,
    B          =>Bs,
    C          =>Cs,
    ExternalP   =>ExternalP,
    ExternalI   =>ExternalI,
    Set_Point     =>Set_Point,
    Proportional  =>Proportional,
    Integral      =>Integral,
    Output  =>Duty_s,
    Count   =>Count,
    ERROR   =>ERROR_ss
  );


--Duty_s <= std_logic_vector(to_unsigned(65,32)) when switch= "001" else
--          std_logic_vector(to_unsigned(400,32)) when switch= "010" else
--          std_logic_vector(to_unsigned(1000,32)) when switch= "100" else
--          std_logic_vector(to_unsigned(1800,32)) when switch= "011" else
--          std_logic_vector(to_unsigned(2000,32)) when switch= "111" else
--          std_logic_vector(to_unsigned(0,32)) ;
--Salidas Hall Sensor--
A_out<=As;
B_out<=Bs;
C_out<=Cs;
--A_PMOD<=As;
--B_PMOD<=Bs;
--C_PMOD<=Cs;
HALL_s(0)<=As;
HALL_s(1)<=Bs;
HALL_s(2)<=Cs;
--Proportional_s<="00000000" & Switch(7 downto 0);
--Duty_s(31 downto 10)<=(others=>'0');

Duty_Led<=Duty_s;

--Set_Point_s<=std_logic_vector(to_unsigned(83333,20)) when Switch(10 downto 8)="100"else
          --  std_logic_vector(to_unsigned(125000,20)) when  Switch(10 downto 8)="010"else
          --  std_logic_vector(to_unsigned(166666,20)) when  Switch(10 downto 8)="001"else
          --  std_logic_vector(to_unsigned(125000,20));
end Behavioral;