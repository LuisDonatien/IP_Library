library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity PID_PID is
  Generic(
    Duty_SIZE: integer range 10 to 12:=10;
    KP: integer range 0 to 255:=0;
    KI: integer range 0 to 255:=0
  );
  Port ( 
    CLK:    in std_logic;
    RESET:  in std_logic;
    Enable: in std_logic;
    Sensor : in std_logic_vector(19 downto 0);
    ExternalP: in std_logic;
    ExternalI: in std_logic;
    Set_Point:  in std_logic_vector(19 downto 0);
    Proportional: in std_logic_vector(7 downto 0);
    Integral    : in std_logic_vector(7 downto 0);
    Output: out std_logic_vector(Duty_SIZE-1 downto 0)
  );
end PID_PID;

architecture Behavioral of PID_PID is
signal Error,Error_SS,ErrorInt: std_logic_vector(15 downto 0);        --Error actual entre la señal medida y la referencia (SetPoint)
signal SumarError: std_logic_vector(15 downto 0);   --Acumulacion del error de la constante Integral
signal Marca:std_logic_vector(19 downto 0):=(others=>'1');
signal Flag,Flag1: std_logic_vector(3 downto 0);
signal Pout,Iout,ErrOut: integer:=0;   --Señal almacena la multiplicacion de la constante proporcional por el error y la constante integral por el error+antiguo error
signal AntiguaSalida,Salida,Salida_s:integer:=0;
signal Output_ss: std_logic_vector(Duty_Size downto 0); --Usado para el caso de tener un Duty_Size de 12 => 40 Hz
signal Output_s:std_logic_vector(Duty_Size-1 downto 0);
signal Set_Point_s,Set_Point_ss,Sensor_s:std_logic_vector(19 downto 0);
signal Flag_Delay: std_logic_vector(1 downto 0);
signal Enable_s:std_logic;
signal Flag_Enable,ExternalP_s,ExternalI_s:std_logic;
signal Counter_Delay:std_logic_vector(5 downto 0);
signal Proportional_s,Integral_s: std_logic_vector(7 downto 0);
signal I: integer:=0;

begin

PID_Resta: process(CLK)
begin
    if rising_edge(CLK) then
        if RESET='1' then
             Error<=(others=>'0');
             ErrorInt<=(others=>'0');
            SumarError<=(others=>'0');
            Output_s<=(others=>'0'); 
            Output_ss<=(others=>'0');
            ErrOut<=0;          
            Salida<=0;
            Salida_s<=0;
            AntiguaSalida<=0;
            Flag_Delay<=(others=>'0');    
            Set_Point_s<=(others=>'0');   
            Proportional_s<=(others=>'0');
            Sensor_s<=(others=>'0');
            Integral_s<=(others=>'0');
        elsif Enable='1'  then
            Set_Point_s<=Set_Point;
            Proportional_s<=Proportional;
            Integral_s<=Integral;
            ExternalP_s<=ExternalP;
            ExternalI_s<=ExternalI;
            Sensor_s<=Sensor;  
            SumarError<=Error;     
            AntiguaSalida<=Salida_s;     
        else
         for I in 0 to 7 loop
            case I is
                when 0 =>   Error <= unsigned(Sensor_s(19 downto 5 ))- signed(Set_Point_S(19 downto 5));
                when 1 => 
                            ErrorInt<=signed(Error)+signed(SumarError);                                 
                when 2 =>
                        if ExternalP_s='0' then
                            Pout<=conv_integer(signed(Error))*KP;
                        else
                            Pout<=conv_integer(signed(Error))*conv_integer(unsigned(Proportional_s));
                        end if;      
                            if ExternalI_s='0' then
                            Iout<=conv_integer(signed(ErrorInt))*KI;
                        else
                            Iout<=conv_integer(signed(ErrorInt))*conv_integer(unsigned(Integral_s));
                        end if; 
                when 3 => ErrOut<=Iout+Pout;
                when 4 => Salida<=AntiguaSalida+((ErrOut)/2048);
                when 5 => 
                            if Salida>=1000 then
                                  Salida_s<=1000;
                            elsif Salida<=0 then
                                   Salida_s<=0;
                            else 
                                   Salida_s<=Salida;
                            end if;
                when 6 =>
                        if Duty_SIZE=10 then
                            Output_s<=std_logic_vector(conv_unsigned(Salida_s ,10));        
                        elsif Duty_SIZE=11 then
                            Output_s<=std_logic_vector(conv_unsigned(Salida_s*2 ,11));
                        elsif Duty_SIZE=12 then                                        -- En caso de ser 40 Hz el duty 100 es 2500 por lo tanto se multiplica 1000*5/2
                            Output_ss<=(std_logic_vector(conv_unsigned(Salida_s*5 ,13)));
                        end if;
                when 7 =>
                        if Duty_SIZE=12 then
                            Output_s<=Output_ss(Duty_SIZE downto 1);         
                        end if;                    
                when others => null;
            end case;
        end loop;       
        
        end if;    
    end if;
end process;


Actualizar_Salida: process(CLK)
begin
    if rising_edge(CLK) then
        if RESET='1' then
            Output<=(others=>'0');
            counter_delay<=(others=>'0');
        elsif Enable='1' then
            counter_delay<=(others=>'0');
        elsif unsigned(counter_delay)>=8 then
            Output<=Output_s;
        else
            counter_delay<=unsigned(counter_delay)+1;
        end if;
        
    end if;
end process;
--Resta: process(CLK)
--begin
--    if rising_edge(CLK) then     
--    Set_Point_s<=Set_Point;
--    Error_SS<=Error;
--    Proportional_s<=Proportional;
--    Integral_s<=Integral;
--    Sensor_s<=Sensor;
--        if RESET='1' then
--            Error<=(others=>'0');
 --           SumarError<=(others=>'0');
 --           Output<=(others=>'0'); 
 --           Output_s<=(others=>'0');           
 --           Salida<=0;
 --           AntiguaSalida<=0;
 --           Flag_Delay<=(others=>'0');
 --           Flag<="0001";
 --      elsif Enable='1' AND Flag="0001" then
 --          Error<=unsigned(Sensor_s(19 downto 5 ))- signed(Set_Point_s(19 downto 5));
 --       Flag<="1111";
 --           AntiguaSalida<=Salida;  --Se suma el valor de la antigua salida.
 --       elsif Flag="1111" then
 --         Flag<="0010";
 --       elsif Flag="0010"then
 --           if ExternalP='0' then
 --               Pout<=conv_integer(signed(Error_ss))*KP;
 --           else
 --               Pout<=conv_integer(signed(Error_ss))*conv_integer(unsigned(Proportional_s));
 --           end if;      
--            if ExternalI='0' then
--                Iout<=conv_integer(signed(Error_ss)+signed(SumarError))*KI;
--            else
--                Iout<=conv_integer(signed(Error_ss)+signed(SumarError))*conv_integer(unsigned(Integral_s));
--            end if;               
--            Flag<="0100";
--        elsif Flag="0100" then
--                Salida<=AntiguaSalida+((Pout+Iout)/2048);
--            Flag<="1000";
 --       elsif Flag="1000" then
--            if Salida>=1000 then
--                Salida<=1000;
--            elsif Salida<=0 then
--                Salida<=0;
--            end if;
--            Flag<="1001";
 --       elsif Flag="1001" then
 --        SumarError<=Error_ss;     --Se guarda el antiguo error 
 --               if Duty_SIZE=10 then
 --                   Output<=std_logic_vector(conv_unsigned(Salida ,10));        
 --                               Flag<="0001";  
 --               elsif Duty_SIZE=11 then
 --                   Output<=std_logic_vector(conv_unsigned(Salida*2 ,11));
 --                               Flag<="0001";  
 --               elsif Duty_SIZE=12 then                                        -- En caso de ser 40 Hz el duty 100 es 2500 por lo tanto se multiplica 1000*5/2
 --                   Output_s<=(std_logic_vector(conv_unsigned(Salida*5 ,13)));
 --                               Flag<="1011";      
 --               end if;
 --       elsif Flag="1011" then
 --           Output<=Output_s(Duty_SIZE downto 1);
--            Flag<="0001";    
--        end if;
--    end if;
--end process;

end Behavioral;