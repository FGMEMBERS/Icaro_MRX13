##################################################################
#
# Handling: Set factors for handling adjustment
#
##################################################################

var handling = func {

  #### Edit the factors for your individual requirements here ####

  # Factors for Rookie:
  # -------------------

  var Rookie_factor_for_Clda    = 1.0 ;
  var Rookie_factor_for_Clp     = 2.0 ;
  var Rookie_factor_for_Cmalpha = 1.0 ;
  var Rookie_factor_for_Cmq     = 5.0 ;

  # Factors for Student:
  # --------------------

  var Student_factor_for_Clda    = 1.0 ;
  var Student_factor_for_Clp     = 1.5 ;
  var Student_factor_for_Cmalpha = 1.0 ;
  var Student_factor_for_Cmq     = 3.0 ;


  ################## Do not edit below this line #################

  if(getprop("sim/model/MRX13/handling/Rookie")){
   setprop("sim/model/MRX13/handling/factor-Clda",Rookie_factor_for_Clda);
   setprop("sim/model/MRX13/handling/factor-Clp",Rookie_factor_for_Clp);
   setprop("sim/model/MRX13/handling/factor-Cmalpha",Rookie_factor_for_Cmalpha );
   setprop("sim/model/MRX13/handling/factor-Cmq",Rookie_factor_for_Cmq);
  }
  else if(getprop("sim/model/MRX13/handling/Student")){
   setprop("sim/model/MRX13/handling/factor-Clda",Student_factor_for_Clda);
   setprop("sim/model/MRX13/handling/factor-Clp",Student_factor_for_Clp);
   setprop("sim/model/MRX13/handling/factor-Cmalpha",Student_factor_for_Cmalpha);
   setprop("sim/model/MRX13/handling/factor-Cmq",Student_factor_for_Cmq);
  }
  else if(getprop("sim/model/MRX13/handling/Pilot")){
   setprop("sim/model/MRX13/handling/factor-Clda",1);
   setprop("sim/model/MRX13/handling/factor-Clp",1);
   setprop("sim/model/MRX13/handling/factor-Cmalpha",1);
   setprop("sim/model/MRX13/handling/factor-Cmq",1);
  }

}


var custom = func {

  setprop("sim/model/MRX13/handling/Rookie",0);
  setprop("sim/model/MRX13/handling/Student",0);
  setprop("sim/model/MRX13/handling/Pilot",0);

}
