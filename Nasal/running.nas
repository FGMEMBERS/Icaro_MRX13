var RunningAnimation = func {
#
# ---------------------------------------------------------------------------------
#                        Running Animation                      Status: 09.04.2016
# ---------------------------------------------------------------------------------
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
  var legs_pos_gear = gear_pos_norm * 90.;
#
# -------------------------------------------------------------
#                              running
# -------------------------------------------------------------
#
  var legs_pos_run = 0 ;    #initializing
  var time = getprop("sim/time/elapsed-sec");

    var altitude = getprop("position/altitude-agl-ft");
    var brake    = getprop("controls/gear/brake-parking");
    var u_fps    = getprop("/fdm/jsbsim/velocities/u-fps");

    if(altitude < 10. ) {

      var groundspeed = getprop("velocities/groundspeed-kt");

      var direction = 1;
      if ( u_fps < 0. ) {var direction = -1; }

      var omega = 0.;
      if      ( groundspeed < .25 ) { var omega = 0; }
      else if ( groundspeed <  5  ) { var omega = 2. * math.pi / 4 * direction; }
      else if ( groundspeed <  20 ) { var omega = 2. * math.pi / 2 * direction; }
      else if ( groundspeed <  40 ) { var omega = 2. * math.pi     * direction; }
      else                          { var omega = 2. * math.pi * 2 * direction;}

      var legs_pos_run = 30. * math.sin( omega * time );
      var position_dot_sign = math.cos( omega * time );

      if ( groundspeed < .25  )
        { var legs_pos_run = 0. ;
          var position_dot_sign = 0.;
          var position_lower_leg = 30; }
      else
        { var position_lower_leg = legs_pos_run; }
    }    # end altitude<10
    else # above altitude 10
    {
    #  var legs_pos_run = 0.; # straight
      var legs_pos_run = 7.5;
      var position_dot_sign = 0.;
    #  var position_lower_leg = 30;  # straight
      var position_lower_leg = 15;
    }
    var position2 = position_lower_leg *  gear_pos_norm + 30 * (  1 - gear_pos_norm );
    setprop("sim/model/MRX13/animation/running_leg",position2);
    setprop("sim/model/MRX13/animation/running_leg_sign",position_dot_sign);

  var leg_pos_left  = legs_pos_gear + legs_pos_run * gear_pos_norm;
  var leg_pos_right = legs_pos_gear - legs_pos_run * gear_pos_norm;

  setprop("sim/model/MRX13/animation/running_leg_left" ,leg_pos_left);
  setprop("sim/model/MRX13/animation/running_leg_right",leg_pos_right);

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


#########################################################################
#########################################################################

#
# ---------------------------------------------------------------------------------
#               Launch Position (experimental)                  Status: 30.08.2014
# ---------------------------------------------------------------------------------
#
var GliderLaunchPosition = func {

  # f=m*a  a=f/m  a=v/t=s/(t*t)      s=f/m*t*t
  # m = fdm/jsbsim/inertia/empty-weight-lbs  (35kg)
  # t = sim/time/delta-sec

  var length    = getprop("sim/model/MRX13/LaunchPosition");
  var pilot_attitude_rad = 0.0174532 * getprop("controls/flight/pilot-attitude-deg");
  var length_max = 1.0 - 0.35 - 0.5*math.sin(pilot_attitude_rad);
  #var length_max = 0.15 + 75-1.0 - 0.35 - 0.5*math.sin(pilot_attitude_rad);
  var length_max = 0.15;  # valid for upright position only 
  
  var force_aero = - getprop("fdm/jsbsim/forces/fbz-aero-lbs") * 4.4482216153 ;
  var dt        = getprop("sim/time/delta-sec"); #check if this is valid for nasal update-time
  var mass_wing = 35.;  # m = fdm/jsbsim/inertia/empty-weight-lbs  (35kg)
  var force_gravity = mass_wing * 9.81 ;


  var force_wing = force_aero - force_gravity ;  # we assume a horizontal position of the wing!

  var delta_length = force_wing / mass_wing * dt*dt ;
  length = length - delta_length;  # 0:= flying position / length_max := launch position

  if ( length < 0. ) {
    length = 0.;
    setprop("sim/model/MRX13/RotateAboutHangpoint", 1 );
    setprop("sim/model/MRX13/RotateAboutPilot", 0 );
    }
  else if ( length > length_max ) {
    length = length_max;
    setprop("sim/model/MRX13/RotateAboutHangpoint", 0 );
    setprop("sim/model/MRX13/RotateAboutPilot", 1 );
  }
  else {
    setprop("sim/model/MRX13/RotateAboutHangpoint", 0 );
    setprop("sim/model/MRX13/RotateAboutPilot", 1 );
  }
 
  setprop("sim/model/MRX13/LaunchPosition",length);

  settimer(GliderLaunchPosition,0);
}

# Start GliderLaunchPosition ASAP
setprop("sim/model/MRX13/LaunchPosition", 0.15 );      # default/initialization
setprop("sim/model/MRX13/RotateAboutHangpoint", 0 );
setprop("sim/model/MRX13/RotateAboutPilot", 1 );

GliderLaunchPosition();
