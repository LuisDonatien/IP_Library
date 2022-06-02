library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP_PID is
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
    ExternalP: in std_logic;
    ExternalI: in std_logic;
    Set_Point:  in std_logic_vector(19 downto 0);
    Proportional: in std_logic_vector(7 downto 0);
    Integral    : in std_logic_vector(7 downto 0);
    Output: out std_logic_vector(Duty_SIZE-1 downto 0);
    Count:  out std_logic_vector(19 downto 0);
    ERROR:  out std_logic
  );
end TOP_PID;

architecture Behavioral of TOP_PID is

COMPONENT PID_PID
Generic(
  Duty_SIZE: integer range 10 to 12:=10;
  KP: integer range 0 to 255:=0;
  KI: integer range 0 to 255:=0
);
Port(
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

COMPONENT PID_SAMPLE
  generic(
  TIMES: integer range 1 to 100:= 100
  );
  Port ( 
  CLK:  in std_logic;
  RESET: in std_logic;
  Enable: in std_logic;
  Flag: out std_logic
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
---Señales----
signal Flag_s: std_logic;
signal Enable: std_logic:='1';
signal Sensor_s: std_logic_vector(19 downto 0);
begin

uut_PID: PID_PID GENERIC MAP(
    Duty_SIZE   =>Duty_SIZE,
    KP  =>KP,
    KI  =>KI
)
PORT MAP(
    CLK     =>CLK,
    RESET   =>RESET,
    Enable  =>Flag_s,
    Sensor  =>Sensor_s,
    Set_Point   =>Set_Point,
    ExternalP   =>ExternalP,
    ExternalI   =>ExternalI,
    Proportional    =>Proportional,
    Integral    =>Integral,
    Output      =>Output
);

uut_SAMPLE: PID_SAMPLE GENERIC MAP(
  TIMES=>TIMES
)
PORT MAP(
  CLK=>CLK,
  RESET=>RESET,
  Enable=>Enable,
  Flag=>Flag_s
);

uut_TOP_SENSOR: PID_TOPSENSOR PORT MAP(
  CLK   =>CLK,
  RESET =>RESET,
  A     =>A,
  B     =>B,
  C     =>C,
  Count =>Sensor_s,
  ERROR =>ERROR
);

Count<=Sensor_s;
end Behavioral;
