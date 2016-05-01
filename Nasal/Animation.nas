var ViewAnimation = func {
#
# ---------------------------------------------------------------------------------
#                        View and Hitch Animation               Status: 1.05.2016
# ---------------------------------------------------------------------------------
#
#
# Definitions:
# ----------------
#
# roll     pitch       yaw      prone
# alpha    beta        gamma    theta
# aileron  elevator    rudder   pilot-attitude-deg
# +-15deg  -20/+20deg  +-25deg  +75/0/-10
#
#
#       z                  y
#       |  y               |  x
#       | /                | /
#       |/                 |/
#       ----->x            ----->z
#
#
#     FDM-System          View-System
# (Structural Frame)
#
#
# view-no |       name        | animation on ground |  animation in air    |
#---------|-------------------|---------------------|----------------------|
#     0   | Pilot View        |      only prone     | deflection w/o angle |
#    11   | Left Wingtip View | deflection + angle  |           -          |
#     8   | Harness View      |      only prone     | deflection + angle   |
#     9   | Keel View
#         | Hitch             |          -          | deflection w/o angle |
#----------------------------------------------------------------------------------

var m2in = 39.3700787;

var view_number = getprop("sim/current-view/view-number");
var on_ground   = getprop("fdm/jsbsim/systems/on-ground");
#var rotation = 0;          # help variable (0:= do not run rotation routine / 1:= run rotation routine
#var rotation_harness = 0;  # help variable (0:= do not rotate harness / 1:= rotate harness

var mode = ["dummy","dummy","dummy"];
var device=["dummy","dummy","dummy"];
var hitch= ["dummy","dummy","dummy"];

var n_loop = 0;

if ( view_number == 0 or view_number == 8 or view_number == 11 ) {
  n_loop = n_loop + 1;
  mode[n_loop-1] = "view_animation";
  }
if ( getprop("sim/hitches/aerotow/open") == 0 ) {
  n_loop = n_loop + 1;
  mode[n_loop-1] = "hitch_animation";
  device[n_loop-1] = "aerotow";
  hitch[n_loop-1] = getprop("sim/hitches/aerotow/force_name_jsbsim");
  }
if ( getprop("sim/hitches/winch/open") == 0 ) {
  n_loop = n_loop + 1;
  mode[n_loop-1] = "hitch_animation";
  device[n_loop-1] = "winch";
  hitch[n_loop-1] = getprop("sim/hitches/winch/force_name_jsbsim");
  }
if ( getprop("sim/model/MRX13/DrogueChute") == 1 ) {
  n_loop = n_loop + 1;
  mode[n_loop-1] = "droguechute_animation";
  }

for (var n=0; n < n_loop; n = n+1) {

  var rotation = 0;          # help variable (0:= do not run rotation routine / 1:= run rotation routine
  var rotation_harness = 0;  # help variable (0:= do not rotate harness / 1:= rotate harness

  if( mode[n] == "view_animation") {
    if ( view_number == 0 ) {
      # Point to rotate = X = (x,y,z) (Eyes; FDM-system)
      var x = -0.867;
      var y = 0;
      var z = -1.287;
      if ( on_ground == 0 ) { var rotation = 1; };
      var rotation_harness = 1;
    }
    else if ( view_number == 8 ) {
      # Point to rotate = X = (x,y,z) (Harness View; FDM-system)
      var x = 0.504;
      var y = 0.;
      var z = -1.106;
      if ( on_ground == 0 ) { var rotation = 1; };
      var rotation_harness = 1;
    }
    else if ( view_number == 11 ) {
      # Point to rotate = X = (x,y,z) (Left Wingtip View; FDM-system)
      var x = 1.35;
      var y = -5.;
      var z = -0.73;
      if ( on_ground == 1 ) {
        var rotation = 1; 
        # experimental
# rotation point moves, too!
        var length = getprop("sim/model/MRX13/LaunchPosition");
        var pilot_attitude_deg = getprop("controls/flight/pilot-attitude-deg");
        x = x - length * (( 75. - pilot_attitude_deg ) / 75. * 1.5 + 1.8 ) ;
        z = z - length * (( 75. - pilot_attitude_deg ) / 75. * 4.0 + 1.5 ) ;
      };
      var rotation_harness = 0;
    }
  } # end mode view_animation

  else if ( mode[n] == "hitch_animation") {
    # Point to rotate = X = (x,y,z) (hitch; FDM-system)
    if ( hitch[n] == "belly" ) {
      var x = 0.0;
      var y =  0.;
      var z = -1.5;
      if ( on_ground == 0 ) rotation = 1;
      rotation_harness = 1;
    }
    else if ( hitch[n] == "chest" ) {
      var x =  -0.45;
      var y =  0.;
      var z = -1.45;
      if ( on_ground == 0 ) rotation = 1;
      rotation_harness = 1;
    }
    else if ( hitch[n] == "drop" ) {
      var x = 0.;
      var y = 0.;
      var z = 0.1;
      if ( on_ground == 1 ) rotation = 1;
      rotation_harness = 0;
    }
    else {
      var x = 0.;
      var y = 0.;
      var z = 0.;
    }
#    if ( on_ground == 0 ) rotation = 1;
#    rotation_harness = 1;
  } # end mode hitch_animation

  else if( mode[n] == "droguechute_animation") {
      # Point to rotate = X = (x,y,z) (Eyes; FDM-system)
      var x = 0.;
      var y = 0;
      var z = -1.2;
      if ( on_ground == 0 ) { var rotation = 1; };
      var rotation_harness = 1;
  } # end mode droguechute_animation


  if (n == 0 ) {

    # Center of rotation = Xr = (xr,yr,zr) (FDM-system)
    var xr = 0.;
    var yr = 0.;
    var zr = 0.;


    # Center of rotation harness (prone) = Xrh = (xrh,yrh,zrh) (FDM-system)
    if ( on_ground == 0 ) {
     var xrh = 0.020;
     var yrh = 0.0;
     var zrh = -1.146;
    } 
    else{
     var xrh = 0.036;
     var yrh = 0.0;
     var zrh = -1.272;  
    }
    
    # defaults are necessary to avoid nasal runtime errors
    var x_new = x;
    var y_new = y;
    var z_new = z;
    var roll_zyx    = 0.;
    var pitch_zyx   = 0.;
    var heading_zyx = 0.;
    #----------------------------------------------------------------------------------

    var fak = math.pi / 180.;
    var fakh = fak;
    if ( on_ground == 1 ) { fak = -1 * fak};  # switch reference system

    # get variables
    var aileron_rad        = getprop("surface-positions/left-aileron-pos-norm") * 15. * fak;
    var elevator_rad       = getprop("surface-positions/elevator-pos-norm") * 20. * fak;
    var rudder_rad         = getprop("surface-positions/rudder-pos-norm") * 25.* fak;
    var pilot_attitude_deg = getprop("controls/flight/pilot-attitude-deg");


    # Deflections

    var roll_offset_deg = aileron_rad / fak;
    var sin_alpha = math.sin(aileron_rad);
    var cos_alpha = math.cos(aileron_rad);

    var pitch_offset_deg = elevator_rad / fak;
    var sin_beta  = math.sin(elevator_rad);
    var cos_beta  = math.cos(elevator_rad);

    var heading_offset_deg = rudder_rad / fak;
    var sin_gamma = math.sin(rudder_rad);
    var cos_gamma = math.cos(rudder_rad);
    var sin_theta = math.sin( pilot_attitude_deg * fakh );
    var cos_theta = math.cos( pilot_attitude_deg * fakh );

  }  # end n=0

  #-------------------------------   prone   ----------------------------
  #
  if ( rotation_harness == 1 ) {         # pilot / harness view
    # transformation in harness rotation-system Xh_rel = X-Xrh = (x-xrh, y-yrh, z-zrh)
    var xh_rel = x-xrh;
    var yh_rel = y-yrh;
    var zh_rel = z-zrh;
    #
    # rotate about y-axis Ryh(theta) due to pilot inclination
    #
    #              Ryh11 Ryh12 Ryh13       cos(theta)  0 sin(theta)
    # Ryh(theta)=  Ryh21 Ryh22 Ryh23   =       0       1     0
    #              Ryh31 Ryh32 Ryh33      -sin(theta)  0 cos(theta)
    #
    var Ryh11 = cos_theta;
   #var Ryh12 = 0.;
    var Ryh13 = sin_theta;
   #var Ryh21 = 0.;
   #var Ryh22 = 1.;
   #var Ryh23 = 0.;
    var Ryh31 = - sin_theta;
   #var Ryh32 = 0.;
    var Ryh33 = cos_theta;
    #
    #var xh_y = Ryh11 * xh_rel + Ryh12 * yh_rel + Ryh13 * zh_rel;
    #var yh_y = Ryh21 * xh_rel + Ryh22 * yh_rel + Ryh23 * zh_rel;
    #var zh_y = Ryh31 * xh_rel + Ryh32 * yh_rel + Ryh33 * zh_rel;

    var xh_y = Ryh11 * xh_rel + Ryh13 * zh_rel;
    var yh_y =             yh_rel;
    var zh_y = Ryh31 * xh_rel + Ryh33 * zh_rel;

    pitch_offset_deg = pitch_offset_deg + pilot_attitude_deg;

    # back transformation in FDM-System (this are the new view coordinates)
    var x = xrh + xh_y;
    var y = yrh + yh_y;
    var z = zrh + zh_y;

      var x_new = x;
      var y_new = y;
      var z_new = z;
      var roll_zyx    = 0.;
# nur wenn harness view
      var pitch_zyx   = pilot_attitude_deg;
      var heading_zyx = 0.;
  }
  #----------------------------    end prone   --------------------------

  if ( rotation == 1 ) {

    # Transformation in glider rotation-system X_rel = X-Xr = (x-xr, y-yr, z-zr)
    var x_rel = x-xr;
    var y_rel = y-yr;
    var z_rel = z-zr;
    #
    # Rotate about x-axis Rx(alpha)
    #
    #             Rx11 Rx12 Rx13      1     0            0
    # Rx(alpha)=  Rx21 Rx22 Rx23   =  0  cos(alpha)  -sin(alpha)
    #             Rx31 Rx32 Rx33      0  sin(alpha)   cos(alpha)
    #
    var Rx11 = 1.;
    var Rx12 = 0.;
    var Rx13 = 0.;
    var Rx21 = 0.;
    var Rx22 = cos_alpha;
    var Rx23 = - sin_alpha;
    var Rx31 = 0.;
    var Rx32 = sin_alpha;
    var Rx33 = cos_alpha;
    #
    # Rotate about y-axis Ry(beta)
    #
    #            Ry11 Ry12 Ry13      cos(beta)  0   sin(beta)
    # Ry(beta)=  Ry21 Ry22 Ry23   =     0       1      0
    #            Ry31 Ry32 Ry33     -sin(beta)  0   cos(beta)
    #
    var Ry11 = cos_beta;
    var Ry12 = 0.;
    var Ry13 = sin_beta;
    var Ry21 = 0.;
    var Ry22 = 1.;
    var Ry23 = 0.;
    var Ry31 = - sin_beta;
    var Ry32 = 0.;
    var Ry33 = cos_beta;
    #
    # Rotate about z-axis Rz(gamma)
    #
    #            Rz11 Rz12 Rz13      cos(gamma)  -sin(gamma)  0
    # Rz(gamma)= Rz21 Rz22 Rz23   =  sin(gamma)   cos(gamma)  0
    #            Rz31 Rz32 Rz33         0            0        1
    #
    var Rz11 = cos_gamma;
    var Rz12 = - sin_gamma;
    var Rz13 = 0.;
    var Rz21 = sin_gamma;
    var Rz22 = cos_gamma;
    var Rz23 = 0.;
    var Rz31 = 0.;
    var Rz32 = 0.;
    var Rz33 = 1.;
    #
    # First rotation about z-axis
    # X_z = Rz*X_rel
    var x_z = Rz11 * x_rel + Rz12 * y_rel + Rz13 * z_rel;
    var y_z = Rz21 * x_rel + Rz22 * y_rel + Rz23 * z_rel;
    var z_z = Rz31 * x_rel + Rz32 * y_rel + Rz33 * z_rel;

    var roll_z    = Rz11 * roll_offset_deg + Rz12 *  pitch_offset_deg + Rz13 * heading_offset_deg;
    var pitch_z   = Rz21 * roll_offset_deg + Rz22 *  pitch_offset_deg + Rz23 * heading_offset_deg;
    var heading_z = Rz31 * roll_offset_deg + Rz32 *  pitch_offset_deg + Rz33 * heading_offset_deg;
    #
    # subsequent rotation about y-axis
    # X_zy = Ry*X_z
    var x_zy = Ry11 * x_z + Ry12 * y_z + Ry13 * z_z;
    var y_zy = Ry21 * x_z + Ry22 * y_z + Ry23 * z_z;
    var z_zy = Ry31 * x_z + Ry32 * y_z + Ry33 * z_z;

    var roll_zy    = Ry11 * roll_z + Ry12 * pitch_z + Ry13 * heading_z;
    var pitch_zy   = Ry21 * roll_z + Ry22 * pitch_z + Ry23 * heading_z;
    var heading_zy = Ry31 * roll_z + Ry32 * pitch_z + Ry33 * heading_z;
    #
    # subsequent rotation about x-axis:
    # X_zyx = Rx*X_zy
    var x_zyx = Rx11 * x_zy + Rx12 * y_zy + Rx13 * z_zy;
    var y_zyx = Rx21 * x_zy + Rx22 * y_zy + Rx23 * z_zy;
    var z_zyx = Rx31 * x_zy + Rx32 * y_zy + Rx33 * z_zy;

    var roll_zyx    = Rx11 * roll_zy + Rx12 * pitch_zy + Rx13 * heading_zy;
    var pitch_zyx   = Rx21 * roll_zy + Rx22 * pitch_zy + Rx23 * heading_zy;
    var heading_zyx = Rx31 * roll_zy + Rx32 * pitch_zy + Rx33 * heading_zy;

    #----------------------------------------------------------------------
    #
    #
    #       z              y
    #       |  y           |  x
    #       | /            | /
    #       |/             |/
    #       ----->x        ----->z
    #
    #
    #     FDM-System          View-System
    # (Structural Frame)
    #
    #
    #
    # FDM-System
    var x_new = xr + x_zyx;
    var y_new = yr + y_zyx;
    var z_new = zr + z_zyx;
  }

  if( mode[n] == "view_animation") {

    # View-System
    setprop("sim/current-view/x-offset-m",y_new);
    setprop("sim/current-view/y-offset-m",z_new);
    setprop("sim/current-view/z-offset-m",x_new);

    if ( view_number == 8 ) {
      # Harness View
      setprop("sim/current-view/pitch-offset-deg",pitch_zyx);
      setprop("sim/current-view/roll-offset-deg",-roll_zyx);
      setprop("sim/current-view/heading-offset-deg",heading_zyx);
    }

    if ( view_number == 11 ) {
      # Left Wingtip View
      var pitch_xyzq = -pitch_zyx - 5 ;
      var heading_xyzq = -heading_zyx - 65 ;
      setprop("sim/current-view/pitch-offset-deg",-roll_zyx);
      setprop("sim/current-view/roll-offset-deg",pitch_xyzq);
      setprop("sim/current-view/heading-offset-deg",heading_xyzq);
    }
  }
  if ( mode[n] == "hitch_animation") {
    #print("device ",device[n],"    hitch ",hitch[n]);
    # force location
    setprop("fdm/jsbsim/external_reactions/" ~ hitch[n]~ "/location-x-in",x_new * m2in);
    setprop("fdm/jsbsim/external_reactions/" ~ hitch[n]~ "/location-y-in",y_new * m2in);
    setprop("fdm/jsbsim/external_reactions/" ~ hitch[n]~ "/location-z-in",z_new * m2in);
  } # end mode hitch_animation
  if ( mode[n] == "droguechute_animation") {
    setprop("fdm/jsbsim/external_reactions/droguechute/location-x-in",x_new * m2in);
    setprop("fdm/jsbsim/external_reactions/droguechute/location-y-in",y_new * m2in);
    setprop("fdm/jsbsim/external_reactions/droguechute/location-z-in",z_new * m2in);
  } # end mode droguechut_animation

}  # end loop

    settimer(ViewAnimation,0);
}
# Start ViewAnimation ASAP
ViewAnimation();
