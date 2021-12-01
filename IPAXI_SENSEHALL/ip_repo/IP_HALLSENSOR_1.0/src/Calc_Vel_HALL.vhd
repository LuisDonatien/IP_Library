library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity Calc_Vel_HALL is
Port ( 
    CLK         : in std_logic;
    RESET       : in std_logic;
    CLK_COUNT   : in std_logic;
    DIVISION_DONE   : in std_logic;   
    DIVIDE      : out std_logic;                                            --Order to divide the next module
    RESET_CNT   : out std_logic
);
end Calc_Vel_HALL;

architecture Behavioral of Calc_Vel_HALL is
	type estate_t is (S0_RECIBIENDO,S1_CALCULANDO,S2_VALOR);                            --Posible state of encoder reception
    signal   estate , nxt_estate : estate_t;   
begin

estate_register : process(CLK,RESET)
    begin    	
    if RESET = '1' then
        estate <= S0_RECIBIENDO;
    elsif rising_edge(CLK) then
      --To save the actual state in case of a change in nxt_state.
    	estate<= nxt_estate; 
   	end if;
   end process;
   
   nxtstate_decod : process(CLK_COUNT,DIVISION_DONE,estate)
   begin
   	nxt_estate <= estate; 
       	case estate is	
        	when S0_RECIBIENDO =>
                if CLK_COUNT='1' then
                    nxt_estate<=S1_CALCULANDO;  
                end if;   	   
            when S1_CALCULANDO => 
                    nxt_estate<=S2_VALOR;  
            when S2_VALOR =>
                    if DIVISION_DONE='1' then
                    nxt_estate<=S0_RECIBIENDO;
                    end if;                  
            when others => --Something wrong happened
                nxt_estate <= S0_RECIBIENDO; 		
      	end case;
   end process;
   
   output_decod   : process(estate) 
   begin
    DIVIDE<='0';
    RESET_CNT<='0';
    if estate=S1_CALCULANDO then
        DIVIDE<='1';                                                          --Reset to 0 the number of pulse on the counter pulse module while calculating values.
    elsif estate=S2_VALOR then
        DIVIDE<='1';
        RESET_CNT<='1';
    end if;
   end process;
end Behavioral;
