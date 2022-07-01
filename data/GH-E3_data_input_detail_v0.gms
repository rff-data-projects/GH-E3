

*===================================import %BenchYr% make tables====================================================================================================================================================================

* Define input parameters for Make Tables
parameters
make%BenchYr%_in(bea_ind_det0,bea_com_det0)
com_make%BenchYr%_tot
ind_make%BenchYr%_tot
;

*$CALL GDXXRW.EXE %Process%\Make_AfterRedef_%BenchYr%_Detailed_NoLabels.xlsx o=%Process%\Make_AfterRedef_%BenchYr%_Detailed_NoLabels.gdx par=make%BenchYr%_in rng=A1:OT410 cdim = 1 rdim = 1

$GDXIN %Process%\Make_AfterRedef_%BenchYr%_Detailed_NoLabels.gdx
$LOAD make%BenchYr%_in
$GDXIN

*Adjustments made because the data year make table has positive value at summary level but is zero in benchmark year at detailed level (due to rounding to zero)
make%BenchYr%_in('339990','233230') = 1;
make%BenchYr%_in('321100','313100') = 1;
make%BenchYr%_in('311410','313200') = 1;
make%BenchYr%_in('333111','324190') = 1;

make%BenchYr%_in(bea_ind_det0,bea_com_det0)$(make%BenchYr%_in(bea_ind_det0,bea_com_det0) < 0) = 0;


com_make%BenchYr%_tot(bea_com_det0) = sum(bea_ind_det0,make%BenchYr%_in(bea_ind_det0,bea_com_det0));
ind_make%BenchYr%_tot(bea_ind_det0) = sum(bea_com_det0,make%BenchYr%_in(bea_ind_det0,bea_com_det0));


*=================================import value added %BenchYr% rows==========================================================================================================================================
*define input parameters for value added row vectors

parameters
value_added_%BenchYr%_in(value_added_det,bea_ind_det0)
ind_value_added_%BenchYr%_tot
;

* Load excel files into input parameters

*$CALL GDXXRW.EXE %Process%\Use_AfterRedef_%BenchYr%_ValueAdded_NoLabels.xlsx o=%Process%\Use_AfterRedef_%BenchYr%_ValueAdded_NoLabels.gdx par=value_added_%BenchYr%_in rng=A1:OP4 cdim = 1 rdim = 1

$GDXIN %Process%\Use_AfterRedef_%BenchYr%_ValueAdded_NoLabels.gdx
$LOAD value_added_%BenchYr%_in
$GDXIN

* Eliminate negative gross operating surplus by shifting gross operating surplus to TOPI

value_added_%BenchYr%_in('V00200','491000') = value_added_%BenchYr%_in('V00200','491000') + (value_added_%BenchYr%_in('V00300','491000')-100);
value_added_%BenchYr%_in('V00300','491000') = 100;
value_added_%BenchYr%_in('V00200','S00201') = value_added_%BenchYr%_in('V00200','S00201') + (value_added_%BenchYr%_in('V00300','S00201')-100);
value_added_%BenchYr%_in('V00300','S00201') = 100;

display
value_added_%BenchYr%_in
;

ind_value_added_%BenchYr%_tot(bea_ind_det0) = sum(value_added_det,value_added_%BenchYr%_in(value_added_det,bea_ind_det0));

*====================================import %BenchYr% use table===========================================================================================================================================================================
* Define input parameters for Use Tables
parameters
use%BenchYr%_in(bea_com_det0,bea_ind_det0)
com_use%BenchYr%_tot
ind_use%BenchYr%_tot
;

* Load excel files into input parameters

*$CALL GDXXRW.EXE %Process%\Use_AfterRedef_%BenchYr%_Detailed_NoLabels.xlsx o=%Process%\Use_AfterRedef_%BenchYr%_Detailed_NoLabels.gdx par=use%BenchYr%_in rng=A1:OP406 cdim = 1 rdim = 1


$GDXIN %Process%\Use_AfterRedef_%BenchYr%_Detailed_NoLabels.gdx
$LOAD use%BenchYr%_in
$GDXIN

*Adjustment made because the data year use table has positive value at summary level but is blank in all detailed rows/columns in benchmark year
use%BenchYr%_in('S00402','532A00') = 1;
use%BenchYr%_in('711100','531HST') = 1;
use%BenchYr%_in('493000','531HST') = 1;
use%BenchYr%_in('491000','531HST') = 1;
use%BenchYr%_in('486000','531HST') = 1;
use%BenchYr%_in('322130','531HST') = 1;
use%BenchYr%_in('313200','531HST') = 1;
use%BenchYr%_in('331110','531HST') = 1;
use%BenchYr%_in('111400','531HST') = 1;
use%BenchYr%_in('445000','332114') = 1;
use%BenchYr%_in('486000','334111') = 1;
use%BenchYr%_in('314900','335312') = 1;
use%BenchYr%_in('441000','335312') = 1;
use%BenchYr%_in('445000','335312') = 1;
use%BenchYr%_in('212310','485000') = 1;
use%BenchYr%_in('483000','511110') = 1;
use%BenchYr%_in('483000','512100') = 1;
use%BenchYr%_in('486000','541100') = 1;
use%BenchYr%_in('337215','541511') = 1;
use%BenchYr%_in('336999','550000') = 1;
use%BenchYr%_in('486000','711100') = 1;
use%BenchYr%_in('445000','713100') = 1;
use%BenchYr%_in('4B0000','S00102') = 1;

com_use%BenchYr%_tot(bea_com_det0) = sum(bea_ind_det0,use%BenchYr%_in(bea_com_det0,bea_ind_det0));
ind_use%BenchYr%_tot(bea_ind_det0) = sum(bea_com_det0,use%BenchYr%_in(bea_com_det0,bea_ind_det0));

*==========================import %BenchYr%  final use columns=================================================================================================================================================
*define input parameters for final use column vectors
parameters
final_use_%BenchYr%_in(bea_com_det0,final_use_det)
imp_adj_%BenchYr%(bea_com_det0)
final_use_row
com_final_use_%BenchYr%_tot
;

* Load excel files into use tables
*$CALL GDXXRW.EXE %Process%\Use_AfterRedef_%BenchYr%_FinalUse_NoLabels.xlsx o=%Process%\Use_AfterRedef_%BenchYr%_FinalUse_NoLabels.gdx  par=final_use_%BenchYr%_in rng=A1:U406 cdim = 1 rdim = 1
*$CALL GDXXRW.EXE %Process%\ImportAdj%BenchYr%_%DataYr%.xlsx o=%Process%\ImportAdj_%BenchYr%.gdx  par=imp_adj_%BenchYr% rng=%BenchYr%_det!A2:B9 rdim = 1

$GDXIN %Process%\Use_AfterRedef_%BenchYr%_FinalUse_NoLabels.gdx
$LOAD final_use_%BenchYr%_in
$GDXIN

$GDXIN %Process%\ImportAdj_%BenchYr%.gdx
$LOAD imp_adj_%BenchYr%
$GDXIN


final_use_%BenchYr%_in(bea_com_det0,'F05000') = final_use_%BenchYr%_in(bea_com_det0,'F05000') - imp_adj_%BenchYr%(bea_com_det0);


com_final_use_%BenchYr%_tot(bea_com_det0) = sum(final_use_det,final_use_%BenchYr%_in(bea_com_det0,final_use_det))+imp_adj_%BenchYr%(bea_com_det0) ;


*=============Check for Make/Use Consistency by industry/commodity =============

parameter
com_det_tot
ind_det_tot

com_det_diff
ind_det_diff

va_det_tot
fd_det_tot
va_fd_det_diff
;

com_det_tot(bea_com_det0) = com_use%BenchYr%_tot(bea_com_det0) + com_final_use_%BenchYr%_tot(bea_com_det0);
ind_det_tot(bea_ind_det0) = ind_use%BenchYr%_tot(bea_ind_det0) + ind_value_added_%BenchYr%_tot(bea_ind_det0);

com_det_diff(bea_com_det0) = com_det_tot(bea_com_det0) - com_make%BenchYr%_tot(bea_com_det0);
ind_det_diff(bea_ind_det0) = ind_det_tot(bea_ind_det0) - ind_make%BenchYr%_tot(bea_ind_det0);

va_det_tot = sum(bea_ind_det0,ind_value_added_%BenchYr%_tot(bea_ind_det0));
fd_det_tot = sum(bea_com_det0,com_final_use_%BenchYr%_tot(bea_com_det0));
va_fd_det_diff = va_det_tot - fd_det_tot;

display
com_make%BenchYr%_tot
com_det_tot
com_det_diff

ind_make%BenchYr%_tot
ind_det_tot
ind_det_diff

va_det_tot
fd_det_tot
va_fd_det_diff
;

*=============Alter VA/FGD for Make/Use Consistency by industry/commodity =============


* Define total consistent value added, use value added component shares to assign new value to each component

parameter
va_det_share(value_added_det,bea_ind_det0)
va_det_temp(bea_ind_det0)
;


va_det_share(value_added_det,bea_ind_det0)$(ind_value_added_%BenchYr%_tot(bea_ind_det0) <> 0) = value_added_%BenchYr%_in(value_added_det,bea_ind_det0)/ind_value_added_%BenchYr%_tot(bea_ind_det0);
va_det_temp(bea_ind_det0) = ind_make%BenchYr%_tot(bea_ind_det0) - ind_use%BenchYr%_tot(bea_ind_det0);
value_added_%BenchYr%_in(value_added_det,bea_ind_det0) = va_det_share(value_added_det,bea_ind_det0)*va_det_temp(bea_ind_det0);
ind_value_added_%BenchYr%_tot(bea_ind_det0) = sum(value_added_det,value_added_%BenchYr%_in(value_added_det,bea_ind_det0));
ind_det_tot(bea_ind_det0) = ind_use%BenchYr%_tot(bea_ind_det0) + ind_value_added_%BenchYr%_tot(bea_ind_det0);
ind_det_diff(bea_ind_det0) = ind_det_tot(bea_ind_det0) - ind_make%BenchYr%_tot(bea_ind_det0);

display
ind_det_diff
;


* Assign consistency adjustment value to "inventory"

final_use_%BenchYr%_in(bea_com_det0,inv_det) = com_make%BenchYr%_tot(bea_com_det0) - com_use%BenchYr%_tot(bea_com_det0) -
sum(finuse_det,final_use_%BenchYr%_in(bea_com_det0,finuse_det))-imp_adj_%BenchYr%(bea_com_det0);

com_final_use_%BenchYr%_tot(bea_com_det0) = sum(final_use_det,final_use_%BenchYr%_in(bea_com_det0,final_use_det))+imp_adj_%BenchYr%(bea_com_det0) ;
com_det_tot(bea_com_det0) = com_use%BenchYr%_tot(bea_com_det0) + com_final_use_%BenchYr%_tot(bea_com_det0);
com_det_diff(bea_com_det0) = com_det_tot(bea_com_det0) - com_make%BenchYr%_tot(bea_com_det0);

display
com_det_diff
;

* Check again for va/fgd consistency

va_det_tot = sum(bea_ind_det0,ind_value_added_%BenchYr%_tot(bea_ind_det0));
fd_det_tot = sum(bea_com_det0,com_final_use_%BenchYr%_tot(bea_com_det0));
va_fd_det_diff = va_det_tot - fd_det_tot;

display
va_fd_det_diff
;


* Congratulations: you have a consistent detailed level dataset
