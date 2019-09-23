##################################################################
#
# Weight and balance properties
#
##################################################################

var inertia_weight_to_kg = func {

 var weight_lbs = getprop("fdm/jsbsim/inertia/weight-lbs");
 var weight_kg = weight_lbs * 0.453592;
 setprop("fdm/jsbsim/inertia/weight-kg",weight_kg) ;

}

