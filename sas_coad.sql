/*CREATING LIBRARY */
LIBNAME CC "/home/u62467441/credit card project";

/*IMPORT DATA*/
PROC IMPORT DATAFILE="/home/u62467441/credit card project/credit_card_dataset.csv" 
    OUT=CC.credit_card_data
    DBMS=CSV 
    REPLACE;
    GETNAMES=YES;
RUN;

/*Reading the Data*/
proc print data=CC.credit_card_data (OBS=10);
run;
proc contents data=CC.credit_card_data;
run;

/*Understanding the Data*/
proc sql ;
describe table dictionary.columns;
select name, type, length
from dictionary.columns
where libname="CC";
quit;

proc sql number outobs=20;
select distinct Rate,Home,Intent
From CC.credit_card_data;
quit;

/*Preprocessing the Data*/
PROC SORT DATA=CC.credit_card_data OUT=sorted_data;
    BY DESCENDING Income;
RUN;

 DATA credit_data_clean;
    SET CC.credit_card_data;
    IF MISSING(Rate) THEN Rate = 0;
RUN;

/*Data Filtering & Conditional Queries*/
/*display only the customers who have an Income greater than $2,00,000*/
PROC SQL;
    SELECT * 
    FROM CC.credit_card_data
    WHERE Income > 300000;
QUIT;

/*count the number of Fully Paid vs. Charged Off loans*/
PROC SQL;
    SELECT Status, COUNT(*) AS Loan_Count
    FROM CC.credit_card_data
    GROUP BY Status;
QUIT;

/*CREDIT INDENT DATA ANALYSIS*/

/* 1.avg of income and rate */
TITLE "avg of income and rate";
PROC SQL;
    SELECT AVG(Income) AS Avg_Income, 
           AVG(Rate) AS Avg_Rate
    FROM cc.credit_card_data;
QUIT;
title;

/* 2.max of amount */
TITLE "max of amount";
PROC MEANS DATA=cc.credit_card_data MAX;
    VAR Amount;
RUN;
TITLE;

/* 3.max of amount by home*/
TITLE "max of amount by home";
PROC SQL;
    SELECT Home, MAX(Amount) AS Max_Amount
    FROM cc.credit_card_data
    GROUP BY Home;
QUIT;
TITLE;

/* 4.sum of amount by intent*/
TITLE "sum of amount by intent";
PROC SQL;
    SELECT Intent, SUM(Amount) AS Total_Amount
    FROM cc.credit_card_data
    GROUP BY Intent;
QUIT;
TITLE;

/* 5.min of rate by home*/
TITLE "min of rate by home";
PROC MEANS DATA=cc.credit_card_data MIN;
    CLASS Home;
    VAR Rate;
RUN;
TITLE;

/* 6.avg of income by age*/
TITLE "avg of income by age";
PROC MEANS DATA=cc.credit_card_data MEAN;
    CLASS Age;
    VAR Income;
RUN;
TITLE;

/* 7.count of id by card_length*/
TITLE "count of id by card_length";
PROC SQL;
    SELECT Cred_Length, COUNT(ID) AS ID_Count
    FROM cc.credit_card_data
    GROUP BY Cred_Length;
QUIT;
TITLE;

/* 8.avg of income by years*/
TITLE "avg of income by years";
PROC SQL OUTOBS=20;
    SELECT DATE, AVG(Income) AS Avg_Income 
    FROM cc.credit_card_data
    GROUP BY DATE;
QUIT;
TITLE;

/* 9.univariate of income */
TITLE "univariate of income";
PROC UNIVARIATE DATA=cc.credit_card_data;
    VAR Income;
RUN;
TITLE;





