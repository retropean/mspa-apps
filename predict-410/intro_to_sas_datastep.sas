/* 	Check out create_data.sas instead

Chad R. Bhatti
	09.08.2012
	intro_to_sas_data_step.sas
*/

/* 	This code is meant to serve as a short introduction to the SAS data step.
	The code will be verbally explained in an accompanying video, but the comments
	in the code serve as the official "documentation" of the code, as comments 
	always do.
	
	Within this code I will reference page numbers from the 4th edition of
	"The Little SAS Book" (LSB).  You should read the noted pages so that you can 
	obtain a better understanding of SAS.  Note that not all of the discussion in 
	LSB is directly relevant to our computing arrangement of using SAS OnDemand 
	through JMP.  In particular students will never be able to use an INFILE statement 
	to read in data.  Students can only use data that the instructor has saved on the 
	server, data read in using a CARDS or DATALINES statement, or data pushed up to 
	the server through JMP.
	
	Begin by reading pp. 1-8 in LSB.
*/	
	
	
	
 **************************************************************************;
 * Creating SAS data sets using a DATALINES statement - see LSB p. 38. ;
 **************************************************************************;
data temp1;
input dimkey $3. x 4.0 y 4.2 ;
	* Note that the $ indicates that dimkey is a character variable and not
	a numeric variable like x and y.  $, 8.0, and 8.2 are called "informats".
	See pp. 46-47 in LSB for a list of SAS informats.;
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
	
	
**************************************************************************;
* Print the data sets out for visual inspection;
* See LSB pp. 110-111;
**************************************************************************;	
title 'Data = temp1';
proc print data=temp1; run; quit;

title 'Data = temp2';
proc print data=temp2; run; quit;


/* Print out 5 observations
proc print data=temp2(obs=5); run; quit;
*/

**************************************************************************;
* Use PROC CONTENTS to list the metadata for the data sets;
* See LSB pp. 74-75;
**************************************************************************;	
title ; * Reset the title statement to blank;
proc contents data=temp1; run; quit;
proc contents data=temp2; run; quit;


**************************************************************************;
* Manipulate SAS data sets;
**************************************************************************;	
data temp1;
	set temp1;
	w = 2*y + 1;
	
	* See LSB pp. 86-89;
	if (x < 150) then segment=1;
	else if (x < 250) then segment=2;
	else segment=3;
run;

data temp2;
	set temp2;
	* See pp. 82-83 for "Selected SAS Character Functions";
	proper_first_name = propcase(first_name);
	upper_last_name   = upcase(last_name);
	first_initial = substr(upcase(first_name),1,1);
	last_initial  = substr(upcase(last_name),1,1);
	initials = compress(first_initial||last_initial);
run;

title 'Data = temp1';
proc print data=temp1; run; quit;

title 'Data = temp2';
proc print data=temp2(obs=15); run; quit;



**************************************************************************;
* Subsetting Your Data;
* See LSB pp. 90-91, 330-333;
**************************************************************************;	
data s1;
	set temp1;
	if (segment=1);
run;

data s2;
	set temp1;
	if (segment ne 1) then delete;
run;

* This will work, but it is not really proper;
data s3;
	set temp1;
	where (segment=1);
run;

* A where clause really belongs in the set statement... USE THIS ONE;
data s4;
	set temp1 (where=(segment=1));
run;

* Verify that all of the data sets are the same;
title ; * Reset the title statement to blank;
proc print data=s1; run; quit;
proc print data=s2; run; quit;
proc print data=s3; run; quit;
proc print data=s4; run; quit;


**************************************************************************;
* Stacking two data sets together;
* See LSB pp. 180-181;
**************************************************************************;	
data stacked_data;
	set temp1 temp2;
run;

title 'Data = stacked_data';
proc print data=stacked_data; run; quit;


**************************************************************************;
* Creating an ordered stack of two data sets;
* See LSB pp. 182-183;
**************************************************************************;	
* First sort the data by the dimkey;
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
* Combine the columns into one data step by merging the two data sets 
* together.  See LSB pp. 184-187.;
**************************************************************************;	
* Note that our data are already sorted.  Data must be sorted in order to
  be merged;

data merged_data;
	merge temp1 temp2;
	by dimkey;
run;

title 'Data = merged_data';
proc print data=merged_data; run; quit;


**************************************************************************;
* LEFT JOIN, RIGHT JOIN, and INNER JOIN using an IN statement;
* See LSB 198-201;
**************************************************************************;	
* Note that our data are already sorted.  Data must be sorted in order to
  be merged;

* LEFT JOIN;
title 'LEFT JOIN OUTPUT';
data left_join;
	merge temp1 (in=a) temp2 (in=b);
	by dimkey;
	if (a=1);
run;

proc print data=left_join; run; quit;


* RIGHT JOIN;
title 'RIGHT JOIN OUTPUT';
data right_join;
	merge temp1 (in=a) temp2 (in=b);
	by dimkey;
	if (b=1);
run;

proc print data=right_join; run; quit;


* INNER JOIN;
title 'INNER JOIN OUTPUT';
data inner_join;
	merge temp1 (in=a) temp2 (in=b);
	by dimkey;
	if (a=1) and (b=1);
run;

proc print data=inner_join; run; quit;




**************************************************************************;
**************************************************************************;	
* Create an error to check the log;
/*
data error_data;
	set temp1
run;
*/


**************************************************************************;
**************************************************************************;	