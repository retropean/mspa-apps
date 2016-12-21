/*	Chad R. Bhatti
	linden_example.sas
	07.07.2015
*/


/*
In this example we will try to reproduce the results from the following paper.

'Factor Analytical Study of Olympic Decathlon Data' by Michael Linden

Paper is available in the Predict 410 Course Reserves.  Students should read the paper 
and then work through this SAS example.
*/


data correlation_matrix(type=corr);
* Note that text parsing in Unix SAS is much more fickle (literal) than in PC SAS;
* We will have to use a fixed width data read to make sure that Unix SAS reads in the data correctly;
input _TYPE_ $1-5 _NAME_ $6-16 M100 17-22 LongJump 23-28 ShotPut 29-34 HighJump 35-40 
	M400 41-46 M110 47-52 Discus 53-58 PoleVault 59-64 Javelin 65-70 M1500 71-75;
* Note that when you create a fixed width line read with datalines, you cannot have any tabs;
* All whitespace must be generated by the space bar;
datalines;
CORR M100       1.000 0.590	0.350 0.340	0.630 0.400	0.280 0.200	0.110 -0.07	             
CORR LongJump   0.590 1.000	0.420 0.510	0.490 0.520	0.310 0.360	0.210 0.090	
CORR ShotPut    0.350 0.420	1.000 0.380	0.190 0.360	0.730 0.240	0.440 -0.08	
CORR HighJump   0.340 0.510	0.380 1.000	0.290 0.460	0.270 0.390	0.170 0.180	
CORR M400       0.630 0.490	0.190 0.290	1.000 0.340	0.170 0.230	0.130 0.390	
CORR M110       0.400 0.520	0.360 0.460	0.340 1.000	0.320 0.330	0.180 0.000	
CORR Discus     0.280 0.310	0.730 0.270	0.170 0.320	1.000 0.240	0.340 -0.02	
CORR PoleVault  0.200 0.360	0.240 0.390	0.230 0.330	0.240 1.000	0.240 0.170	
CORR Javelin    0.110 0.210	0.440 0.170	0.130 0.180	0.340 0.240	1.000 0.000	
CORR M1500      -0.07 0.090	-0.08 0.180	0.390 0.000	-0.02 0.170	0.000 1.000	
N    .          160.0 160.0	160.0 160.0	160.0 160.0	160.0 160.0	160.0 160.0	
;
run;
quit;


proc print data=correlation_matrix; run; quit;
proc contents data=correlation_matrix; run; quit;


********************************************************************************;
* Perform a Principal Factor Analysis
********************************************************************************;
ods graphics on;
proc factor data=correlation_matrix 
	method=principal priors=smc nfactors=4 rotate=none
	outstat=principal_fa
;
run; quit;
ods graphics off;


********************************************************************************;
* Perform a Principal Factor Analysis with VARIMAX rotation
********************************************************************************;
ods graphics on;
proc factor data=correlation_matrix 
	method=principal priors=smc nfactors=4 rotate=varimax
	outstat=principal_fa
;
run; quit;
ods graphics off;


/*
(1) Did we match of the factor loadings from Linden's study?

No.  Virtually impossible to replicate a factor analysis unless you are using the exact same software,
i.e. same software and same version e.g. SAS 9.4.

(2) Did we obtain a simple structure?

No.  Virtually impossible to produce a simple structure in a factor analysis.  It is far closer to
wishful thinking than a modeling reality.

(3) Did we obtain a meaningful factor structure?

Always a completely subjective question.  The beauty will be in the eye of the beholder.  However, in
this example we did get decent results.

Factor 1: Arm Strength -  Shot Put, Discuss, Javelin
Factor 2: Running Speed (Fast twitch muscle) - M100, Long Jump, M400, M110
Factor 3: Explosive Leg Strength (Body Projection) - Long Jump, High Jump, M110, Pole Vault
Factor 4: Running Endurance - M400, M1500

Note that we were able to estimate the same qualitative factors as Linden.
Our factor order is different, i.e. his Factor 1 is not our Factor 1, and our factor loadings
are different.

*/



********************************************************************************;
* Perform a MLE Factor Analysis
********************************************************************************;

* Can we get the same results using MLE?;
ods graphics on;
proc factor data=correlation_matrix 
	method=ml priors=smc nfactors=4 rotate=varimax
;
run; quit;
ods graphics off;
* What happenend here?  Do we have any options?;



* Estimate using the HEYWOOD option;
ods graphics on;
proc factor data=correlation_matrix 
	method=ml heywood priors=smc nfactors=4 rotate=varimax
;
run; quit;
ods graphics off;
* Did we get the same results here?
* Should we consider this to be a valid factor analysis?;
* What are some caveats?;


********************************************************************************;
* What Else?
********************************************************************************;
/*
Use this 'working' example of factor analysis to try anything related to factor
analysis that interests you.

- Try using different estimation methods.
- Compare factor analysis results to principal component results.
- Try estimating 3 common factors and 5 common factors.  See what you get.

*/
