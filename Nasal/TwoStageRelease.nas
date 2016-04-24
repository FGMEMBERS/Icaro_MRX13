# ######################################################################
#              place winch model and close two-stage release
#                     (also emergency release)
# ######################################################################

var setWinchPositionTwoStageRelease = func {

  var open = getprop("sim/hitches/winch/open");
  if ( open ) {
    setprop("sim/hitches/open-toprope", 1);
    setprop("sim/hitches/open-bottomrope", 1);
  }
  else {
    # emergency release
    #setprop("sim/hitches/open-toprope",1);
    interpolate("sim/hitches/open-toprope", 1, 0.5);
    #setprop("sim/hitches/open-bottomrope","true");
    interpolate("sim/hitches/open-bottomrope", 1, 0.5);
    #towing.releaseHitch("winch");
    settimer( func { towing.releaseHitch("winch"); } ,0.25);
    return;
  }

  var open_toprope = getprop("sim/hitches/open-toprope");
  var open_bottomrope = getprop("sim/hitches/open-bottomrope");

  if ( open_toprope  and open_bottomrope  ) {
    #towing.setWinchPositionAuto();
    settimer( func { towing.setWinchPositionAuto(); } , 0.5);
    #setprop("sim/hitches/open-toprope",0);
    interpolate("sim/hitches/open-toprope", 0, 2.);
    #setprop("sim/hitches/open-bottomrope","false");
    interpolate("sim/hitches/open-bottomrope", 0, 2.);
  }

}


# ######################################################################
#                              release hitch
# ######################################################################

var releaseHitch = func {

  var open_toprope = getprop("sim/hitches/open-toprope");
  var open_bottomrope = getprop("sim/open-bottomrope");

  #var open_toprope = 1;  # uncomment this line to activate a 1-stage release

  if (!open_toprope and !open_bottomrope ) {
    #setprop("sim/hitches/open-toprope","true");
    interpolate("sim/hitches/open-toprope", 1, 0.5);
    setprop("sim/hitches/winch/tow/length", getprop("sim/hitches/winch/tow/length")+ 2.);
  }
  else if ( open_toprope  and !open_bottomrope ) {
    #setprop("sim/hitches/open-bottomrope", 1);
    interpolate("sim/hitches/open-bottomrope", 1, 0.5);
    settimer( func { towing.releaseHitch("winch"); } ,0.25);
  }

}
