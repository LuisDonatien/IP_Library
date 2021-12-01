library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity FSM_HALL is
Port(
	RESET      : in std_logic;
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    CLK        : in std_logic;
    STEP      : out std_logic;
    SENSE      : out std_logic
);
end FSM_HALL;

architecture Behavioral of FSM_HALL is
	type estate_t is (S0_001,S1_000,S2_100,S3_110,S4_111,S5_011,S6_ERROR);                            --Posible state of encoder reception
    signal   estate , nxt_estate : estate_t;
begin

estate_register : process(CLK,RESET)
    begin    	
    if RESET = '1' then
        if A='0' AND B='0' AND C='1' then      ---Determinate estate from reset
            estate <= S0_001;
        elsif A='0' AND B='0' AND C='0' then
            estate <= S1_000;
        elsif A='1' AND B='0' AND C='0' then
            estate <= S2_100;
        elsif A='1' AND B='1' AND C='0' then
            estate <= S3_110;
        elsif A='1' AND B='1' AND C='1' then
            estate <= S4_111;
        elsif A='0' AND B='1' AND C='1' then
            estate <= S5_011;
        else
            estate <=S6_ERROR;                 --Avoid latch defect state
        end if;        
    elsif rising_edge(CLK) then
      --To save the actual state in case of a change in nxt_state.
    	estate<= nxt_estate;  
   	end if;
   end process;
   
   nxtstate_decod : process(A,B,C,estate)
   begin
   	nxt_estate <= estate; 
    
       	case estate is	
        	when S0_001 =>
        	        if A='0' AND B='0' AND C='1' then      ---Stay on same state
                        nxt_estate <= S0_001;
                    elsif A='0' AND B='0' AND C='0' then
                        nxt_estate <= S1_000;
                    elsif A='0' AND B='1' AND C='1' then
                        nxt_estate <=S5_011;
                    else
                        nxt_estate <=S6_ERROR;
                    end if;

            when S1_000 =>
        	        if A='0' AND B='0' AND C='0' then      ---Stay on same state
                        nxt_estate <= S1_000;
                    elsif A='1' AND B='0' AND C='0' then
                        nxt_estate <= S2_100;
                    elsif A='0' AND B='0' AND C='1' then
                        nxt_estate <=S0_001;
                    else
                        nxt_estate <=S6_ERROR;
                    end if;
            when S2_100 =>           
        	        if A='1' AND B='0' AND C='0' then      ---Stay on same state
                        nxt_estate <= S2_100;
                    elsif A='1' AND B='1' AND C='0' then
                        nxt_estate <= S3_110;
                    elsif A='0' AND B='0' AND C='0' then
                        nxt_estate <=S1_000;
                    else
                        nxt_estate <=S6_ERROR;
                    end if;
            when S3_110 =>
        	        if A='1' AND B='1' AND C='0' then      ---Stay on same state
                        nxt_estate <= S3_110;
                    elsif A='1' AND B='1' AND C='1' then
                        nxt_estate <= S4_111;
                    elsif A='1' AND B='0' AND C='0' then
                        nxt_estate <=S2_100;
                    else
                        nxt_estate <=S6_ERROR;
                    end if;            
            when S4_111 =>           
        	        if A='1' AND B='1' AND C='1' then      ---Stay on same state
                        nxt_estate <= S4_111;
                    elsif A='0' AND B='1' AND C='1' then
                        nxt_estate <= S5_011;
                    elsif A='1' AND B='1' AND C='0' then
                        nxt_estate <=S3_110;
                    else
                        nxt_estate <=S6_ERROR;
                    end if;
            when S5_011 =>
        	        if A='0' AND B='1' AND C='1' then      ---Stay on same state
                        nxt_estate <= S5_011;
                    elsif A='0' AND B='0' AND C='1' then
                        nxt_estate <= S0_001;
                    elsif A='1' AND B='1' AND C='1' then
                        nxt_estate <=S4_111;
                    else
                        nxt_estate <=S6_ERROR;
                    end if; 
            when others => --Something wrong happened
                        nxt_estate <=S6_ERROR;		
      	end case;
   end process;
   
   output_decod   : process(estate,nxt_estate) 
   begin
    if estate/=nxt_estate then
        STEP <= '1';
    else
        STEP <='0';
    end if;
   end process;
end architecture;

