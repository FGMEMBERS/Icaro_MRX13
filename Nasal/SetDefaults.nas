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
      if ( getprop("position/altitude-agl-ft") < 4. ) {
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

  # wing aerea
  var area_sqm  = 13.5;
  var area_sqft = area_sqm / 0.09290;
  setprop("fdm/jsbsim/metrics/Sw-sqm" , area_sqm);
  setprop("fdm/jsbsim/metrics/Sw-sqft", area_sqft);
}