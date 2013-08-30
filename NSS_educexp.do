#delimit;
clear;
cap log close;
cap program drop _all;
set more 1;

**mbmsteinberg killed a slave!
*Just kidding, she only maimed him.

use "C:\Users\mbshah\Documents\NSS\62\62\1\NSS_Round62_Schedule1_Level6.dta" ; 
global dl = "C:\Users\mbshah\Documents\ASER\Bryce Paper\logs";
log using "$dl\expenditure.log",  replace;


***only keep education expenditure;
keep if itemcode==409;


gen district_code=state62*100+district62; 
****only keep rural ;


sort state62; 

by state62:egen educ_exp=mean(value6); 

egen exp_quart2=pctile(educ_exp), p(25);
egen exp_quart3=pctile(educ_exp), p(50);
egen exp_quart4=pctile(educ_exp), p(75);

gen quart_st=1 if educ_exp<  173253.5 ;
replace quart_st=2 if educ_exp>= 173253.5  &  educ_exp<258069.6  ;
replace quart_st=3 if educ_exp>=258069.6  & educ_exp<  297703.3   ;
replace quart_st=4 if educ_exp>=  297703.3  ;
** I am adding this



**Wait!  I am also adding this.

sort district_code; 
by district_code:egen educ_exp_dist=mean(value6); 

egen exp_quart5=pctile(educ_exp_dist), p(25);
egen exp_quart6=pctile(educ_exp_dist), p(50);
egen exp_quart7=pctile(educ_exp_dist), p(75);

gen quart_dis=1 if educ_exp< 138357.1;
replace quart_dis=2 if educ_exp>=138357.1 &  educ_exp<  228630  ;
replace quart_dis=3 if educ_exp>=  228630   & educ_exp<351218.8    ;
replace quart_dis=4 if educ_exp>= 351218.8   ;


keep district_code quart_st quart_dis educ_exp educ_exp_dist; 
sort district_code;
save "C:\Users\mbshah\Documents\ASER\Bryce paper\dta\Expenditure.dta", replace; 

use "C:\Users\mbshah\Documents\ASER\Bryce paper\dta\ASER_rainfall_all.dta", replace; 
drop _merge; 

merge district_code using "C:\Users\mbshah\Documents\ASER\Bryce paper\dta\Expenditure.dta"; 
tab _merge; 
drop if _merge~=3;
save "C:\Users\mbshah\Documents\ASER\Bryce paper\dta\ASER_withExpend.dta", replace; 
