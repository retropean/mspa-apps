* View Influential observations for total_area_calc;
proc reg data = sample_houses ;
  model SalePrice = total_area_calc;
  output out = t student=res cookd = cookd h = lev;
run;
quit;

data t; set t;
  resid_sq = res*res;
run;

proc sgplot data = t;
  scatter y = lev x = resid_sq / datalabel = PID;
run;
quit;

* Compare the influential observations to the entire sample;
proc sgplot data=t;
where cookd > 4/1743;
scatter y=SalePrice x=total_area_calc;
run; quit;

data cookd_influence;
	set t;
	if (cookd > 4/1743);
run;

proc contents data=cookd_influence;
run;quit;

proc sgplot data=sample_houses;
scatter y=SalePrice x=total_area_calc;
run; quit;

proc univariate data=sample_houses;
var total_area_calc; 
cdfplot total_area_calc; * cumulative distribution plot;
histogram total_area_calc / normal;





* View Influential observations for OverallQual;
proc reg data = sample_houses ;
  model SalePrice = total_area_calc total_baths_calc OverallQual YearRemodel MasVnrArea;
  output out = t student=res cookd = cookd h = lev;
run;
quit;

data t; set t;
  resid_sq = res*res;
run;

proc sgplot data = t;
  scatter y = lev x = resid_sq / datalabel = PID;
run;
quit;

* Compare the influential observations to the entire sample;
proc sgplot data=t;
where cookd > 4/1743;
scatter y=SalePrice x=OverallQual;
run; quit;

data cookd_influence;
	set t;
	if (cookd > 4/1743);
run;

proc contents data=cookd_influence;
run;quit;

proc sgplot data=sample_houses;
scatter y=SalePrice x=OverallQual;
run; quit;

proc univariate data=sample_houses;
var OverallQual; 
cdfplot OverallQual; * cumulative distribution plot;
histogram OverallQual/ midpoints=1 to 10 by 1 normal;

proc univariate data=sample_houses;
var Total_baths_calc; 
cdfplot Total_baths_calc; * cumulative distribution plot;
histogram Total_baths_calc/ midpoints=1 to 10 by 1 normal;

proc univariate data=sample_houses;
var MasVnrArea; 
cdfplot MasVnrArea; * cumulative distribution plot;
histogram MasVnrArea/ normal;


data sample_houses_trim;
	set sample_houses;
	format outlier_def $30.;
	if (total_baths_calc > 4) then outlier_def='01. More than 4 baths';
	else if (OverallQual < 4) then outlier_def='02. OverallQual less than 4';
	else if (OverallQual > 8) then outlier_def='02. OverallQual greater than 8';
	else if (MasVnrArea > 600) then outlier_def='03. MasVnrArea greater than 600';
	else if (total_area_calc> 4000) then outlier_def='04: total_area_calc greater than 4500';
	else outlier_def='05: Trimmed Sample Population';
run;

* Outlier Waterfall;
proc freq data=sample_houses_trim;
tables outlier_def;
title 'Outlier Waterfall';
run; quit;

* Create Outlier-free dataset;
data sample_houses_trim;
	set sample_houses_trim;
	if (outlier_def = '05: Trimmed Sample Population');
run;

proc freq data=sample_houses_trim;

ods graphics on;
proc reg data = sample_houses_trim plots(unpack) = (diagnostics residualplot);
	model SalePrice = total_area_calc total_baths_calc OverallQual YearRemodel MasVnrArea;
run;
quit;
ods graphics off;
