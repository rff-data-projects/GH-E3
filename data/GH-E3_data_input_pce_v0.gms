
*=========================================================import PCE bridge data===========================================================================================================================================================


parameters
pce%BenchYr%_in(pce_det,bea_com_det0,pce_categories)
pce%DataYr%_in(pce_sum,bea_com_sum0,pce_categories)
;

*note that to make this import work I had to rename the set columns in excel.
*$CALL GDXXRW.EXE %Process%\pce_%BenchYr%_detailed.xlsx o=%Process%\pce_%BenchYr%_detailed.gdx par=pce%BenchYr%_in rng=A1:G713 rdim=2 cdim=1
$GDXIN %Process%\pce_%BenchYr%_detailed.gdx
$LOAD pce%BenchYr%_in
$GDXIN

*$CALL GDXXRW.EXE %Process%\pce_%DataYr%_summary.xlsx o=%Process%\pce_%DataYr%_summary.gdx par=pce%DataYr%_in rng=A1:G302 rdim=2 cdim=1
$GDXIN %Process%\pce_%DataYr%_summary.gdx
$LOAD pce%DataYr%_in
$GDXIN



*=========================================================disaggregate PCE data=====================================================================================================================================================
*Disaggregate Annual Summary Level Data using Benchmark Detailed  Level Data

parameter
pce_%BenchYr%_sum_partial(pce_det,bea_com_sum0,pce_categories)
pce_%BenchYr%_sum(pce_sum,bea_com_sum0,pce_categories)
pce_%BenchYr%_sum_det(pce_det,bea_com_det0,pce_categories)
pce_%BenchYr%_share(pce_det,bea_com_det0,pce_categories)
pce_%DataYr%_sum_det(pce_det,bea_com_det0,pce_categories)
pce_%DataYr%_det(pce_det,bea_com_det0,pce_categories)
;


pce_%BenchYr%_sum_partial(pce_det,bea_com_sum0,pce_categories)= sum(bea_com_det0,   mapbea_com(bea_com_sum0,bea_com_det0)*pce%BenchYr%_in(pce_det,bea_com_det0,pce_categories));

* Step 1: For each summary level industry, use detailed data to calculate benchmark summary level data
pce_%BenchYr%_sum(pce_sum,bea_com_sum0,pce_categories) = sum(pce_det,    map_pce(pce_det,pce_sum)*sum(bea_com_det0,   mapbea_com(bea_com_sum0,bea_com_det0)*pce%BenchYr%_in(pce_det,bea_com_det0,pce_categories)));

* Step 2: "Replicate" the benchmark summary level industry data to each detailed industry
pce_%BenchYr%_sum_det(pce_det,bea_com_det0,pce_categories) = sum(pce_sum,   map_pce(pce_det,pce_sum)*sum(bea_com_sum0,  mapbea_com(bea_com_sum0,bea_com_det0)*pce_%BenchYr%_sum(pce_sum,bea_com_sum0,pce_categories)));

* Step 3: Create benchmark share parameters for each summary industry -- careful not to divide by zero
pce_%BenchYr%_share(pce_det,bea_com_det0,pce_categories) $ (pce_%BenchYr%_sum_det(pce_det,bea_com_det0,pce_categories)<>0) = pce%BenchYr%_in(pce_det,bea_com_det0,pce_categories)/pce_%BenchYr%_sum_det(pce_det,bea_com_det0,pce_categories);

* Step 4: "Replicate" the data-year summary level industry data to each detailed industry
pce_%DataYr%_sum_det(pce_det,bea_com_det0,pce_categories)= sum(pce_sum,   map_pce(pce_det,pce_sum)*sum(bea_com_sum0,mapbea_com(bea_com_sum0,bea_com_det0)*pce%DataYr%_in(pce_sum,bea_com_sum0,pce_categories)));

* Step 5: Create new annual detailed level data
pce_%DataYr%_det(pce_det,bea_com_det0,pce_categories) = pce_%BenchYr%_share(pce_det,bea_com_det0,pce_categories) * pce_%DataYr%_sum_det(pce_det,bea_com_det0,pce_categories)



* Check if total spending is equal between fd and pce

parameter
pce_purch_db
pce_prod_db
;

pce_prod_db = sum(bea_com_det0,final_use_goods(bea_com_det0,'F01000')) - sum(pce_det,sum(bea_com_det0,pce_%DataYr%_det(pce_det,bea_com_det0,"Producers' Value")));
pce_purch_db = sum(margin_com,sum(bea_com_det0,final_use_margin_com(bea_com_det0,'F01000',margin_com))) + sum(bea_com_det0,final_use_goods(bea_com_det0,'F01000')) - sum(pce_det,sum(bea_com_det0,pce_%DataYr%_det(pce_det,bea_com_det0,"Purchasers' Value")));

display
pce_purch_db
pce_prod_db
;

*scale pce data to be consistent with final_use data


pce_%DataYr%_det(pce_det,bea_com_det0,"Producers' Value") = pce_%DataYr%_det(pce_det,bea_com_det0,"Producers' Value") * ( (final_use_goods(bea_com_det0,'F01000'))  / sum(pce_det0,pce_%DataYr%_det(pce_det0,bea_com_det0,"Producers' Value")));
pce_prod_db = sum(bea_com_det0,final_use_goods(bea_com_det0,'F01000')) - sum(pce_det,sum(bea_com_det0,pce_%DataYr%_det(pce_det,bea_com_det0,"Producers' Value")));


display
pce_prod_db
;
