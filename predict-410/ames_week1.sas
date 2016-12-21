* Load Predict 410 data warehouse;
libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;

* List out the column names and data types for the data set;
proc contents data=mydata.ames_housing_data; run; quit;

* Create shortened dataset name;
data all_houses;
set mydata.ames_housing_data;
run;

* Create price per square foot variable;
data all_houses;
set all_houses;
PriceSqft = SalePrice / GrLivArea;
run;

* Initial graphing and info on SalePrice variable;
proc univariate data=all_houses;
var SalePrice; 
cdfplot SalePrice; * cumulative distribution plot;
histogram SalePrice / normal; * histogram plot;
ppplot SalePrice; * probability-probability plot;
probplot SalePrice; * probability plot;
qqplot SalePrice; * quantile-quantile plot;
run;

* Scatterplot Matrix for all Num variables;
ods graphics on;
Title2 "Scatterplot Matrix";
proc corr data=all_houses plot=matrix(histogram) PLOTS(MAXPOINTS= 50000);
VAR WoodDeckSF YearBuilt YearRemodel TotRmsAbvGrd YrSold SubClass ThreeSsnPorch TotalBsmtSF ScreenPorch	SecondFlrSF PoolArea OpenPorchSF	OverallCond	OverallQual MiscVal MoSold LotFrontage LowQualFinSF MasVnrArea LotArea KitchenAbvGr GarageYrBlt GrLivArea HalfBath Fireplaces FirstFlrSF FullBath GarageArea GarageCars EnclosedPorch BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtFullBath BsmtHalfBath BsmtUnfSF;
WITH SalePrice;
run;
ods graphics off;

* Scatterplot Matrix for all promising variables;
* YearBuilt YearRemodel TotRmsAbvGrd TotalBsmtSF OverallQual MasVnrArea GarageYrBlt GrLivArea FirstFlrSF FullBath GarageArea GarageCars;
ods graphics on;
Title2 "Scatterplot Matrix";
proc corr data=all_houses plot=matrix(histogram) PLOTS(MAXPOINTS= 500000);
VAR YearBuilt YearRemodel TotRmsAbvGrd TotalBsmtSF OverallQual MasVnrArea GarageYrBlt GrLivArea FirstFlrSF FullBath GarageArea GarageCars;
WITH SalePrice;
Title2 "Scatterplot Matrix";
proc corr data=all_houses plot=matrix(histogram) PLOTS(MAXPOINTS= 500000);
VAR MasVnrArea GarageYrBlt GrLivArea FirstFlrSF FullBath;
WITH SalePrice;
run;
Title2 "Scatterplot Matrix";
proc corr data=all_houses plot=matrix(histogram) PLOTS(MAXPOINTS= 500000);
VAR GarageArea GarageCars;
WITH SalePrice;
run;
ods graphics off;


* Remove houses with less than 4000SQ FT.;
proc univariate data=all_houses;
var GrLivArea;
run; quit;

proc sgplot data=all_houses;
scatter x=GrLivArea y=SalePrice;
run; quit;

data houses_sample;
	set all_houses;
	if (GrLivArea < 4000);
run;

proc sgplot data=houses_sample;
scatter x=GrLivArea y=SalePrice;
run; quit;

* TotalBsmtSF, remove non-basement and massive basements;
proc univariate data=all_houses;
var TotalBsmtSF;
run; quit;

proc sgplot data=all_houses;
scatter x=TotalBsmtSF y=SalePrice;
run; quit;

data houses_sample;
	set all_houses;
	if (TotalBsmtSF < 3000 & TotalBsmtSF > 0);
run; quit;

proc sgplot data=houses_sample;
scatter x=TotalBsmtSF y=SalePrice;
run; quit;

* Boxplot SalePrice by utilities;
proc sgplot data=all_houses;
vbox SalePrice / category=utilities;
run; quit;

proc freq data=all_houses;
tables utilities;
run; quit;

data houses_sample;
	set all_houses;
	if (Utilities = 'AllPub');
run;

proc freq data=houses_sample;
tables utilities;
run; quit;

* Boxplot SalePrice by neighborhood;
proc sgplot data=all_houses;
vbox SalePrice / category=neighborhood;
run; quit;

* Most houses are normal locationwise. Not many near railroads;
proc sgplot data=all_houses;
vbox SalePrice / category=Condition1;
run; quit;

proc freq data=all_houses;
tables Condition1;
run; quit;

* Boxplot SalePrice by zoning;
proc sgplot data=all_houses;
vbox SalePrice / category=zoning;
run; quit;


* Boxplot SalePrice by Basement finish;
proc sgplot data=all_houses;
vbox SalePrice / category=BsmtFinType1;
run; quit;

proc sgplot data=all_houses;
vbox SalePrice / category=BsmtQual;
run; quit;


* PANEL;
proc sgpanel data=all_houses;
panelby BsmtQual / rows=1 columns=6;
scatter x=BsmtFinType1 y=SalePrice;
title 'Sale Price by Living Area';
run; quit;



proc freq data=all_houses;
tables BsmtFinType1;
run; quit;

* Check frequency of oddball zonings in dataset;
proc sgplot data=all_houses;
vbox SalePrice / category=zoning;
run; quit;

proc freq data=all_houses;
tables zoning;
run; quit;

* Delete weird zoning;
data houses_sample;
	set all_houses;
	if (zoning in ('FV','RP','RH','RL','RM'));
run;



* Boxplot SalePrice by SaleCondition - New construction seems to be more expensive;
proc sgplot data=all_houses;
vbox SalePrice / category=SaleCondition;
run; quit;




* Boxplot SalePrice by Street type, remove gravel roads;
proc sgplot data=all_houses;
vbox SalePrice / category=street;
run; quit;

proc freq data=all_houses;
tables street;
run; quit;

data houses_sample;
	set all_houses;
	if (street = 'Pave');
run;

proc freq data=houses_sample;
tables street;
run; quit;

* Boxplot SalePrice by BldgType;
proc sgplot data=all_houses;
vbox SalePrice / category=BldgType;
run; quit;

proc freq data=all_houses;
tables BldgType;
run; quit;


proc sgplot data=all_houses;
vbox SalePrice / category=overallqual;
run; quit;

* PANEL;
proc sgpanel data=mydata.ames_housing_data;
panelby LotShape / rows=1 columns=4;
scatter x=GrLivArea y=SalePrice;
title 'Sale Price by Living Area';
run; quit;
