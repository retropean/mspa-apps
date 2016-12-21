* Get data from ames_waterfall.sas and create two variable manipulations;
data sample_houses;
set nondrop;
logSalePrice = log(SalePrice);
sqrtOverallQual = sqrt(OverallQual);
sqrtGarageArea = sqrt(GarageArea);

*logSalePrice = log(SalePrice);
*logSalePrice = log(SalePrice);
PriceSqft = SalePrice / GrLivArea;

* Add total bathrooms;
total_baths = max(FullBath,0) + max(BsmtFullBath,0);
total_halfbaths = max(HalfBath,0) + max(BsmtHalfBath,0);
total_baths_calc = total_baths + total_halfbaths;

* Total Area;
total_area_calc = max(GrLivArea,0) + max(TotalBsmtSF,0);
sqrttotal_area_calc = sqrt(total_area_calc);
*total_area_calc = max(GrLivArea,0) + max(BasmtFinType1,0) + max(BasmtFinType2,0);

* Fireplace Indicator;
if (Fireplaces>0) then fireplace_ind=1; else fireplace_ind=0;
* Garage Indicator;
if (GarageCars>0) then garage_ind=1; else garage_ind=0;
* Good Basement Indicator;
if (BsmtQual in ('Ex','Gd')) or (BsmtCond in ('Ex','Gd')) then good_basement_ind=1; else good_basement_ind=0;


* Exterior Material Quality - Family of Indicator Variables;
if (ExterQual='Ex') then ExterQual_Ex=1; else ExterQual_Ex=0;
if (ExterQual='Gd') then ExterQual_Gd=1; else ExterQual_Gd=0;
if (ExterQual='TA') then ExterQual_TA=1; else ExterQual_TA=0;
if (ExterQual='Fa') then ExterQual_Fa=1; else ExterQual_Fa=0;
if (ExterQual='Po') then ExterQual_Po=1; else ExterQual_Po=0;

* Brick Exterior;
if (Exterior1 in ('BrkComm','BrkFace')) or (Exterior2 in ('BrkComm','BrkFace')) 
then brick_exterior=1; else brick_exterior=0;

* Tile Roof;
if (RoofMat='ClyTile') then tile_roof=1; else tile_roof=0;

* Lot Shape;
if (LotShape in ('Reg','IR1')) then regular_lot=1; else regular_lot=0;

* Lot Configuration;
if (LotConfig='Inside') then lot_inside=1; else lot_inside=0;
if (LotConfig='Corner') then lot_corner=1; else lot_corner=0;
if (LotConfig='CulDSac') then lot_culdsac=1; else lot_culdsac=0;
if (LotConfig in ('FR2','FR3')) then lot_frontage=1; else lot_frontage=0;

* Construct a composite quality index;
quality_index = OverallCond*OverallQual;

run;

* Run multiple regressions, Check R-Squared;
ods graphics on;
proc reg data = sample_houses;
	model SalePrice = quality_index total_area_calc total_baths_calc regular_lot good_basement_ind fireplace_ind brick_exterior GrLivArea OverallQual YearBuilt YearRemodel TotRmsAbvGrd TotalBsmtSF MasVnrArea GarageYrBlt FirstFlrSF FullBath GarageArea GarageCars / 
	selection = rsquare cp adjrsq;
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

* Simple Linear Regression for total_area_calc;
ods graphics on;
proc reg data = sample_houses;
	model SalePrice = total_area_calc;
	OUTPUT out=myL1Resid r=yresid zresid;
run;
quit;
ods graphics off;

* Check residuals;
proc sgplot data=myL1Resid;
scatter x=total_area_calc y=yresid;
run; quit;

proc univariate data=myL1Resid normal ;
proc contents data=myL1Resid ; run; quit;
run;

* Multiple Linear Regression for GrLivArea OverallQual TotalBsmtSF GarageArea;
ods graphics on;
proc reg data = sample_houses plots(unpack) = (diagnostics residualplot);
	model SalePrice = total_area_calc total_baths_calc OverallQual YearRemodel MasVnrArea;
run;
quit;
ods graphics off;

* Multi-collinearity check;
proc reg data = sample_houses;
	model SalePrice = total_area_calc total_baths_calc OverallQual YearRemodel MasVnrArea / VIF;
run;
quit;

* Multiple Linear Regression for GrLivArea OverallQual TotalBsmtSF GarageArea;
ods graphics on;
proc reg data = sample_houses plots(unpack) = (diagnostics residualplot);
	model SalePrice = total_area_calc OverallQual YearRemodel MasVnrArea GarageArea;
run;
quit;
ods graphics off;

* Multi-collinearity check;
proc reg data = sample_houses;
	model SalePrice = total_area_calc OverallQual YearRemodel MasVnrArea GarageArea / VIF;
run;
quit;

* With Log;

ods graphics on;
proc reg data = sample_houses;
	model logSalePrice = GrLivArea;
run;
quit;
ods graphics off;

* Simple Linear Regression for total_area_calc;
ods graphics on;
proc reg data = sample_houses;
	model logSalePrice = total_area_calc;
run;
quit;
ods graphics off;

* Multiple Linear Regression for GrLivArea OverallQual TotalBsmtSF GarageArea;
ods graphics on;
proc reg data = sample_houses plots(unpack) = (diagnostics residualplot);
	model logSalePrice = total_area_calc total_baths_calc OverallQual YearRemodel MasVnrArea;
run;
quit;
ods graphics off;

* Now with sqrttotal_area_calc & sqrtGarageArea;
proc reg data = sample_houses;
	model logSalePrice = sqrttotal_area_calc OverallQual YearRemodel MasVnrArea sqrtGarageArea / VIF;
run;
quit;

* Outlier Identification;
* Influence check for GrLivArea;
ods graphics on;
ods listing close;
proc reg data = sample_houses plots(only) = (cooksd(label)
	rstudentbypredicted(label));
	id PID;
	model SalePrice = total_area_calc / influence r;
run;
quit;
ods graphics off;
ods listing;


* Influence Check on Second model;
ods graphics on;
proc reg data = sample_houses plots(label only unpack) = (cooksd rstudentbypredicted dffits dfbetas);
	id PID;
	model logSalePrice = total_area_calc total_baths_calc OverallQual YearRemodel MasVnrArea / influence;
run;
quit;
ods graphics off;
