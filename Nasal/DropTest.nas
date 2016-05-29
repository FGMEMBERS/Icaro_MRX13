##################################################################
#
# Drop Test: Defined positioning of the glider in air
#
##################################################################

var DropTest = func {

 setprop("fdm/jsbsim/forces/hold-down",1);
 setprop("fdm/jsbsim/position/h-agl-km",getprop("sim/model/DropTest/height-agl-m")/1000.);
 setprop("orientation/heading-deg",getprop("sim/model/DropTest/glider-heading-deg") ) ;
 setprop("orientation/pitch-deg",getprop("sim/model/DropTest/glider-pitch-deg") -15. ) ;
 setprop("orientation/roll-deg",getprop("sim/model/DropTest/glider-roll-deg") ) ;
 setprop("controls/flight/elevator",getprop("sim/model/DropTest/pilot-elevator-cmd") );
 setprop("controls/flight/aileron",getprop("sim/model/DropTest/pilot-aileron-cmd") );

}


