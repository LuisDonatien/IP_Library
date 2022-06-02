library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PID_TOPSENSOR is
  Port ( 
  CLK:      in std_logic;
  RESET:    in std_logic;
  A:        in std_logic;
  B:        in std_logic;
  C:        in std_logic;
  Count:    out std_logic_vector(19 downto 0);
  ERROR:    out std_logic
  );
end PID_TOPSENSOR;

architecture Behavioral of PID_TOPSENSOR is
signal STEP_s: std_logic;
COMPONENT PID_TIMER
  Port ( 
  CLK   : in std_logic;
  RESET : in std_logic;
  Input : in std_logic;
  Count : out std_logic_vector(19 downto 0) 
  );
END COMPONENT;

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
begin

uut_PIDFSM: PID_HALLFSM PORT MAP(
	RESET  =>RESET,
    A      =>A,
    B      =>B,        
    C      =>C,  
    CLK    =>CLK,
    STEP   =>STEP_s,
    ERROR  =>ERROR

);

uut_PID_TIME: PID_TIMER PORT MAP(
  CLK       =>CLK,
  RESET     =>RESET,
  Input     =>Step_s,
  Count     =>Count
);
end Behavioral;
