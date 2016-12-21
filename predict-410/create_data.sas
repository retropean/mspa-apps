* First data set creation;
data temp1;
input dimkey $3. x 4.0 y 4.2 ;
* Note that the $ indicates that dimkey is a character variable and not
a numeric variable like x and y. $, 8.0, and 8.2 are called "informats".
See pp. 46-47 in LSB for a list of SAS informats.;
* Note that the first entry must be all of the way to the left.;
* The code must be typed exactly like this - left justified with 1 space
between clumns;
* Note that DATALINES does not act consistently across platforms - PC versus
Linux;
datalines;
01 100 12.2
02 300 7.45
03 200 10.0
04 500 5.67
05 300 4.55
;
run;
* Second data set creation;
data temp2;
input dimkey $3. z 4.0 first_name $9. last_name $10.;
* Note that for SAS to read this correctly, you will need to space this data
* out like a fixed width text file;
*23456789012345678901234567890;
datalines;
01 100 steve    miller
02 300 Steve    Utrup
04 500 JacK     wilsoN
05 300 AbRAham  LINcoln
06 100 JackSON  SmiTH
07 200 EarL     Campbell
08 400 WiLLiam  Right
;
run;
* Pull up table of temp1 data;
title 'Data = temp1';
proc print data=temp1; run; quit;
* Pull up table of temp3 data;
title 'Data = temp2';
proc print data=temp2; run; quit;
* Print PROC CONTENTS
title ; * Reset the title statement to blank;
proc contents data=temp1; run; quit;
proc contents data=temp2; run; quit;

* Create variables;
data temp1;
	set temp1;
	w = 2*y + 1;
	* See LSB pp. 84-85;
	if (x < 150) then segment=1;
	else if (x < 250) then segment=2;
	else segment=3;
run;

data temp2;
	set temp2;
	* See pp. 78-79 for "Selected SAS Character Functions";
	proper_first_name = propcase(first_name);
	upper_last_name = upcase(last_name);
	first_initial = substr(upcase(first_name),1,1);
	last_initial = substr(upcase(last_name),1,1);
	initials = compress(first_initial||last_initial);
run;

title 'Data = temp1';
proc print data=temp1; run; quit;
title 'Data = temp2';
proc print data=temp2(obs=15); run; quit;

data s1;
	set temp1;
	if (segment=1);
run;

data s2;
	set temp1;
	if (segment ne 1) then delete;
run;

* Set two datasets together;
data stacked_data;
set temp1 temp2;
run;
title 'Data = stacked_data';
proc print data=stacked_data; run; quit;


proc sort data=temp1; by dimkey; run; quit;
proc sort data=temp2; by dimkey; run; quit;
* Now order the stack by including a BY statement;
data ordered_stack;
set temp1 temp2;
by dimkey;
run;
title 'Data = ordered_stack';
proc print data=ordered_stack; run; quit;


**************************************************************************;
* LEFT JOIN, RIGHT JOIN, and INNER JOIN using an IN statement;
* See LSB 200-201;
**************************************************************************;
* Note that our data are already sorted. Data must be sorted in order to
 be merged;
* LEFT JOIN;
title 'LEFT JOIN OUTPUT';
data left_join;
merge temp1 (in=a) temp2 (in=b);
by dimkey;
if (a=1);
run;
proc print data=left_join; run; quit;
proc print data=temp2(obs=15); run; quit;
proc print data=temp1; run; quit;
* RIGHT JOIN;
title 'RIGHT JOIN OUTPUT';
data right_join;
merge temp1 (in=a) temp2 (in=b);
by dimkey;
if (b=1);
run;
proc print data=right_join; run; quit;
proc print data=temp2(obs=15); run; quit;
proc print data=temp1; run; quit;
* INNER JOIN;
title 'INNER JOIN OUTPUT';
data inner_join;
merge temp1 (in=a) temp2 (in=b);
by dimkey;
if (a=1) and (b=1);
run;
proc print data=inner_join; run; quit;
proc print data=temp2(obs=15); run; quit;
proc print data=temp1; run; quit;