libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;

proc contents data=mydata.ames_housing_data; run; quit;

proc print data=mydata.ames_housing_data(obs=10); run; quit;

* Conditions for waterfall;
data temp;
	set mydata.ames_housing_data;
	format drop_condition $30.;
	if (GrLivArea > 4000) then drop_condition='01: GT 4000 SQFT';
	else if (Utilities ne 'AllPub') then drop_condition='02: Missing Utilities';
	else if (TotalBsmtSF > 3000) then drop_condition='03: Basement GT 3000 SQFT';
	else if (TotalBsmtSF < 1) then drop_condition='04: No Basement';
	else if (Street ne 'Pave') then drop_condition='05: Street not Paved';
	else if (zoning in ('A','C','FV','I','RM')) then drop_condition='06: Non-residential zoning';
	else if (PoolArea > 0) then drop_condition='07: Contains Pool';
	else if (Heating ne 'GasA') then drop_condition='08: Not Gas Heating';
	else if (CentralAir = 'N') then drop_condition='09: No Central Air';
	else if (SaleCondition ne 'Normal') then drop_condition='10: Non-Normal Sale';
	else if (LotArea > 25000) then drop_condition='11: LotArea GT 33000';
	else drop_condition='12: Sample Population';
run;

* Sample Waterfall chart print;
proc freq data=temp;
tables drop_condition;
title 'Sample Waterfall';
run; quit;

* Create Sample Population dataset;
data nondrop;
	set temp;
	if (drop_condition = '12: Sample Population');
run;

* Check frequency of variable post-waterfall;
*proc freq data=nondrop;
*tables CentralAir;
*run; quit;

* Get overview of SalePrice post-waterfall;
*proc univariate data=nondrop;
*var SalePrice; 
*cdfplot SalePrice;
*histogram SalePrice / normal;
*ppplot SalePrice;
*probplot SalePrice;
*qqplot SalePrice;
*run;