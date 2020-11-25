# Power nets
set ::power_nets $::env(_VDD_NET_NAME)
set ::ground_nets $::env(_GND_NET_NAME)

set stdcell {
    name grid
	core_ring {
		met5 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_H_OFFSET)}
		met4 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_V_OFFSET)}
	}
	rails {
	}
    connect {{met4 met5}}
}

if { $::env(_WITH_STRAPS) } {
	dict append stdcell straps {
	    met4 {width $::env(_WIDTH) pitch $::env(_V_PITCH) offset $::env(_V_PDN_OFFSET)}
	    met5 {width $::env(_WIDTH) pitch $::env(_H_PITCH) offset $::env(_H_PDN_OFFSET)}
    }
}

pdngen::specify_grid stdcell $stdcell

pdngen::specify_grid macro {
	instance "obs_core_obs"
    power_pins $::env(_VDD_NET_NAME)
    ground_pins $::env(_GND_NET_NAME)
    blockages "li1 met1 met2 met3 met4 met5"
    straps { 
    } 
    connect {}
}


pdngen::specify_grid macro {
    power_pins $::env(_VDD_NET_NAME)
    ground_pins $::env(_GND_NET_NAME)
    blockages "li1 met1 met2 met3 met4"
    straps { 
    } 
    connect {}
}

set ::halo 10

# POWER or GROUND #Std. cell rails starting with power or ground rails at the bottom of the core area
set ::rails_start_with "POWER" ;

# POWER or GROUND #Upper metal stripes starting with power or ground rails at the left/bottom of the core area
set ::stripes_start_with "POWER" ;
