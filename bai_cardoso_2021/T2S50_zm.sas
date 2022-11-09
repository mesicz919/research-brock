proc import datafile="C:\Users\zm14bg\Desktop\CEEDD_VariableList_2020vintage-miguel.xlsx"
	dbms=xlsx
	out=var replace;
	sheet=T2S50;
	run;
proc import datafile="C:\Users\zm14bg\Desktop\CEEDD_VariableList_2020vintage_zm.xlsx"
	dbms=xlsx
	out=var_1 replace;
	sheet=T2S50;
	run;
proc import datafile="C:\Users\zm14bg\Desktop\CEEDD_VariableList_Pengyi_831meeting.xlsx"
	dbms=xlsx
	out=var_2 replace;
	sheet=T2S50;
	run;
proc import datafile="C:\Users\zm14bg\Desktop\CEEDD_VariableList_2020vintage_XB.xlsx"
	dbms=xlsx
	out=var_3 replace;
	sheet=T2S50;
	run;
proc sort data=var;
by Number Variable Description;
run;
proc sort data=var_1;
by Number Variable Description;
run;
proc sort data=var_2;
by Number Variable Description;
run;
proc sort data=var_3;
by Number Variable Description;
run;
data varlist_T2S50;
merge var var_1 var_2 var_3;
by Number Variable Description;
run;
options missing = ' ';
data varlist_T2S50;
set var;
set var_1; 
set var_2; 
set var_3;
   if missing(cats(of _all_)) then delete;
run;
proc print data=varlist_T2S50;
run;
