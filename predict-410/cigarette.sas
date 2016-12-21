libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;
proc contents data=mydata.cigarette_consumption; run;

* Set the dog mandible measurements data set to short name;
data cig;
set mydata.cigarette_consumption;
run;

Title "OLS Regression SAS Tutorial";
ods graphics on;
* Produce the scatterplot matrix;
Title2 "Scatterplot Matrix";
proc corr data=cig plot=matrix(histogram nvar=all);
run;
ods graphics off;




ods graphics on;
* Best Single Variable model from Correlation Matrix;
proc reg data=cig PLOTS(ONLY)=(DIAGNOSTICS FITPLOT RESIDUALS);
model sales = income;
title2 'Base Model';
run;
ods graphics off;

ods graphics on;
* OLS Model using Part e on pp. 87 RABE Variables;
proc reg data=cig PLOTS(ONLY)=(diagnostics residuals fitplot);
model sales = age income price / vif;
title2 'Optimal Model';
output out=fitted_model pred=yhat residual=resid ucl=ucl lcl=lcl;
run;
ods graphics off;
