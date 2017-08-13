##################################################################
#
# Wheel properties
#
##################################################################

var Wheels = func {

 # wheel left
 var weight_kg  = getprop("sim/model/Wheels/wheel_left_weight-kg");
 var weight_lbs = weight_kg * 2.20462;

 if( ! getprop("sim/model/MRX13/with-wheels") ) {
  weight_kg  = 0.;
  weight_lbs = 0.;
 }
 setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",weight_lbs);
 setprop("sim/model/Wheels/wheel_left_weight-kg_used",weight_kg);


 # wheel right
 weight_kg  = getprop("sim/model/Wheels/wheel_right_weight-kg");
 weight_lbs = weight_kg * 2.20462;

 if( ! getprop("sim/model/MRX13/with-wheels") ) {
  weight_kg  = 0.;
  weight_lbs = 0.;
 }
 setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[2]",weight_lbs);
 setprop("sim/model/Wheels/wheel_right_weight-kg_used",weight_kg);

}

# initialization
#Wheels();
# listener needed for Variants
setlistener("sim/model/MRX13/with-wheels", Wheels, 1, 0 );


