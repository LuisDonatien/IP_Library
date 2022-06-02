#Fichero de restrcciones temporales del IP controlador de motor BLDC
# Restricciones para el Reloj de propósito general y el reloj del bus AXI-LITE

create_clock -period 10.000 -name CLK -waveform {0.000 5.000} -add [get_ports CLK]
create_clock -period 10.000 -name s00_axi_aclk -waveform {0.000 5.000} -add [get_ports s00_axi_aclk]
