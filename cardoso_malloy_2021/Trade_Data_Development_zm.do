
use "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/FullDataJan2022.dta", clear

order Origin Destination NAICS2 Direction Month
sort Origin Destination NAICS2 Direction Month

bysort Origin Destination NAICS2 Direction: gen lag24_total_NAICS2_Value = total_NAICS2_Value[_n-24] 
order lag24_total_NAICS2_Value, a(lag12_total_NAICS2_Value)

gen     growth_total_NAICS2_Value_2019 = ( (total_NAICS2_Value - lag12_total_NAICS2_Value )  / lag12_total_NAICS2_Value ) *100 if Month <25 /*Percentage change in year on year trade flows*/
replace growth_total_NAICS2_Value_2019 = ( (total_NAICS2_Value - lag24_total_NAICS2_Value )  / lag12_total_NAICS2_Value ) *100 if Month >24

label variable growth_total_NAICS2_Value_2019 "Change in NAICS 2 trade relative to 2019"


merge m:1 Direction Month using "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/PPI_Industry_CAN.dta"
drop _merge
merge m:1 Direction Month using "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/PPI_Industry_USA.dta", update
drop _merge
order PPI, a(Value)
sort Origin Destination NAICS2 Direction Month

gen r_growth_total_NAICS2_Value_2019 = ( (total_NAICS2_Value*(100/PPI) - lag12_total_NAICS2_Value*(100/PPI[_n-12]) )  / lag12_total_NAICS2_Value*(PPI[_n-12]/100) ) *100 if Month <25 /*Percentage change in year on year trade flows*/
replace r_growth_total_NAICS2_Value_2019 = ( (total_NAICS2_Value*(100/PPI) - lag24_total_NAICS2_Value*(100/PPI[_n-24]) )  / lag24_total_NAICS2_Value*(100/PPI[_n-24]) ) *100 if Month >24

gen r_growth_total_NAICS2_Value = ( (total_NAICS2_Value*(100/PPI) - lag12_total_NAICS2_Value*(100/PPI[_n-12]) )  / lag12_total_NAICS2_Value*(PPI[_n-12]/100) ) *100  /*Percentage change in year on year trade flows*/


bysort Origin Month Direction: egen total_Prov_Value = sum(Value)
sort Origin Destination NAICS2 Direction Month 
bysort Origin Destination NAICS2 Direction: gen lag12_total_Prov_Value = total_Prov_Value[_n-12] 
bysort Origin Destination NAICS2 Direction: gen lag24_total_Prov_Value = total_Prov_Value[_n-24] 

gen r_growth_total_Prov_Value = ( (total_Prov_Value*(100/PPI) - lag12_total_Prov_Value*(100/PPI[_n-12]))  / lag12_total_Prov_Value*(100/PPI[_n-12]) ) *100 /*% change in year on year trade flows*/

gen r_growth_total_Prov_Value_2019 = ( (total_Prov_Value*(100/PPI) - lag12_total_Prov_Value*(100/PPI[_n-12]) )  / lag12_total_Prov_Value*(PPI[_n-12]/100) ) *100 if Month <25 /*Percentage change in year on year trade flows*/
replace r_growth_total_Prov_Value_2019 = ( (total_Prov_Value*(100/PPI) - lag24_total_Prov_Value*(100/PPI[_n-24]) )  / lag24_total_Prov_Value*(100/PPI[_n-24]) ) *100 if Month >24


replace r_growth_total_NAICS2_Value = ( (total_NAICS2_Value*(100/PPI) - lag12_total_NAICS2_Value*(100/PPI[_n-12]) )  / lag12_total_NAICS2_Value*(PPI[_n-12]/100) ) *100  /*Percentage change in year on year trade flows*/

gen r_growth_value = ( (total_Value*(100/PPI) - lag12_total_Value*(100/PPI[_n-12]))  / lag12_total_Value*(100/PPI[_n-12]) ) *100 /*% change in year on year trade flows*/

bysort Origin Destination NAICS2 Direction: gen lag24_total_Value = total_Value[_n-24]
gen     r_growth_total_Value_2019 = ( (total_Value*(100/PPI) - lag12_total_Value*(100/PPI[_n-12]) )  / lag12_total_Value*(PPI[_n-12]/100) ) *100 if Month <25 /*Percentage change in year on year trade flows*/
replace r_growth_total_Value_2019 = ( (total_Value*(100/PPI) - lag24_total_Value*(100/PPI[_n-24]) )  / lag24_total_Value*(100/PPI[_n-24]) ) *100 if Month >24


												/*******************TOTAL TRADE GRAPHS**********************/

/*FIGURE 1: Shows the year-on-year change in total export/import by month*/
/*I specify Alerbta/Alabama but the values are identical across Canadian provinces and US States, only varies by month and direction of trade flows*/
line    growth_total_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Export",lpattern (solid) ///
|| line growth_total_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Import",lpattern (dash) ///
legend(label(1 "Exports") label(2 "Imports"))  title("Year-over-year percentage change in Canadian trade to the U.S") subtitle("by direction, 2019-2021") ytitle("% change in exports and imports")  xtitle("Month")  xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" ) ylabel(,labsize(medsmall)) xlabel(,labsize(medsmall)) xsize(14) ysize(8) note("{bf: Trade Data Sources:} Statistics Canada and U.S. Census Bureau, Government of Canada’s Trade Data Online database.", size(small))
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_total.pdf"

line    r_growth_value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Export",lpattern (solid) ///
|| line r_growth_value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Import",lpattern (dash) ///
legend(label(1 "Exports") label(2 "Imports"))  title("Year-over-year percentage change in Canadian trade to the U.S, PPI") subtitle("by direction, 2019-2021") ytitle("% change in exports and imports")  xtitle("Month")  xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" ) ylabel(,labsize(medsmall)) xlabel(,labsize(medsmall)) xsize(14) ysize(8) note("{bf: Trade Data Sources:} Statistics Canada and U.S. Census Bureau, Government of Canada’s Trade Data Online database.", size(small))
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_total_ppi.pdf"

line    r_growth_total_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Export",lpattern (solid) ///
|| line r_growth_total_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Import",lpattern (dash) ///
legend(label(1 "Exports") label(2 "Imports"))  title("Year-over-year percentage change in Canadian trade to the U.S, PPI") subtitle("by direction, 2019-2021") ytitle("% change in exports and imports")  xtitle("Month")  xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" ) ylabel(,labsize(medsmall)) xlabel(,labsize(medsmall)) xsize(14) ysize(8) note("{bf: Trade Data Sources:} Statistics Canada and U.S. Census Bureau, Government of Canada’s Trade Data Online database.", size(small))
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_total_ppi_2019.pdf"

												/*******************INDUSTRY GRAPHS**********************/
												
/*Shows the year-on-year change in total export/import by month for our 5 NAICS2 categories*/
/*I specify Alerbta/Alabama but the values are identical across Canadian provinces and US States, only varies by month, direction of trade flows, and Naics code*/
line    growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==11 & Direction=="Export" ///
|| line growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==21 & Direction=="Export" ///
|| line growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Export" ///
|| line growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==32 & Direction=="Export" ///
|| line growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==33 & Direction=="Export", ///
legend(label(1 "11:Agriculture") label(2 "21:Mining/Oil/Gas") label(3 "31:Food, Beverage, Textile Manu") label(4 "32:Paper, Chemical, Plastics Manu") label(5 "33:Durables Manu")col(2)) yline(0) title("Percentage change in Canadian exports to U.S., YoY") subtitle("by industry, 2019-2020") ytitle("year-over-year % change", margin(large))  xtitle("Month") xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" )
*legend(label(1 "Agriculture") label(2 "Mining/Oil/Gas") label(3 "Utilities") label(4 "Manufacturing") col(2)) yline(0)  title("Percentage change in Canadian exports to U.S.") subtitle("by industry, 2019-2020") ytitle("year-over-year % change") xtitle("Month")  xlabel(14 "Feb 2020" 16 "Apr 2020" 18 "Jun 2020" 20 "Aug 2020")
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_naics2_yoy.pdf"



/*Shows the change in total export/import by month for our 5 NAICS2 categories relative to 2019!*/
/*I specify Alerbta/Alabama but the values are identical across Canadian provinces and US States, only varies by month, direction of trade flows, and Naics code*/
line    growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==11 & Direction=="Export" ///
|| line growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==21 & Direction=="Export" ///
|| line growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Export" ///
|| line growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==32 & Direction=="Export" ///
|| line growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==33 & Direction=="Export", ///
legend(label(1 "11:Agriculture") label(2 "21:Mining/Oil/Gas") label(3 "31:Food, Beverage, Textile Manu") label(4 "32:Paper, Chemical, Plastics Manu") label(5 "33:Durables Manu")col(2)) yline(0) title("Percentage change in Canadian exports to U.S., 2019 base year") subtitle("by industry, 2019-2021") ytitle("% change", margin(large))  xtitle("Month") xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" )
*legend(label(1 "Agriculture") label(2 "Mining/Oil/Gas") label(3 "Utilities") label(4 "Manufacturing") col(2)) yline(0)  title("Percentage change in Canadian exports to U.S.") subtitle("by industry, 2019-2020") ytitle("year-over-year % change") xtitle("Month")  xlabel(14 "Feb 2020" 16 "Apr 2020" 18 "Jun 2020" 20 "Aug 2020")
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_naics2_2019.pdf"

/*Shows the YoY change in total export/import by month for our 5 NAICS2 categories adjusting for price increases!*/
/*I specify Alerbta/Alabama but the values are identical across Canadian provinces and US States, only varies by month, direction of trade flows, and Naics code*/
line    r_growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==11 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==21 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==32 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==33 & Direction=="Export", ///
legend(label(1 "11:Agriculture") label(2 "21:Mining/Oil/Gas") label(3 "31:Food, Beverage, Textile Manu") label(4 "32:Paper, Chemical, Plastics Manu") label(5 "33:Durables Manu")col(2)) yline(0) title("Percentage change in Canadian exports to U.S., PPI adjusted") subtitle("by industry, 2019-2021") ytitle("% change", margin(large))  xtitle("Month") xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" )
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_naics2_ppi.pdf"


/*Shows the change in total export/import by month for our 5 NAICS2 categories relative to 2019 adjusting for price increases!*/
/*I specify Alerbta/Alabama but the values are identical across Canadian provinces and US States, only varies by month, direction of trade flows, and Naics code*/
line    r_growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==11 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==21 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==31 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==32 & Direction=="Export" ///
|| line r_growth_total_NAICS2_Value_2019 Month if Month>12 & Month<35 & Origin =="Alberta" & Destination=="Alabama" & NAICS2==33 & Direction=="Export", ///
legend(label(1 "11:Agriculture") label(2 "21:Mining/Oil/Gas") label(3 "31:Food, Beverage, Textile Manu") label(4 "32:Paper, Chemical, Plastics Manu") label(5 "33:Durables Manu")col(2)) yline(0) title("Percentage change in Canadian exports to U.S., PPI adjusted 2019 base year") subtitle("by industry, 2019-2021") ytitle("% change", margin(large))  xtitle("Month") xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" )
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_naics2_ppi_2019.pdf"



												/*******************PROVINCIAL GRAPHS**********************/
/*Shows the year-on-year change in total export/import by month for all Canadian Provinces categories, PPI adjusted*/
/*I specify Alabama and a NAICS2 code but the values are identical across US States and NAICS2, only varies by month, direction of trade flows, and Origin province*/
   line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="British" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="New Bru" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Newfoun" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Nova Sc" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Prince" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Export" ///
|| line r_growth_total_Prov_Value Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Saskatc" & Direction=="Export", ///
legend(label(1 "AB") label(2 "BC") label(3 "MB") label(4 "NB") label(5 "NL") label(6 "NS") label(7 "ON") label(8 "PE") label(9 "QC") label(10 "SK") col(5)) yline(0) title("Percentage change in Canadian exports to U.S., PPI") subtitle("by province, 2019-2021") ytitle("% change", margin(large))  xtitle("Month") xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" )
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_prov_ppi.pdf"

										/*******************PROVINCIAL GRAPHS**********************/
/*Shows the year-on-year change in total export/import by month for all Canadian Provinces categories, PPI adjusted*/
/*I specify Alabama and a NAICS2 code but the values are identical across US States and NAICS2, only varies by month, direction of trade flows, and Origin province*/
   line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="British" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="New Bru" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Newfoun" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Nova Sc" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Prince" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Export" ///
|| line r_growth_total_Prov_Value_2019 Month if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Saskatc" & Direction=="Export", ///
legend(label(1 "AB") label(2 "BC") label(3 "MB") label(4 "NB") label(5 "NL") label(6 "NS") label(7 "ON") label(8 "PE") label(9 "QC") label(10 "SK") col(5)) yline(0) title("Percentage change in Can exports to U.S., 2019 and PPI") subtitle("by province, 2019-2021") ytitle("% change", margin(large))  xtitle("Month") xlabel(13 "Jan 2020" 19 "July 2020" 25 "Jan 2021" 31 "July 2021" )
graph display
graph export "/Users/zack/Documents/NEW MAC/Office/Brock/MBE/RA/Cardoso_Malloy_2021/Cardoso_Malloy_data/export_prov_ppi_2019.pdf"




												/*******************PROVINCE/TRADE GRAPHS**********************/

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Import", lcolor(maroon)), ///
name(alberta_trade) subtitle("Alberta", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Alberta" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="British" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="British" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="British" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="British" & Direction=="Import", lcolor(maroon)), ///
name(bc_trade) subtitle("British", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="British Columbia" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="British Columbia" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Import", lcolor(maroon)), ///
name(manitoba_trade) subtitle("Manitoba", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Manitoba" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="New Bru" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="New Bru" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="New Bru" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="New Bru" & Direction=="Import", lcolor(maroon)), ///
name(nb_trade) subtitle("New Bru", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="New Brunswick" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="New Brunswick" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Newfoun" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Newfoun" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Newfoun" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Newfoun" & Direction=="Import", lcolor(maroon)), ///
name(nfld_trade) subtitle("Newfoun", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Newfoundland and Labrador" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Newfoundland and Labrador" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Nova Sc" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Nova Sc" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Nova Sc" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Nova Sc" & Direction=="Import", lcolor(maroon)), ///
name(ns_trade) subtitle("Nova Sc", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Nova Scotia" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Nova Scotia" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Import", lcolor(maroon)), ///
name(ontario_trade) subtitle("Ontario", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Ontario" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Prince" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Prince" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Prince" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Prince" & Direction=="Import", lcolor(maroon)), ///
name(pei_trade) subtitle("Prince", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Prince Edward Island" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Prince Edward Island" & Direction=="Import"


twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Import", lcolor(maroon)), ///
name(quebec_trade) subtitle("Quebec", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Quebec" & Direction=="Import"

twoway (scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Saskatc" & Direction=="Export", msymbol(oh)) ///
(scatter r_growth_total_Prov_Value OriginMonthlyCasesPerM if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Saskatc" & Direction=="Import", msymbol(o)) ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Saskatc" & Direction=="Export", lcolor(navy))  ///
(lfit r_growth_total_Prov_Value OriginMonthlyCasesPerM  if Month>12 & Month<35 & NAICS2==31 & Destination=="Alabama" & Origin=="Saskatc" & Direction=="Import", lcolor(maroon)), ///
name(saskatchewan_trade) subtitle("Saskatc", size(small)) legend(off) ytitle("") xtitle("") ylabel(,labsize(vsmall)) xlabel(,labsize(vsmall)) note("Exports: Slope coefficient = -0.0452, standard error = 0.0251" "Imports: Slope coefficient = -0.0200, standard error = 0.0093", size(vsmall))

*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Saskatchewan" & Direction=="Export"
*regress growth_total_Prov_ValueUS OriginMonthlyCasesPerM  if Month>12 & NAICS2==21 & Destination=="Alabama" & Origin=="Saskatchewan" & Direction=="Import"

*legend options for smaller sizesymxsize(*.15) keygap(*.25) colgap(*.25) bmargin(bexpand) 

graph combine alberta_trade bc_trade manitoba_trade nb_trade nfld_trade ns_trade ontario_trade pei_trade quebec_trade saskatchewan_trade, cols(3) imargin(0 0 0 0) title("Year-over-year percentage changes in Canadian trade with the U.S. and COVID-19",size(medsmall)) subtitle("by province and direction, 2019-2020", size(vsmall)) l1(% change in exports and imports, size(small)) b1("Monthly COVID cases per million", size(small)) ycommon note("{bf: Trade Data Sources:} Statistics Canada and U.S. Census Bureau, Government of Canada’s Trade Data Online database." "{bf: COVID-19 Cases Data Sources:} ESRI Canada's COVID-19 statistics for Canada and the COVID Tracking Project for the U.S.",  size(tiny))


												/*******************REGRESSION ANALYSIS**********************/
											
xi, pre(F1) i.Origin /*Prov Dummies*/
xi, pre(F2) i.Destination /*State Dummies*/


/*Interpretation of coefficient in front of these terms: 1% increase in the average monthly case/death/test in a prov/state ->% change in trade*/
/*Current period Covid indicators*/
gen ln_DestMonthlyCasesPerM = log(1 + DestMonthlyCasesPerM)
gen ln_DestMonthlyDeathsPerM = log(1 + DestMonthlyDeathsPerM)
gen ln_DestMonthlyHospPerM = log(1 + DestMonthlyHospPerM)
gen ln_DestMonthlyCumVaxPerM = log(1+ DestMonthlyCumVaxPerM)

gen ln_OriginMonthlyCasesPerM = log(1 + OriginMonthlyCasesPerM)
gen ln_OriginMonthlyDeathsPerM = log(1 + OriginMonthlyDeathsPerM)
gen ln_OriginMonthlyHospPerM = log(1 + OriginMonthlyHospPerM)
gen ln_OriginMonthlyCumVaxPerM = log(1+ OriginMonthlyCumVaxPerM)
		
*ln_dist_pop

reg growth_logdiff_Value  ln_DestMonthlyCasesPerM ln_OriginMonthlyCasesPerM ln_OriginMonthlyDeathsPerM ln_OriginMonthlyHospPerM OriginLockdown DestLockdown F1* F2* if Direction=="Export" & Month>12												
