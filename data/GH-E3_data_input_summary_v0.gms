

*===================================import %DataYr% make tables====================================================================================================================================================================

* Define input parameters for Make Tables
parameters
make%DataYr%_in(bea_ind_sum0,bea_com_sum0)
com_make%DataYr%_tot
ind_make%DataYr%_tot
;

*$CALL GDXXRW.EXE %Process%\Make_AfterRedef_%DataYr%_Summary_NoLabels.xlsx o=%Process%\Make_AfterRedef_%DataYr%_Summary_NoLabels.gdx par=make%DataYr%_in rng=A1:BV72 cdim = 1 rdim = 1

$GDXIN %Process%\Make_AfterRedef_%DataYr%_Summary_NoLabels.gdx
$LOAD make%DataYr%_in
$GDXIN

make%DataYr%_in(bea_ind_sum0,bea_com_sum0)$(make%DataYr%_in(bea_ind_sum0,bea_com_sum0) < 0) = 0;


com_make%DataYr%_tot(bea_com_sum0) = sum(bea_ind_sum0,make%DataYr%_in(bea_ind_sum0,bea_com_sum0));
ind_make%DataYr%_tot(bea_ind_sum0) = sum(bea_com_sum0,make%DataYr%_in(bea_ind_sum0,bea_com_sum0));


*=================================import value added %DataYr% rows==========================================================================================================================================
*define input parameters for value added row vectors

parameters
value_added_%DataYr%_in(value_added_sum,bea_ind_sum0)
ind_value_added_%DataYr%_tot
;

* Load excel files into input parameters

*$CALL GDXXRW.EXE %Process%\Use_AfterRedef_%DataYr%_ValueAdded_NoLabels.xlsx o=%Process%\Use_AfterRedef_%DataYr%_ValueAdded_NoLabels.gdx par=value_added_%DataYr%_in rng=A1:BT4 cdim = 1 rdim = 1

$GDXIN %Process%\Use_AfterRedef_%DataYr%_ValueAdded_NoLabels.gdx
$LOAD value_added_%DataYr%_in
$GDXIN


ind_value_added_%DataYr%_tot(bea_ind_sum0) = sum(value_added_sum,value_added_%DataYr%_in(value_added_sum,bea_ind_sum0));

*====================================import %DataYr% use table===========================================================================================================================================================================
* Define input parameters for Use Tables
parameters
use%DataYr%_in(bea_com_sum0,bea_ind_sum0)
com_use%DataYr%_tot
ind_use%DataYr%_tot
;

* Load excel files into input parameters

*$CALL GDXXRW.EXE %Process%\Use_AfterRedef_%DataYr%_Summary_NoLabels.xlsx o=%Process%\Use_AfterRedef_%DataYr%_Summary_NoLabels.gdx par=use%DataYr%_in rng=A1:BT74 cdim = 1 rdim = 1


$GDXIN %Process%\Use_AfterRedef_%DataYr%_Summary_NoLabels.gdx
$LOAD use%DataYr%_in
$GDXIN


com_use%DataYr%_tot(bea_com_sum0) = sum(bea_ind_sum0,use%DataYr%_in(bea_com_sum0,bea_ind_sum0));
ind_use%DataYr%_tot(bea_ind_sum0) = sum(bea_com_sum0,use%DataYr%_in(bea_com_sum0,bea_ind_sum0));

*==========================import %DataYr% final use columns=================================================================================================================================================
*define input parameters for final use column vectors
parameters
final_use_%DataYr%_in(bea_com_sum0,final_use_sum)
imp_adj_%DataYr%(bea_com_sum0)
final_use_row
com_final_use_%DataYr%_tot
;

* Load excel files into use tables
*$CALL GDXXRW.EXE %Process%\Use_AfterRedef_%DataYr%_FinalUse_NoLabels.xlsx o=%Process%\Use_AfterRedef_%DataYr%_FinalUse_NoLabels.gdx  par=final_use_%DataYr%_in rng=A1:U74 cdim = 1 rdim = 1
*$CALL GDXXRW.EXE %Process%\ImportAdj%BenchYr%_%DataYr%.xlsx o=%Process%\ImportAdj_%DataYr%.gdx  par=imp_adj_%DataYr% rng=%DataYr%_sum!A2:B9 rdim = 1

$GDXIN %Process%\Use_AfterRedef_%DataYr%_FinalUse_NoLabels.gdx
$LOAD final_use_%DataYr%_in
$GDXIN


$GDXIN %Process%\ImportAdj_%DataYr%.gdx
$LOAD imp_adj_%DataYr%
$GDXIN



final_use_%DataYr%_in(bea_com_sum0,'F050') = final_use_%DataYr%_in(bea_com_sum0,'F050') - imp_adj_%DataYr%(bea_com_sum0);
final_use_row = sum(final_use_sum,final_use_%DataYr%_in('OTHER',final_use_sum))+sum(bea_ind_sum0,use%DataYr%_in('OTHER',bea_ind_sum0));


com_final_use_%DataYr%_tot(bea_com_sum0) = sum(final_use_sum,final_use_%DataYr%_in(bea_com_sum0,final_use_sum))+imp_adj_%DataYr%(bea_com_sum0) ;


*=============Check for Make/Use Consistency by industry/commodity =============

parameter
com_tot
ind_tot

com_diff
ind_diff

va_tot
fd_tot
va_fd_diff
;

com_tot(bea_com_sum0) = com_use%DataYr%_tot(bea_com_sum0) + com_final_use_%DataYr%_tot(bea_com_sum0);
ind_tot(bea_ind_sum0) = ind_use%DataYr%_tot(bea_ind_sum0) + ind_value_added_%DataYr%_tot(bea_ind_sum0);

com_diff(bea_com_sum0) = com_tot(bea_com_sum0) - com_make%DataYr%_tot(bea_com_sum0);
ind_diff(bea_ind_sum0) = ind_tot(bea_ind_sum0) - ind_make%DataYr%_tot(bea_ind_sum0);

va_tot = sum(bea_ind_sum0,ind_value_added_%DataYr%_tot(bea_ind_sum0));
fd_tot = sum(bea_com_sum0,com_final_use_%DataYr%_tot(bea_com_sum0));
va_fd_diff = va_tot - fd_tot;

display
com_make%DataYr%_tot
com_tot
com_diff

ind_make%DataYr%_tot
ind_tot
ind_diff

va_tot
fd_tot
va_fd_diff
;

*=============Alter VA/FGD for Make/Use Consistency by industry/commodity =============


* Define total consistent value added, use value added component shares to assign new value to each component

parameter
va_share(value_added_sum,bea_ind_sum0)
va_temp(bea_ind_sum0)
;


va_share(value_added_sum,bea_ind_sum0)$(ind_value_added_%DataYr%_tot(bea_ind_sum0) <> 0) = value_added_%DataYr%_in(value_added_sum,bea_ind_sum0)/ind_value_added_%DataYr%_tot(bea_ind_sum0);
va_temp(bea_ind_sum0) = ind_make%DataYr%_tot(bea_ind_sum0) - ind_use%DataYr%_tot(bea_ind_sum0);
value_added_%DataYr%_in(value_added_sum,bea_ind_sum0) = va_share(value_added_sum,bea_ind_sum0)*va_temp(bea_ind_sum0);
ind_value_added_%DataYr%_tot(bea_ind_sum0) = sum(value_added_sum,value_added_%DataYr%_in(value_added_sum,bea_ind_sum0));
ind_tot(bea_ind_sum0) = ind_use%DataYr%_tot(bea_ind_sum0) + ind_value_added_%DataYr%_tot(bea_ind_sum0);
ind_diff(bea_ind_sum0) = ind_tot(bea_ind_sum0) - ind_make%DataYr%_tot(bea_ind_sum0);

display
ind_diff
;


* Assign consistency adjustment value to "inventory"

final_use_%DataYr%_in(bea_com_sum0,inv_sum) = com_make%DataYr%_tot(bea_com_sum0) - com_use%DataYr%_tot(bea_com_sum0) -
sum(finuse_sum,final_use_%DataYr%_in(bea_com_sum0,finuse_sum))-imp_adj_%DataYr%(bea_com_sum0);

com_final_use_%DataYr%_tot(bea_com_sum0) = sum(final_use_sum,final_use_%DataYr%_in(bea_com_sum0,final_use_sum))+imp_adj_%DataYr%(bea_com_sum0) ;
com_tot(bea_com_sum0) = com_use%DataYr%_tot(bea_com_sum0) + com_final_use_%DataYr%_tot(bea_com_sum0);
com_diff(bea_com_sum0) = com_tot(bea_com_sum0) - com_make%DataYr%_tot(bea_com_sum0);

display
com_diff
;

* Check again for va/fgd consistency

va_tot = sum(bea_ind_sum0,ind_value_added_%DataYr%_tot(bea_ind_sum0));
fd_tot = sum(bea_com_sum0,com_final_use_%DataYr%_tot(bea_com_sum0));
va_fd_diff = va_tot - fd_tot;

display
va_fd_diff
final_use_row
;



* Congratulations: you have a consistent summary level dataset
