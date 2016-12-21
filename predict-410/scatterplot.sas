libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;
proc contents data=mydata.anscombe; run;



proc print data=mydata.anscombe; run; quit;


TITLE "PROC CORR Example: Anscombe Quartet";
ods graphics on;
PROC CORR DATA=mydata.anscombe PLOT=(matrix);
VAR X1;
WITH Y1;
TITLE2 "X1 and Y1 Correlation";
run;
ods graphics off;

ods graphics on;
PROC SGPLOT DATA=mydata.anscombe;
scatter X=X1 Y=Y1;
title "X1 and Y1 Scatter Plot – No Smoothers";
run;
ods graphics off;


ods graphics on;
PROC SGPLOT DATA=mydata.anscombe;
LOESS X=X1 Y=Y1 / NOMARKERS;
REG X=X1 Y=Y1;
title "X1 and Y1 Scatter Plot with LOESS and Regression";
run;
ods graphics off;

ods graphics on;
PROC SGSCATTER data=mydata.anscombe;
compare X=X1 Y=Y1 / loess reg;
title "X1 and Y1 Scatter with Loess and Regression";
run;
ods graphics off;

* X1 & Y1;
ods graphics on;
PROC SGSCATTER data=mydata.anscombe;
plot Y1*X1 / loess reg;
title "X1 and Y1 Scatter with Loess and Regression";
run;

PROC SGSCATTER data=mydata.anscombe;
compare Y=Y1 X=X1 / loess reg;
title "X1 and Y1 Scatter with Loess and Regression";
run;
ods graphics off;

* X3 & Y3;
ods graphics on;
PROC SGSCATTER data=mydata.anscombe;
plot Y3*X3 / loess reg;
title "X3 and Y3 Scatter with Loess and Regression";
run;

PROC SGSCATTER data=mydata.anscombe;
compare Y=Y3 X=X3 / loess reg;
title "X3 and Y3 Scatter with Loess and Regression";
run;
ods graphics off;

* X4 & Y4;
ods graphics on;
PROC SGSCATTER data=mydata.anscombe;
plot Y4*X4 / loess reg;
title "X4 and Y4 Scatter with Loess and Regression";
run;

PROC SGSCATTER data=mydata.anscombe;
compare Y=Y4 X=X4 / loess reg;
title "X4 and Y4 Scatter with Loess and Regression";
run;
ods graphics off;



PROC PRINT data=mydata.anscombe; RUN; QUIT;
DATA long;
set mydata.anscombe (keep=x1 y1 rename=(x1=x y1=y) in=a)
mydata.anscombe (keep=x2 y2 rename=(x2=x y2=y) in=b)
mydata.anscombe (keep=x3 y3 rename=(x3=x y3=y) in=c)
mydata.anscombe (keep=x4 y4 rename=(x4=x y4=y) in=d)
;
if (a=1) then anscombe_group=1;
else if (b=1) then anscombe_group=2;
else if (c=1) then anscombe_group=3;
else if (d=1) then anscombe_group=4;
else anscombe_group=0;
RUN;
PROC PRINT data=long; RUN; QUIT;


ods graphics on;
PROC SGPANEL data=long;
PANELBY anscombe_group / COLUMNS=4 ROWS=1;
SCATTER X=x Y=y;
TITLE 'Panel of Scatterplots';
RUN; QUIT;
ods graphics off;
ods graphics on;
PROC SGPANEL data=long;
PANELBY anscombe_group / COLUMNS=2 ROWS=2;
SCATTER X=x Y=y;
TITLE 'Panel of Scatterplots';
RUN; QUIT;
ods graphics off;