library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity PWM_Generator is
Generic(
    Frecuencies: integer range 1000 to 2500:= 1000;
    DeadBand: integer range 3 to 10:=5;
    Duty_SIZE: integer range 10 to 12:=10;
    COMPLEMENTARIO  : boolean:=FALSE
);
  Port ( 
  CLK:          in std_logic;
  RESET:        in std_logic;
  Duty:         in std_logic_vector(Duty_SIZE-1 downto 0);
  PWM_H:        out std_logic;
  PWM_L:        out std_logic
  );
end PWM_Generator;

architecture Behavioral of PWM_Generator is
signal counter_PWM: unsigned(Duty_Size-1 downto 0);
signal counter_DelayH, counter_DelayL: std_logic_vector(DeadBand downto 0);
signal PWM:std_logic;
begin

PWM_Generator:process(CLK,RESET)
variable PWM_Internal: std_logic;
begin
    if rising_edge(CLK) then
        counter_PWM<=counter_PWM-1;
        if RESET='1' then
            PWM<='0';
            counter_DelayH<=(others=>'0');
            counter_DelayL<=(others=>'0');
            counter_PWM<=to_unsigned(Frecuencies,Duty_Size);
        elsif COMPLEMENTARIO  =TRUE then
            if counter_PWM=to_unsigned(0,Duty_Size)+1 then      --Al llegar a 0 el contador Reset de contador e inicio de delay H para ponerse a 1
                PWM<='1';
                counter_PWM<=to_unsigned(Frecuencies,Duty_Size);
                    if Frecuencies= unsigned(Duty) AND counter_DelayH(DeadBand)='1' then   --En caso de tener un valor próximo al 100% duty menos X ciclos de deadband se opta por dejarlo a valor alto y no hacer conmutado --Frecuencies<= unsigned(Duty)+DeadBand AND counter_DelayH(DeadBand)='1'
                        counter_DelayH<=(others=>'1');                             
                    else     
                        counter_DelayH<=counter_DelayH(DeadBand-1 downto 0) & '1';
                    end if;
                    if to_unsigned(0,Duty_SIZE)= unsigned(Duty) AND counter_DelayL(DeadBand)='1' then   --En caso de tener un valor próximo al 0% duty menos X ciclos de deadband se opta por dejarlo a valor alto y no hacer conmutado -to_unsigned(0,32)+1+DeadBand>= unsigned(Duty) AND counter_DelayL(DeadBand)='1'
                        counter_DelayL<=(others=>'1');                             
                    else
                        counter_DelayL<=(others=>'0');  
                    end if;
            elsif counter_PWM>Frecuencies-unsigned(Duty) then
                PWM<='1';
                counter_DelayH<=counter_DelayH(DeadBand-1 downto 0) & '1';
                counter_DelayL<=(others=>'0');
            else
                PWM<='0';     
                counter_DelayH<=(others=>'0');
                counter_DelayL<=counter_DelayL(DeadBand-1 downto 0) & '1';
            end if;
        elsif COMPLEMENTARIO  =FALSE then
            if counter_PWM=to_unsigned(0,Duty_Size)+1 then      --Al llegar a 0 el contador Reset de contador e inicio de delay H para ponerse a 1
                PWM<='0';
                counter_PWM<=to_unsigned(Frecuencies,Duty_Size);
                counter_DelayH<=(others=>'1');
                counter_DelayL<=(others=>'0');
            elsif counter_PWM>Frecuencies-unsigned(Duty) then
                PWM<='1';
                counter_DelayH<=(others=>'1');
                counter_DelayL<=(others=>'0');               
            else
                PWM<='0';     
                counter_DelayH<=(others=>'0');
                counter_DelayL<=(others=>'0');                    
            end if;
        end if;
    end if;
end process;

PWM_H<=counter_DelayH(DeadBand);
--PWM_H<=PWM;
PWM_L<=counter_DelayL(DeadBand);
--PWM_L<='0';

end Behavioral;
