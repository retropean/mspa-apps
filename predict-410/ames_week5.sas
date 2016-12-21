* Get data from ames_waterfall.sas;
data houses_temp;
set nondrop;

* Add some variables;
total_baths = max(FullBath,0) + max(BsmtFullBath,0);
total_halfbaths = max(HalfBath,0) + max(BsmtHalfBath,0);
total_baths_calc = total_baths + total_halfbaths;
* Total Area;
total_area_calc = max(GrLivArea,0) + max(TotalBsmtSF,0);
sqrttotal_area_calc = sqrt(total_area_calc);
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

* generate a uniform(0,1) random variable with seed set to 123;
u = uniform(123);
if (u < 0.70) then train = 1;
else train = 0;

if (train=1) then train_response=SalePrice;
else train_response=.;
run;

* Check distribution;
proc univariate data=houses_temp;
var u; 

* Check 30/70 split;
proc freq data=houses_temp;
tables train;
run; quit;

* Check SalePrice distribution of two partitions;
proc sgplot data=houses_temp;
vbox SalePrice / category=train;
run; quit;

data houses_train;
	set houses_temp;
	if (train=1);
run;

data houses_test;
	set houses_temp;
	if (train=0);
run;

* Check contents of data set;
proc contents data=houses_train; run; quit;
proc contents data=houses_test; run; quit;

* Forward method;
proc reg data=houses_train;
model SalePrice  = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF  FullBath GrLivArea LotArea MasVnrArea OverallQual PoolArea SecondFlrSF TotRmsAbvGrd YearBuilt YearRemodel brick_exterior fireplace_ind garage_ind total_area_calc total_baths_calc
 / selection=forward slentry=0.05 maxstep=5;
run;

* Backward Method;
proc reg data=houses_train;
model SalePrice  = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF  FullBath GrLivArea LotArea MasVnrArea OverallQual PoolArea SecondFlrSF TotRmsAbvGrd YearBuilt YearRemodel brick_exterior fireplace_ind garage_ind total_area_calc total_baths_calc
 / selection=backward slstay=0.01 aic bic cp;
run;

* Stepwise method;
proc reg data=houses_train;
model SalePrice  = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF  FullBath GrLivArea LotArea MasVnrArea OverallQual PoolArea SecondFlrSF TotRmsAbvGrd YearBuilt YearRemodel brick_exterior fireplace_ind garage_ind total_area_calc total_baths_calc
 / selection=stepwise slentry=0.15 slstay=0.15 maxstep=5;
run;

* R-Squared method;
proc reg data=houses_train;
model SalePrice  = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF  FullBath GrLivArea LotArea MasVnrArea OverallQual PoolArea SecondFlrSF TotRmsAbvGrd YearBuilt YearRemodel brick_exterior fireplace_ind garage_ind total_area_calc total_baths_calc
 / selection=rsquare start=2 stop=4 best=2 aic bic cp vif;
run;

* Maximum R-Squared Improvement Selection;
proc reg data=houses_train;
model SalePrice  = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF  FullBath GrLivArea LotArea MasVnrArea OverallQual PoolArea SecondFlrSF TotRmsAbvGrd YearBuilt YearRemodel brick_exterior fireplace_ind garage_ind total_area_calc total_baths_calc
 / selection=maxr stop=5 aic bic cp vif;
run;

* Adjusted R-Squared Selection;
proc reg data=houses_train;
model SalePrice  = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF  FullBath GrLivArea LotArea MasVnrArea OverallQual PoolArea SecondFlrSF TotRmsAbvGrd YearBuilt YearRemodel brick_exterior fireplace_ind garage_ind total_area_calc total_baths_calc 
 / selection=adjrsq best=10 stop=5  aic bic cp vif;
run;

* Mallow's CP Selection;
proc reg data=houses_train;
model SalePrice  = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF  FullBath GrLivArea LotArea MasVnrArea OverallQual PoolArea SecondFlrSF TotRmsAbvGrd YearBuilt YearRemodel brick_exterior fireplace_ind garage_ind total_area_calc total_baths_calc
 / selection=cp best=10 stop=5 aic bic cp vif;
run;

*Check multicollinearity with VIF;
proc reg data = houses_train;
	model SalePrice = BsmtUnfSF lotArea OverallQual YearRemodel total_area_calc / VIF;
run;
quit;

proc reg data = houses_train;
	model SalePrice = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 FirstFlrSF FullBath LotArea MasVnrArea OverallQual SecondFlrSF YearBuilt YearRemodel brick_exterior total_area_calc / VIF;
run;
quit;

*Check specs of Model_B;
proc reg data = houses_train;
	model SalePrice = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 FirstFlrSF FullBath LotArea MasVnrArea OverallQual SecondFlrSF YearBuilt YearRemodel brick_exterior total_area_calc / aic bic cp;
run;
quit;

* Results output;
proc reg data = houses_train;
	model SalePrice = BsmtUnfSF lotArea OverallQual YearRemodel total_area_calc / p;
run;
quit;

proc reg data = houses_train;
	model SalePrice = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 FirstFlrSF FullBath LotArea MasVnrArea OverallQual SecondFlrSF YearBuilt YearRemodel brick_exterior total_area_calc / p;
run;
quit;


* Results output;
proc reg data = houses_train outest=model_AdjR2;
	model SalePrice = BsmtUnfSF lotArea OverallQual YearRemodel total_area_calc;
run;
quit;
proc print data=model_AdjR2;
run;

* Results using test;
proc score data=houses_test score=model_AdjR2
	out=train_predictions type = parms;
	var BsmtUnfSF lotArea OverallQual YearRemodel total_area_calc;
run;

proc print data=train_predictions;

* Add Residuals;
data train_predictions;
set train_predictions;
priceresid = MODEL1-SalePrice;
run;quit;

* Grade it;
data train_predictions;
set train_predictions;
if (priceresid/SalePrice)<.10 then train_accuracy='Grade 1';
else if (priceresid/SalePrice)>.10 AND priceresid/SalePrice<.15 then train_accuracy='Grade 2';
else if (priceresid/SalePrice)>.15 then train_accuracy='Grade 3';
run;quit;

data train_predictions;
set train_predictions;
priceresidabs = abs(priceresid);
residsquare = priceresid**2;
run;quit;


proc means data=train_predictions;


proc freq data=train_predictions;
tables train_accuracy;
run; quit;

* MODEL B;

* Results output;
proc reg data = houses_train outest=model_B;
	model SalePrice = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 FirstFlrSF FullBath LotArea MasVnrArea OverallQual SecondFlrSF YearBuilt YearRemodel brick_exterior total_area_calc;
run;
quit;
proc print data=model_B;
run;

* Results output;
proc reg data = houses_train outest=model_B;
	model SalePrice = BedroomAbvGr BsmtFinSF1 BsmtFinSF2 FirstFlrSF FullBath LotArea MasVnrArea OverallQual SecondFlrSF YearBuilt YearRemodel brick_exterior total_area_calc;
run;
quit;
proc print data=model_B;
run;

* Results using test;
proc score data=houses_test score=model_B
	out=train_predictions_b type = parms;
	var BedroomAbvGr BsmtFinSF1 BsmtFinSF2 FirstFlrSF FullBath LotArea MasVnrArea OverallQual SecondFlrSF YearBuilt YearRemodel brick_exterior total_area_calc;
run;

proc print data=train_predictions_b;

* Add Residuals;
data train_predictions_b;
set train_predictions_b;
priceresid = MODEL1-SalePrice;
run;quit;

* Grade it;
data train_predictions_b;
set train_predictions_b;
if (priceresid/SalePrice)<.10 then train_accuracy='Grade 1';
else if (priceresid/SalePrice)>.10 AND priceresid/SalePrice<.15 then train_accuracy='Grade 2';
else if (priceresid/SalePrice)>.15 then train_accuracy='Grade 3';
run;quit;

data train_predictions_b;
set train_predictions_b;
priceresidabs = abs(priceresid);
residsquare = priceresid**2;
run;quit;


proc means data=train_predictions_b;


proc freq data=train_predictions_b;
tables train_accuracy;
run; quit;



