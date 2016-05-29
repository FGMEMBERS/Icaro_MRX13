##################################################################
#
# Parachutes: Set additional variables
#
################################################################## 

var DrogueChute = func {

  var cd        = getprop("sim/model/Parachutes/cd-DrogueChute");
  var area_sqm = getprop("sim/model/Parachutes/area-DrogueChute-sqm");

  var area_sqft = area_sqm * 10.7639;
  var CDxA_sqm  = cd * area_sqm;
  var CDxA_sqft = cd * area_sqft;

  setprop("sim/model/Parachutes/CDxA-DrogueChute-sqm" , CDxA_sqm);
  setprop("sim/model/Parachutes/CDxA-DrogueChute-sqft", CDxA_sqft);

}


var EmergencyChute = func { 

  var cd        = getprop("sim/model/Parachutes/cd-EmergencyChute");
  var area_sqm = getprop("sim/model/Parachutes/area-EmergencyChute-sqm");

  var area_sqft = area_sqm * 10.7639;
  var CDxA_sqm  = cd * area_sqm;
  var CDxA_sqft = cd * area_sqft;

  setprop("sim/model/Parachutes/CDxA-EmergencyChute-sqm" , CDxA_sqm);
  setprop("sim/model/Parachutes/CDxA-EmergencyChute-sqft", CDxA_sqft);

}
