################################################################################################
#
# Set default values
#
################################################################################################

var set_defaults = func (device){

  if(device == "aerotow") {
    setprop("sim/hitches/aerotow/tow/length", 60.);
    setprop("sim/hitches/aerotow/tow/brake-force", 1000.);
    setprop("sim/hitches/aerotow/tow/elastic-constant", 9000.);
    setprop("sim/hitches/aerotow/rope/rope-diameter-mm", 8.);
    # setprop("sim/hitches/aerotow/tow/weight-per-m-kg-m", 0.035);

    setprop("sim/hitches/aerotow/force_name_jsbsim","chest");
    setprop("sim/hitches/winch/force_name_jsbsim","chest");
  }

  if(device == "winch") {
    setprop("sim/hitches/winch/tow/initial-tow-length-m", 800.);
    setprop("sim/hitches/winch/tow/max-tow-length-m", 1500.);
    setprop("sim/hitches/winch/tow/break-force-N", 1500.);
    setprop("sim/hitches/winch/tow/elastic-constant", 40000.);
    setprop("sim/hitches/winch/rope/rope-diameter-mm", 20.);
    setprop("sim/hitches/winch/tow/weight-per-m-kg-m", 0.01);

    setprop("sim/hitches/winch/winch/initial-tow-length-m", 800.);
    setprop("sim/hitches/winch/winch/max-tow-length-m", 1500.);
    setprop("sim/hitches/winch/winch/max-power-kW", 10.);
    setprop("sim/hitches/winch/winch/max-force-N", 800.);
    setprop("sim/hitches/winch/winch/max-spool-speed-m-s", 20.);
    setprop("sim/hitches/winch/winch/max-unspool-speed-m-s", 20.);
    setprop("sim/hitches/winch/winch/spool-acceleration-m-s-s", 5.);

    setprop("sim/hitches/winch/force_name_jsbsim","chest");
    setprop("sim/hitches/aerotow/force_name_jsbsim","chest");
  }

  setprop("fdm/jsbsim/external_reactions/belly/magnitude", 0.);
  setprop("fdm/jsbsim/external_reactions/belly/x", 0.);
  setprop("fdm/jsbsim/external_reactions/belly/y", 0.);
  setprop("fdm/jsbsim/external_reactions/belly/z", 0.);

  setprop("fdm/jsbsim/external_reactions/chest/magnitude", 0.);
  setprop("fdm/jsbsim/external_reactions/chest/x", 0.);
  setprop("fdm/jsbsim/external_reactions/chest/y", 0.);
  setprop("fdm/jsbsim/external_reactions/chest/z", 0.);

  setprop("fdm/jsbsim/external_reactions/drop/magnitude", 0.);
  setprop("fdm/jsbsim/external_reactions/drop/x", 0.);
  setprop("fdm/jsbsim/external_reactions/drop/y", 0.);
  setprop("fdm/jsbsim/external_reactions/drop/z", 0.);

}


##################################################################
#
# Wing Failure: Reset all failure values
#
##################################################################

var wing_failure_repair = func {
      setprop("sim/model/MRX13/wing-failure", 0 );
      setprop("sim/model/MRX13/wing-failure-direction", 0 );
      setprop("sim/model/MRX13/wing-failure-left", 0 );
      setprop("sim/model/MRX13/wing-failure-right", 0 );
#      setprop("fdm/jsbsim/metrics/Sw-sqft", 113. );
#      setprop("ai/submodels/submodel[0]/count", 1 );
#      setprop("ai/submodels/submodel[1]/count", 1 );
      if ( getprop("position/altitude-agl-ft") < 4. or
           getprop("sim/model/MRX13/on-ground") ) {
        setprop("orientation/roll-deg", 0. );
        setprop("orientation/pitch-deg", 0. );
      }
      print("plane repaired");
    }


################################################################################################
#
# Avoid possible wing failure at startup
#
################################################################################################

if ( getprop("sim/model/MRX13/wing-failure-enable") ) {
  setprop("sim/model/MRX13/wing-failure-enable",0);
  settimer( func { setprop("sim/model/MRX13/wing-failure-enable", 1 ); }, 2 );
  }


################################################################################################
#
# Set default weight and balance values
#
################################################################################################

var weight_and_balance_defaults = func {

  # hook in weight (pilot + harness)
  var weight_kg = 80. ;
  var weight_lbs = weight_kg / 0.453592;
  setprop("/fdm/jsbsim/inertia/pointmass-weight-kg",weight_kg) ;
  setprop("/fdm/jsbsim/inertia/pointmass-weight-lbs",weight_lbs);

  # wing area
  var area_sqm  = 13.5;
  var area_sqft = area_sqm / 0.09290;
  setprop("fdm/jsbsim/metrics/Sw-sqm" , area_sqm);
  setprop("fdm/jsbsim/metrics/Sw-sqft", area_sqft);
}


################################################################################################
#
# Set default parachutes values
#
################################################################################################

var DrogueChute_defaults = func {

  var cd = 0.75 ;     # Full drag coefficient 0.6 - 0.75
  var area_sqm = 1.;  # Full droguechute area 1m^2
  
  var area_sqft = area_sqm * 10.7639;
  var CDxA_sqm  = cd * area_sqm;
  var CDxA_sqft = cd * area_sqft;
  
  setprop("sim/model/Parachutes/cd-DrogueChute", cd) ;
  setprop("sim/model/Parachutes/area-DrogueChute-sqm", area_sqm);

  setprop("sim/model/Parachutes/CDxA-DrogueChute-sqm" , CDxA_sqm);
  setprop("sim/model/Parachutes/CDxA-DrogueChute-sqft", CDxA_sqft);

}


var EmergencyChute_defaults = func {

  var cd = 2.45 ;      # Full drag coefficient 2.45
  var area_sqm = 32.;  # Full parachute area 32m^2

  var area_sqft = area_sqm * 10.7639;
  var CDxA_sqm  = cd * area_sqm;
  var CDxA_sqft = cd * area_sqft;

  setprop("sim/model/Parachutes/cd-EmergencyChute", cd) ;
  setprop("sim/model/Parachutes/area-EmergencyChute-sqm", area_sqm);

  setprop("sim/model/Parachutes/CDxA-EmergencyChute-sqm" , CDxA_sqm);
  setprop("sim/model/Parachutes/CDxA-EmergencyChute-sqft", CDxA_sqft);

}


################################################################################################
#
# Set default stability factor values
#
################################################################################################

var stability_roll_defaults = func {

  setprop("sim/model/MRX13/stability/factor-Clda", 1.);
  setprop("sim/model/MRX13/stability/factor-Clb" , 1.);
  setprop("sim/model/MRX13/stability/factor-Clr" , 1.);  
  setprop("sim/model/MRX13/stability/factor-Clp" , 1.);

}

var stability_pitch_defaults = func {

  setprop("sim/model/MRX13/stability/factor-Cmalpha", 1.);
  setprop("sim/model/MRX13/stability/factor-Cmq" , 1.);

}

var stability_yaw_defaults = func {

  setprop("sim/model/MRX13/stability/factor-Cnb" , 1.);
  setprop("sim/model/MRX13/stability/factor-Cnp" , 1.);
  setprop("sim/model/MRX13/stability/factor-Cnr" , 1.);
  
}

var stability_SideForce_defaults = func {

  setprop("sim/model/MRX13/stability/factor-Cyb" , 1.);
  setprop("sim/model/MRX13/stability/factor-Cyp" , 1.);
  setprop("sim/model/MRX13/stability/factor-Cyr" , 1.);

}


################################################################################################
#
# Set default smoke generator values
#
################################################################################################

var smoke_defaults = func {

  setprop("sim/model/SmokeTrail/Keel/Generator", 0);
  setprop("sim/model/SmokeTrail/Keel/burning-time-sec", 240);
  setprop("sim/model/SmokeTrail/Keel/red", 0.8);
  setprop("sim/model/SmokeTrail/Keel/green", 0.);
  setprop("sim/model/SmokeTrail/Keel/blue", 0.);

  setprop("sim/model/SmokeTrail/ControlBarLeft/Generator", 0);
  setprop("sim/model/SmokeTrail/ControlBarLeft/burning-time-sec", 180);
  setprop("sim/model/SmokeTrail/ControlBarLeft/red", 0.8);
  setprop("sim/model/SmokeTrail/ControlBarLeft/green", 0.);
  setprop("sim/model/SmokeTrail/ControlBarLeft/blue", 0.);

  setprop("sim/model/SmokeTrail/ControlBarRight/Generator", 0);
  setprop("sim/model/SmokeTrail/ControlBarRight/burning-time-sec", 185); 
  setprop("sim/model/SmokeTrail/ControlBarRight/red", 0.8);
  setprop("sim/model/SmokeTrail/ControlBarRight/green", 0.);
  setprop("sim/model/SmokeTrail/ControlBarRight/blue", 0.);

}


