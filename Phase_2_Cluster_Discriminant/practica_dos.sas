LIBNAME practic2 "C:\Users\Pablo Galaron\OneDrive - Universidad Complutense de Madrid (UCM)\Escritorio\No Supervisado\Prácticas\Práctica_2";


/*--------------------------------------PRÁCTICA 2----------------------------------------------------------------------------
*/


/*----------------Compruebo la salida de la práctica anterior para observar un poco--------------------------------------------------------------------------------------------------
*/

proc print data = practic2.Afact_QUARTIMAX; run;


/* División del dataset limpio en 70%(SAMPLE) y 30% (RESTANTE) */

PROC SURVEYSELECT DATA=practic2.Afact_QUARTIMAX OUT=SAMPLE_RAW
     METHOD=SRS          /* Muestreo aleatorio simple */
     SAMPRATE=0.7        /* 70% para clúster */
     SEED=12345
     OUTALL noprint;
RUN;

/* 70% */
DATA practic2.SAMPLE;
    SET SAMPLE_RAW;
    IF Selected = 1;
RUN;

/* 30% */
DATA practic2.RESTANTE;
    SET SAMPLE_RAW;
    IF Selected = 0;
RUN;


/*-----------------------Observo que pasa con los primeros factores-------------------------------------------------------------------------------------------
*/
PROC CLUSTER DATA=practic2.SAMPLE 
method=ward
std nonorm pseudo RSQUARE ccc /*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_ward_factores;
var factor1 factor2; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
id id;
RUN;

proc tree data=salida_ward_factores ncl=5 out=clusters_factores noprint; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor1 factor2;
id id; 
run; 

proc sgplot data=clusters_factores;
    scatter x=factor1 y=factor2/ group=cluster ;
    xaxis label="factor1";
    yaxis label="Factor 2";
    title "Representación de los Clusters en el espacio Factorial (Ward, 6 grupos)";
run;

/*-----------------------Voy a hacerlo solo para factor1-------------------------------------------------------------------------------------------
*/

PROC CLUSTER DATA=practic2.SAMPLE 
method=ward
std nonorm pseudo RSQUARE ccc /*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_ward_factor1;
var factor1; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor2;
id id;
RUN;

proc tree data=salida_ward_factor1 ncl=8 out=clusters_factor1 noprint; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor1 factor2;
id id; 
run; 


proc sgplot data=clusters_factor1;
    scatter x=factor1 y=id/ group=cluster ;
run;

PROC FREQ DATA=clusters_factor1;
   TABLES CLUSTER; 
   TITLE "Número de observaciones por Clúster";
RUN;

/*-----------------------Voy a hacer aceclus para obtener can1 y can2-------------------------------------------------------------------------------------------
*/

PROC ACECLUS DATA=practic2.SAMPLE 
             OUT=practic2.SAMPLE_TRANSFORMED 
             P=.03;
    VAR traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor1 factor2;
run;

PROC CLUSTER DATA=practic2.SAMPLE_transformed /*datos no estandarizados*/
method=ward
std nonorm pseudo RSQUARE ccc/*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_ward_cans;
var  Can1 Can2; /*especificar las variables transformadas en esta forma*/
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor1 factor2;
id id;
RUN;

proc tree data=salida_ward_cans ncl=6 out=clusters_cans noprint; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu can1 can2 factor1 factor2;
id id; 
run; 


proc sgplot data= clusters_cans; 
scatter x=can1 y=can2 / group=cluster; 
run; 


/*-----------------------Voy a probar solo con can 1 a ver si mejora algo-------------------------------------------------------------------------------------------
*/

PROC CLUSTER DATA=practic2.SAMPLE_transformed /*datos no estandarizados*/
method=ward
std nonorm pseudo RSQUARE ccc/*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_ward_cans1;
var  Can1; /*especificar las variables transformadas en esta forma*/
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor1 factor2 can2;
id id;
RUN;

proc tree data=salida_ward_cans1 ncl=4 out=clusters_can1 noprint; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu can1 can2 factor1 factor2;
id id; 
run; 

proc sgplot data= clusters_can1; 
scatter x=can1 y=can2 / group=cluster; 
run; 

PROC FREQ DATA=clusters_can1;
   TABLES CLUSTER; 
   TITLE "Número de observaciones por Clúster";
RUN;


/*-----------------------ME QUEDO CON FACTOR 1 Y AHORA PRUEBO MÁS MÉTODOS PARA VER SI MEJORA ALGO-------------------------------------------------------------------------------------------
*/


PROC CLUSTER DATA=practic2.SAMPLE 
method= average
std nonorm pseudo RSQUARE ccc /*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_average_factor1;
var factor1; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor2;
id id;
RUN;

PROC CLUSTER DATA=practic2.SAMPLE 
method= centroid
std nonorm pseudo RSQUARE ccc /*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_centroid_factor1;
var factor1; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor2;
id id;
RUN;

PROC CLUSTER DATA=practic2.SAMPLE 
method= single
std nonorm pseudo RSQUARE ccc /*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_single_factor1;
var factor1; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor2;
id id;
RUN;

PROC CLUSTER DATA=practic2.SAMPLE 
method= complete
std nonorm pseudo RSQUARE ccc /*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_complete_factor1;
var factor1; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor2;
id id;
RUN;





/*-----------------------DEFINITIVO-------------------------------------------------------------------------------------------
*/
PROC CLUSTER DATA=practic2.SAMPLE 
method= average
std nonorm pseudo RSQUARE ccc /*incluir "std" para estandarizar los datos*/
print=20 outtree=salida_average_factor1;
var factor1; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu factor2;
id id;
RUN;

proc tree data=salida_average_factor1 ncl=4 out=clusters_avg_factor1; 
copy traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu  factor1;
id id; 
run; 

proc sgplot data= clusters_avg_factor1; 
scatter x=factor1 y=id / group=cluster; 
run; 


proc sort data = clusters_avg_factor1; by cluster; run;
proc print data = clusters_avg_factor1; run;

PROC FREQ DATA=clusters_avg_factor1;
   TABLES CLUSTER; 
   TITLE "Número de observaciones por Clúster";
RUN;




PROC STEPDISC DATA=clusters_avg_factor1 METHOD=STEPWISE SLE=0.05 SLS=0.10;
	VAR g1 g2 g3;
	CLASS cluster;
RUN;

proc sgplot data= clusters_avg_factor1; 
scatter x=factor1 y=g3 / group=cluster; 
run; 




/*-----------------------NO JERARQUICO-------------------------------------------------------------------------------------------
*/



proc standard data=clusters_avg_factor1 MEAN=0 STD=1 OUT=SALIDA_stan;
VAR g1 g2 g3 factor1;
RUN;

proc sort data = salida_stan; by cluster; run;

proc means data=SALIDA_stan NOPRINT;
BY cluster;
Var g1 g2 g3 factor1;
OUTPUT OUT=CENTINIC MEAN= factor1;/* ESCRIBIR NOMBRE DE  LAS VARIABLES*/ 
RUN;
PROC PRINT DATA=CENTINIC;
RUN;



/*-----------------------NO JERARQUICO--sin drift-------------------------------------------------------------------------------------------
*/


PROC FASTCLUS DATA=clusters_avg_factor1 SEED=CENTINIC RADIUS=0 REPLACE=FULL DISTANCE 
MAXCLUSTERS=4 OUT=CLUSTER_definitivo MAXITER=20;
VAR factor1;
run;


PROC FASTCLUS DATA=clusters_avg_factor1 random = 12345678 RADIUS=0 REPLACE=random DISTANCE 
MAXCLUSTERS=4 OUT=CLUSTER_definitivo_random MAXITER=30;
VAR factor1;
run;



/*-----------------------NO JERARQUICO--con drift-------------------------------------------------------------------------------------------
*/


PROC FASTCLUS DATA=clusters_avg_factor1 SEED=CENTINIC RADIUS=0 REPLACE=FULL DISTANCE DRIFT
MAXCLUSTERS=4 OUT=CLUSTER_definitivo_drift MAXITER=20;
VAR factor1;
run;


PROC FASTCLUS DATA=clusters_avg_factor1 random = 12345678 RADIUS=0 REPLACE=random DISTANCE DRIFT
MAXCLUSTERS=4 OUT=CLUSTER_definitivo_random_drift MAXITER=30;
VAR factor1;
run;



/*-----------------------gráficos-------------------------------------------------------------------------------------------
*/


proc sgplot data=CLUSTER_definitivo;
   scatter y=factor1 x=id / group=cluster;
   xaxis label="ID";
   yaxis label="Factor 1";
   title "Representación de los clústeres (FASTCLUS sin DRIFT y con semilla)";
   keylegend / title="Cluster";
run;

proc sgplot data=CLUSTER_definitivo_random;
   scatter y=factor1 x=id / group=cluster;
   xaxis label="ID";
   yaxis label="Factor 1";
   title "Representación de los clústeres (FASTCLUS sin DRIFT e inicialización aleatoria)";
   keylegend / title="Cluster";
run;



proc sgplot data=CLUSTER_definitivo_drift;
   scatter y=factor1 x=id / group=cluster;
   xaxis label="ID";
   yaxis label="Factor 1";
   title "Representación de los clústeres (FASTCLUS con DRIFT y semilla)";
   keylegend / title="Cluster";
run;


proc sgplot data=CLUSTER_definitivo_random_drift;
   scatter y=factor1 x=id / group=cluster;
   xaxis label="ID";
   yaxis label="Factor 1";
   title "Representación de los clústeres (FASTCLUS con DRIFT e inicialización aleatoria)";
   keylegend / title="Cluster";
run;


/*-----------------------caracterización-------------------------------------------------------------------------------------------
*/



proc means data=CLUSTER_definitivo_drift mean std nway;
   class cluster;
   var factor1;
   output out=stats_cluster mean=mean_f1 std=std_f1;
run;

proc sgplot data=stats_cluster;
   bubble x=cluster y=mean_f1 size=std_f1;
   xaxis label="Cluster";
   yaxis label="Media del Factor 1";
   title "Caracterización de los clústeres (FASTCLUS con DRIFT y semilla)";
run;




/*-----------------------DISCRIMINANTE-------------------------------------------------------------------------------------------
*/


proc stepdisc data=CLUSTER_definitivo_drift method=stepwise sle=0.1;
   var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
   class cluster;
run;

title;
proc sgplot data= CLUSTER_definitivo_drift; 
scatter x=factor1 y=g2 / group=cluster; 
run; 


%NORMAL_MULT(DATA=CLUSTER_definitivo_drift, VAR=g1 g2 g3); 





PROC DISCRIM DATA=cluster_definitivo 
	OUT=sol
	CROSSVALIDATE
	OUTSTAT=practic2.ESTADISTICOS 
	POOL=TEST 
	TESTDATA=practic2.restante;
 
	PRIORS PROPORTIONAL;

	CLASS CLUSTER;

	VAR g1 g2 g3;
RUN; 






