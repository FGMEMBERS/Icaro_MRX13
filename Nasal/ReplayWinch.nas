#
# ---------------------------------------------------------------------------------
#             Flight Recorder: Replay Winch Control             Status: 26.07.2016
# ---------------------------------------------------------------------------------
#
var winchReplay = func {

 if( getprop("sim/replay/replay-state") ) {

  # initialize trigger
  if( getprop("sim/replay/time") <= getprop("sim/replay/start-time") + 1. )
   setprop("sim/hitches/Replay/winch-trigger", 0 );

  # create and place winch and create rope
  if( !getprop("sim/hitches/Replay/winch-trigger") ) {
   if( !getprop("sim/hitches/Replay/open-trigger") ) {
    if( !getprop("sim/hitches/open-toprope") ) {
     if( !getprop("sim/hitches/open-bottomrope") ) {
      towing.setWinchPositionAuto();
      setprop("sim/hitches/Replay/open-trigger", 1 );
      setprop("sim/hitches/Replay/winch-trigger", 1 );
      }
     }
    }
   }

  # rewind: rope handling for hooked mode
  if( getprop("sim/hitches/Replay/winch-trigger") ) {   
   if( !getprop("sim/hitches/Replay/open-trigger") ) {
    if( !getprop("sim/hitches/open-toprope")  or 
        !getprop("sim/hitches/open-bottomrope") ) {
     # start winch and create rope
     props.globals.getNode("sim/hitches/winch/open").setBoolValue(0);
     setprop("sim/hitches/Replay/open-trigger", 1 );
     setprop("sim/hitches/winch/tow/dist", getprop("sim/hitches/winch/tow/length") - 1. );
    }
   }
  }

  # Rewind: rope handling for rope-pull-in mode
  # Does not work. Needs position of rope to work properly.
  # But rope position is not stored in flight recorder.
  # 
  #if( getprop("sim/hitches/Replay/winch-trigger") ) {
  # if( !getprop("sim/hitches/Replay/open-trigger") ) {
  #  if( !getprop("sim/hitches/winch/rope/exist") ) {
  #   if( getprop("sim/hitches/winch/tow/length") >
  #       getprop("sim/hitches/winch/winch/min-tow-length-m") ) {
  #       print("pull-in-rope");
  #       towing.createTowrope("winch");
  #       setprop("sim/hitches/winch/tow/length", 500. );
  #       towing.pull_in_rope();
  #   }
  #  }
  # }
  #}

  # hitch release 
  if( getprop("sim/hitches/Replay/open-trigger") ) {
   if( getprop("sim/hitches/open-toprope") ) {
    if( getprop("sim/hitches/open-bottomrope") ) {
     # release hitch and pull in rope
     towing.releaseHitch("winch");
     setprop("sim/hitches/Replay/open-trigger", 0 );
    }
   }
  }

 }
 settimer(winchReplay,0);
}
settimer(winchReplay,0);
