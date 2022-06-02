library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.std_logic_arith.all;


entity CLOCK_DISPLAY is
  Port ( 
  CLK: in std_logic;
  STEP: out std_logic_vector(1 downto 0)
  );
end CLOCK_DISPLAY;

architecture Behavioral of CLOCK_DISPLAY is
signal Frecuencia: integer:=16E5;
signal Cuarto: integer:=4E5;
signal counter: unsigned(31 downto 0):=(others=>'0');
begin

Reloj: process(CLK)
begin
    if rising_edge(CLK) then
    counter<=counter+1;
        if counter<cuarto then
            STEP<="00";        
        elsif counter<2*Cuarto AND counter>=Cuarto  then
            STEP<="01";
        elsif counter>=2*Cuarto AND counter<3*Cuarto then
            STEP<="10";
        elsif counter<Frecuencia AND counter>=3*Cuarto then
            STEP<="11";
        else
            counter<=(others=>'0');     
        end if;
    end if;
end process;

end Behavioral;
