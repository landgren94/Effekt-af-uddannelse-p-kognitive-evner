*Den kausale effekt af uddannelse på det mentale helbred
*Bachelor projekt E2019
*Af Anne-Mette Landgren 

clear all 
set more off

cap log c
cd "C:\Users\annem\Documents\BA\Data"
log using Bachelor.log, replace 


 *Load EasySHARE data: 
 use "C:\Users\annem\Documents\BA\Data\easySHARE_rel7-0-0_Stata/easySHARE_rel7-0-0.dta",clear 
 
*merge dataset for at finde områdekoder(Germany)
 merge m:1 mergeid using "C:\Users\annem\Documents\BA\Data\sharew1_rel7-0-0_ALL_datasets_stata/sharew1_rel7-0-0_gv_housing.dta", keepus (nuts1_2003)
   
 cap drop _merge
 
 tab nuts1_2003 if country==12
 gen germanregions =substr(nuts1_2003,1,3) if country==12 
 
 
*****Generate Education Variables**********************************************
 
 gen YOB = dn003_mod
 *YOB= Year of birth 
 drop if YOB <1000
 
 gen YOE = eduyears_mod
 replace YOE=. if YOE<0 
 *YOE = years of education 
 
*generate YCE= years of compulsory schooling, (ref: table 1) 
 gen YCE=. 
 
*Austria
replace YCE=8 if inrange(YOB,1940,1946) & country==11
replace YCE=9 if inrange(YOB,1947,1953) & country==11
*Germany
replace YCE=8 if inrange(YOB,1934,1940) & germanregions == "DEF"
replace YCE=9 if inrange(YOB,1941,1947) & germanregions == "DEF"

replace YCE=8 if inrange(YOB,1927,1933) & germanregions == "DE6"
replace YCE=9 if inrange(YOB,1934,1940) & germanregions == "DE6"

replace YCE=8 if inrange(YOB,1940,1946) & germanregions == "DE9"
replace YCE=9 if inrange(YOB,1947,1953) & germanregions == "DE9"

replace YCE=8 if inrange(YOB,1936,1942) & germanregions == "DE5"
replace YCE=9 if inrange(YOB,1943,1949) & germanregions == "DE5"

replace YCE=8 if inrange(YOB,1946,1952) & germanregions == "DEA"
replace YCE=9 if inrange(YOB,1953,1959) & germanregions == "DEA"

replace YCE=8 if inrange(YOB,1946,1952) & germanregions == "DE7"
replace YCE=9 if inrange(YOB,1953,1959) & germanregions == "DE7"

replace YCE=8 if inrange(YOB,1946,1952) & germanregions == "DEB"
replace YCE=9 if inrange(YOB,1953,1959) & germanregions == "DEB"

replace YCE=8 if inrange(YOB,1946,1952) & germanregions == "DE1"
replace YCE=9 if inrange(YOB,1953,1959) & germanregions == "DE1"

replace YCE=8 if inrange(YOB,1948,1954) & germanregions == "DE2"
replace YCE=9 if inrange(YOB,1955,1961) & germanregions == "DE2"

replace YCE=8 if inrange(YOB,1942,1948) & germanregions == "DEC"
replace YCE=9 if inrange(YOB,1950,1956) & germanregions == "DEC"
*Sweden
replace YCE=8 if inrange(YOB,1943,1949) & country==13
replace YCE=9 if inrange(YOB,1950,1956) & country==13
*Netherlands
replace YCE=6 if inrange(YOB,1943,1949) & country==14
replace YCE=8 if inrange(YOB,1950,1956) & country==14
*Italy
replace YCE=5 if inrange(YOB,1942,1948) & country==16
replace YCE=8 if inrange(YOB,1949,1955) & country==16
*France
replace YCE=8  if inrange(YOB,1946,1952) & country==17
replace YCE=10 if inrange(YOB,1953,1959) & country==17
*Denmark
replace YCE=5  if inrange(YOB,1938,1944) & country==18
replace YCE=7  if inrange(YOB,1945,1951) & country==18

*******generate country dummies********************************
gen Austria=0 
replace Austria=1 if country==11

gen Germany=0 
replace Germany=1 if country==12

gen Denmark=0 
replace Denmark=1 if country==18

gen France=0 
replace France=1 if country==17

gen Italy=0 
replace Italy=1 if country==16

gen Netherlands=0 
replace Netherlands=1 if country==14

gen Sweden=0 
replace Sweden=1 if country==13

********generate y-variables

gen memory = recall_1+recall_2
replace memory=. if memory<0

*standalize memory 
egen std_memory = std(memory)
sum std_memory


*merge fluency-dataset dannet ud fra (wave 1-7) - et mål for cognitive evner  

 merge m:1 mergeid wave using "C:\Users\annem\Documents\BA\Data\easySHARE_rel7-0-0_Stata/fluency.dta", keepus (fluency)   
 cap drop _merge
 
 
 gen Cognitive_ability = memory+fluency
 replace Cognitive_ability=. if Cognitive_ability<0
 
*2)standaliser Cognitive ability
egen std_CA = std(Cognitive_ability)
sum std_CA

****generate childhood variables:
gen rual=0
replace rual=1 if iv009_mod ==5
replace rual=. if iv009_mod<0

* merge dataset (wave 3 + 7) to find childhood condition  
 merge m:1 mergeid using "C:\Users\annem\Documents\BA\Data\easySHARE_rel7-0-0_Stata/ChildhoodConditions.dta", keepus (room2l book25l BWoccupation features badmath badlanguage)  
 cap drop _merge

 
* merge dataset (wave 3 + 7) to find childhood health   
 merge m:1 mergeid using "C:\Users\annem\Documents\BA\Data\easySHARE_rel7-0-0_Stata/ChildhoodHealth.dta", keepus (badhealth chmental padict pmental)  
 cap drop _merge
 
 gen badstudent = 0
 replace badstudent = 1 if badlanguage==1 & badmath==1
 
 gen badchhealth = 0 
 replace badchhealth = 1 if badhealth==1 & chmental==1
 
****Deskriptive analysis*******************************************

*identifikations strategi, udvælgelse af observationer til videre analyse
keep if int_version==0
drop if YCE ==.
keep if country==11 | country==12 | country==13 | country==14 | country==16 | country==17 |country==18 
keep if inrange(eduyears_mod,0,25)
drop if room2l ==. | badhealth ==. | chmental ==. | book25l ==. | badlanguage ==. | badmath ==. | BWoccupation ==. | features ==. | rual ==.
drop if std_CA ==.
keep if age>=50 
drop if YOE<YCE

*For de lande der har indført en skolereform indgår de personer der er over 50 år, hvor childhood variablene, YOB, YCE std_CA er kendt. Alle personer indgår kun en gang med deres baseline interview. 

*Tjek antallet af par i gruppen:  
sort coupleid 
quietly by coupleid: gen dup2 =cond(_N==1,0,_n)

gen couple=0
replace couple=1 if dup2==1 | dup2==2
replace couple=0 if mergeid=="F1-885992-01" | mergeid=="SE-165352-01"

sort mergeid 

* der kan være et problem med dependency between respondents. Da 42 pct er registrerede par. Par ligner hinanden b.a. ved uddannelse, derfor ikke ransom selection 

sum female age YCE YOE Cognitive_ability wave couple 
sum room2l badhealth badstudent book25l BWoccupation features chmental rual 
sum Austria Germany Sweden Netherlands Italy France Denmark 

*kumulative kognitive evner

cumul std_CA, gen(cum)
sort cum 
line cum std_CA , ylab(, grid) ytitle("kumulative andel") xlab(, grid)  xtitle("standardiserede værdier af kognitive evner")

*histogram af uddannelseslængde
histogram YOE, bin(18) ytitle("Andel") xtitle("Uddannelseslængde")


****Grafisk test: Test om der er en forskel i den gns. uddannelseslængde som følge af reform. 
bysort YOB country: egen YOE_mean = mean(YOE)
bysort YOB germanregions: egen YOE_G_mean = mean(YOE)

twoway (scatter YOE_mean YOB if country==11 ) (lfit YOE_mean YOB if country==11 & inrange(YOB,1940,1946)) (lfit YOE_mean YOB if country==11 & inrange(YOB,1947,1953)), xline (1946) name(Østrig,  replace) subtitle(Østrig) legend(off) xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_mean YOB if country==13 ) (lfit YOE_mean YOB if country==13 & inrange(YOB,1943,1949)) (lfit YOE_mean YOB if country==13 & inrange(YOB,1950,1956)), xline (1949) name(Sverige,  replace)  subtitle(Sverige) legend(off) xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_mean YOB if country==14 ) (lfit YOE_mean YOB if country==14 & inrange(YOB,1943,1949)) (lfit YOE_mean YOB if country==14 & inrange(YOB,1950,1956)), xline (1949) name(Holland,  replace) subtitle (Holland) legend(off) xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_mean YOB if country==16 ) (lfit YOE_mean YOB if country==16 & inrange(YOB,1942,1948)) (lfit YOE_mean YOB if country==16 & inrange(YOB,1949,1955)), xline (1948) name(Italien, replace) subtitle(Italien) legend(off) xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_mean YOB if country==17 ) (lfit YOE_mean YOB if country==17 & inrange(YOB,1946,1952)) (lfit YOE_mean YOB if country==17 & inrange(YOB,1953,1959)), xline (1952) name(Frankrig, replace) subtitle(Frankrig) legend(off) xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_mean YOB if country==18 ) (lfit YOE_mean YOB if country==18 & inrange(YOB,1938,1944)) (lfit YOE_mean YOB if country==18 & inrange(YOB,1945,1951)), xline (1944) name(Danmark, replace) subtitle (Danmark) legend(off) xtitle(Fødselsår) ytitle(Uddannelseslængde)

graph combine Østrig Sverige Holland  Italien Frankrig Danmark

*Tyskland
twoway (scatter YOE_G_mean YOB if germanregions=="DEF" ) (lfit YOE_G_mean YOB if germanregions=="DEF" & inrange(YOB,1934,1940)) (lfit YOE_G_mean YOB if germanregions=="DEF" & inrange(YOB,1941,1947)), xline (1940) name(SchleswigHolstein,  replace) subtitle(Schleswig-Holstein) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DE6" ) (lfit YOE_G_mean YOB if germanregions=="DE6" & inrange(YOB,1927,1933)) (lfit YOE_G_mean YOB if germanregions=="DE6" & inrange(YOB,1934,1940)), xline (1933) name(Hamburg,  replace)  subtitle(Hamburg) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DE9" ) (lfit YOE_G_mean YOB if germanregions=="DE9" & inrange(YOB,1940,1946)) (lfit YOE_G_mean YOB if germanregions=="DE9" & inrange(YOB,1947,1953)), xline (1946) name(Niedersachsen,  replace) subtitle (Niedersachsen) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DE5" ), xline (1942) name(Bremen, replace) subtitle(Bremen) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DEA" ) (lfit YOE_G_mean YOB if germanregions=="DEA" & inrange(YOB,1946,1952)) (lfit YOE_G_mean YOB if germanregions=="DEA" & inrange(YOB,1953,1959)), xline (1952) name(NordrheinWestfalen, replace) subtitle(Nordrhein-Westfalen) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DE7" ) (lfit YOE_G_mean YOB if germanregions=="DE7" & inrange(YOB,1946,1952)) (lfit YOE_G_mean YOB if germanregions=="DE7" & inrange(YOB,1953,1959)), xline (1952) name(Hessen, replace) subtitle (Hessen) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DEB" )(lfit YOE_G_mean YOB if germanregions=="DEB" & inrange(YOB,1946,1952)) (lfit YOE_G_mean YOB if germanregions=="DEB" & inrange(YOB,1953,1959)), xline (1952) name(RheinlandPfalz, replace) subtitle(Rheinland-Pfalz) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DE1" )(lfit YOE_G_mean YOB if germanregions=="DE1" & inrange(YOB,1946,1952)) (lfit YOE_G_mean YOB if germanregions=="DE1" & inrange(YOB,1953,1959)), xline (1952) name(BadenWuerttemberg, replace) subtitle(Baden-Wuerttemberg) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DE2" ) (lfit YOE_G_mean YOB if germanregions=="DE2" & inrange(YOB,1948,1954)) (lfit YOE_G_mean YOB if germanregions=="DE2" & inrange(YOB,1955,1961)), xline (1954) name(Bayern , replace) subtitle (Bayern) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)
twoway (scatter YOE_G_mean YOB if germanregions=="DEC" ), xline (1948) name(Saarland, replace) subtitle (Saarland) legend(off)  xtitle(Fødselsår) ytitle(Uddannelseslængde)

graph combine SchleswigHolstein Hamburg Niedersachsen Bremen NordrheinWestfalen Hessen RheinlandPfalz BadenWuerttemberg Bayern Saarland


* contry-specific qudratic cohort trends: Alder påvirker ikke det mentale helbred lineært, og der kan være landespecifikke trends. 
gen age2Austria = age^2*Austria
gen age2Germany = age^2*Germany
gen age2Sweden = age^2*Sweden
gen age2Netherlands = age^2*Netherlands
gen age2Italy = age^2*Italy 
gen age2Denmark = age^2*Denmark
*gen age2France = age^2*France


*Wave control: Tjek af om metode og tid har betydning. 
gen wave1=0 
replace wave1=1 if wave==1
gen wave2=0 
replace wave2=1 if wave==2
gen wave3=0 
replace wave3=1 if wave==3
gen wave4=0 
replace wave4=1 if wave==4
gen wave5=0 
replace wave5=1 if wave==5
gen wave6=0 
replace wave6=1 if wave==6
*gen wave7=0 replace wave7=1 if wave==7
*HUSK at udlede en pga. dummy-trap (tjek med Søren)


***************************first stage***********************************
eststo clear

*1)effekten af reformer på uddannelseslængde 

eststo: regress YOE YCE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden, r

*brug robus std.error, da de er størst


*****Breusch-Pegan test (heteroskedasicitets problemer): 
*drop uhat uhat2 yhat
regress YOE YCE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden 

predict uhat, residuals 
predict yhat, xb

gen uhat2 = uhat*uhat 
label var uhat2 "squared residuals"

regress uhat2 YCE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden 

*LM test 
display e(N)*e(r2)
display invchi2tail(16,0.05)
*Da teststørrelsen er større end den kritiske værdi forkastes H_0. modellen har derved heteroskedastiske fejlled.

*****Endogenitetstest: (Er YOE påvirket af YCE) 
*drop ehat1

regress YOE YCE age female Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden,  r
predict ehat1, residuals

regress std_CA YOE YCE age female Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden ehat1, r

test ehat1 == 0 

*H0 forskastets og YOE er derved endogen, og kan delvis beskrives ud fra YCE


*2)Se om skolebeslutninger er heterogene

*lineært
eststo: regress YOE YCE female age  Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual,r 

test YCE

*flere af barndomsvariablerne har en effekt.
*badhealth og chmental ikke signifikant, kunne evt. fjernes. 


*******

*3) test om reformer påvirker særlige grupper (dem der ellers ville droppe ud)
*lineært
gen YCExrual = YCE*rual
gen YCExroom2l = YCE*room2l
gen YCExbook25l = YCE*book25l
gen YCExBWoccupation = YCE*BWoccupation
gen YCExfeatures = YCE*features
gen YCExbadmath= YCE*badmath
gen YCExbadlanguage = YCE*badlanguage
gen YCExbadstudent= YCE*badstudent
gen YCExbadhealth = YCE*badhealth
gen YCExchmental = YCE*chmental

*kvadreret
gen YCE2rual = YCE^2*rual
gen YCE2room2l = YCE^2*room2l
gen YCE2book25l = YCE^2*book25l
gen YCE2BWoccupation = YCE^2*BWoccupation
gen YCE2features = YCE^2*features
gen YCE2badmath= YCE^2*badmath
gen YCE2badlanguage = YCE^2*badlanguage
gen YCE2badstudent = YCE^2*badstudent
gen YCE2badhealth = YCE^2*badhealth
gen YCE2chmental = YCE^2*chmental
gen YCE2 = YCE^2

 
*lineært
eststo: regress YOE YCE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental,r 

test YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental
test YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental
test YCExroom2l YCExBWoccupation YCExbadstudent YCExbadhealth YCExchmental


*F-test forkaster at at instruments=0. 
* instrumentet er derved relevant og kan bruges i 2.stage

***TABEL MED FIRST STAGE! 

cd "C:\Users\annem\Documents\BA\Data"
n esttab using table1.tex, replace star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) r2(3) varwidth (35) ///
addnotes("")

**************************2 stage*****************************************
*udannelseslængdens effet på Cognitive evner
eststo clear

*linært
gen YOExrual = YOE*rual
gen YOExroom2l = YOE*room2l
gen YOExbook25l = YOE*book25l
gen YOExBWoccupation = YOE*BWoccupation
gen YOExfeatures = YOE*features
gen YOExbadmath= YOE*badmath
gen YOExbadlanguage = YOE*badlanguage
gen YOExbadstudent= YOE*badstudent
gen YOExbadhealth = YOE*badhealth
gen YOExchmental = YOE*chmental

*kvadreret
gen YOE2rual = YOE^2*rual
gen YOE2room2l = YOE^2*room2l
gen YOE2book25l = YOE^2*book25l
gen YOE2BWoccupation = YOE^2*BWoccupation
gen YOE2features = YOE^2*features
gen YOE2badmath= YOE^2*badmath
gen YOE2badlanguage = YOE^2*badlanguage
gen YOE2badstudent = YOE^2*badstudent
gen YOE2badhealth = YOE^2*badhealth
gen YOE2chmental = YOE^2*chmental
gen YOE2 = YOE^2


*(1) OLS baseline specifikation 
eststo: regress std_CA YOE age female Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden,  r

*(2) OLS childhood variables
eststo: regress std_CA YOE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual YOExrual YOExroom2l YOExbook25l YOExBWoccupation YOExfeatures YOExbadstudent YOExbadhealth YOExchmental,r 


*(3) IV baseline 
eststo: ivregress 2sls std_CA female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden (YOE = YCE ),r


eststo: regress YOE YCE female age  Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden ,r 

test YCE


*(4) IV (perfekt identifikation) 
eststo: ivregress 2sls std_CA female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual (YOE YOExrual YOExroom2l YOExbook25l YOExBWoccupation YOExfeatures YOExbadstudent YOExbadhealth YOExchmentalc= YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental),r 


cd "C:\Users\annem\Documents\BA\Data"
n esttab using table2.tex, replace star(* 0.10 ** 0.05 *** 0.01) b(3) se(4) r2(4) varwidth (35) ///
addnotes("")

**********grafer med gennemsnit og subgruppe **********************

*Model(4) estimater for signifikante interaktionsled.
 
* YOE  =  .2415436 
* YOExbook25l = -.2210004
* YOExroom2l = .0607571  
* YOExfeatures =  .0362806  
* konstant =   -2.352507

gen estimate_mean = -2.352507  + YOE*0.2415436
gen estimate_book = -2.352507  + YOE*(0.2415436 - 0.2210004)
gen estimate_room = -2.352507  + YOE*(0.2415436 + 0.0607571)
gen estimate_feat = -2.352507  + YOE*(0.2415436 + (0.0362806*features)) 

twoway (lfit estimate_mean YOE) (lfit estimate_book YOE, lp(dash)) (lfit estimate_room YOE, lp(dash)) (lfit estimate_feat YOE if features==5, lp(dash)), name(e_book, replace) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "Gennemsnitlig effekt") label(2 "Færre end 25 bøger") label(3 "Færre end 2 værelser") label(4 " Maks antal brugsgoder")) 



******************** Robusthedsanalyse**************************************
*0: uden tyskland

eststo clear

preserve
drop if Germany==1 

ivregress 2sls std_CA female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual (YOE YOExrual YOExroom2l YOExbook25l YOExBWoccupation YOExfeatures YOExbadstudent YOExbadhealth YOExchmental= YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental),r 

restore

*3: Med Wave.

eststo: ivregress 2sls std_CA female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden wave1 wave2 wave3 wave4 wave5 wave6 badstudent book25l BWoccupation features room2l badhealth chmental rual (YOE YOExrual YOExroom2l YOExbook25l YOExBWoccupation YOExfeatures YOExbadstudent YOExbadhealth YOExchmental= YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental),r 

regress YOE YCE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden wave1 wave2 wave3 wave4 wave5 wave6  badstudent book25l BWoccupation features room2l badhealth chmental rual YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental,r 

test YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental

*2: uden  partner

preserve
drop if dup2==2 

eststo: ivregress 2sls std_CA female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual (YOE YOExrual YOExroom2l YOExbook25l YOExBWoccupation YOExfeatures YOExbadstudent YOExbadhealth YOExchmental= YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental),r 

regress YOE YCE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental,r 

test YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental

restore



*4 

 *(second stage)IV - kvadreret
eststo: ivregress 2sls std_CA female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual (YOE YOExrual YOExroom2l YOExbook25l YOExBWoccupation YOExfeatures YOExbadstudent YOExbadhealth YOExchmental YOE2 YOE2rual YOE2room2l YOE2book25l YOE2BWoccupation YOE2features YOE2badstudent YOE2badhealth YOE2chmental = YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental YCE2 YCE2rual YCE2room2l YCE2book25l YCE2BWoccupation YCE2features YCE2badstudent YCE2badhealth YCE2chmental),r 


*(first stage)OLS kvadreret
regress YOE female age Austria Denmark Germany Italy Netherlands Sweden age2Austria age2Denmark age2Germany age2Italy age2Netherlands age2Sweden badstudent book25l BWoccupation features room2l badhealth chmental rual YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental YCE2 YCE2rual YCE2room2l YCE2book25l YCE2BWoccupation YCE2features YCE2badstudent YCE2badhealth YCE2chmental,r 

test YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental YCE2 YCE2rual YCE2room2l YCE2book25l YCE2BWoccupation YCE2features YCE2badstudent YCE2badhealth YCE2chmental

test YCE YCExrual YCExroom2l YCExbook25l YCExBWoccupation YCExfeatures YCExbadstudent YCExbadhealth YCExchmental
test YCE2 YCE2rual YCE2room2l YCE2book25l YCE2BWoccupation YCE2features YCE2badstudent YCE2badhealth YCE2chmental

test YCE YCE2
test YCExrual YCE2rual 
test YCExroom2l YCE2room2l 
test YCExbook25l YCE2book25l
test YCExBWoccupation YCE2BWoccupation
test YCExfeatures YCE2features 
test YCExbadstudent YCE2badstudent
test YCExbadhealth YCE2badhealth
test YCExchmental YCE2chmental

** tabel ROBUST
cd "C:\Users\annem\Documents\BA\Data"
n esttab using table3.tex, replace star(* 0.10 ** 0.05 *** 0.01) b(3) se(3) r2(3) varwidth (35) ///
addnotes("")


***********************Grafer med faktiske værdier: *********************************
*faktiske værdier
drop CA_badstuden_mean CA_book25l_mean CA_BWoccupation_mean CA_features_mean CA_room2l_mean CA_badhealth_mean CA_chmental_mean CA_rual_mean

bysort YOE badstudent: egen CA_badstuden_mean = mean(std_CA)
twoway (scatter CA_badstuden_mean YOE if badstudent==1) (scatter CA_badstuden_mean YOE if badstudent==0) (qfit CA_badstuden_mean YOE if badstudent==1) (qfit CA_badstuden_mean YOE if badstudent==0), name(g_badstudent, replace) subtitle(Dårlig elev) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "Dårlig elev") label(2 "Gns. elev") label(3 "Dårlig elev (trend)") label(4 "Gns. elev (trend)") )

bysort YOE book25l: egen CA_book25l_mean = mean(std_CA)
twoway (scatter CA_book25l_mean  YOE if book25l==1) (scatter CA_book25l_mean YOE if book25l==0) (qfit CA_book25l_mean  YOE if book25l==1) (qfit CA_book25l_mean  YOE if book25l==0), name(g_book25l, replace) subtitle(Færre end 25 bøger) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "Færre end 25 bøger") label(2 "Gns. antal bøger") label(3 "Færre end 25 bøger (trend) ") label(4 "Gns. antal bøger (trend)") )

bysort YOE BWoccupation: egen CA_BWoccupation_mean = mean(std_CA)
twoway (scatter CA_BWoccupation_mean  YOE if BWoccupation==1) (scatter CA_BWoccupation_mean YOE if BWoccupation==0) (qfit CA_BWoccupation_mean  YOE if BWoccupation==1) (qfit CA_BWoccupation_mean  YOE if BWoccupation==0), name(g_BWoccupation, replace) subtitle(Primære forsørgers (P.F.) job) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "Lavt P.F. job") label(2 "Gns. P.F. job") label(3 "Lavt. P.F. job (trend) ") label(4 "Gns. P.F. job (trend)") )

bysort YOE features: egen CA_features_mean = mean(std_CA)
twoway (scatter CA_features_mean  YOE if features==0) (scatter CA_features_mean YOE if features==5) (qfit CA_features_mean  YOE if features ==0) (qfit CA_features_mean  YOE if features==5), name(g_features, replace) subtitle(Brugsgoder) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "min. brugsgoder") label(2 "maks. brugsgoder") label(3 "min. brugsgoder(trend) ") label(4 "maks. brugsgoder (trend)") )

bysort YOE room2l: egen CA_room2l_mean = mean(std_CA)
twoway (scatter CA_room2l_mean YOE if room2l==0) (scatter CA_room2l_mean YOE if room2l==1) (qfit CA_room2l_mean  YOE if room2l ==0) (qfit CA_room2l_mean  YOE if room2l==1), name(g_room2l, replace) subtitle(Færre end 2 værrelser) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "Færre end 2 værlser") label(2 "Gns. antal værelser") label(3 "Færre end 2 værelser(trend) ") label(4 "Gns. antal værelser (trend)") )

bysort YOE badhealth: egen CA_badhealth_mean = mean(std_CA)
twoway (scatter CA_badhealth_mean YOE if badhealth==0) (scatter CA_badhealth_mean YOE if badhealth==1) (qfit CA_badhealth_mean  YOE if badhealth ==0) (qfit CA_badhealth_mean  YOE if badhealth==1), name(g_badhealth, replace) subtitle(Dårligt fysisk helbred) xtitle(Uddannelseslængde) ytitle(std(kognitive evner))legend(label(1 "Dårlig f. helbred") label(2 "Gns. f. helbred") label(3 "Dårligt f. helbred (trend)") label(4 "Gns. f. helbred (trend)") )

bysort YOE chmental: egen CA_chmental_mean = mean(std_CA)
twoway (scatter CA_chmental_mean YOE if chmental==0) (scatter CA_chmental_mean YOE if chmental==1) (qfit CA_chmental_mean  YOE if chmental ==0) (qfit CA_chmental_mean  YOE if chmental==1), name(g_chmental, replace) subtitle(Dårligt mentalt helbred) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "Dårlig m. helbred") label(2 "Gns. m. helbred") label(3 "Dårligt m. helbred (trend)") label(4 "Gns. m. helbred (trend)") )

bysort YOE rual: egen CA_rual_mean = mean(std_CA)
twoway (scatter CA_rual_mean YOE if rual==0) (scatter CA_rual_mean YOE if rual==1) (qfit CA_rual_mean YOE if rual==0) (qfit CA_rual_mean  YOE if rual==1), name(g_rual, replace) subtitle(Udkantsområde) xtitle(Uddannelseslængde) ytitle(std(kognitive evner)) legend(label(1 "Udkantsområde") label(2 "Alle områder") label(3 "Udkantsområde (trend)") label(4 "Alle områder (trend)") )


graph combine g_badstudent g_book25l g_BWoccupation g_features
graph combine  g_room2l g_badhealth g_chmental g_rual

