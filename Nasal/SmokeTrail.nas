##################################################################
#
# Smoke Trail Control
#
##################################################################

var smoke = func {

 if( getprop("sim/model/SmokeTrail/Smoke") ) {

  # if no smoke generator available, start smoke configure gui
  if( !getprop("sim/model/SmokeTrail/Keel/Generator")           and
      !getprop("sim/model/SmokeTrail/ControlBarLeft/Generator") and
      !getprop("sim/model/SmokeTrail/ControlBarRight/Generator") )
      { smoke_dialog.open();
        setprop("sim/model/SmokeTrail/Smoke", 0 );
        return
      }

  # start smoke

  smoke_control("Keel","1");
  smoke_control("ControlBarLeft","1");
  smoke_control("ControlBarRight","1");

  burning();

 }
 else {

  # stop smoke
  setprop("sim/model/SmokeTrail/Keel/Smoke",0);
  setprop("sim/model/SmokeTrail/ControlBarLeft/Smoke",0);
  setprop("sim/model/SmokeTrail/ControlBarRight/Smoke",0);

 }
 
}

var smoke_control = func (SmokeGenerator,smoke){

  if( getprop("sim/model/SmokeTrail/" ~ SmokeGenerator ~ "/Generator") ) {
   setprop("sim/model/SmokeTrail/" ~ SmokeGenerator ~ "/Smoke",smoke);

   if( smoke ){
    #calculate burning end time
    setprop("sim/model/SmokeTrail/" ~ SmokeGenerator ~ "/burning-end-sec",
     getprop("sim/time/elapsed-sec") + 
     getprop("sim/model/SmokeTrail/" ~ SmokeGenerator ~ "/burning-time-sec") );

    setprop("sim/model/SmokeTrail/Smoke",1); 
    burning();
   }
  } else {
   setprop("sim/model/SmokeTrail/" ~ SmokeGenerator ~ "/Smoke",0);
  }
  
}


var burning = func {

 if( getprop("sim/model/SmokeTrail/Smoke") ) {

  # check, if time > burning end time
  if( getprop("sim/time/elapsed-sec") < 
      getprop("sim/model/SmokeTrail/Keel/burning-end-sec") ) {
  } else {
    setprop("sim/model/SmokeTrail/Keel/Smoke", 0);
  }

  if( getprop("sim/time/elapsed-sec") < 
      getprop("sim/model/SmokeTrail/ControlBarLeft/burning-end-sec") ) {
  } else {
    setprop("sim/model/SmokeTrail/ControlBarLeft/Smoke", 0);
  }

  if( getprop("sim/time/elapsed-sec") < 
      getprop("sim/model/SmokeTrail/ControlBarRight/burning-end-sec") ) {
  } else {
    setprop("sim/model/SmokeTrail/ControlBarRight/Smoke", 0);
  }

  if( getprop("sim/model/SmokeTrail/Keel/Smoke") or
      getprop("sim/model/SmokeTrail/ControlBarLeft/Smoke") or 
      getprop("sim/model/SmokeTrail/ControlBarRight/Smoke") ) {

   settimer(burning,2);

  }
  else {
   setprop("sim/model/SmokeTrail/Smoke", 0)
  }

 }

}

