

*Heckman
use "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria_soil\complete\Real_heckman.dta", clear
use "C:\Users\obine\Music\Documents\Project\codes_for_bootstrap\Nigeria_soil\complete\Nominal_heckman.dta" , clear



tabstat total_qty_w subsidy_qty_w mrk_dist_w real_tpricefert_cens_mrk num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding [aweight = weight], statistics( mean median sd min max ) columns(statistics)
egen med_zone = median (zone)
replace zone = med_zone if zone ==.
misstable summarize total_qty_w subsidy_qty_w mrk_dist_w real_tpricefert_cens_mrk num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding  subsidy_dummy femhead informal_save formal_credit informal_credit ext_acess attend_sch pry_edu finish_pry finish_sec safety_net net_seller net_buyer soil_qty_rev2 zone year





sum real_tpricefert_cens_mrk, detail


local time_avg "total_qty_w subsidy_qty_w mrk_dist_w real_tpricefert_cens_mrk num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding  subsidy_dummy femhead informal_save formal_credit informal_credit ext_acess attend_sch pry_edu finish_pry finish_sec safety_net net_seller net_buyer soil_qty_rev2"

foreach x in `time_avg' {

	bysort hhid : egen TAvg_`x' = mean(`x')

}


*************Model sig


capture program drop myboot	
program define myboot, rclass
** CRE-TOBIT
 preserve 


 heckman real_tpricefert_cens_mrk subsidy_qty_w  mrk_dist_w real_maize_price_mr real_rice_price_mr  land_holding informal_save formal_credit informal_credit ext_acess  i.year, select (commercial_dummy= mrk_dist_w subsidy_qty_w num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding femhead informal_save formal_credit informal_credit ext_acess attend_sch safety_net net_seller net_buyer soil_qty_rev2 i.year) twostep


predict yhat, xb


gen lyhat = log(yhat)
*replace total_qty_w = 1 if total_qty_w==0
gen ltotal_qty_w = log(total_qty_w + 1)

local time_avg "lyhat ltotal_qty_w"

foreach x in `time_avg' {

	bysort hhid : egen TAvg_`x' = mean(`x')

}


** CRE-TOBIT 
tobit ltotal_qty_w lyhat subsidy_qty_w mrk_dist_w hh_headage real_hhvalue real_maize_price_mr real_rice_price_mr land_holding  femhead informal_save formal_credit informal_credit ext_acess attend_sch safety_net net_seller net_buyer soil_qty_rev2 TAvg_ltotal_qty_w TAvg_subsidy_qty_w TAvg_mrk_dist_w TAvg_lyhat TAvg_hh_headage TAvg_real_hhvalue TAvg_real_maize_price_mr TAvg_real_rice_price_mr TAvg_land_holding TAvg_femhead TAvg_informal_save TAvg_formal_credit TAvg_informal_credit TAvg_ext_acess TAvg_attend_sch TAvg_safety_net TAvg_net_seller TAvg_net_buyer TAvg_soil_qty_rev2 i.year, ll(0)

margins, predict(ystar(0,.)) dydx(*) post

restore
end
bootstrap, reps(100) seed(123) cluster(hhid) idcluster(newid): myboot



tobit total_qty_w yhat subsidy_qty_w mrk_dist_w num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding  femhead informal_save formal_credit informal_credit ext_acess attend_sch pry_edu finish_pry finish_sec safety_net net_seller net_buyer soil_qty_rev2 TAvg_total_qty_w TAvg_subsidy_qty_w TAvg_mrk_dist_w TAvg_yhat TAvg_num_mem TAvg_hh_headage TAvg_real_hhvalue TAvg_worker TAvg_real_maize_price_mr TAvg_real_rice_price_mr TAvg_land_holding TAvg_femhead TAvg_informal_save TAvg_formal_credit TAvg_informal_credit TAvg_ext_acess TAvg_attend_sch TAvg_pry_edu TAvg_finish_pry TAvg_finish_sec TAvg_safety_net TAvg_net_seller TAvg_net_buyer TAvg_soil_qty_rev2 i.zone i.year, ll(0)










***********************************************************
*Tobit Bootstrap
***********************************************************
capture program drop myboot	
program define myboot, rclass
** CRE-TOBIT
 preserve 
 

 heckman real_tpricefert_cens_mrk subsidy_qty_w  mrk_dist_w real_maize_price_mr real_rice_price_mr  land_holding informal_save formal_credit informal_credit ext_acess  i.year, select (commercial_dummy= mrk_dist_w subsidy_qty_w num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding femhead informal_save formal_credit informal_credit ext_acess attend_sch safety_net net_seller net_buyer soil_qty_rev2 i.year) twostep

predict yhat, xb



local time_avg "yhat"

foreach x in `time_avg' {

	bysort hhid : egen TAvg_`x' = mean(`x')

}

** CRE-TOBIT 
tobit total_qty_w yhat subsidy_qty_w mrk_dist_w hh_headage real_hhvalue real_maize_price_mr real_rice_price_mr land_holding  femhead informal_save formal_credit informal_credit ext_acess attend_sch safety_net net_seller net_buyer soil_qty_rev2 TAvg_total_qty_w TAvg_subsidy_qty_w TAvg_mrk_dist_w TAvg_yhat TAvg_hh_headage TAvg_real_hhvalue TAvg_real_maize_price_mr TAvg_real_rice_price_mr TAvg_land_holding TAvg_femhead TAvg_informal_save TAvg_formal_credit TAvg_informal_credit TAvg_ext_acess TAvg_attend_sch TAvg_safety_net TAvg_net_seller TAvg_net_buyer TAvg_soil_qty_rev2 i.year, ll(0)

margins, predict(ystar(0,.)) dydx(*) post


restore
end

bootstrap, reps(100) seed(123) cluster(hhid) idcluster(newid): myboot

tabstat total_qty_w yhat subsidy_qty_w mrk_dist_w  num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding [aweight = weight], statistics( mean median sd min max ) columns(statistics)





tobit total_qty_w yhat subsidy_qty_w mrk_dist_w num_mem hh_headage real_hhvalue worker real_maize_price_mr real_rice_price_mr land_holding  femhead informal_save formal_credit informal_credit ext_acess attend_sch pry_edu finish_pry finish_sec safety_net net_seller net_buyer soil_qty_rev2 TAvg_total_qty_w TAvg_subsidy_qty_w TAvg_mrk_dist_w TAvg_yhat TAvg_num_mem TAvg_hh_headage TAvg_real_hhvalue TAvg_worker TAvg_real_maize_price_mr TAvg_real_rice_price_mr TAvg_land_holding TAvg_femhead TAvg_informal_save TAvg_formal_credit TAvg_informal_credit TAvg_ext_acess TAvg_attend_sch TAvg_pry_edu TAvg_finish_pry TAvg_finish_sec TAvg_safety_net TAvg_net_seller TAvg_net_buyer TAvg_soil_qty_rev2 i.zone i.year, ll(0)














