*Incidence of tuberclosis, Health Expendenture and Infrastructure among SAARC Countries" Panel Data Analysis*

import excel "C:\Users\khana\Desktop\Globalization\Mics Datasets\data set 2005 to 15.xlsx",  sheet("Data") firstrow
global path "C:\Users\khana\Desktop\Mics Datasets"
drop in 99/103
destring YR*, force replace                            
encode CountryName, gen (country)
encode SeriesName, gen (series)
drop CountryName CountryCode SeriesName SeriesCode
numlabel, add
tab series
reshape long YR, i(country series) j(year)
reshape wide YR, i(country year) j(series)

/*
1. Death rate, crude (per 1,000 people)
2. Domestic general government health e 
3. Domestic private health expenditure  
  4. GDP per capita (constant 2015 US$) 
    5. Hospital beds (per 1,000 people) 
6. Incidence of tuberculosis (per 100,0 
7. Labor force participation rate, fema 
8. Life expectancy at birth, total (yea 
9. Literacy rate, adult total (% of peo 
10. Mortality rate, infant (per 1,000 l 
11. Out-of-pocket expenditure (% of cur 
12. People using safely managed drinkin 
13. People using safely managed sanitat 
      14. Physicians (per 1,000 people)
*/



rename YR1 CDR 
rename YR2 gener_health_exp
rename YR3 privat_health_exp
rename YR4 gdp_capita
rename YR5 hosp_beds
rename YR6 Inci_tb
rename YR7 fem_lab_force
rename YR8 LEB 
rename YR9 liter_adult
rename YR10 IMR
rename YR11 OPP
rename YR12 saf_drinking_water 
rename YR13 Bas_sanit
rename YR14 phy




/* it can also be used as macro and faster outcome
local hill gener_health_exp privat_health_exp PM Cvd_Mor gdp_capita hosp_beds fem_lab_force liter_adult OPP saf_drinking_water Bas_sanit phy
foreach d of local hill {
	gen l_`d'=ln(`d')
	}
*/

gen l_CDR = ln( CDR) 
gen l_privat_health_exp = ln( privat_health_exp )  
gen l_gdp_capita = ln( gdp_capita ) 
gen l_hosp_beds = ln( hosp_beds )
gen l_gener_health_exp = ln( gener_health_exp )
gen l_Inci_tb = ln( Inci_tb ) 
gen l_fem_lab_force = ln( fem_lab_force) 
gen l_LEB = ln( LEB ) 
gen l_liter_adult = ln( liter_adult )
gen l_IMR = ln( IMR )
gen l_OPP = ln(OPP)
gen l_saf_drinking_water = ln( saf_drinking_water ) 
gen l_Bas_sanit = ln( Bas_sanit )
gen l_phy = ln( phy )

gen l_access_health = l_gdp_capita - l_OPP
gen l_female_empower = (l_fem_lab_force + l_liter_adult)/2
gen l_health_infra = (l_phy + l_hosp_beds)/2

graph bar l_female_empower, over(country, sort(1) descending)  title("Average Female Empowerment Index by Country")

xtset country year

*determining fixed and random effect 
xtreg l_IMR l_Bas_sanit l_gdp_capita l_saf_drinking_water  l_OPP l_phy l_fem_lab_force l_gener_health_exp l_hosp_beds l_privat_health_exp l_phy l_liter_adult, fe
estimates store fe

xtreg l_IMR l_Bas_sanit l_gdp_capita l_saf_drinking_water  l_OPP l_phy l_fem_lab_force l_gener_health_exp l_hosp_beds l_privat_health_exp l_phy l_liter_adult, re
estimates store re
hausman fe re

twoway (scatter l_IMR l_Inci_tb) (lfit l_IMR l_Inci_tb)

global xvars  l_gener_health_exp l_privat_health_exp l_gdp_capita l_hosp_beds l_fem_lab_force l_liter_adult l_OPP l_saf_drinking_water l_Bas_sanit l_phy

xtreg l_Inci_tb $xvars, fe
eststo model1

xtreg l_LEB $xvars, fe
eststo model2

xtreg l_CDR $xvars, fe
eststo model3

xtreg l_IMR $xvars, fe
eststo model4 

esttab model1 model2 model3 model4 using myresults.doc, replace se b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 ar2 f label title("Results from Panel with Country Fixed Effects")
asdoc  summarize l_IMR l_access_health l_health_infra l_female_empower l_LEB l_CDR l_Inci_tb 
asdoc xtreg l_IMR l_female_empower l_access_health l_health_infra l_CDR l_Inci_tb l_LEB, fe










 










