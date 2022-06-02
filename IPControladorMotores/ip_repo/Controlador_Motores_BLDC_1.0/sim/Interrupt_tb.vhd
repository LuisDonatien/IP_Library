library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
entity Interrupt_tb is
--  Port ( );
end Interrupt_tb;

architecture Behavioral of Interrupt_tb is
  signal CLK:       std_logic;
  signal RESET:     std_logic;
  signal InCOUNT:   std_logic_vector(19 downto 0);
  signal Intc   :   std_logic;

COMPONENT Interrupt
  Port ( 
  CLK: in std_logic;
  RESET: in std_logic;
  InCOUNT: in std_logic_vector(19 downto 0);
  Intc   : out std_logic
  );
END COMPONENT;
        constant CLK_PERIOD : time := 1 sec / 100_000_000; --Clock period 100MHz  
begin

uut: Interrupt PORT MAP(
  CLK       =>CLK,
  RESET     =>RESET,
  InCOUNT   =>InCOUNT,
  Intc      =>Intc
);

--Generacion de señales------
Generar_Reloj: process
begin
        CLK<='1';
    wait for (CLK_PERIOD/2);
        CLK<='0';
    wait for (CLK_PERIOD/2);
end process;

RESET<='1', '0' after 1ms;
InCOUNT<=  conv_std_logic_vector(conv_integer(50),20), conv_std_logic_vector(conv_integer(200),20) after 1ms+500ns;
end Behavioral;
