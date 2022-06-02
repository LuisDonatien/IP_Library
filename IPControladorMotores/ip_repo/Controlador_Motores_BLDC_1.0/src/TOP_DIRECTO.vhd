library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TOP_DIRECTO  is
  Generic(
    PWM_Frecuencies: integer range 1000 to 2500:= 1000;
    Duty_SIZE: integer range 10 to 12:=10;
    PWM_DeadBand: integer range 3 to 10:=3;
    COMPLEMENTARIO  : boolean:=FALSE    
  );
  Port ( 
    CLK:          in std_logic;
    RESET:        in std_logic;  
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    Sentido     :  in std_logic;
    Duty        : in std_logic_vector(Duty_SIZE-1 downto 0);
    A_out       : out std_logic;
    B_out       : out std_logic;
    C_out       : out std_logic;
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
end TOP_DIRECTO  ;

architecture Behavioral of TOP_DIRECTO  is
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
    Sentido     :  in std_logic;
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

COMPONENT PID_TOPSENSOR
  Port ( 
  CLK:      in std_logic;
  RESET:    in std_logic;
  A:        in std_logic;
  B:        in std_logic;
  C:        in std_logic;
  Count:    out std_logic_vector(19 downto 0);
  ERROR:    out std_logic
  );
END COMPONENT;

signal As,Bs,Cs: std_logic;
signal Duty_s: std_logic_vector(Duty_Size-1 downto 0);
signal SENSE_s,ERROR_s,ERROR_ss: std_logic;
signal HALL_s: std_logic_vector(2 downto 0);
signal Count_s:std_logic_vector(19 downto 0);
signal Set_Point_s:  std_logic_vector(19 downto 0);
signal Proportional_s: std_logic_vector(15 downto 0);
signal Set_Point    :  std_logic_vector(19 downto 0);
signal PROPORTIONAL :  std_logic_vector(15 downto 0);
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
    Duty            =>Duty,
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

uut5: PID_TOPSENSOR PORT MAP(
  CLK       =>CLK,
  RESET     =>RESET,
  A         =>As,
  B         =>Bs,
  C         =>Cs,
  Count     =>Count,
  ERROR     =>ERROR_s
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

Duty_Led<=Duty;

--Set_Point_s<=std_logic_vector(to_unsigned(83333,20)) when Switch(10 downto 8)="100"else
          --  std_logic_vector(to_unsigned(125000,20)) when  Switch(10 downto 8)="010"else
          --  std_logic_vector(to_unsigned(166666,20)) when  Switch(10 downto 8)="001"else
          --  std_logic_vector(to_unsigned(125000,20));
end Behavioral;