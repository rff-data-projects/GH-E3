

*(1) Define margin sets and import margin data
sets
margins0 /producer, transport, wholesale, retail, purchaser/
margins(margins0) /transport, wholesale, retail/
;

parameters
*I'm defining margins%BenchYr%_in over * because they are over industries and final uses
*note that the ordering of indices is ind, com, margins because that's the ordering in the excel sheet.  Ordinatilly I would list com, ind for use-table-related things
margins%BenchYr%_in(*,bea_com_det0,margins0)
;

*$CALL GDXXRW.EXE %Process%\Margins_%BenchYr%.xlsx o=%Process%\Margins_%BenchYr%.gdx par=margins%BenchYr%_in rng=A5:G61135 rdim = 2 cdim = 1
$GDXIN %Process%\Margins_%BenchYr%.gdx
$LOAD margins%BenchYr%_in
$GDXIN

margins%BenchYr%_in('711A00','441000','producer') = 0;
margins%BenchYr%_in('713100','441000','producer') = 0;
margins%BenchYr%_in('713100','332200','purchaser') = 0;
margins%BenchYr%_in('713100','332200','retail') = 0;
margins%BenchYr%_in('713100','444000','producer') = 0;


set
margin_com(bea_com_det0)

/
423100
423400
423600
423800
423A00
424200
424400
424700
424A00
425000
4200ID
441000
445000
452000
444000
446000
447000
448000
454000
4B0000
481000
482000
483000
484000
485000
486000
48A000
492000
493000
/
;

sets
margin_com_map(margin_com,margins)
/
423100 . wholesale
423400 . wholesale
423600 . wholesale
423800 . wholesale
423A00 . wholesale
424200 . wholesale
424400 . wholesale
424700 . wholesale
424A00 . wholesale
425000 . wholesale
4200ID . wholesale
441000 . retail
445000 . retail
452000 . retail
444000 . retail
446000 . retail
447000 . retail
448000 . retail
454000 . retail
4B0000 . retail
481000 . transport
482000 . transport
483000 . transport
484000 . transport
485000 . transport
486000 . transport
48A000 . transport
492000 . transport
493000 . transport
/
;

*(2) define benchmark year margin expenditure by commodity/industry and commodity/final use

parameter
producer_value_use_%BenchYr%(bea_com_det0,bea_ind_det0)
purchaser_value_use_%BenchYr%(bea_com_det0,bea_ind_det0)
producer_value_fu_%BenchYr%(bea_com_det0,final_use_det)
purchaser_value_fu_%BenchYr%(bea_com_det0,final_use_det)

use_margin_%BenchYr%(bea_com_det0,bea_ind_det0)
final_use_margin_%BenchYr%(bea_com_det0,final_use_det)
;




* Margin expenditures are difference between purchaser price and producer price

producer_value_use_%BenchYr%(bea_com_det0,bea_ind_det0) = margins%BenchYr%_in(bea_ind_det0,bea_com_det0,'producer');
purchaser_value_use_%BenchYr%(bea_com_det0,bea_ind_det0) = margins%BenchYr%_in(bea_ind_det0,bea_com_det0,'purchaser');
producer_value_fu_%BenchYr%(bea_com_det0,final_use_det) = margins%BenchYr%_in(final_use_det,bea_com_det0,'producer');
purchaser_value_fu_%BenchYr%(bea_com_det0,final_use_det) = margins%BenchYr%_in(final_use_det,bea_com_det0,'purchaser');



use_margin_%BenchYr%(bea_com_det0,bea_ind_det0) = (producer_value_use_%BenchYr%(bea_com_det0,bea_ind_det0)-purchaser_value_use_%BenchYr%(bea_com_det0,bea_ind_det0))$((producer_value_use_%BenchYr%(bea_com_det0,bea_ind_det0)-purchaser_value_use_%BenchYr%(bea_com_det0,bea_ind_det0))>=0);
final_use_margin_%BenchYr%(bea_com_det0,final_use_det) = (producer_value_fu_%BenchYr%(bea_com_det0,final_use_det)-purchaser_value_fu_%BenchYr%(bea_com_det0,final_use_det))$((producer_value_fu_%BenchYr%(bea_com_det0,final_use_det)-purchaser_value_fu_%BenchYr%(bea_com_det0,final_use_det))>=0);
final_use_margin_%BenchYr%(bea_com_det0,'F03000') = 0;



*(3) Using benchmark year data, for each margin commodity, calculate the share of overall demand (by industry or final good) that is margin demand
parameters
use_margin_share(bea_com_det0,bea_ind_det0)
final_use_margin_share(bea_com_det0,final_use_det)
;

use_margin_share(margin_com,bea_ind_det0)$(use%BenchYr%_in(margin_com,bea_ind_det0)<>0) = use_margin_%BenchYr%(margin_com,bea_ind_det0)/use%BenchYr%_in(margin_com,bea_ind_det0);
final_use_margin_share(margin_com,final_use_det)$(final_use_%BenchYr%_in(margin_com,final_use_det)<>0)= final_use_margin_%BenchYr%(margin_com,final_use_det)/final_use_%BenchYr%_in(margin_com,final_use_det);




*(4) apply the benchmark year margin shares to the annual disaggregated use and final use matrices to create annual use margins and use goods values

parameters
use_margin(bea_com_det0,bea_ind_det0)
use_goods(bea_com_det0,bea_ind_det0)
final_use_margin(bea_com_det0,final_use_det)
final_use_goods(bea_com_det0,final_use_det)
;

use_margin(bea_com_det0,bea_ind_det0) = use_margin_share(bea_com_det0,bea_ind_det0)*use(bea_com_det0,bea_ind_det0);
use_goods(bea_com_det0,bea_ind_det0) = use(bea_com_det0,bea_ind_det0)-use_margin(bea_com_det0,bea_ind_det0);
final_use_margin(bea_com_det0,final_use_det) = final_use_margin_share(bea_com_det0,final_use_det)*final_use(bea_com_det0,final_use_det);
final_use_goods(bea_com_det0,final_use_det) = final_use(bea_com_det0,final_use_det)-final_use_margin(bea_com_det0,final_use_det);



*(5) calculate benchmark year industry and final use margin requirements for each commodity by type of margin

parameters
mr_%BenchYr%_use(bea_ind_det0,bea_com_det0,margins)
mr_%BenchYr%_final_use(final_use_det,bea_com_det0,margins)
;


mr_%BenchYr%_use(bea_ind_det0,bea_com_det0,margins)$(margins%BenchYr%_in(bea_ind_det0,bea_com_det0,'producer')<>0)=margins%BenchYr%_in(bea_ind_det0,bea_com_det0,margins)/margins%BenchYr%_in(bea_ind_det0,bea_com_det0,'producer');
mr_%BenchYr%_final_use(final_use_det,bea_com_det0,margins)$(margins%BenchYr%_in(final_use_det,bea_com_det0,'producer')<>0)= margins%BenchYr%_in(final_use_det,bea_com_det0,margins)/margins%BenchYr%_in(final_use_det,bea_com_det0,'producer');



*(6) scale the %BenchYr% margin requirements to be consistent with %DataYr% level of total margin spending and convert from margin types to margin commodities


* calculate %DataYr% margin totals based on the %BenchYr% margin requirements and the calculated %DataYr% goods

parameters
use_margin_temp(bea_com_det0,bea_ind_det0,margins)
final_use_margin_temp(bea_com_det0,final_use_det,margins)
;

use_margin_temp(bea_com_det0,bea_ind_det0,margins)=mr_%BenchYr%_use(bea_ind_det0,bea_com_det0,margins)*use_goods(bea_com_det0,bea_ind_det0);
final_use_margin_temp(bea_com_det0,final_use_det,margins)=mr_%BenchYr%_final_use(final_use_det,bea_com_det0,margins)*final_use_goods(bea_com_det0,final_use_det);



* compare the margin spending as calculated in use_margin_%DataYr% to use_margin_temp
* these will not be equal, generally

parameters
use_margin_check(bea_ind_det0,margins)
final_use_margin_check(final_use_det,margins)
;

use_margin_check(bea_ind_det0,margins) = sum(margin_com,use_margin(margin_com,bea_ind_det0)*margin_com_map(margin_com,margins))-sum(bea_com_det0,use_margin_temp(bea_com_det0,bea_ind_det0,margins));
final_use_margin_check(final_use_det,margins)=sum(margin_com,final_use_margin(margin_com,final_use_det)*margin_com_map(margin_com,margins))-sum(bea_com_det0,final_use_margin_temp(bea_com_det0,final_use_det,margins));

display
use_margin_check
final_use_margin_check
;


* scale margin requirements such that total margin expenditures by type match calculation from step (4)

parameters
mr_use(bea_com_det0,bea_ind_det0,margins)
mr_final_use(bea_com_det0,final_use_det,margins)
;

mr_use(bea_com_det0,bea_ind_det0,margins)$(sum(bea_com_det00,use_margin_temp(bea_com_det00,bea_ind_det0,margins))<>0)
=mr_%BenchYr%_use(bea_ind_det0,bea_com_det0,margins)*sum(margin_com,use_margin(margin_com,bea_ind_det0)*margin_com_map(margin_com,margins))/sum(bea_com_det00,use_margin_temp(bea_com_det00,bea_ind_det0,margins));

mr_final_use(bea_com_det0,final_use_det,margins)$(sum(bea_com_det00,final_use_margin_temp(bea_com_det00,final_use_det,margins))<>0)
= mr_%BenchYr%_final_use(final_use_det,bea_com_det0,margins)*sum(margin_com,final_use_margin(margin_com,final_use_det)*margin_com_map(margin_com,margins))/sum(bea_com_det00,final_use_margin_temp(bea_com_det00,final_use_det,margins));



* verify the margin requirement scaling worked successfully.

parameters
use_margin_check2(bea_ind_det0,margins)
final_use_margin_check2(final_use_det,margins)
;

final_use_margin_check2(final_use_det,margins) = sum(margin_com,final_use_margin(margin_com,final_use_det)*margin_com_map(margin_com,margins)) - sum(bea_com_det0,mr_final_use(bea_com_det0,final_use_det,margins)*final_use_goods(bea_com_det0,final_use_det));
use_margin_check2(bea_ind_det0,margins)=sum(margin_com,use_margin(margin_com,bea_ind_det0)*margin_com_map(margin_com,margins))-sum(bea_com_det0,mr_use(bea_com_det0,bea_ind_det0,margins)*use_goods(bea_com_det0,bea_ind_det0));


display
use_margin_check2
final_use_margin_check2
;

*(7) Divide mr_use and mr_final_use to margin commodities

parameters
use_margin_tot(bea_ind_det0,margins)
final_use_margin_tot(final_use_det,margins)
use_margin_share2(bea_ind_det0,margin_com)
final_use_margin_share2(final_use_det,margin_com)
mr_use_com(bea_com_det0,bea_ind_det0,margin_com)
mr_final_use_com(bea_com_det0,final_use_det,margin_com)
;

* create matrices that contain the total margin spending by margin type by industry/final demand

use_margin_tot(bea_ind_det0,margins)=sum(margin_com,use_margin(margin_com,bea_ind_det0)*margin_com_map(margin_com,margins));
final_use_margin_tot(final_use_det,margins)=sum(margin_com,final_use_margin(margin_com,final_use_det)*margin_com_map(margin_com,margins));



* create matrices that contain margin_com shares of each of those

use_margin_share2(bea_ind_det0,margin_com)$(sum(margins,use_margin_tot(bea_ind_det0,margins)*margin_com_map(margin_com,margins))<>0)
         = use_margin(margin_com,bea_ind_det0)/sum(margins,use_margin_tot(bea_ind_det0,margins)*margin_com_map(margin_com,margins));

final_use_margin_share2(final_use_det,margin_com)$(sum(margins,margin_com_map(margin_com,margins)*final_use_margin_tot(final_use_det,margins))<>0)
         = final_use_margin(margin_com,final_use_det)/sum(margins,margin_com_map(margin_com,margins)*final_use_margin_tot(final_use_det,margins));


mr_use_com(bea_com_det0,bea_ind_det0,margin_com)=sum(margins,margin_com_map(margin_com,margins)*mr_use(bea_com_det0,bea_ind_det0,margins))*use_margin_share2(bea_ind_det0,margin_com);
mr_final_use_com(bea_com_det0,final_use_det,margin_com)=sum(margins,margin_com_map(margin_com,margins)*mr_final_use(bea_com_det0,final_use_det,margins))*final_use_margin_share2(final_use_det,margin_com);



display
mr_use_com
mr_final_use_com
;

*check that mr_use_com equals mr_use if we sum accross each row.  yup
parameter mr_ck(bea_com_det0,bea_ind_det0);
mr_ck(bea_com_det0,bea_ind_det0)$(sum(margin_com,mr_use_com(bea_com_det0,bea_ind_det0,margin_com)) > 0) = sum(margins,mr_use(bea_com_det0,bea_ind_det0,margins))/sum(margin_com,mr_use_com(bea_com_det0,bea_ind_det0,margin_com)) - 1;
mr_ck(bea_com_det0,bea_ind_det0) = 0$(abs(mr_ck(bea_com_det0,bea_ind_det0) < .01))
display mr_ck;

*Define total margin use over commodity, industry/final good, margin commodity

parameter
use_margin_com(bea_com_det0,bea_ind_det0,margin_com)
final_use_margin_com(bea_com_det0,final_use_det,margin_com)

use_margin_com_check(bea_ind_det0)
final_use_margin_com_check(final_use_det)
;
use_margin_com(bea_com_det0,bea_ind_det0,margin_com) = mr_use_com(bea_com_det0,bea_ind_det0,margin_com)*use_goods(bea_com_det0,bea_ind_det0);
final_use_margin_com(bea_com_det0,final_use_det,margin_com) = mr_final_use_com(bea_com_det0,final_use_det,margin_com)*final_use_goods(bea_com_det0,final_use_det);

use_margin_com_check(bea_ind_det0) = sum(margin_com,sum(bea_com_det0,use_margin_com(bea_com_det0,bea_ind_det0,margin_com))) - sum(margin_com,use_margin(margin_com,bea_ind_det0));
final_use_margin_com_check(final_use_det) = sum(margin_com,sum(bea_com_det0,final_use_margin_com(bea_com_det0,final_use_det,margin_com))) - sum(margin_com,final_use_margin(margin_com,final_use_det));

display
use_margin_com_check
final_use_margin_com_check
;

parameter
final_use_db
final_use_com
final_use_com_margin
final_use_com_db
;

final_use_db(final_use_det) = sum(bea_com_det0,final_use_goods(bea_com_det0,final_use_det) + sum(margin_com,final_use_margin_com(bea_com_det0,final_use_det,margin_com)))/1000000;

final_use_com(bea_com_det0) = sum(final_use_det,final_use_goods(bea_com_det0,final_use_det));
final_use_com_margin(margin_com) = sum(final_use_det,sum(bea_com_det0,final_use_margin_com(bea_com_det0,final_use_det,margin_com)));

final_use_com_db(bea_com_det0) = (com_final_use_tot(bea_com_det0)- imp_adj_%DataYr%_det(bea_com_det0))-final_use_com(bea_com_det0)-final_use_com_margin(bea_com_det0);

display
final_use_com_db
final_use_db
;


