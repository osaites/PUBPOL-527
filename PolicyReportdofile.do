clear
use "H:\onis\Downloads\PUBPOL527\ACS 2019 weighted subsample.dta"

**METHODS:
*Using data from the 2019 American Community Survey (ACS), we will examine the use of social safety
*net programs in relation to educational attainment for observations in the state of Washington. We will
*filter by age, limiting our responses to those who are over 25 so that we are not using cases of children
*and young adults who have yet to have the opportunity to receive a higher education. We will use
*Medicaid coverage and food stamps as indicators of reliance on the social safety net. We will further
*analyze how education affects these variables within different subgroups based on race and metropolitan
*status.

**filtering observations to WA, older than 25
tab statefip
tab statefip, nol

**statefip for WA is 53

**generate a variable for those who are in Washington and older than 25
    **I'm open to changing this to >= to include 25 year olds but it shouldn't matter too much
	*****I have it as greater than 21 right now to align with what's currently in the intro

*also generating a variable for adults in the US in general, this excludes WA but it shouldn't make much difference
gen usadults =.
replace usadults = 1 if statefip != 53 & age > 21   

gen wadults =. 
replace wadults = 1 if statefip == 53 & age > 21
replace wadults = 0 if usa == 1

**--------------Generating Higher Education Variable---------------**

tab educd
tab educd, nol
*101, 114, 115, and 116 are all 4-year degree or above
* can consider this as having received a higher education

gen highered =.
replace highered = 1 if educd > 100
replace highered = 0 if educd <100

tab highered
label define highered 0 "No" 1 "Yes"
label value highered highered
tab highered
tab highered if wa == 1
*about 35.25% of the adult population in WA have a higher education degree

*to include associates degrees
gen higherassociate =.
replace highera = 1 if educd > 80
replace highera = 0 if educd < 80

**-------------Metro Area-------------**

tab metro
tab metro, nol
replace metro =. if metro == 0

*create binary for ttests later
gen metrobinary = 1 if metro >= 2
replace metrobinary = 0 if metro == 1
label define metrob 0 "Not in Metropolitan Area" 1 "In Metropolitan Area"
label value metrob metrob
gen seattle =.
replace seattle = 1 if city == 6430
replace seattle = 0 if city == 0

**----------Race-------------**

* can either create a binary from the race variables
* or can use racwht which is already a binary


**-------------Food Stamps-------------**
tab foods
*alter to 0 and 1 in order for means to be proportions/probabilities
replace foods = 0 if foods == 1 
replace foods = 1 if foods == 2
label define foods 0 "Not a recipient" 1 "Food stamp recipient"
label value foods foods

tab foods if usa==1
tab foods if wa ==1


**-------------Medicaid----------------**
tab hinscaid
replace hinscaid = 0 if hinscaid == 1 
replace hinscaid = 1 if hinscaid == 2
label define hinscaid 0 "Not Covered by Medicaid" 1 "Covered by Medicaid"
label value hinscaid hinscaid

tab hinscaid if usa ==1
tab hinscaid if wa ==1


**-------------Initial ttests----------**

ttest foods, by(highered)
ttest foods if wa == 1, by(highered)
ttest foods if usa == 1, by(highered)

ttest hinscaid, by(highered)
ttest hinscaid if wa == 1, by(highered)
ttest hinscaid if usa == 1, by(highered)

** these show that there is a difference in foodstamp recipiency and medicaid coverage based on highereducation; using proportions

tab race
tab race, nol
*identifies codes for various races
*White = 1, Black = 2, American Indian or Alaska Native = 3, etc.

*test of only white identifying people
ttest foods if race == 1 & wa == 1, by(highered)
*test of those not identifying as white
ttest foods if race != 1 & wa == 1, by(highered)

*shows greater difference in the effect of highereducation between white and non-white

*when testing between groups in and out of metro there doesn't seem to be an effect based on metro status alone
ttest foods if wa == 1, by(metrob)
ttest foods if usa == 1, by(metrob)
ttest hinscaid if wa == 1, by(metrob)
ttest hinscaid if usa ==1, by(metrob)

ttest foods if race == 1, by(metrob)
ttest foods if race != 1, by(metrob)
ttest hinscaid if race == 1, by(metrob)
ttest hinscaid if race != 1, by(metrob)
*interesting, but still statisticall insignificant results

save "H:\onis\Downloads\PUBPOL527\REFORMATTEDPOLICYREPORTACS 2019 weighted subsample.dta", replace
