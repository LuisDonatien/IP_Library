library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.std_logic_arith.all;

entity PID_SAMPLE is
  generic(
  TIMES: integer range 1 to 100:= 100
  );
  Port ( 
  CLK:  in std_logic;
  RESET: in std_logic;
  Enable: in std_logic;
  Flag: out std_logic
  );
end PID_SAMPLE;

architecture Behavioral of PID_SAMPLE is
signal count: std_logic_vector(23 downto 0); -- TIME=10 with 10ns period is 1E6 Count
begin

Temporizador: process(RESET,CLK)
begin
    if RESET='1' then
        count<=(others=>'0');
        flag<='0';
    elsif rising_edge(CLK) then
        if enable='1' then
            count<=unsigned(count)+1;
            if unsigned(count)> conv_unsigned(TIMES*1E5,24)-1 then
                count<=(others=>'0');
                flag<='1';
            else
                flag<='0';
            end if;
        else
            count<=(others=>'0');
            flag<='0';
        end if;
    end if;
end process;
end Behavioral;