




*use "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\Nigeria.dta", clear

use "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\Nominal_Nigeria.dta", clear


gen dummy = 1

collapse (sum) dummy, by (hhid)
tab dummy
keep if dummy==4
sort hhid

*save "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\subset_Real_heckman", replace
save "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\subset_Nominal_heckman", replace


*merge 1:m hhid using "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\Nigeria.dta"
merge 1:m hhid using "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\Nominal_Nigeria.dta"

drop if _merge==2

*save "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\Real_heckman.dta", replace
save "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\Nominal_heckman.dta", replace


gen year_2010 = (year==2010)
gen year_2012 = (year==2012)
gen year_2015 = (year==2015)
gen year_2018 = (year==2018)

gen commercial_dummy = (total_qty_w>0)

tab commercial_dummy


tabstat total_qty_w subsidy_qty_w mrk_dist_w real_tpricefert_cens_mrk num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding [aweight = weight], statistics( mean median sd min max ) columns(statistics)
misstable summarize total_qty_w subsidy_qty_w mrk_dist_w real_tpricefert_cens_mrk num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding  subsidy_dummy femhead informal_save formal_credit informal_credit ext_acess attend_sch pry_edu finish_pry finish_sec safety_net net_seller net_buyer soil_qty_rev2


sum real_tpricefert_cens_mrk, detail




*save "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\complete\Real_heckman.dta", replace
save "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria\complete\Nominal_heckman.dta", replace



