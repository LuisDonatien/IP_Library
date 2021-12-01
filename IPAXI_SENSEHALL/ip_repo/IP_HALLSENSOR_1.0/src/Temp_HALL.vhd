library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Temp_HALL is
generic(
    NUM_CYCLES: integer; --Number of cycles of CLK REAL INTERTAL TIME= PERIOD CLOCK*CYCLE_CLK
    SIZE_COUNTER: integer 
);
Port ( 
    CLK     : in std_logic;
    RESET   : in std_logic;
    TIME_UP : out std_logic
);
end Temp_HALL;

architecture Behavioral of Temp_HALL is
    signal count_s : unsigned(SIZE_COUNTER-1 downto 0);
begin

counter: process(RESET,CLK)
begin
    if RESET='1' then
        count_s<=(others=>'0');
        TIME_UP<='0';
    elsif rising_edge(CLK) then
        if count_s < NUM_CYCLES-1 then
            count_s<=count_s+1;
            TIME_UP<='0';
        else
            count_s<=(others=>'0');
            TIME_UP<='1';
        end if;
    end if;
end process;
end Behavioral;
