
* View histogram of logSalePrice and SalePrice;
proc univariate data=sample_houses;
histogram logSalePrice / normal kernel;
histogram SalePrice / normal kernel;
run;

proc sgplot data=sample_houses;
scatter x=LotArea y=SalePrice;
run; quit;

proc sgplot data=sample_houses;
scatter x=LotArea y=GrLivArea;
run; quit;

proc sgplot data=sample_houses;
reg x=LotArea y=GrLivArea/ clm;
loess x=LotArea y=GrLivArea/ nomarkers;
run; quit;

proc univariate data=sample_houses;
histogram LotArea / normal;

proc sgplot data=sample_houses;
scatter x=LotArea y=SalePrice;
run; quit;