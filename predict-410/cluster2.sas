/*	Chad R. Bhatti
	11.14.2015
	dog_mandible_02.sas
*/

/*
In this example we will look at clustering dogs based on a set of jaw measurements using
the hierarchical clustering algorithm provided by PROC CLUSTER.  The hierarchical clustering
algorithm creates a tree of cluster solutions so that we can easily recall any number of 
clusters using PROC TREE.

We will view this problem as a supervised learning problem or a classification problem 
where the objective is to create clusters in order to assign (or predict) the type of dog
based on its cluster membership.  We will look at the accuracy results for two different
sets (number) of clusters.

In this example we will standardize the attributes using PROC STANDARD before using the 
hierarchical clustering algorithm provided by PROC CLUSTER.

*/


libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;

proc contents data=mydata.dog_mandible_measurements; run; quit;

proc print data=mydata.dog_mandible_measurements; run; quit;


* list out class names and counts;
proc freq data=mydata.dog_mandible_measurements; 
tables group_name;
run; quit;
* note that we have 5 classes of dogs, 10 if we would count type of dog and gender;


* strip off class identifiers for clustering;
data measurements;
	set mydata.dog_mandible_measurements(keep= X:);
run;

proc print data=measurements; run; quit;

*********************************************************************************;
* Standardize the data measurements using PROC STANDARD;
*********************************************************************************;
proc standard data=measurements out=std_measurements
	mean=0 std=1 noprint;
run; quit;

proc print data=std_measurements; run; quit;

data n_measurements;
	set mydata.dog_mandible_measurements;
	n = _n_;
	
	rename X1=rX1 X2=rX2 X3=rX3 X4=rX4 X5=rX5 X6=rX6 X7=rX7 X8=rX8 X9=rX9;
run;

data n_std_measurements;
	set std_measurements;
	n = _n_;
run;

proc sort data=n_measurements; by n; run; quit;
proc sort data=n_std_measurements; by n; run; quit;

data n_data;
	merge n_measurements n_std_measurements;
	by n;
run;

proc print data=n_data; run; quit;


*********************************************************************************;
* Perform cluster analysis using PROC CLUSTER;
*********************************************************************************;
ods graphics on;
proc cluster data=std_measurements method=average outtree=tree1;
run; quit;
ods graphics off;


*********************************************************************************;
* Pull results for 5 clusters using PROC TREE;
*********************************************************************************;
ods graphics on;
proc tree data=tree1 ncl=5 out=_5_clusters;
copy X: ;
run; quit;
ods graphics off;

proc print data=_5_clusters; run; quit;

proc freq data=_5_clusters;
tables clusname;
run; quit;

proc sort data=_5_clusters; by X1-X9; run; quit;
proc sort data=n_data out=class_labels; by X1-X9; run; quit;

data cluster_fit5;
	merge class_labels _5_clusters;
	by X1-X9;
run;

proc freq data=cluster_fit5;
tables clusname*group_name;
run; quit;


*********************************************************************************;
* Pull results for 10 clusters using PROC TREE;
* Note that with hierarchical clustering we do not need to refit the clustering
* algorithm.  All sets of clusters have already been fit.
*********************************************************************************;
ods graphics on;
proc tree data=tree1 ncl=10 out=_10_clusters;
copy X: ;
run; quit;
ods graphics off;

proc print data=_10_clusters; run; quit;

proc freq data=_10_clusters;
tables clusname;
run; quit;

proc sort data=_10_clusters; by X1-X9; run; quit;
proc sort data=n_data out=class_labels; by X1-X9; run; quit;

data cluster_fit10;
	merge class_labels _10_clusters;
	by X1-X9;
run;

proc freq data=cluster_fit10;
tables clusname*group_name;
run; quit;


*********************************************************************************;
* Formalize the cluster fits and their accuracy;
*********************************************************************************;
data predict5;
	set cluster_fit5;
	format predicted_group $20.;
	
	if (clusname='CL5') then predicted_group='Golden Jackal';
	else if (clusname in ('CL6','OB61')) then predicted_group='Indian Wolves';
	else if (clusname='CL7') then predicted_group='Cuons';
	else if (clusname='OB74') then predicted_group='Prehistoric';
	else predicted_group='Error';
	* Note that we are only predicting four of the five groups when using five clusters;
	* Note that the individual observations are essentially clustering outliers for the 
	given number of clusters.  They are far enough away from the other observations that
	they are given their own cluster;
	
	if (predicted_group=group_name) then correct_prediction=1;
	else correct_prediction=0;
run;

* Check predicted_group assignment for ERROR;
proc freq data=predict5; 
tables predicted_group;
run; quit;

proc means data=predict5 mean noprint;
var correct_prediction;
output out=prediction_accuracy5 
	sum(correct_prediction)=count_accurate
	mean(correct_prediction)=pct_accurate;
run; quit;

proc print data=prediction_accuracy5; run; quit;


data predict10;
	set cluster_fit10;
	format predicted_group $20.;
	
	if (clusname='CL27') then predicted_group='Golden Jackal';
	else if (clusname='OBS74') then predicted_group='Prehistoric';
	else if (clusname in ('CL12','CL14','CL17','CL28','OB56','OB61')) then predicted_group='Indian Wolves';
	else if (clusname in ('CL13','CL14')) then predicted_group='Cuons';
	else if (clusname='CL11') then predicted_group='Modern';
	else predicted_group='Error';
	* Now we are predicting all five of the groups when using ten clusters;
	
	if (predicted_group=group_name) then correct_prediction=1;
	else correct_prediction=0;
run;

* Check predicted_group assignment for ERROR;
proc freq data=predict10; 
tables predicted_group;
run; quit;


proc means data=predict10 mean noprint;
var correct_prediction;
output out=prediction_accuracy10 
	sum(correct_prediction)=count_accurate
	mean(correct_prediction)=pct_accurate;
run; quit;

proc print data=prediction_accuracy10; run; quit;




*********************************************************************************;
* How can we improve this (supervised) cluster analysis?;
*********************************************************************************;
/*
(1) We did not standardize the attributes (or variable measurements).  When the
attributes are not standardized, then the clustering algorithm will focus on the
variables of largest magnitude.

With standardized variables:
* Prediction Accuracy for 5 Clusters = 0.58442;
* Prediction Accuracy for 10 Clusters = 0.59740;

With raw variables:
* Prediction Accuracy for 5 Clusters = 0.63636;
* Prediction Accuracy for 10 Clusters = 0.74026;


* Note that standardizing the variables did not improve the predictive accuracy
of the clusters.  This suggests that the larger variables are more important than
the smaller variables in predicting dog type;

(2) We did not reduce the dimension of our problem.  Cluster analysis works best
in lower dimensions.  Points get far apart quickly as the dimension of the 
attribute space grows. 

Principal components can reduce our dimension and weight
our variables in an order of importance.  Applying PCA as a preconditioner to the
cluster analysis should be our next step of exploration.


*/




/*	Chad R. Bhatti
	11.14.2015
	dog_mandible_03.sas
*/

/*
In this example we will look at clustering dogs based on a set of jaw measurements using
the hierarchical clustering algorithm provided by PROC CLUSTER.  The hierarchical clustering
algorithm creates a tree of cluster solutions so that we can easily recall any number of 
clusters using PROC TREE.

We will view this problem as a supervised learning problem or a classification problem 
where the objective is to create clusters in order to assign (or predict) the type of dog
based on its cluster membership.  We will look at the accuracy results for two different
sets (number) of clusters.

In this example we will reduce the dimension of the attributes using Principal Component
Analysis via PROC PRINCOMP before using the hierarchical clustering algorithm provided 
by PROC CLUSTER.

*/


libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;

proc contents data=mydata.dog_mandible_measurements; run; quit;

proc print data=mydata.dog_mandible_measurements; run; quit;


* list out class names and counts;
proc freq data=mydata.dog_mandible_measurements; 
tables group_name;
run; quit;
* note that we have 5 classes of dogs, 10 if we would count type of dog and gender;


* strip off class identifiers for clustering;
data measurements;
	set mydata.dog_mandible_measurements(keep= X:);
run;

proc print data=measurements; run; quit;

*********************************************************************************;
* Transform the data measurements into principal components using PROC PRINCOMP;
*********************************************************************************;
proc princomp data=measurements out=pca_scores plots=all;
run; quit;
* How many principal components should we use?;

proc print data=pca_scores; run; quit;


proc sort data=mydata.dog_mandible_measurements out=class_labels; by X1-X9; run; quit;
proc sort data=pca_scores; by X1-X9; run; quit;

data class_labels;
	merge class_labels pca_scores;
	by X1-X9;
run;

proc print data=class_labels; run; quit;


*********************************************************************************;
* Perform cluster analysis using PROC CLUSTER;
*********************************************************************************;
ods graphics on;
proc cluster data=class_labels method=average outtree=tree1;
var prin1 prin2;
run; quit;
ods graphics off;


*********************************************************************************;
* Pull results for 5 clusters using PROC TREE;
*********************************************************************************;
ods graphics on;
proc tree data=tree1 ncl=5 out=_5_clusters;
copy prin1 prin2 ;
run; quit;
ods graphics off;

proc print data=_5_clusters; run; quit;

proc freq data=_5_clusters;
tables clusname;
run; quit;

proc sort data=_5_clusters; by prin1 prin2; run; quit;
proc sort data=class_labels out=cluster_labels; by prin1 prin2; run; quit;

data cluster_fit5;
	merge cluster_labels _5_clusters;
	by prin1 prin2;
run;

proc freq data=cluster_fit5;
tables clusname*group_name;
run; quit;


*********************************************************************************;
* Pull results for 10 clusters using PROC TREE;
* Note that with hierarchical clustering we do not need to refit the clustering
* algorithm.  All sets of clusters have already been fit.
*********************************************************************************;
ods graphics on;
proc tree data=tree1 ncl=10 out=_10_clusters;
copy prin1 prin2 ;
run; quit;
ods graphics off;

proc print data=_10_clusters; run; quit;

proc freq data=_10_clusters;
tables clusname;
run; quit;

proc sort data=_10_clusters; by prin1 prin2; run; quit;
proc sort data=class_labels out=cluster_labels; by prin1 prin2; run; quit;

data cluster_fit10;
	merge cluster_labels _10_clusters;
	by prin1 prin2;
run;


proc freq data=cluster_fit10;
tables clusname*group_name;
run; quit;


*********************************************************************************;
* Formalize the cluster fits and their accuracy;
*********************************************************************************;
data predict5;
	set cluster_fit5;
	format predicted_group $20.;
	
	if (clusname='CL12') then predicted_group='Golden Jackal';
	else if (clusname in ('CL6','OB77')) then predicted_group='Indian Wolves';
	else if (clusname='CL5') then predicted_group='Cuons';
	else if (clusname='CL7') then predicted_group='Modern';
	else predicted_group='Error';
	* Note that we are only predicting four of the five groups when using five clusters;
	* Note that the individual observations are essentially clustering outliers for the 
	given number of clusters.  They are far enough away from the other observations that
	they are given their own cluster;
	
	if (predicted_group=group_name) then correct_prediction=1;
	else correct_prediction=0;
run;

* Check predicted_group assignment for ERROR;
proc freq data=predict5; 
tables predicted_group;
run; quit;

proc means data=predict5 mean noprint;
var correct_prediction;
output out=prediction_accuracy5 
	sum(correct_prediction)=count_accurate
	mean(correct_prediction)=pct_accurate;
run; quit;

proc print data=prediction_accuracy5; run; quit;


data predict10;
	set cluster_fit10;
	format predicted_group $20.;
	
	if (clusname='CL12') then predicted_group='Golden Jackal';
	else if (clusname='CL13') then predicted_group='Prehistoric';
	else if (clusname in ('CL10','CL16','CL19','OB77')) then predicted_group='Indian Wolves';
	else if (clusname in ('CL11','CL15')) then predicted_group='Cuons';
	else if (clusname in ('CL14','CL17')) then predicted_group='Modern';
	else predicted_group='Error';
	* Now we are predicting all five of the groups when using ten clusters;
	
	if (predicted_group=group_name) then correct_prediction=1;
	else correct_prediction=0;
run;

* Check predicted_group assignment for ERROR;
proc freq data=predict10; 
tables predicted_group;
run; quit;


proc means data=predict10 mean noprint;
var correct_prediction;
output out=prediction_accuracy10 
	sum(correct_prediction)=count_accurate
	mean(correct_prediction)=pct_accurate;
run; quit;

proc print data=prediction_accuracy10; run; quit;




*********************************************************************************;
* Predictive Accuracy of clusters:
*********************************************************************************;
/*

With standardized variables:
* Prediction Accuracy for 5 Clusters = 0.58442;
* Prediction Accuracy for 10 Clusters = 0.59740;

With raw variables:
* Prediction Accuracy for 5 Clusters = 0.63636;
* Prediction Accuracy for 10 Clusters = 0.74026;

Using the first two principal components:
* Prediction Accuracy for 5 Clusters = 0.74026;
* Prediction Accuracy for 10 Clusters = 0.80519;

** Why don't you compute the accuracy obtained by using the first three principal
components for the clustering?

*/




/*	Chad R. Bhatti
	11.14.2015
	dog_mandible_04.sas
*/

/*
In this example we will look at clustering dogs based on a set of jaw measurements using
the disjoint clustering algorithm provided by PROC FASTCLUS.  The hierarchical clustering
algorithm of PROC CLUSTER creates a tree of cluster solutions so that we can easily recall 
any number of clusters using PROC TREE.  Hierarchical clustering is computationally 
intensive and does not work well on large data sets.  Hence, disjoint algorithms such as
k-means are used on large data sets.

We will view this problem as a supervised learning problem or a classification problem 
where the objective is to create clusters in order to assign (or predict) the type of dog
based on its cluster membership.  We will look at the accuracy results for two different
sets (number) of clusters.

In this example we will reduce the dimension of the attributes using Principal Component
Analysis via PROC PRINCOMP before using the k-means clustering algorithm provided 
by PROC FASTCLUST.

*/


libname mydata     '/scs/crb519/PREDICT_410/SAS_Data/' access=readonly;

proc contents data=mydata.dog_mandible_measurements; run; quit;

proc print data=mydata.dog_mandible_measurements; run; quit;


* list out class names and counts;
proc freq data=mydata.dog_mandible_measurements; 
tables group_name;
run; quit;
* note that we have 5 classes of dogs, 10 if we would count type of dog and gender;


* strip off class identifiers for clustering;
data measurements;
	set mydata.dog_mandible_measurements(keep= X:);
run;

proc print data=measurements; run; quit;

*********************************************************************************;
* Transform the data measurements into principal components using PROC PRINCOMP;
*********************************************************************************;
proc princomp data=measurements out=pca_scores plots=all;
run; quit;
* How many principal components should we use?;

proc print data=pca_scores; run; quit;


proc sort data=mydata.dog_mandible_measurements out=class_labels; by X1-X9; run; quit;
proc sort data=pca_scores; by X1-X9; run; quit;

data class_labels;
	merge class_labels pca_scores;
	by X1-X9;
run;

proc print data=class_labels; run; quit;


*********************************************************************************;
* Perform cluster analysis using PROC FASTCLUS - 5 clusters;
*********************************************************************************;
ods graphics on;
proc fastclus data=class_labels maxclusters=5 mean=cluster_stats5 out=cluster_fit5;
var prin1 prin2;
run; quit;
ods graphics off;

proc print data=cluster_stats5; run; quit;
proc print data=cluster_fit5; run; quit;


proc freq data=cluster_fit5;
tables cluster*group_name;
run; quit;


*********************************************************************************;
* Formalize the cluster fits and their accuracy;
*********************************************************************************;
data predict5;
	set cluster_fit5;
	format predicted_group $20.;
	
	if (cluster=1) then predicted_group='Modern';
	else if (cluster=2) then predicted_group='Modern';
	else if (cluster=3) then predicted_group='Golden Jackal';
	else if (cluster=4) then predicted_group='Indian Wolves';
	else if (cluster=5) then predicted_group='Cuons';
	else predicted_group='Error';
	* Note that we are only predicting four of the five groups when using five clusters;
		
	if (predicted_group=group_name) then correct_prediction=1;
	else correct_prediction=0;
run;

* Check predicted_group assignment for ERROR;
proc freq data=predict5; 
tables predicted_group;
run; quit;

proc means data=predict5 mean noprint;
var correct_prediction;
output out=prediction_accuracy5 
	sum(correct_prediction)=count_accurate
	mean(correct_prediction)=pct_accurate;
run; quit;

proc print data=prediction_accuracy5; run; quit;


*********************************************************************************;
* Perform cluster analysis using PROC FASTCLUS - 10 clusters;
*********************************************************************************;
ods graphics on;
proc fastclus data=class_labels maxclusters=10 mean=cluster_stats10 out=cluster_fit10;
var prin1 prin2;
run; quit;
ods graphics off;

proc print data=cluster_stats10; run; quit;
proc print data=cluster_fit10; run; quit;


proc freq data=cluster_fit10;
tables cluster*group_name;
run; quit;


*********************************************************************************;
* Formalize the cluster fits and their accuracy;
*********************************************************************************;
data predict10;
	set cluster_fit10;
	format predicted_group $20.;
	
	if (cluster=1) then predicted_group='Cuons';
	else if (cluster=2) then predicted_group='Cuons';
	else if (cluster=3) then predicted_group='Golden Jackal';
	else if (cluster=4) then predicted_group='Golden Jackal';
	else if (cluster=5) then predicted_group='Modern';
	else if (cluster=6) then predicted_group='Indian Wolves';
	else if (cluster=7) then predicted_group='Modern';
	else if (cluster=8) then predicted_group='Prehistoric';
	else if (cluster=9) then predicted_group='Indian Wolves';
	else if (cluster=10) then predicted_group='Indian Wolves';
	else predicted_group='Error';
	* Now we are predicting all five of the groups when using ten clusters;
	
	if (predicted_group=group_name) then correct_prediction=1;
	else correct_prediction=0;
run;

* Check predicted_group assignment for ERROR;
proc freq data=predict10; 
tables predicted_group;
run; quit;


proc means data=predict10 mean noprint;
var correct_prediction;
output out=prediction_accuracy10 
	sum(correct_prediction)=count_accurate
	mean(correct_prediction)=pct_accurate;
run; quit;

proc print data=prediction_accuracy10; run; quit;




*********************************************************************************;
* Predictive Accuracy of clusters:
*********************************************************************************;
/*

With standardized variables:
* Prediction Accuracy for 5 Clusters = 0.58442;
* Prediction Accuracy for 10 Clusters = 0.59740;

With raw variables:
* Prediction Accuracy for 5 Clusters = 0.63636;
* Prediction Accuracy for 10 Clusters = 0.74026;

Using the first two principal components:
* Prediction Accuracy for 5 Clusters = 0.74026;
* Prediction Accuracy for 10 Clusters = 0.80519;

K-Means: Using the first two principal components:
* Prediction Accuracy for 5 Clusters = 0.72727;
* Prediction Accuracy for 10 Clusters = 0.80519;


** Why don't you compute the accuracy obtained by using the first three principal
components for the clustering?

*/
