
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top_FSMVel_Temp_HALL is
Generic(
    NUM_CYCLES:             integer:=32;
    SIZE_COUNTER:           integer:=32
);
Port ( 
    CLK:        in std_logic;
    RESET:      in std_logic;
    DIVIDE:      out std_logic;
    DIVISION_DONE: in std_logic;
    RESET_CNT:  out std_logic
);
end Top_FSMVel_Temp_HALL;

architecture Behavioral of Top_FSMVel_Temp_HALL is
COMPONENT Calc_Vel_HALL --FSM
Port ( 
    CLK         : in std_logic;
    RESET       : in std_logic;
    CLK_COUNT   : in std_logic;
    DIVISION_DONE   : in std_logic;   
    DIVIDE      : out std_logic;                                            --Order to divide the next module
    RESET_CNT   : out std_logic
);
END COMPONENT;

COMPONENT Temp_HALL
generic(
    NUM_CYCLES: integer; --Number of cycles of CLK REAL INTERTALL TIME= PERIOD CLOCK*CYCLE_CLK
    SIZE_COUNTER: integer 
);
Port ( 
    CLK     : in std_logic;
    RESET   : in std_logic;
    TIME_UP : out std_logic
);
END COMPONENT;

signal TIME_UP_s : std_logic;
signal RESET_CNT_s : std_logic;
signal RESET_T_s: std_logic;
begin
uut0: Calc_Vel_HALL
PORT MAP(
    CLK         =>CLK,
    RESET       =>RESET,
    CLK_COUNT   =>TIME_UP_s,  
    DIVISION_DONE  =>DIVISION_DONE,
    DIVIDE         =>DIVIDE,
    RESET_CNT      =>RESET_CNT_s
);

uut1: Temp_HALL
GENERIC MAP(
    NUM_CYCLES      =>NUM_CYCLES,
    SIZE_COUNTER    =>SIZE_COUNTER
)
PORT MAP(
    CLK         =>CLK,   
    RESET       =>RESET_T_s,
    TIME_UP     =>TIME_UP_s
);

RESET_CNT<= RESET_CNT_s;
RESET_T_s<=RESET_CNT_s OR RESET;
end Behavioral;