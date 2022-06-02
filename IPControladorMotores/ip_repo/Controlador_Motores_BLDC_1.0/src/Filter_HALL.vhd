library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
 
entity Filter_HALL is
  Generic(
  Delay: integer:= 10           -- Delay*10^3
  );
  Port ( 
  CLK: in std_logic;
  INPUT: in std_logic;
  OUTPUT: out std_logic
  );
end Filter_HALL;

architecture Behavioral of Filter_HALL is
signal count  : std_logic_vector(32 downto 0);
signal SYNC_OUT_s,previnput     : std_logic;


COMPONENT SYNCHRNZR
 port (
 CLK : in std_logic;
 ASYNC_IN : in std_logic;
 SYNC_OUT : out std_logic
 );
END COMPONENT;
begin

uut: SYNCHRNZR PORT MAP(
 CLK        =>CLK,
 ASYNC_IN   =>INPUT,
 SYNC_OUT   =>SYNC_OUT_s
 );



--Filter debouncer--
FilterClock: process(CLK)
begin
    if rising_edge(CLK) then
    previnput<=SYNC_OUT_s;
        if previnput/=SYNC_OUT_s then
            count<=(others=>'0');
        elsif unsigned(count)> conv_unsigned(Delay,32)-1 then
            OUTPUT<=SYNC_OUT_s;
        else
            count<=unsigned(count)+1;
        end if;
    end if;
end process;
end Behavioral;
