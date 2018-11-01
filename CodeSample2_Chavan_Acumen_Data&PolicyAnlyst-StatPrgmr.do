
version 13.1

		* /*redacted*/ Analyses for presentation
		* Saurabh Chavan
		* May 13, 2018
		
		
		* read in /*redacted*/
		
		gen age=2018-birthyear if deathdate==.
		replace age=yofd(deathdate)-birthyear if deathdate!=.
		tab presentsex, m
		tab transgendered,m
		
		gen count = 0 
		replace count = 1 if deathdate!=.
		su count, de
		summarize age if count==1, detail
		summarize age if count==0, detail
		drop count
		* mean*100 is percent dead
		tab deathdatesource,m
		
		* read in /*redacted*/
		
		clear
		
		* initial visits
		
		histogram yoiv, freq addl addlabopts(mlabsize(vsmall) mlabangle(45) mlabgap(2)) ylabel(0(50)400)  xtitle("Distribution of enrollment visits by year of enrollment") ytitle("Number of initial visits") xlabel(2000(1)2017) note("Data are truncated for 2017")
		

		* CD4
		
		histogram entryCD4 if entryCD4<2001, freq addl addlabopts(mlabsize(vsmall) mlabangle(45) mlabgap(2)) normal width(50) ylabel(0(50)400)  xtitle("CD4 count at enrollment +/- one month") 
				
		histogram entryCD4 if entryCD4<2001,freq ylabel(0(50)400) xlabel(0(250)2000) xtitle("CD4 count in cells/mm3 at enrollment +/- one month") note("Data truncated at 2000 cells/mm3")
		su entryCD4, de
		
		
		* VL
		
				histogram entryVL if entryVL<100000, percent  kdensity  width(500)  xlabel(0(5000)100000) ylabel(0(5)45) xtitle("Viral load in copies/mL at enrollment +/- one month") note("Data truncated at 100000 copies/mL")
				
				gen yoiv=yofd(initialvisit)
				scatter entryVL  yoiv if entryVL<1000000
				
				
				histogram yoiv , freq 
				
				* loss to follow up
				
				stset obstimeLTFU, id(sitepatientid) failure(LTFU) scale(365.25)
								sts graph, survival xtitle("Analysis time in years") xlabel(0(1)20) xmtick(0(0.5)17) ylabel(0(0.2)1) ymtick(0(0.05)1) title("KM estimate of time to first Loss To Follow Up (no PC visit for 12 months after last kept PC visit)") ci riskt(0(5)20) 
												
								sts gen KM = s
	gen Complement = 1- KM
	twoway line Complement obstimeLTFU
	stset, clear
				
				
				* time to ART
				
				stset obstimeART, id(sitepatientid) failure(ART) scale(365.25)	
				
								sts graph, survival xtitle("Analysis time in years") xlabel(0(1)20) xmtick(0(0.5)17) ylabel(0(0.2)1) ymtick(0(0.05)1) title("KM estimate of time to first ART after enrollment") ci riskt(0(5)20) 
								sts graph, survival xtitle("Analysis time in years") xlabel(0(1)20) xmtick(0(0.5)17) ylabel(0(0.2)1) ymtick(0(0.05)1) title("KM estimate of time to first ART after enrollment") ci riskt(0(5)20)  by(priorART)
				
				
								sts graph, failure xtitle("Analysis time in years") xlabel(0(1)18) xmtick(0(0.5)18) ylabel(0(0.2)1) ymtick(0(0.05)1) title("KM estimate of time to first ART after enrollment") ci riskt(0(2)18) 
								sts graph, failure xtitle("Analysis time in years") xlabel(0(1)18) xmtick(0(0.5)18) ylabel(0(0.2)1) ymtick(0(0.05)1) title("KM estimate of time to first ART after enrollment") ci riskt(0(2)18)   by(priorART)
			
				stset, clear
				
				* CI of death
				
		egen eventdatedeath = rowmin(deathdate firstltfudate dbclosedate)
		format eventdatedeath %tdCY-N-D
		gen obstimedeath=eventdatedeath-initialvisit
		gen DEATH=1 if deathdate!=.
		replace DEATH=0 if DEATH==.
		
			stset obstimedeath, id(sitepatientid) failure(DEATH) scale(365.25)
			
											sts graph, failure xtitle("Analysis time in years") xlabel(0(1)18) xmtick(0(0.5)18) ylabel(0(0.2)1) ymtick(0(0.05)1) title("KM estimate of time to first ART after enrollment") ci riskt(0(2)18)
			
	
				* censoring
				
				gen eventdeath = 0 if eventddeath == dbclosedate
				replace eventdeath = 1 if eventddeath == deathdate
				replace eventdeath = 2 if eventd == firstltfudate



			stset obstimedeath, id(sitepatientid) failure(eventdeath==1) scale(365.25)
					stcompet CI=ci Hi=hi Lo=lo, compet1(3) 
					stcompet CumInc = ci SError = se, compet1(3)
					gen CumInc1 = CumInc if eventdeath==2


			* hospitalisation
			
				egen eventdateHOSP=rowmin(admitdate deathdate firstltfudate dbclosedate)
				format eventdateHOSP %tdCY-N-D
	gen obstimeHOSP=eventdateHOSP-initialvisit
	tab obstimeHOSP,m
	replace obstimeHOSP = 0 if obstimeHOSP<0
	gen HOSP=1 if admitdate!=.
	replace HOSP=0 if HOSP==.
	
	stset obstimeHOSP, id(sitepatientid)  fail(HOSP) scale(365.25)
		
	sts graph, failure xtitle("Analysis time in years") xlabel(0(1)18) xmtick(0(0.5)18) ylabel(0(0.2)1) ymtick(0(0.05)1) title("KM estimate of time to first hospitalisation after enrollment") ci riskt(0(2)18)
				
				
				** LE FIN **
				* END OF CODE *
			








