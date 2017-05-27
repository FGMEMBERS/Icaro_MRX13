var RunningAnimation = func {
#
# ---------------------------------------------------------------------------------
#                        Running Animation                      Status: 01.04.2017
# ---------------------------------------------------------------------------------
#
if( !getprop("sim/replay/replay-state") ) { # skip in flight recorder replay mode
#
# Variables:
# ----------
# running_leg_left/right := entire leg (LegUpper+LegLower+Shoe)
# running_leg            := only lower leg + shoe
#
#
# -------------------------------------------------------------
#                            gear and prone
# -------------------------------------------------------------
#
var gear_pos_norm = getprop("gear/gear[1]/position-norm"); # gear in-out (0-1)

if( gear_pos_norm > 0) {

  # trick: slight time shift to ensure that legs are entirely inside
  #harness before this routine stops
  gear_pos_norm = math.max(0, (gear_pos_norm-0.02)*1.02);

  var legs_pos_gear = gear_pos_norm * 90.;

  # -------------------------------------------------------------
  #                              running
  # -------------------------------------------------------------

  var legs_pos_run = 7.5 ;    #initializing
  var position_lower_leg = -30.;
  var position_dot_sign = 0.;
  var weighting_altitude = 0.;

  var altitude = getprop("position/altitude-agl-ft");
  # var brake    = getprop("controls/gear/brake-parking");

  if(altitude < 15. ) {

    var groundspeed = getprop("velocities/uBody-fps") +
                      getprop("sim/model/MRX13/animation/ahead")*15;
    var phi_rad = getprop("sim/model/MRX13/animation/phi-rad");
    var dt = getprop("sim/time/delta-sec");

    weighting_altitude = math.clamp( (15-altitude)/10 , 0, 1);

    var step_length_deg = math.min( math.sqrt( abs(groundspeed) ) * 10 , 50 );
    step_length_deg = step_length_deg * weighting_altitude + 0.0000001;

    var delta_phi_rad = 2. * math.pi * math.min(groundspeed , 35 ) / math.sqrt(step_length_deg) / 2 * dt ;
    delta_phi_rad = delta_phi_rad * weighting_altitude;

    phi_rad = phi_rad + delta_phi_rad;
    phi_rad = math.periodic(0, 2*math.pi, phi_rad);

    legs_pos_run = step_length_deg * math.sin( phi_rad );

    position_dot_sign = math.cos( phi_rad );

    if ( abs(groundspeed) < .01 ) {
      legs_pos_run = 0.;
      position_dot_sign = 0.;
      position_lower_leg = 0;
    }
    else {
      var position_lower_leg = -2. * step_length_deg + 2. * abs( legs_pos_run );
    }
    setprop("sim/model/MRX13/animation/phi-rad",phi_rad);

    legs_pos_run = 7.5 * (1-weighting_altitude) + legs_pos_run * weighting_altitude;
    position_lower_leg = -30 * (1-weighting_altitude) + position_lower_leg * weighting_altitude;

  } # end altitude<15

  var position2 = position_lower_leg *  gear_pos_norm;
  setprop("sim/model/MRX13/animation/running_leg",position2);
  setprop("sim/model/MRX13/animation/running_leg_sign",position_dot_sign);

  var leg_pos_left  = legs_pos_gear + legs_pos_run * gear_pos_norm;
  var leg_pos_right = legs_pos_gear - legs_pos_run * gear_pos_norm;

  setprop("sim/model/MRX13/animation/running_leg_left" ,leg_pos_left);
  setprop("sim/model/MRX13/animation/running_leg_right",leg_pos_right);

  # -------------------------------------------------------------
  #                              sidestep
  # -------------------------------------------------------------

  sidestep_deg = 0.;

  if(altitude < 10. ) {

    var sidespeed = getprop("sim/model/MRX13/animation/side");
    phi_rad = getprop("sim/model/MRX13/animation/phi_side-rad");

    if ( sidespeed == 0. ) phi_rad = 0.;

    delta_phi_rad = 2. * math.pi * 0.7 * dt ;

    phi_rad = phi_rad + delta_phi_rad;
    phi_rad = math.periodic(0, math.pi, phi_rad);

    sidestep_deg = math.min( abs(sidespeed) * 40 , 30 );
    sidestep_deg = sidestep_deg * math.sin( phi_rad );

    setprop("sim/model/MRX13/animation/phi_side-rad",phi_rad);

  } # end altitude<10

  setprop("sim/model/MRX13/animation/sidestep-deg" ,sidestep_deg);

 } # end gear out
}
  settimer(RunningAnimation,0);

#
# -------------------------------------------------------------
#             groundhandling/walking         Status: 18.04.2016
# -------------------------------------------------------------
#
  var on_ground   = getprop("fdm/jsbsim/systems/on-ground");

  if ( on_ground > 0 ){
     Walking();
   }
   else{
      setprop("sim/model/MRX13/animation/ahead",0.);
      setprop("sim/model/MRX13/animation/side",0.);
   }
#
# -------------------------------------------------------------

}

# Start the running animation delayed to ensure that all necessary variables are initialized
setprop("sim/model/MRX13/animation/running_leg",30);   # 30 -> deflection lower leg is 0
setprop("sim/model/MRX13/animation/running_leg_sign",0);

settimer(RunningAnimation,1);



#########################################################################
#########################################################################
#
# -------------------------------------------------------------
#                              walking
# -------------------------------------------------------------
#
var Walking = func(){

  var heading_deg = getprop("orientation/heading-deg");

  # --- enforce turning ---
  var pitch_deg = getprop("orientation/pitch-deg");
  var roll_deg  = getprop("orientation/roll-deg");

  var step_deg = 1.;

  var turning = getprop("fdm/jsbsim/fcs/turning-moment-norm");

  if(turning != 0.){

    if ( turning < 0. ) step_deg = - step_deg ;
    var heading_deg = heading_deg + step_deg ;

    setprop("orientation/heading-deg",heading_deg);
    setprop("fdm/jsbsim/fcs/turning-moment-norm",0);

    var delta_heading_rad = step_deg * 0.0174532;
    var sin_delta_heading = math.sin( delta_heading_rad );
    var cos_delta_heading = math.cos( delta_heading_rad );

    var pitch = pitch_deg * cos_delta_heading - roll_deg * sin_delta_heading;
    var roll  = pitch_deg * sin_delta_heading + roll_deg * cos_delta_heading;
    setprop("orientation/pitch-deg",pitch);
    setprop("orientation/roll-deg",roll);

  }

  # --- enforce walking ---
  var heading_rad = heading_deg * 0.0174532;
  var sin_heading = math.sin( heading_rad );
  var cos_heading = math.cos( heading_rad );

  var step_size = 0.0000005;

  var side = getprop("sim/model/MRX13/animation/side");
  var step_side_deg = side * step_size;

  var ahead  = getprop("sim/model/MRX13/animation/ahead");
  var step_ahead_deg = ahead * step_size;

  #var longitude_deg = getprop("position/longitude-deg");
  #var latitude_deg  = getprop("position/latitude-deg");
  var longitude_deg = getprop("fdm/jsbsim/position/long-gc-deg");
  var latitude_deg  = getprop("fdm/jsbsim/position/lat-gc-deg");

  latitude_deg  = latitude_deg  + step_ahead_deg * cos_heading - step_side_deg * sin_heading;
  longitude_deg = longitude_deg + step_ahead_deg * sin_heading + step_side_deg * cos_heading;

  #setprop("position/longitude-deg",longitude_deg);
  #setprop("position/latitude-deg" ,latitude_deg);
  setprop("fdm/jsbsim/position/long-gc-deg",longitude_deg);
  setprop("fdm/jsbsim/position/lat-gc-deg" ,latitude_deg);

}
