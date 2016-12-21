libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;
proc contents data=mydata.ames_housing_data; run; quit;

* Create shortened dataset name;
data all_houses;
set mydata.ames_housing_data;
run;

data all_houses;
set all_houses;
PriceSqft = SalePrice / GrLivArea;
run;

* Macro for basic EDA functions;
%macro myEDA(x); *macro name & start;
proc univariate data=all_houses;
var &x;
cdfplot &x; * cumulative distribution plot;
histogram &x; * histogram plot;
ppplot &x; * probability-probability plot;
probplot &x; * probability plot;
qqplot &x; * quantile-quantile plot;

proc freq data=all_houses;
tables &x;
run; quit;

proc means data=all_houses min mean median max;
var &x;
run; quit;
%mend myEDA; 

* Macro to compare versus SalePrice;
%macro saleCompare(x); 
proc sgplot data=all_houses;
scatter x=&x y=SalePrice;
run; quit;

proc sgplot data=all_houses;
vbox SalePrice / category=&x;
run; quit;

%mend saleCompare; 


* YearBuilt;
%myEDA(x=YearBuilt);
%saleCompare(x=YearBuilt);

data houses_pre1950;
	set all_houses;
	if (YearBuilt < 1950);
run;

data houses_post1950;
	set all_houses;
	if (YearBuilt >= 1950);
run;

* Note that houses pre-1950 have different relationship;

proc sgplot data=houses_post1950;
scatter x=YearBuilt y=SalePrice;
run; quit;
proc sgplot data=houses_pre1950;
scatter x=YearBuilt y=SalePrice;
run; quit;

ods graphics on;
PROC SGPLOT DATA=houses_post1950;
LOESS X=YearBuilt Y=SalePrice / NOMARKERS;
REG X=YearBuilt Y=SalePrice;
run;
ods graphics off;

ods graphics on;
PROC SGPLOT DATA=houses_pre1950;
LOESS X=YearBuilt Y=SalePrice / NOMARKERS;
REG X=YearBuilt Y=SalePrice;
run;
ods graphics off;

proc sgplot data=all_houses;
vbox YearBuilt / category=neighborhood;
run; quit;

proc sgplot data=all_houses;
scatter x=YearBuilt y=SalePrice;
run; quit;

*Functional;
%myEDA(x=Functional);
%saleCompare(x=Functional);

proc sgpanel data=mydata.ames_housing_data;
panelby Functional / rows=1 columns=4;
scatter x=YearBuilt y=SalePrice;
title 'Sale Price by Living Area';
run; quit;

* SaleType;
%myEDA(x=SaleType);
%saleCompare(x=SaleType);

* SaleCondition;
%myEDA(x=SaleCondition);
%saleCompare(x=SaleCondition);

proc sgplot data=all_houses;
scatter x=SaleCondition y=PriceSqFt;
run; quit;

* OverallCond;
%myEDA(x=OverallCond);
%saleCompare(x=OverallCond);

proc sgplot data=all_houses;
vbox YearBuilt / category=OverallCond;
run; quit;

* OverallQual;
%myEDA(x=OverallQual);
%saleCompare(x=OverallQual);

proc sgplot data=all_houses;
vbox YearBuilt / category=OverallQual;
run; quit;

* YearRemodel;
%myEDA(x=YearRemodel);
%saleCompare(x=YearRemodel);

proc sgplot data=all_houses;
scatter x=YearRemodel y=PriceSqFt;
run; quit;

proc sgplot data=all_houses;
scatter x=YearRemodel y=SalePrice;
run; quit;

* GrLivArea; 
%myEDA(x=GrLivArea);
%saleCompare(x=GrLivArea);

proc sgplot data=all_houses;
scatter y=GrLivArea x=YearRemodel;
run; quit;

proc sgplot data=all_houses;
scatter y=GrLivArea X=YearBuilt;
run; quit;

proc sgplot data=all_houses;
vbox GrLivArea / category=neighborhood;
run; quit;

proc sgplot data=all_houses;
vbox YearRemodel / category=neighborhood;
run; quit;

* GarageCars, GarageArea; 
%myEDA(x=GarageArea);
%myEDA(x=GarageCars);

proc sgplot data=all_houses;
scatter y=GarageCars X=GarageArea;
run; quit;

%saleCompare(x=GarageCars);
%saleCompare(x=GarageArea);

* FullBath; 
%myEDA(x=FullBath);
%saleCompare(x=FullBath);

proc sgplot data=all_houses;
scatter x=FullBath y=GrLivArea;
run; quit;

* HouseStyle;
%myEDA(x=HouseStyle);
%saleCompare(x=HouseStyle);

* SubClass;
%myEDA(x=SubClass);
%saleCompare(x=SubClass);

* LotShape;
%myEDA(x=LotShape);
%saleCompare(x=LotShape);

* PoolArea;
%myEDA(x=PoolArea);
%saleCompare(x=PoolArea);

* LandContour;
%myEDA(x=LandContour);
%saleCompare(x=LandContour);

* Heating;
%myEDA(x=Heating);
%saleCompare(x=Heating);

*CentralAir;
%myEDA(x=CentralAir);
%saleCompare(x=CentralAir);


TotRmsAbvGrd TotalBsmtSF OverallQual MasVnrArea GarageYrBlt GrLivArea FirstFlrSF FullBath GarageArea GarageCars;