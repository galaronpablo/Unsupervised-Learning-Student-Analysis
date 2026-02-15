LIBNAME practic1 "C:\Users\Pablo Galaron\OneDrive - Universidad Complutense de Madrid (UCM)\Escritorio\No Supervisado\Prácticas\Práctica_1";

/* Importar archivo de Matemáticas */
PROC IMPORT DATAFILE="C:\Users\Pablo Galaron\OneDrive - Universidad Complutense de Madrid (UCM)\Escritorio\No Supervisado\Prácticas\Práctica_1\student-mat.csv"
            OUT=practic1.MatData
            DBMS=CSV
            REPLACE;
     DELIMITER = ";"; 
     GETNAMES=YES;
RUN;

/* Importar archivo de Portugués */
PROC IMPORT DATAFILE="C:\Users\Pablo Galaron\OneDrive - Universidad Complutense de Madrid (UCM)\Escritorio\No Supervisado\Prácticas\Práctica_1\student-por.csv"
            OUT=practic1.PorData
            DBMS=CSV
            REPLACE;
     DELIMITER = ";"; 
     GETNAMES=YES;
RUN;

DATA practic1.datos;
    SET practic1.MatData 
        practic1.PorData;

	ID = _N_;

    G1_Num = INPUT(G1, ?? 8.); 
    G2_Num = INPUT(G2, ?? 8.);

    KEEP ID traveltime studytime failures famrel freetime goout dalc walc health absences G1_num G2_num G3 Medu; 

RUN;

DATA practic1.datos;
    SET practic1.datos;
    RENAME G1_Num=G1 G2_Num=G2;
RUN;

/*-----------------------------------------------------------------------------------------------------------------------------------*/

/*Miramos si hay datos ausentes*/
proc means data = practic1.datos nmiss;
run;


/*Miramos si tenemos datos atípicos*/
%outliers_mult(data=practic1.datos, var=traveltime studytime failures famrel freetime goout 
                                    dalc walc health absences Medu G1 G2 G3);

/*Cuantificamos los atípicos*/
data solo_atipicos;
set outliers;
where CONCLUSION = 'caso atípico';
run;
proc print data = solo_atipicos; run;



data practic1.datos_limpios;
    set practic1.datos;
    if ID in (566,504,675,297,174,248,809,568,265,335,109,342,457,887,316,137,135,260,161,141,136,1006,559,396,131,184,277) then delete;
run;


/*------------------------------------------------------------------------------------------------------------------
*/

proc means data = practic1.datos_limpios
STD MIN MAX MEAN MEDIAN;
VAR traveltime studytime failures famrel freetime goout 
                                    dalc walc health absences Medu G1 G2 G3;
RUN;

proc sgplot data=data_siete;
  scatter x=prin1 y=prin2;
run;


/*------------------------------------------------------------------------------------------------------------------
*/

PROC CORR DATA=practic1.datos_limpios
PEARSON NOSIMPLE COV PLOTS=MATRIX(HISTOGRAM);
VAR traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
RUN;


/*------------------------------------------------------------------------------------------------------------------
*/

proc princomp data = practic1.datos_limpios;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
run;


/*------------------------------------------------------------------------------------------------------------------
*/

proc princomp
data = practic1.datos_limpios n = 7  plots = all plots = pattern outstat = stats out = data_siete;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
ods output Eigenvalues = autovalores;
ods output Eigenvectors = autovectores;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

title 'Correlaciones entre las variables y las distintas componentes seleccionadas';
data correlaciones (drop = label);
   set autovectores;
   /* Cálculo de las correlaciones: eigenvector * raíz cuadrada del autovalor */
   comp1 = Prin1 * sqrt(3.39161960);
   comp2 = Prin2 * sqrt(1.89938250);
   comp3 = Prin3 * sqrt(1.27889183);
   comp4 = Prin4 * sqrt(1.18919301);
   comp5 = Prin5 * sqrt(1.02452825);
   comp6 = Prin6 * sqrt(0.92153143);
   comp7 = Prin7 * sqrt(0.85926428);
run;


proc print data=correlaciones;
var variable comp1--comp7;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

proc factor data = practic1.datos_limpios corr
outstat = afact_est out = afact_res
residuals nfact = 7 msa scree plot = all;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

proc factor data = practic1.datos_limpios corr outstat = afact_est out = afact_res
priors = smc
residuals nfact = 7 msa scree plot = all;
var traveltime studytime failures /*famrel*/ freetime goout dalc walc health absences G1 G2 G3 Medu;
run;

proc factor data = practic1.datos_limpios corr outstat = afact_est out = afact_res
residuals nfact = 7 msa scree plot = all;
var traveltime studytime failures famrel /*freetime*/ goout dalc walc health absences G1
G2 G3 Medu;
run;

proc factor data = practic1.datos_limpios corr outstat = afact_est out = afact_res
residuals nfact = 7 msa scree plot = all;
var traveltime studytime failures /*famrel freetime*/ goout dalc walc health absences G1 G2 G3 Medu;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

proc factor data=practic1.datos_limpios corr
method=principal
priors=one
heywood
nfact=7
outstat=Af_fact_prin_stats out=Af_fact_prin
residuals msa scree plot=all;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

proc factor data=practic1.datos_limpios corr
method=prinit
priors=smc
heywood
nfact=7
outstat=Af_fact_prin_stats out=Af_fact_prin
residuals msa scree plot=all;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
run;

proc factor data=practic1.datos_limpios corr
method=prinit
priors=one
heywood
nfact=7
outstat=Af_fact_prin_stats out=Af_fact_prin
residuals msa scree plot=all;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2
G3 Medu;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

%NORMAL_MULT(DATA=practic1.datos_limpios, VAR=traveltime studytime failures famrel freetime goout 
dalc walc health absences G1 G2 G3 Medu);

/*------------------------------------DEFINITIVO------------------------------------------------------------------------------
*/

proc factor data=practic1.datos_limpios corr
method=principal
priors=one
heywood
nfact=7
outstat=Af_fact_prin_stats out=Af_fact_prin
residuals msa scree plot=all;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
run;


/*------------------------------------------------------------------------------------------------------------------
*/

proc factor data=practic1.datos_limpios corr
priors=one 
heywood
nfact=7
rotate=VARIMAX
outstat=Afact_est_VARIMAX out=Afact_VARIMAX
residuals msa scree plot=all;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
run;


/*------------------------------------------------------------------------------------------------------------------
*/

proc factor data=practic1.datos_limpios corr
priors=one 
heywood
nfact=7
rotate=QUARTIMAX 
outstat=Afact_est_QUARTIMAX out=Afact_QUARTIMAX
residuals msa scree plot=all;
var traveltime studytime failures famrel freetime goout dalc walc health absences G1 G2 G3 Medu;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

DATA practic1.datos_corresp_simples;
SET practic1.datos_limpios;

/* Categorización de Walc (consumo de alcohol en fines de semana) */
IF Walc <= 1 THEN Walc_rec = 'Consumo_muy_bajo';
ELSE IF 1 < Walc <= 2 THEN Walc_rec = 'Consumo_bajo';
ELSE IF 2 < Walc <= 3 THEN Walc_rec = 'Consumo_medio';
ELSE IF 3 < Walc <= 4 THEN Walc_rec = 'Consumo_alto';
ELSE IF Walc > 4 THEN Walc_rec = 'Consumo_muy_alto';

/* Categorización de Health (estado de salud) */
IF health <= 1 THEN health_rec = 'Salud_muy_mala';
ELSE IF 1 < health <= 2 THEN health_rec = 'Salud_mala';
ELSE IF 2 < health <= 3 THEN health_rec = 'Salud_media';
ELSE IF 3 < health <= 4 THEN health_rec = 'Salud_buena';
ELSE IF health > 4 THEN health_rec = 'Salud_muy_buena';

RUN;

/*------------------------------------------------------------------------------------------------------------------
*/

proc corresp data = practic1.datos_corresp_simples chi2p all outc = salida PLOTS = all;
TABLES Walc_rec, health_rec;
ods output rowprofiles = perfilfila;
ods output cellchisq = aportaciones;
ods output colprofiles = perfilcolumna;
run;

/*------------------------------------------------------------------------------------------------------------------
*/

/* PERFIL DE FILAS*/
proc sgplot data=perfilfila;
  series x=label y=Salud_muy_mala   / lineattrs=(thickness=3);
  series x=label y=Salud_mala       / lineattrs=(thickness=3);
  series x=label y=Salud_media      / lineattrs=(thickness=3);
  series x=label y=Salud_buena      / lineattrs=(thickness=3);
  series x=label y=Salud_muy_buen  / lineattrs=(thickness=3);
  title "PERFIL FILA";
run;

/* PERFIL DE COLUMNAS*/
proc sgplot data=perfilcolumna;
  series x=label y=Salud_muy_mala   / lineattrs=(thickness=3);
  series x=label y=Salud_mala       / lineattrs=(thickness=3);
  series x=label y=Salud_media      / lineattrs=(thickness=3);
  series x=label y=Salud_buena      / lineattrs=(thickness=3);
  series x=label y=Salud_muy_buen  / lineattrs=(thickness=3);
  title "PERFIL COLUMNA";
run;


proc contents data=perfilfila; run;
proc contents data=perfilcolumna; run;

/*------------------------------------------------------------------------------------------------------------------
*/
