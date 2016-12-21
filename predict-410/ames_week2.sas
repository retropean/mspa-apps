* Get data from ames_waterfall.sas and create two variable manipulations;
data sample_houses;
set nondrop;
logSalePrice = log(SalePrice);
PriceSqft = SalePrice / GrLivArea;
run;

* Simple Linear Regression for LotArea;
ods graphics on;
proc reg data = sample_houses;
	model SalePrice = LotArea;
run;
quit;
ods graphics off;

* Simple Linear Regression for GrLivArea;
ods graphics on;
proc reg data = sample_houses;
	model SalePrice = GrLivArea;
run;
quit;
ods graphics off;

* Influence check for GrLivArea;
ods graphics on;
ods listing close;
proc reg data = sample_houses plots(only) = (cooksd(label)
	rstudentbypredicted(label));
	id PID;
	model SalePrice = GrLivArea / influence r;
run;
quit;
ods graphics off;
ods listing;

* Check observations with high influence;
proc print data=mydata.ames_housing_data;
   where PID = 528360050;
run;

* Multiple Linear Regression for GrLivArea & OverallQual;
ods graphics on;
proc reg data = sample_houses plots(unpack) = (diagnostics residualplot);
	model SalePrice = GrLivArea OverallQual;
run;
quit;
ods graphics off;

* RSquare Selection Method;
ods graphics on;
proc reg data = sample_houses;
	model SalePrice = GrLivArea OverallQual YearBuilt YearRemodel TotRmsAbvGrd TotalBsmtSF MasVnrArea GarageYrBlt FirstFlrSF FullBath GarageArea GarageCars / 
	selection = rsquare cp adjrsq;
run;
quit;
ods graphics off;

* Second Multiple Linear Regression;
ods graphics on;
proc reg data = sample_houses plots(unpack) = (diagnostics residualplot);
	model SalePrice = GrLivArea OverallQual TotalBsmtSF GarageArea;
run;
quit;
ods graphics off;

* Using VIF to detect collinearity;
proc reg data = sample_houses;
	model SalePrice = GrLivArea OverallQual TotalBsmtSF GarageArea / VIF;
run;
quit;

* Rerun all four regressions using logSalePrice
* Simple Linear Regression for LotArea;
ods graphics on;
proc reg data = sample_houses;
	model logSalePrice = LotArea;
run;
quit;
ods graphics off;

* Simple Linear Regression for GrLivArea;
ods graphics on;
proc reg data = sample_houses;
	model logSalePrice = GrLivArea;
run;
quit;
ods graphics off;

* Multiple Linear Regression for GrLivArea & OverallQual;
ods graphics on;
proc reg data = sample_houses plots(unpack) = (diagnostics residualplot);
	model logSalePrice = GrLivArea OverallQual;
run;
quit;
ods graphics off;

* Multiple Linear Regression for GrLivArea OverallQual TotalBsmtSF GarageArea;
ods graphics on;
proc reg data = sample_houses plots(unpack) = (diagnostics residualplot);
	model logSalePrice = GrLivArea OverallQual TotalBsmtSF GarageArea;
run;
quit;
ods graphics off;