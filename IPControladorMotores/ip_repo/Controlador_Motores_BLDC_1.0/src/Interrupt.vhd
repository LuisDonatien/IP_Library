library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Interrupt is
  Port ( 
  CLK: in std_logic;
  RESET: in std_logic;
  InCOUNT: in std_logic_vector(19 downto 0);
  Intc   : out std_logic
  );
end Interrupt;

architecture Behavioral of Interrupt is
signal Prevalue: std_logic_vector(19 downto 0);
signal Intc_s: std_logic_vector(9 downto 0);
begin
comp: process(CLK)
begin
    if rising_edge(CLK) then
        if RESET='1' then
            Prevalue<=(others=>'0');
            Intc_s<=(others=>'0');
        else
            Intc_s<=Intc_s(8 downto 0) & '0';
            Prevalue<=InCount;
            if Prevalue/=InCount then
                Intc_s<=(others=>'1');
            end if;
        end if;
    end if;
end process;
Intc<=Intc_s(9);
end Behavioral;
