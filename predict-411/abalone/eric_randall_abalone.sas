libname mydata     '/scs/dkw841/Unit03/' access=readonly;
data abalone;  set mydata.zip_abalone_test; 
run; quit;

data abalone_prep_test;
	set abalone;

	if(TARGET_RINGS>25) then TARGET_RINGS_TRIM=25;
	else TARGET_RINGS_TRIM = TARGET_RINGS;
	
	if(ShellWeight>0.6200) then ShellWeight_TRIM=0.600;
	else ShellWeight_TRIM= ShellWeight;
	
	if(HEIGHT>.200) then HEIGHT_TRIM=.200;
	else HEIGHT_TRIM= HEIGHT;
	
	if(VisceraWeight>.5) then VisceraWeight_TRIM=.5;
	else VisceraWeight_TRIM= VisceraWeight;	
	
	if(ShuckedWeight>1) then ShuckedWeight_TRIM=1;
	else ShuckedWeight_TRIM= ShuckedWeight;
	
	if(Sex="I") then intersex=1;
	else intersex=0;
	
	*if(TARGET_RINGS=0) then rings=0;
	*else rings=1;
run;

data abalone_prep_test;  set abalone_prep_test; 
DROP ShellWeight HEIGHT VisceraWeight ShuckedWeight;
run; quit;


data abalone_prep_test;
set abalone_prep_test;
TEMP = 1.6405
+2.0333 * ShellWeight_TRIM
-1.1573 * ShuckedWeight_TRIM 
-0.0207 * VisceraWeight_TRIM
+0.9713 * Length 
+0.1055 * (intersex in (0));
P_SCORE_ZINB_ALL = exp( TEMP );

TEMP = 0.0944
-68.4276 * VisceraWeight_TRIM
-83.6094 * HEIGHT_trim
+30.0345 * Length;
P_SCORE_ZERO = exp(TEMP)/(1+exp(TEMP));
	
P_TARGET_RINGS = P_SCORE_ZINB_ALL * (1-P_SCORE_ZERO);

run;

data abalone_prep_test;  set abalone_prep_test; 
KEEP INDEX P_TARGET_RINGS;
run; quit;

proc print data=abalone_prep_test;
