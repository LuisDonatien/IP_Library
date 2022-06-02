
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_LITE_tb is
generic
(
  C_S_AXI_DATA_WIDTH             : integer              := 32;
  C_S_AXI_ADDR_WIDTH             : integer              := 5
);

end AXI_LITE_tb;

architecture Behavioral of AXI_LITE_tb is
        ---Configuracion MODO-----
        constant CONTROLADOR:boolean:=FALSE;
        constant LAZOABIERTO:boolean:=TRUE;
        --------------------------
        --------------Configuracion PI-----
        constant KP:     integer range 0 to 255:=40;
        constant KI:     integer range 0 to 255:=0;       
        constant SAMPLES:integer range 10 to 100:=50;
        -----------------------------------
        ---CONFIGURACION PWM------
        constant COMPLEMENTARIO: boolean:= FALSE;
        constant Duty_SIZE: integer range 10 to 12:=10;
        constant DeadBand: integer range 3 to 10:=5;
        constant Frecuencia: integer range 1000 to 2500:=1000;
    signal CLK:           std_logic;
    signal RESET:         std_logic;  
    signal A          :  std_logic;
    signal B          :  std_logic;
    signal C          :  std_logic;
    signal A_out       : std_logic;
    signal B_out       : std_logic;
    signal C_out       : std_logic;
    signal PWM_AH       : std_logic;
    signal PWM_AL       : std_logic;
    signal PWM_BH       : std_logic;
    signal PWM_BL       : std_logic;
    signal PWM_CH       : std_logic;
    signal PWM_CL       : std_logic;
    signal PWM_HIGH     :  std_logic;
    signal PWM_LOW      :  std_logic;
    signal ERROR        :  std_logic;
    signal Duty_Led     :  std_logic_vector(Duty_SIZE-1 downto 0);
    signal Intc         :  std_logic;
    signal Segment      :  std_logic_vector(6 downto 0);
    signal Display      :  std_logic_vector(3 downto 0);
    
    signal S_AXI_ACLK                     :  std_logic;
    signal S_AXI_ARESETN                  :  std_logic;
    signal S_AXI_AWADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_AWVALID                  :  std_logic;
    signal S_AXI_WDATA                    :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_WSTRB                    :  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    signal S_AXI_WVALID                   :  std_logic;
    signal S_AXI_BREADY                   :  std_logic;
    signal S_AXI_ARADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_ARVALID                  :  std_logic;
    signal S_AXI_RREADY                   :  std_logic;
    signal S_AXI_ARREADY                  : std_logic;
    signal S_AXI_RDATA                    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_RRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_RVALID                   : std_logic;
    signal S_AXI_WREADY                   : std_logic;
    signal S_AXI_BRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_BVALID                   : std_logic;
    signal S_AXI_AWREADY                  : std_logic;
    signal S_AXI_AWPROT                   : std_logic_vector(2 downto 0);
    signal S_AXI_ARPROT                   : std_logic_vector(2 downto 0);

    
    Constant ClockPeriod : TIME := 5 ns;
    Constant ClockPeriod2 : TIME := 10 ns;
    shared variable ClockCount : integer range 0 to 50_000 := 10;
    signal sendIt : std_logic := '0';
    signal readIt : std_logic := '0';
    signal Registro0: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0):="00000";
    signal Registro1: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0):="00100";
    signal Registro2: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0):="01000";
    signal Registro3: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0):="01100";
    signal Registro4: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0):="10000";
    signal Registro5: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0):="10100";
    
    signal Registro_Leido: std_logic_vector(31 downto 0);

    COMPONENT Controlador_Motores_BLDC_v1_0
	generic (
		-- Users to add parameters here
		--expr  [set Size_Led [if {$OPCION} {list 16} {list 20}]] 
        ---Configuracion MODO-----
        CONTROLADOR:boolean:=FALSE;
        DIRECTO:boolean:=TRUE;
        --------------------------
        --------------Configuracion PI-----
        KP:     integer range 0 to 255:=40;
        KI:     integer range 0 to 255:=0;       
        SAMPLES:integer range 10 to 100:=50;
        -----------------------------------
        ---CONFIGURACION PWM------
        COMPLEMENTARIO: boolean:= FALSE;
        Duty_SIZE: integer range 10 to 12:=10;
        DeadBand: integer range 3 to 10:=5;
        Frecuencia: integer range 1000 to 2500:=1000;
        --------------------------
        ---Configuracion Filtros HALL
        Ciclos: integer range 5 to 1000:=10;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 5
	);
	port (
		-- Users to add ports here
    CLK:          in std_logic;
    RESET:        in std_logic;  
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    A_out       : out std_logic;
    B_out       : out std_logic;
    C_out       : out std_logic;
    PWM_AH       : out std_logic;
    PWM_AL       : out std_logic;
    PWM_BH       : out std_logic;
    PWM_BL       : out std_logic;
    PWM_CH       : out std_logic;
    PWM_CL       : out std_logic;
    PWM_HIGH    : out std_logic;
    PWM_LOW     : out std_logic;
    ERROR      : out std_logic;
    Duty_Led   : out std_logic_vector(Duty_SIZE-1 downto 0);
    Intc       : out std_logic;
    Segment: out std_logic_vector(6 downto 0);
    Display: out std_logic_vector(3 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic; 
		s00_axi_rready	: in std_logic
	);    
    END COMPONENT;
begin
    IP_Creado: Controlador_Motores_BLDC_v1_0 
  -- instance "led_controller_v1_0_1"
    generic map (
      C_S00_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
      C_S00_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH)
    port map (
    CLK =>CLK,
    RESET   =>RESET,
    A       =>A,
    B       =>B,
    C       =>C,
    A_out   =>A_out,
    B_out   =>B_out,
    C_out   =>C_out,
    PWM_AH  =>PWM_AH,
    PWM_AL  =>PWM_AL,
    PWM_BH  =>PWM_BH,
    PWM_BL  =>PWM_BL,
    PWM_CH  =>PWM_CH,
    PWM_CL  =>PWM_CL,
    PWM_HIGH  =>PWM_HIGH,
    PWM_LOW   =>PWM_LOW,
    ERROR       =>ERROR,
    Duty_Led    =>Duty_Led,
    Intc        =>Intc,
    Segment     =>Segment,
    Display     =>Display,
    
      s00_axi_aclk    => S_AXI_ACLK,
      s00_axi_aresetn => S_AXI_ARESETN,
      s00_axi_awaddr  => S_AXI_AWADDR,
      s00_axi_awprot  => S_AXI_AWPROT,
      s00_axi_awvalid => S_AXI_AWVALID,
      s00_axi_awready => S_AXI_AWREADY,
      s00_axi_wdata   => S_AXI_WDATA,
      s00_axi_wstrb   => S_AXI_WSTRB,
      s00_axi_wvalid  => S_AXI_WVALID,
      s00_axi_wready  => S_AXI_WREADY,
      s00_axi_bresp   => S_AXI_BRESP,
      s00_axi_bvalid  => S_AXI_BVALID,
      s00_axi_bready  => S_AXI_BREADY,
      s00_axi_araddr  => S_AXI_ARADDR,
      s00_axi_arprot  => S_AXI_ARPROT,
      s00_axi_arvalid => S_AXI_ARVALID,
      s00_axi_arready => S_AXI_ARREADY,
      s00_axi_rdata   => S_AXI_RDATA,
      s00_axi_rresp   => S_AXI_RRESP,
      s00_axi_rvalid  => S_AXI_RVALID,
      s00_axi_rready  => S_AXI_RREADY);

 -- Generate S_AXI_ACLK signal
 GENERATE_REFCLOCK : process
 begin
   wait for (ClockPeriod / 2);
   ClockCount:= ClockCount+1;
   S_AXI_ACLK <= '1';
   wait for (ClockPeriod / 2);
   S_AXI_ACLK <= '0';
 end process;

 -- Initiate process which simulates a master wanting to write.
 -- This process is blocked on a "Send Flag" (sendIt).
 -- When the flag goes to 1, the process exits the wait state and
 -- execute a write transaction.
 send : PROCESS
 BEGIN
    S_AXI_AWVALID<='0';
    S_AXI_WVALID<='0';
    S_AXI_BREADY<='0';
    loop
        wait until sendIt = '1';
        wait until S_AXI_ACLK= '0';
            S_AXI_AWVALID<='1';
            S_AXI_WVALID<='1';
        wait until (S_AXI_AWREADY and S_AXI_WREADY) = '1';  --Client ready to read address/data        
            S_AXI_BREADY<='1';
        wait until S_AXI_BVALID = '1';  -- Write result valid
            assert S_AXI_BRESP = "00" report "AXI data not written" severity failure;
            S_AXI_AWVALID<='0';
            S_AXI_WVALID<='0';
            S_AXI_BREADY<='1';
        wait until S_AXI_BVALID = '0';  -- All finished
            S_AXI_BREADY<='0';
    end loop;
 END PROCESS send;

  -- Initiate process which simulates a master wanting to read.
  -- This process is blocked on a "Read Flag" (readIt).
  -- When the flag goes to 1, the process exits the wait state and
  -- execute a read transaction.
  read : PROCESS
  BEGIN
    S_AXI_ARVALID<='0';
    S_AXI_RREADY<='0';
     loop
         wait until readIt = '1';
         wait until S_AXI_ACLK= '0';
             S_AXI_ARVALID<='1';
             S_AXI_RREADY<='1';
         wait until (S_AXI_RVALID and S_AXI_ARREADY) = '1';  --Client provided data
            assert S_AXI_RRESP = "00" report "AXI data not written" severity failure;
             S_AXI_ARVALID<='0';
            S_AXI_RREADY<='0';
     end loop;
  END PROCESS read;


 -- 
 tb : PROCESS
 BEGIN
        S_AXI_ARESETN<='0';
        sendIt<='0';
    wait for 1ms ;
        S_AXI_ARESETN<='1';

        S_AXI_AWADDR<=Registro0;
        S_AXI_WDATA<=x"FFFFFFFF";
        S_AXI_WSTRB<=b"1111";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  --AXI Write finished
        S_AXI_WSTRB<=b"0000";
    wait for 100ns;
        S_AXI_AWADDR<=Registro2;
        S_AXI_WDATA<=x"00000FFF";
        S_AXI_WSTRB<=b"1111";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  --AXI Write finished
        S_AXI_WSTRB<=b"0000";
        
        S_AXI_AWADDR<="00100";
        S_AXI_WDATA<=x"00000002";
        S_AXI_WSTRB<=b"1111";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  --AXI Write finished
        S_AXI_WSTRB<=b"0000";
        
        S_AXI_AWADDR<=Registro1;
        S_AXI_WDATA<=x"A5A5A5A5";
        S_AXI_WSTRB<=b"1111";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  --AXI Write finished
        S_AXI_WSTRB<=b"0000";
    wait for 1ms;
        S_AXI_ARADDR<=Registro0;
        readIt<='1';                --Start AXI Read from Slave
        wait for 1 ns; readIt<='0'; --Clear "Start Read" Flag
    wait until S_AXI_RVALID = '1';
             Registro_Leido<=S_AXI_RDATA;
    wait until S_AXI_RVALID = '0';
     wait for 1ms;
        S_AXI_ARADDR<="00100";
        readIt<='1';                --Start AXI Read from Slave
        wait for 1 ns; readIt<='0'; --Clear "Start Read" Flag
    wait until S_AXI_RVALID = '1';
             Registro_Leido<=S_AXI_RDATA;
    wait until S_AXI_RVALID = '0';
        
     wait; -- will wait forever
 END PROCESS tb;

RESET<='0';
end Behavioral;
