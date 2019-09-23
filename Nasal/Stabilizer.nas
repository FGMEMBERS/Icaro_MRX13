##################################################################
#
# Horizontal Stabilizer: Provide properties for JSBSim
#
##################################################################

var HorizontalStabilizer = func {

 var location_x_m = getprop("sim/model/Stabilizer/hstab_location-x-m");  # in keel direction
 var location_z_m = getprop("sim/model/Stabilizer/hstab_location-z-m");  # normal to keel

 var PitchOffsetModell_rad = 15.*D2R;

 var location_jsbsim_x_in = ( location_x_m * math.cos(PitchOffsetModell_rad)
                              + location_z_m * math.sin(PitchOffsetModell_rad)
                            ) * M2IN;
 var location_jsbsim_z_in = ( - location_x_m * math.sin(PitchOffsetModell_rad)
                              + location_z_m * math.cos(PitchOffsetModell_rad)
                            ) * M2IN;

 setprop("fdm/jsbsim/inertia/pointmass-location-X-inches[3]",location_jsbsim_x_in);
 setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[3]",location_jsbsim_z_in);

# setprop("fdm/jsbsim/systems/Stabilizer/hstab_location-xb-ft",location_x_m*M2FT);
# setprop("fdm/jsbsim/systems/Stabilizer/hstab_location-zb-ft",location_z_m*M2FT);
 var in2ft = 0.08333;
 setprop("fdm/jsbsim/systems/Stabilizer/hstab_location-xb-ft",location_jsbsim_x_in*in2ft);
 setprop("fdm/jsbsim/systems/Stabilizer/hstab_location-zb-ft",location_jsbsim_z_in*in2ft);


 var area_sqm = getprop("sim/model/Stabilizer/hstab_area-sqm");
 var area_sqft = area_sqm * 10.7639;

 setprop("sim/model/Stabilizer/hstab_area-scale",math.sqrt(area_sqm/0.25));
 setprop("fdm/jsbsim/systems/Stabilizer/Sh-sqft",area_sqft);


 var pitch_deg = getprop("sim/model/Stabilizer/hstab_pitch-deg"); # rel. to keel

 setprop("fdm/jsbsim/systems/Stabilizer/hstab_pitch-deg",pitch_deg);
 setprop("fdm/jsbsim/systems/Stabilizer/hstab_pitch-rad",pitch_deg * D2R);


 var weight_kg  = getprop("sim/model/Stabilizer/hstab_weight-kg");
 var weight_lbs = weight_kg * 2.20462;
 
 if( ! getprop("sim/model/MRX13/with-HorizontalStabilizer") ) {
  weight_kg  = 0.;
  weight_lbs = 0.;
 }
 setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[3]",weight_lbs);
 setprop("sim/model/Stabilizer/hstab_weight-kg_used",weight_kg);


 setprop("fdm/jsbsim/systems/Stabilizer/hstab_enable",getprop("sim/model/MRX13/with-HorizontalStabilizer") );

}

# initialization
HorizontalStabilizer();


##################################################################
#
# Vertical Stabilizer: Provide properties for JSBSim
#
##################################################################

var VerticalStabilizer = func {

 var location_x_m = getprop("sim/model/Stabilizer/vstab_location-x-m");  # in keel direction
 var location_y_m = getprop("sim/model/Stabilizer/vstab_location-y-m");
 #var location_z_m = getprop("sim/model/Stabilizer/vstab_location-z-m"); # normal to keel
 var location_z_m = 0.; # assumption: mass is lumped at vstab root

 var PitchOffsetModell_rad = 15.*D2R;

 var location_jsbsim_x_in = ( location_x_m * math.cos(PitchOffsetModell_rad)
                              + location_z_m * math.sin(PitchOffsetModell_rad)
                            ) * M2IN;
 var location_jsbsim_z_in = ( - location_x_m * math.sin(PitchOffsetModell_rad)
                              + location_z_m * math.cos(PitchOffsetModell_rad)
                            ) * M2IN;

 setprop("fdm/jsbsim/inertia/pointmass-location-X-inches[4]",location_jsbsim_x_in);
 setprop("fdm/jsbsim/inertia/pointmass-location-Y-inches[4]",location_y_m * M2IN);
 setprop("fdm/jsbsim/inertia/pointmass-location-Z-inches[4]",location_jsbsim_z_in);

# setprop("fdm/jsbsim/systems/Stabilizer/vstab_location-xb-ft",location_x_m*M2FT);
# setprop("fdm/jsbsim/systems/Stabilizer/vstab_location-yb-ft",location_y_m*M2FT);
 #setprop("fdm/jsbsim/systems/Stabilizer/vstab_location-zb-ft",location_z_m*M2FT);
 var in2ft = 0.08333;
 setprop("fdm/jsbsim/systems/Stabilizer/vstab_location-xb-ft",location_jsbsim_x_in*in2ft);
 setprop("fdm/jsbsim/systems/Stabilizer/vstab_location-yb-ft",location_y_m * M2FT);
 #setprop("fdm/jsbsim/systems/Stabilizer/vstab_location-zb-ft",location_jsbsim_z_in*in2ft);
 

 var area_sqm = getprop("sim/model/Stabilizer/vstab_area-sqm");
 var area_sqft = area_sqm * 10.7639;

 setprop("sim/model/Stabilizer/vstab_area-scale",math.sqrt(area_sqm/0.25));
 setprop("fdm/jsbsim/systems/Stabilizer/Sv-sqft",area_sqft);


 var deflection_deg = getprop("sim/model/Stabilizer/vstab_deflection-deg"); # rel. to keel

 setprop("fdm/jsbsim/systems/Stabilizer/vstab_deflection-deg",deflection_deg);
 setprop("fdm/jsbsim/systems/Stabilizer/vstab_deflection-rad",deflection_deg * D2R);


 var weight_kg  = getprop("sim/model/Stabilizer/vstab_weight-kg");
 var weight_lbs = weight_kg * 2.20462;
 
 if( ! getprop("sim/model/MRX13/with-VerticalStabilizer") ) {
  weight_kg  = 0.;
  weight_lbs = 0.;
 }
 setprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",weight_lbs);
 setprop("sim/model/Stabilizer/vstab_weight-kg_used",weight_kg);


 setprop("fdm/jsbsim/systems/Stabilizer/vstab_enable",getprop("sim/model/MRX13/with-VerticalStabilizer") );

}

# initialization
VerticalStabilizer();

