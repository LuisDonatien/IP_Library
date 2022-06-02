
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity SEGMENT_TOP is
  Port ( 
  CLK : in std_logic;
  COUNT: in std_logic_vector(11 downto 0);
  Segment: out std_logic_vector(6 downto 0);
  Display: out std_logic_vector(3 downto 0)
  );
end SEGMENT_TOP;

architecture Behavioral of SEGMENT_TOP is

COMPONENT ConvertBCD
  Port ( 
  Number: in std_logic_vector(11 downto 0);
  Digit0: out std_logic_vector(6 downto 0);
  Digit1: out std_logic_vector(6 downto 0);
  Digit2: out std_logic_vector(6 downto 0);
  Digit3: out std_logic_vector(6 downto 0)
  );
END COMPONENT;

COMPONENT Decoder_Display
  Port ( 
  BCD:  in   std_logic_vector(6 downto 0);
  Segment: out  std_logic_vector(6 downto 0) 
  );
END COMPONENT;

COMPONENT CLOCK_DISPLAY
  Port ( 
  CLK: in std_logic;
  STEP: out std_logic_vector(1 downto 0)
  );
END COMPONENT;
signal BCD0,BCD1,BCD2,BCD3: std_logic_vector(6 downto 0);
signal Number_s : std_logic_vector(15 downto 0);
signal Segment0_s,Segment1_s,Segment2_s, Segment3_s : std_logic_vector(6 downto 0);
signal RESET_s: std_logic;
signal STEP_s : std_logic_vector(1 downto 0);
begin

uut0: ConvertBCD PORT MAP(
  Number =>COUNT,
  Digit0 =>BCD0,
  Digit1 =>BCD1,
  Digit2 =>BCD2,
  Digit3 =>BCD3
);

uut1: Decoder_Display PORT MAP(
  BCD   =>BCD0,
  Segment =>Segment0_s
);

uut2: Decoder_Display PORT MAP(
  BCD   =>BCD1,
  Segment =>Segment1_s
);

uut3: Decoder_Display PORT MAP(
  BCD   =>BCD2,
  Segment =>Segment2_s
);

uut4: Decoder_Display PORT MAP(
  BCD   =>BCD3,
  Segment =>Segment3_s
);

uut5: CLOCK_DISPLAY PORT MAP(
  CLK =>CLK,
  STEP =>STEP_s
);

Segment<= NOT Segment0_s when STEP_s="00" else
          NOT Segment1_s when STEP_s="01" else
          NOT Segment2_s when STEP_s="10" else
          NOT Segment3_s when STEP_s="11" else
          NOT "1000000" ;
          
Display<= "0111" when STEP_s="00" else
          "1011" when STEP_s="01" else
          "1101" when STEP_s="10" else
          "1110" when STEP_s="11" else
          "1110" ;
end Behavioral;
