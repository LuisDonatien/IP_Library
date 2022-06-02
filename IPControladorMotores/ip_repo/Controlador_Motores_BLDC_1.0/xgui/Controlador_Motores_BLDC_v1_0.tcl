
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/Controlador_Motores_BLDC_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {CONFIGURACION AXI}]
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}

  #Adding Page
  set CONFIGURACION_CONTROLADOR [ipgui::add_page $IPINST -name "CONFIGURACION CONTROLADOR"]
  ipgui::add_param $IPINST -name "DIRECTO" -parent ${CONFIGURACION_CONTROLADOR}
  ipgui::add_param $IPINST -name "CONTROLADOR" -parent ${CONFIGURACION_CONTROLADOR}
  #Adding Group
  set TIPO_CONTROLADOR [ipgui::add_group $IPINST -name "TIPO CONTROLADOR" -parent ${CONFIGURACION_CONTROLADOR}]
  ipgui::add_param $IPINST -name "TIPOCONTROLADOR" -parent ${TIPO_CONTROLADOR} -widget comboBox
  #Adding Group
  set CONTROLADOR_PI [ipgui::add_group $IPINST -name "CONTROLADOR PI" -parent ${TIPO_CONTROLADOR} -layout horizontal]
  ipgui::add_param $IPINST -name "KP" -parent ${CONTROLADOR_PI}
  ipgui::add_param $IPINST -name "KI" -parent ${CONTROLADOR_PI}
  #Adding Group
  set Tiempo_de_muestreo [ipgui::add_group $IPINST -name "Tiempo de muestreo" -parent ${CONTROLADOR_PI}]
  ipgui::add_param $IPINST -name "SAMPLES" -parent ${Tiempo_de_muestreo}



  #Adding Group
  set PWM_Configuracion [ipgui::add_group $IPINST -name "PWM Configuracion" -parent ${CONFIGURACION_CONTROLADOR} -layout horizontal]
  ipgui::add_param $IPINST -name "Frecuencia" -parent ${PWM_Configuracion} -widget comboBox
  ipgui::add_param $IPINST -name "Duty_SIZE" -parent ${PWM_Configuracion}
  #Adding Group
  set PWM_COMPLEMENTARIO [ipgui::add_group $IPINST -name "PWM COMPLEMENTARIO" -parent ${PWM_Configuracion}]
  ipgui::add_static_text $IPINST -name "Intro Complementario" -parent ${PWM_COMPLEMENTARIO} -text {Seleccione la opci髇 de complementario si desea generar una se馻l complementaria a la se馻l PWM superior.

Defina el n鷐ero de ciclos de Deadband entre la se馻l superior e inferior.

Tenga en cuenta que la base son 100MHz.}
  ipgui::add_param $IPINST -name "COMPLEMENTARIO" -parent ${PWM_COMPLEMENTARIO}
  ipgui::add_param $IPINST -name "DeadBand" -parent ${PWM_COMPLEMENTARIO}


  #Adding Group
  set FILTROS_HALL [ipgui::add_group $IPINST -name "FILTROS HALL" -parent ${CONFIGURACION_CONTROLADOR}]
  ipgui::add_static_text $IPINST -name "INTRO HALL" -parent ${FILTROS_HALL} -text {El filtrado de las se馻les se realiza mediante un detector anti-rebotes.

Escoja el numero de ciclos necesarios para que la se馻l sea estable.

Tenga en cuenta que la base son 100MHz}
  ipgui::add_param $IPINST -name "Ciclos" -parent ${FILTROS_HALL}


  #Adding Page
  set DEBUG [ipgui::add_page $IPINST -name "DEBUG"]
  #Adding Group
  set Salidas_de_consulta_del_m贸dulo_IP [ipgui::add_group $IPINST -name "Salidas de consulta del m贸dulo IP" -parent ${DEBUG} -display_name {Salidas de consulta del m骴ulo IP} -layout horizontal]
  ipgui::add_param $IPINST -name "DEBUG_HALL" -parent ${Salidas_de_consulta_del_m贸dulo_IP}
  ipgui::add_param $IPINST -name "DEBUG_PWM" -parent ${Salidas_de_consulta_del_m贸dulo_IP}
  ipgui::add_param $IPINST -name "DEBUG_DUTY" -parent ${Salidas_de_consulta_del_m贸dulo_IP}



}

proc update_PARAM_VALUE.CONTROLADOR { PARAM_VALUE.CONTROLADOR PARAM_VALUE.TIPOCONTROLADOR } {
	# Procedure called to update CONTROLADOR when any of the dependent parameters in the arguments change
	
	set CONTROLADOR ${PARAM_VALUE.CONTROLADOR}
	set TIPOCONTROLADOR ${PARAM_VALUE.TIPOCONTROLADOR}
	set values(TIPOCONTROLADOR) [get_property value $TIPOCONTROLADOR]
	set_property value [gen_USERPARAMETER_CONTROLADOR_VALUE $values(TIPOCONTROLADOR)] $CONTROLADOR
}

proc validate_PARAM_VALUE.CONTROLADOR { PARAM_VALUE.CONTROLADOR } {
	# Procedure called to validate CONTROLADOR
	return true
}

proc update_PARAM_VALUE.DIRECTO { PARAM_VALUE.DIRECTO PARAM_VALUE.TIPOCONTROLADOR } {
	# Procedure called to update DIRECTO when any of the dependent parameters in the arguments change
	
	set DIRECTO ${PARAM_VALUE.DIRECTO}
	set TIPOCONTROLADOR ${PARAM_VALUE.TIPOCONTROLADOR}
	set values(TIPOCONTROLADOR) [get_property value $TIPOCONTROLADOR]
	set_property value [gen_USERPARAMETER_DIRECTO_VALUE $values(TIPOCONTROLADOR)] $DIRECTO
}

proc validate_PARAM_VALUE.DIRECTO { PARAM_VALUE.DIRECTO } {
	# Procedure called to validate DIRECTO
	return true
}

proc update_PARAM_VALUE.DeadBand { PARAM_VALUE.DeadBand PARAM_VALUE.COMPLEMENTARIO } {
	# Procedure called to update DeadBand when any of the dependent parameters in the arguments change
	
	set DeadBand ${PARAM_VALUE.DeadBand}
	set COMPLEMENTARIO ${PARAM_VALUE.COMPLEMENTARIO}
	set values(COMPLEMENTARIO) [get_property value $COMPLEMENTARIO]
	if { [gen_USERPARAMETER_DeadBand_ENABLEMENT $values(COMPLEMENTARIO)] } {
		set_property enabled true $DeadBand
	} else {
		set_property enabled false $DeadBand
	}
}

proc validate_PARAM_VALUE.DeadBand { PARAM_VALUE.DeadBand } {
	# Procedure called to validate DeadBand
	return true
}

proc update_PARAM_VALUE.Duty_SIZE { PARAM_VALUE.Duty_SIZE PARAM_VALUE.Frecuencia } {
	# Procedure called to update Duty_SIZE when any of the dependent parameters in the arguments change
	
	set Duty_SIZE ${PARAM_VALUE.Duty_SIZE}
	set Frecuencia ${PARAM_VALUE.Frecuencia}
	set values(Frecuencia) [get_property value $Frecuencia]
	set_property value [gen_USERPARAMETER_Duty_SIZE_VALUE $values(Frecuencia)] $Duty_SIZE
}

proc validate_PARAM_VALUE.Duty_SIZE { PARAM_VALUE.Duty_SIZE } {
	# Procedure called to validate Duty_SIZE
	return true
}

proc update_PARAM_VALUE.KI { PARAM_VALUE.KI PARAM_VALUE.DIRECTO } {
	# Procedure called to update KI when any of the dependent parameters in the arguments change
	
	set KI ${PARAM_VALUE.KI}
	set DIRECTO ${PARAM_VALUE.DIRECTO}
	set values(DIRECTO) [get_property value $DIRECTO]
	if { [gen_USERPARAMETER_KI_ENABLEMENT $values(DIRECTO)] } {
		set_property enabled true $KI
	} else {
		set_property enabled false $KI
	}
}

proc validate_PARAM_VALUE.KI { PARAM_VALUE.KI } {
	# Procedure called to validate KI
	return true
}

proc update_PARAM_VALUE.KP { PARAM_VALUE.KP PARAM_VALUE.DIRECTO } {
	# Procedure called to update KP when any of the dependent parameters in the arguments change
	
	set KP ${PARAM_VALUE.KP}
	set DIRECTO ${PARAM_VALUE.DIRECTO}
	set values(DIRECTO) [get_property value $DIRECTO]
	if { [gen_USERPARAMETER_KP_ENABLEMENT $values(DIRECTO)] } {
		set_property enabled true $KP
	} else {
		set_property enabled false $KP
	}
}

proc validate_PARAM_VALUE.KP { PARAM_VALUE.KP } {
	# Procedure called to validate KP
	return true
}

proc update_PARAM_VALUE.SAMPLES { PARAM_VALUE.SAMPLES PARAM_VALUE.DIRECTO } {
	# Procedure called to update SAMPLES when any of the dependent parameters in the arguments change
	
	set SAMPLES ${PARAM_VALUE.SAMPLES}
	set DIRECTO ${PARAM_VALUE.DIRECTO}
	set values(DIRECTO) [get_property value $DIRECTO]
	if { [gen_USERPARAMETER_SAMPLES_ENABLEMENT $values(DIRECTO)] } {
		set_property enabled true $SAMPLES
	} else {
		set_property enabled false $SAMPLES
	}
}

proc validate_PARAM_VALUE.SAMPLES { PARAM_VALUE.SAMPLES } {
	# Procedure called to validate SAMPLES
	return true
}

proc update_PARAM_VALUE.COMPLEMENTARIO { PARAM_VALUE.COMPLEMENTARIO } {
	# Procedure called to update COMPLEMENTARIO when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COMPLEMENTARIO { PARAM_VALUE.COMPLEMENTARIO } {
	# Procedure called to validate COMPLEMENTARIO
	return true
}

proc update_PARAM_VALUE.Ciclos { PARAM_VALUE.Ciclos } {
	# Procedure called to update Ciclos when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Ciclos { PARAM_VALUE.Ciclos } {
	# Procedure called to validate Ciclos
	return true
}

proc update_PARAM_VALUE.DEBUG_DUTY { PARAM_VALUE.DEBUG_DUTY } {
	# Procedure called to update DEBUG_DUTY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_DUTY { PARAM_VALUE.DEBUG_DUTY } {
	# Procedure called to validate DEBUG_DUTY
	return true
}

proc update_PARAM_VALUE.DEBUG_HALL { PARAM_VALUE.DEBUG_HALL } {
	# Procedure called to update DEBUG_HALL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_HALL { PARAM_VALUE.DEBUG_HALL } {
	# Procedure called to validate DEBUG_HALL
	return true
}

proc update_PARAM_VALUE.DEBUG_PWM { PARAM_VALUE.DEBUG_PWM } {
	# Procedure called to update DEBUG_PWM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_PWM { PARAM_VALUE.DEBUG_PWM } {
	# Procedure called to validate DEBUG_PWM
	return true
}

proc update_PARAM_VALUE.Frecuencia { PARAM_VALUE.Frecuencia } {
	# Procedure called to update Frecuencia when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Frecuencia { PARAM_VALUE.Frecuencia } {
	# Procedure called to validate Frecuencia
	return true
}

proc update_PARAM_VALUE.TIPOCONTROLADOR { PARAM_VALUE.TIPOCONTROLADOR } {
	# Procedure called to update TIPOCONTROLADOR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TIPOCONTROLADOR { PARAM_VALUE.TIPOCONTROLADOR } {
	# Procedure called to validate TIPOCONTROLADOR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.CONTROLADOR { MODELPARAM_VALUE.CONTROLADOR PARAM_VALUE.CONTROLADOR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONTROLADOR}] ${MODELPARAM_VALUE.CONTROLADOR}
}

proc update_MODELPARAM_VALUE.DIRECTO { MODELPARAM_VALUE.DIRECTO PARAM_VALUE.DIRECTO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIRECTO}] ${MODELPARAM_VALUE.DIRECTO}
}

proc update_MODELPARAM_VALUE.KP { MODELPARAM_VALUE.KP PARAM_VALUE.KP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KP}] ${MODELPARAM_VALUE.KP}
}

proc update_MODELPARAM_VALUE.KI { MODELPARAM_VALUE.KI PARAM_VALUE.KI } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KI}] ${MODELPARAM_VALUE.KI}
}

proc update_MODELPARAM_VALUE.SAMPLES { MODELPARAM_VALUE.SAMPLES PARAM_VALUE.SAMPLES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SAMPLES}] ${MODELPARAM_VALUE.SAMPLES}
}

proc update_MODELPARAM_VALUE.COMPLEMENTARIO { MODELPARAM_VALUE.COMPLEMENTARIO PARAM_VALUE.COMPLEMENTARIO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COMPLEMENTARIO}] ${MODELPARAM_VALUE.COMPLEMENTARIO}
}

proc update_MODELPARAM_VALUE.Duty_SIZE { MODELPARAM_VALUE.Duty_SIZE PARAM_VALUE.Duty_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Duty_SIZE}] ${MODELPARAM_VALUE.Duty_SIZE}
}

proc update_MODELPARAM_VALUE.DeadBand { MODELPARAM_VALUE.DeadBand PARAM_VALUE.DeadBand } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DeadBand}] ${MODELPARAM_VALUE.DeadBand}
}

proc update_MODELPARAM_VALUE.Frecuencia { MODELPARAM_VALUE.Frecuencia PARAM_VALUE.Frecuencia } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Frecuencia}] ${MODELPARAM_VALUE.Frecuencia}
}

proc update_MODELPARAM_VALUE.Ciclos { MODELPARAM_VALUE.Ciclos PARAM_VALUE.Ciclos } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Ciclos}] ${MODELPARAM_VALUE.Ciclos}
}

