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


#----------------------------------------------------------------------------------------

# jettisonable smoke grenade
var SmokeGrenadeAI = func(n) {
    var node = props.globals.getNode(n.getValue(), 1);

    geo.put_model("Aircraft/Icaro_MRX13/Models/SmokeTrail/SmokeGrenade.xml",
        node.getNode("impact/latitude-deg").getValue(),
        node.getNode("impact/longitude-deg").getValue(),
        node.getNode("impact/elevation-m").getValue() + 0.1, # +0.1 to ensure the smoke grenade isn't buried
        node.getNode("impact/heading-deg").getValue(),
    0, 0);
}

setlistener("/ai/models/model-impact", SmokeGrenadeAI);

