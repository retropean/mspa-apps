libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;
proc contents data=mydata.dog_mandible_measurements; run;

* Set the dog mandible measurements data set to short name;
data dogjaw;
set mydata.dog_mandible_measurements;
run;


*Data set contains 77 observations of dog mandible measurements.
Variables:
GROUP_NAME: type of dog
CASE: observation number for the group
GROUP_NBR: coded value for the GROUP_NAME
X1: length of mandible
X2: breadth of mandible below first molar
X3: breadth of articular condyle
X4: height of mandible below first molar
X5: length of first molar
X6: breadth of first molar
X7: length of first to third molar
X8: length from first fourth premolar
X9: breadth of lower canine
SEX: 1=male, 2=female, 0=unknown;

* Print first 6 observations checking values of selected variables;
Title "Observe Data Set";
options obs=6;
proc print data=dogjaw; run;

options obs=max; 

Title "PROC MEANS EDA - Examine Variable Descriptive Statistics";
proc means data=dogjaw;
var X1 X2 X3 X4 X5 X6 X7 X8 X9;
run;

* Produce specific descriptive proc means statistics using selected
options;
Title "PROC MEANS EDA - Examine Variable for Specific Descriptive
Statistics";
proc means data=dogjaw n q1 mean q3 stddev median clm ndec=3;
var X1 X2 X3 X4 X5 X6 X7 X8 X9;
run;

* Sort by gender;
proc sort data=dogjaw;
by SEX;
run;

* Produce descriptive statistics using BY statement;
Title "PROC MEANS w/ BY Statement - Examine Variable for Specific
Descriptive Statistics";
proc means data=dogjaw n q1 mean q3 stddev median clm ndec=3;
var X1 X2; *X3 X4 X5 X6 X7 X8 X9;
by SEX;
run;

* Examine means at 5th, 10th, 25th, 50th, 75th, 90th, and 95th
percentile;
proc means data=dogjaw p5 p10 p25 p50 p75 p90 p95 ndec=2;
class SEX;
var X1 X2; *X3 X4 X5 X6 X7 X8 X9;
run;

* Note that I have created a "macro function" named %myMEANS()
which has a "macro variable" x as an argument.;
%macro myMEANS(x, y); *macro name & start;
TITLE "PROC MEANS - Examine Variable Descriptive Statistics for &x by
&y";
proc means data=dogjaw n nmiss q1 mean q3 stddev median clm alpha=0.10
ndec=3;
var &x;
by &y;
run;
proc means data=dogjaw p5 p10 p25 p50 p75 p90 p95 ndec=2;
class &y;
var &x;
run;
%mend myMEANS; *macro end;
* calls to macro for each variable;
%myMEANS(x=X1, y=SEX);
%myMEANS(x=X2, y=SEX);
%myMEANS(x=X3, y=SEX);

* examine descriptive statistics and distributions of data set
variables;
Title "PROC UNIVARIATE EDA - Examine Variable Descriptive Statistics";
proc univariate data=dogjaw;
var X1 X2 X3 X4 X5 X6 X7 X8 X9 SEX;
run;

* examine descriptive statistics and distributions of data set
variables using CLASS statement;
Title "PROC UNIVARIATE w/ Class - Examine Variable Descriptive
Statistics";
proc univariate data=dogjaw;
class GROUP_NAME;
var X1; *X2 X3 X4 X5 X6 X7 X8 X9 SEX;
run;

* Macro for above operation;
%macro myUNIVARIATEbyCLASS(x); *macro name & start;
TITLE "PROC UNIVARIATE w/ Class - Examine Variable Descriptive
Statistics Colony by &x";
proc univariate data=dogjaw;
class GROUP_NAME;
var &x;
run;
%mend myUNIVARIATEbyCLASS; *macro end;
* calls to macro for each variable;
%myUNIVARIATEbyCLASS(x=X1);
%myUNIVARIATEbyCLASS(x=X2);
%myUNIVARIATEbyCLASS(x=X3);

* create statistical graphics with PROC UNIVARIATE;
Title "PROC UNIVARIATE Statistical Plots";
proc univariate data=dogjaw;
var X1; *X2 X3 X4 X5 X6 X7 X8 X9 SEX;
cdfplot X1; * cumulative distribution plot;
histogram X1 / normal; * histogram plot;
ppplot X1; * probability-probability plot;
probplot X1; * probability plot;
qqplot X1; * quantile-quantile plot;
run;

* Macro for above
%macro myUNIVARIATEplots(x); *macro name & start;
TITLE "PROC UNIVARIATE Statistical Plots by &x";
proc univariate data=dogjaw;
var &x;
cdfplot &x; * cumulative distribution plot;
histogram &x / normal; * histogram plot;
ppplot &x; * probability-probability plot;
probplot &x; * probability plot;
qqplot &x; * quantile-quantile plot;
run;
%mend myUNIVARIATEplots; *macro end;
* calls to macro for each variable;
%myUNIVARIATEplots(x=X1);
%myUNIVARIATEplots(x=X2);
%myUNIVARIATEplots(x=X3);

proc sort data=dogjaw;
by GROUP_NAME;
run;
Title "Variable EDA - Boxplot of Variables";
proc boxplot data=dogjaw;
plot X1 * GROUP_NAME;
run;