
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top_HALL is
Generic(
    NUM_CYCLES:         integer:=5E3;   --Number of cycles ==> Frecuencies CLK*NUMCYCLES= INTERVAL TIME 
    SIZE_COUNT:         integer:=16;   --FSM count size
    SIZE_COUNTER:       integer:=32;
    SIZE_RPM:           integer:=16;
    CONST_DIV_SIZE:     integer:=15;
    Value_CONST_DIV:    integer:=3276           --==(DIVISOR*2^n)---->n precision bits= const_div_size
);
Port( 
    CLK:    in std_logic;
    RESET:  in std_logic;
    A:      in std_logic;
    B:      in std_logic;
    C:      in std_logic;
    RPM:    out std_logic_vector(SIZE_RPM-1 downto 0)
);
end Top_HALL;

architecture Behavioral of Top_HALL is
COMPONENT Top_FSMVel_Temp_HALL
Generic(
    NUM_CYCLES:         integer;
    SIZE_COUNTER:         integer
);
Port ( 
    CLK:        in std_logic;
    RESET:      in std_logic;
    DIVIDE:      out std_logic;
    DIVISION_DONE: in std_logic;
    RESET_CNT:  out std_logic
);
END COMPONENT;
COMPONENT  Top_FSM_CntSteps_HALL
Generic(
    SIZE_VECTOR_COUNT : integer
);
Port ( 
    CLK :       in std_logic;   
    RESET:      in std_logic;
    RESET_CNT:  in std_logic;
    A:          in std_logic;
    B:          in std_logic;
    C:          in std_logic;
    COUNT:      out std_logic_vector(SIZE_VECTOR_COUNT-1 downto 0) 
  );
END COMPONENT;
COMPONENT Division_HALL
Generic(
    COUNT_SIZE  : integer:=15;
    RESULT_SIZE : integer:=15;
    CONST_DIV_SIZE : integer:=15;
    Value_CONST_DIV : integer:=3276
);
Port ( 
    CLK:        in std_logic;
    RESET:      in std_logic;
    DIVIDE:     in std_logic;
    COUNT:      in std_logic_vector(COUNT_SIZE-1 downto 0);
    DIVISION_DONE:  out std_logic;
    RESULT:     out std_logic_vector(RESULT_SIZE-1 downto 0)
     
);
END COMPONENT;

    signal  COUNT_PULSE_s   : std_logic_vector(SIZE_COUNT-1 downto 0);
    signal  DIVIDE_s        : std_logic;
    signal  DIVISION_DONE_s : std_logic;
    signal  RESET_CNT_s     : std_logic;    
    signal  REG_COUNT_s     : std_logic_vector(SIZE_COUNT-1 downto 0);
begin

uuFSMVEL: Top_FSMVel_Temp_HALL
GENERIC MAP(
    NUM_CYCLES              =>NUM_CYCLES,
    SIZE_COUNTER            =>SIZE_COUNTER
)
PORT MAP(
    CLK             =>CLK,
    RESET           =>RESET,
    DIVIDE          =>DIVIDE_s,
    DIVISION_DONE   =>DIVISION_DONE_s,
    RESET_CNT       =>RESET_CNT_s
);

uuFSMCntSteps: Top_FSM_CntSteps_HALL
GENERIC MAP(
    SIZE_VECTOR_COUNT=> SIZE_COUNT
)
PORT MAP(
    CLK         =>CLK,  
    RESET       =>RESET,
    RESET_CNT   =>RESET_CNT_s,
    A           =>A,
    B           =>B,
    C           =>C,
    COUNT       =>COUNT_PULSE_s  
);

uuDiv: Division_HALL
GENERIC MAP(
    COUNT_SIZE          => SIZE_COUNT,
    RESULT_SIZE         =>SIZE_RPM,
    CONST_DIV_SIZE      =>CONST_DIV_SIZE,
    Value_CONST_DIV     =>VALUE_CONST_DIV
)
PORT MAP(
    CLK             =>CLK,
    RESET           =>RESET,
    DIVIDE          =>DIVIDE_s,
    COUNT           =>COUNT_PULSE_s,
    DIVISION_DONE   =>DIVISION_DONE_s,
    RESULT          =>RPM
);

end Behavioral;
