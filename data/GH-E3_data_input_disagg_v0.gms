

*===================================create disaggregated %DataYr% make table====================================================================================================================================================================

parameter
make%BenchYr%_sum(bea_ind_sum0,bea_com_sum0)
make%BenchYr%_sum_det(bea_ind_det0,bea_com_det0)
make%BenchYr%_share(bea_ind_det0,bea_com_det0)
make%DataYr%_sum_det(bea_ind_det0,bea_com_det0)
make(bea_ind_det0,bea_com_det0)
com_make_tot(bea_com_det0)
ind_make_tot(bea_ind_det0)
com_make_tot_db(bea_com_sum0)
ind_make_tot_db(bea_ind_sum0)
;


* Step 1: For each summary level industry, use detailed data to calculate benchmark summary level data

make%BenchYr%_sum(bea_ind_sum0,bea_com_sum0) = sum(bea_ind_det0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*sum(bea_com_det0,mapbea_com(bea_com_sum0,bea_com_det0)*make%BenchYr%_in(bea_ind_det0,bea_com_det0)));

* Step 2: "Replicate" the benchmark summary level industry data to each detailed industry

make%BenchYr%_sum_det(bea_ind_det0,bea_com_det0) = sum(bea_ind_sum0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*sum(bea_com_sum0,mapbea_com(bea_com_sum0,bea_com_det0)*make%BenchYr%_sum(bea_ind_sum0,bea_com_sum0)));

* Step 3: Create benchmark share parameters for each summary industry -- careful not to divide by zero

make%BenchYr%_share(bea_ind_det0,bea_com_det0) $ (make%BenchYr%_sum_det(bea_ind_det0,bea_com_det0)<>0) = make%BenchYr%_in(bea_ind_det0,bea_com_det0)/make%BenchYr%_sum_det(bea_ind_det0,bea_com_det0);

* Step 4: "Replicate" the data-year summary level industry data to each detailed industry

make%DataYr%_sum_det(bea_ind_det0,bea_com_det0)= sum(bea_ind_sum0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*sum(bea_com_sum0,mapbea_com(bea_com_sum0,bea_com_det0)*make%DataYr%_in(bea_ind_sum0,bea_com_sum0)));

* Step 5: Create new annual detailed level data

make(bea_ind_det0,bea_com_det0) = make%BenchYr%_share(bea_ind_det0,bea_com_det0)* make%DataYr%_sum_det(bea_ind_det0,bea_com_det0);


ind_make_tot(bea_ind_det0) = sum(bea_com_det0,make(bea_ind_det0,bea_com_det0));
com_make_tot(bea_com_det0) = sum(bea_ind_det0,make(bea_ind_det0,bea_com_det0));


* Step 6: Check that sum of detailed industry/commodity matches data year totals

ind_make_tot_db(bea_ind_sum0) = sum(bea_ind_det0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*ind_make_tot(bea_ind_det0)) - ind_make%DataYr%_tot(bea_ind_sum0);
com_make_tot_db(bea_com_sum0) = sum(bea_com_det0,mapbea_com(bea_com_sum0,bea_com_det0)*com_make_tot(bea_com_det0)) - com_make%DataYr%_tot(bea_com_sum0);

display
com_make_tot_db
ind_make_tot_db

;



*==========================create disaggragated %DataYr% value added rows=====================================================================================

parameter
value_added_%BenchYr%_sum(value_added_det,bea_ind_sum0)
value_added_%BenchYr%_sum_det(value_added_det,bea_ind_det0)
value_added_%BenchYr%_share(value_added_det,bea_ind_det0)
value_added_%DataYr%_sum_det(value_added_det,bea_ind_det0)
value_added(value_added_det,bea_ind_det0)
ind_value_added_tot(bea_ind_det0)
ind_value_added_tot_db(bea_ind_sum0)

;
* Step 1: For each summary level industry, use detailed data to calculate benchmark summary level data

value_added_%BenchYr%_sum(value_added_det,bea_ind_sum0) = sum(bea_ind_det0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*value_added_%BenchYr%_in(value_added_det,bea_ind_det0));

* Step 2: "Replicate" the benchmark summary level industry data to each detailed industry

value_added_%BenchYr%_sum_det(value_added_det,bea_ind_det0) = sum(bea_ind_sum0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*value_added_%BenchYr%_sum(value_added_det,bea_ind_sum0));

* Step 3: Create benchmark share parameters for each summary industry -- careful not to divide by zero

value_added_%BenchYr%_share(value_added_det,bea_ind_det0) $ (value_added_%BenchYr%_sum_det(value_added_det,bea_ind_det0)<>0) = value_added_%BenchYr%_in(value_added_det,bea_ind_det0)/value_added_%BenchYr%_sum_det(value_added_det,bea_ind_det0);

* Step 4: "Replicate" the data-year summary level industry data to each detailed industry

value_added_%DataYr%_sum_det(value_added_det,bea_ind_det0) = sum(bea_ind_sum0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*sum(value_added_sum,map_value_added(value_added_sum,value_added_det)*value_added_%DataYr%_in(value_added_sum,bea_ind_sum0)));

* Step 5: Create new annual detailed level data

value_added(value_added_det,bea_ind_det0) = value_added_%BenchYr%_share(value_added_det,bea_ind_det0)*value_added_%DataYr%_sum_det(value_added_det,bea_ind_det0);

ind_value_added_tot(bea_ind_det0) = sum(value_added_det,value_added(value_added_det,bea_ind_det0));

* Step 6: Check that sum of detailed industry value added matches data year totals

ind_value_added_tot_db(bea_ind_sum0) = sum(bea_ind_det0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*ind_value_added_tot(bea_ind_det0)) - ind_value_added_%DataYr%_tot(bea_ind_sum0);


display
ind_value_added_tot_db
;

*====================================create disaggregated %DataYr% use table==========================================================================================

parameter
use%BenchYr%_sum(bea_com_sum0,bea_ind_sum0)
use%BenchYr%_sum_det(bea_com_det0,bea_ind_det0)
use%BenchYr%_share(bea_com_det0,bea_ind_det0)
use%DataYr%_sum_det(bea_com_det0,bea_ind_det0)
use(bea_com_det0,bea_ind_det0)
com_use_tot(bea_com_det0)
ind_use_tot(bea_ind_det0)
com_use_tot_db(bea_com_sum0)
ind_use_tot_db(bea_ind_sum0)

;

* Step 1: For each summary level industry, use detailed data to calculate benchmark summary level data

use%BenchYr%_sum(bea_com_sum0,bea_ind_sum0) = sum(bea_ind_det0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*sum(bea_com_det0,mapbea_com(bea_com_sum0,bea_com_det0)*use%BenchYr%_in(bea_com_det0,bea_ind_det0)));

* Step 2: "Replicate" the benchmark summary level industry data to each detailed industry

use%BenchYr%_sum_det(bea_com_det0,bea_ind_det0) = sum(bea_ind_sum0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*sum(bea_com_sum0,mapbea_com(bea_com_sum0,bea_com_det0)*use%BenchYr%_sum(bea_com_sum0,bea_ind_sum0)));

* Step 3: Create benchmark share parameters for each summary industry -- careful not to divide by zero

use%BenchYr%_share(bea_com_det0,bea_ind_det0) $ (use%BenchYr%_sum_det(bea_com_det0,bea_ind_det0)<>0) = use%BenchYr%_in(bea_com_det0,bea_ind_det0)/use%BenchYr%_sum_det(bea_com_det0,bea_ind_det0);

* Step 4: "Replicate" the data-year summary level industry data to each detailed industry

use%DataYr%_sum_det(bea_com_det0,bea_ind_det0)= sum(bea_ind_sum0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*sum(bea_com_sum0,mapbea_com(bea_com_sum0,bea_com_det0)*use%DataYr%_in(bea_com_sum0,bea_ind_sum0)));

* Step 5: Create new annual detailed level data

use(bea_com_det0,bea_ind_det0) = use%BenchYr%_share(bea_com_det0,bea_ind_det0)* use%DataYr%_sum_det(bea_com_det0,bea_ind_det0);

com_use_tot(bea_com_det0) = sum(bea_ind_det0,use(bea_com_det0,bea_ind_det0));
ind_use_tot(bea_ind_det0) = sum(bea_com_det0,use(bea_com_det0,bea_ind_det0));

* Step 6: Check that sum of detailed industry/commodity matches data year totals

com_use_tot_db(bea_com_sum0)  = sum(bea_com_det0,mapbea_com(bea_com_sum0,bea_com_det0)*com_use_tot(bea_com_det0)) - com_use%DataYr%_tot(bea_com_sum0);
ind_use_tot_db(bea_ind_sum0)  = sum(bea_ind_det0,mapbea_ind(bea_ind_sum0,bea_ind_det0)*ind_use_tot(bea_ind_det0)) - ind_use%DataYr%_tot(bea_ind_sum0);


display
com_use_tot_db
ind_use_tot_db
;

* Step 0: Move oil&gas expenditures by state government enterprises to natural gas dist.

use('211000','221200') = use('211000','221200') + use('211000','s00203');
use('211000','s00203') = 0;

$ontext
* Following code can be used to determine where summary benchmark year is zero when summary data year is positive
parameter
t1
;

t1(bea_com_sum0,bea_ind_sum0) = 1$(use%BenchYr%_sum(bea_com_sum0,bea_ind_sum0) = 0 and use%DataYr%_in(bea_com_sum0,bea_ind_sum0) > 0);

display
t1
;
$offtext

*=======================create disaggragated %DataYr% final use colums=======================================================================================
parameter
final_use_%BenchYr%_sum(bea_com_sum0,final_use_det)
final_use_%BenchYr%_sum_det(bea_com_det0,final_use_det)
final_use_%BenchYr%_share(bea_com_det0,final_use_det)
final_use_%DataYr%_sum_det(bea_com_det0,final_use_det)
final_use(bea_com_det0,final_use_det)
imp_adj_%DataYr%_det(*)
com_final_use_tot(bea_com_det0)
com_final_use_tot_db(bea_com_sum0)
;
* Step 1: For each summary level industry, use detailed data to calculate benchmark summary level data

final_use_%BenchYr%_sum(bea_com_sum0,final_use_det) = sum(bea_com_det0,mapbea_com(bea_com_sum0,bea_com_det0)*final_use_%BenchYr%_in(bea_com_det0,final_use_det));

* Step 2: "Replicate" the benchmark summary level industry data to each detailed industry

final_use_%BenchYr%_sum_det(bea_com_det0,final_use_det) = sum(bea_com_sum0,mapbea_com(bea_com_sum0,bea_com_det0)*final_use_%BenchYr%_sum(bea_com_sum0,final_use_det));

* Step 3: Create benchmark share parameters for each summary industry -- careful not to divide by zero

final_use_%BenchYr%_share(bea_com_det0,final_use_det) $ (final_use_%BenchYr%_sum_det(bea_com_det0,final_use_det)<>0) = final_use_%BenchYr%_in(bea_com_det0,final_use_det)/final_use_%BenchYr%_sum_det(bea_com_det0,final_use_det);

* Step 4: "Replicate" the data-year summary level industry data to each detailed industry

final_use_%DataYr%_sum_det(bea_com_det0,final_use_det) = sum(bea_com_sum0,mapbea_com(bea_com_sum0,bea_com_det0)*sum(final_use_sum,map_final_use(final_use_sum,final_use_det)*final_use_%DataYr%_in(bea_com_sum0,final_use_sum)));

* Step 5: Create new annual detailed level data

final_use(bea_com_det0,final_use_det) = final_use_%BenchYr%_share(bea_com_det0,final_use_det)*final_use_%DataYr%_sum_det(bea_com_det0,final_use_det);

imp_adj_%DataYr%_det(impadj_det) = sum(impadj_sum,map_impadj(impadj_sum,impadj_det)*imp_adj_%DataYr%(impadj_sum));

com_final_use_tot(bea_com_det0) = sum(final_use_det,final_use(bea_com_det0,final_use_det)) + imp_adj_%DataYr%_det(bea_com_det0);

* alter row adjustment

final_use('s00900','f01000') = final_use_row - final_use('s00900','f04000') - final_use('s00900','f05000');
final_use('s00300','f01000') = final_use_%DataYr%_in('OTHER','f010') - final_use('s00900','f01000');


* Step 6: Check that sum of detailed final use matches data year totals

com_final_use_tot_db(bea_com_sum0) = sum(bea_com_det0,mapbea_com(bea_com_sum0,bea_com_det0)*com_final_use_tot(bea_com_det0)) - com_final_use_%DataYr%_tot(bea_com_sum0);


display
com_final_use_tot_db
;

* By assigning changes in FGD in the consistency routine (data_input_summary) creates new non-zero inventory, there is a chance there will be no consistency between summary benchmark and summary data year.
* Assign summary level data year to inventory for these cases manually for now.

final_use('493000','F03000') = -1;
final_use('515100','F03000') = 1;
final_use('611100','F03000') = -1;
final_use('622000','F03000') = -1;

com_final_use_tot(bea_com_det0) = sum(final_use_det,final_use(bea_com_det0,final_use_det)) + imp_adj_%DataYr%_det(bea_com_det0);
com_final_use_tot_db(bea_com_sum0) = sum(bea_com_det0,mapbea_com(bea_com_sum0,bea_com_det0)*com_final_use_tot(bea_com_det0)) - com_final_use_%DataYr%_tot(bea_com_sum0);

display
com_final_use_tot_db
;

*=============Check for Disaggregated Make/Use Consistency by industry/commodity =============

parameter
com_disagg_tot
ind_disagg_tot

com_disagg_diff
ind_disagg_diff

va_disagg_tot
fd_disagg_tot
va_fd_disagg_diff
;

com_disagg_tot(bea_com_det0) = com_use_tot(bea_com_det0) + com_final_use_tot(bea_com_det0);
ind_disagg_tot(bea_ind_det0) = ind_use_tot(bea_ind_det0) + ind_value_added_tot(bea_ind_det0);

com_disagg_diff(bea_com_det0) = com_disagg_tot(bea_com_det0) - com_make_tot(bea_com_det0);
ind_disagg_diff(bea_ind_det0) = ind_disagg_tot(bea_ind_det0) - ind_make_tot(bea_ind_det0);

va_disagg_tot = sum(bea_ind_det0,ind_value_added_tot(bea_ind_det0));
fd_disagg_tot = sum(bea_com_det0,com_final_use_tot(bea_com_det0));
va_fd_disagg_diff = va_disagg_tot - fd_disagg_tot;

display
com_make_tot
com_disagg_tot
com_disagg_diff

ind_make_tot
ind_disagg_tot
ind_disagg_diff

va_disagg_tot
fd_disagg_tot
va_fd_disagg_diff
;


display
final_use
;
