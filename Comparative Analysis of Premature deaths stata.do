global path "C:\Users\khana\Desktop\performance"
save "C:\Users\khana\Desktop\performance\popstandard.dta", replace
br
sort age
distrate Death pop using popstandard.dta, standstrata(age) by(Country)
asdoc distrate Death pop using popstandard.dta, standstrata(age) by(Country)