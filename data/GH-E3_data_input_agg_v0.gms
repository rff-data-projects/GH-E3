

*======Aggregate detailed level parameters to summary-plus level of aggregation=============================

* Define new aggregate margin commodities and mappings

set margin_agg(bea_com_agg0) /com34*com46/;

sets
map_margin_agg(margin_com,margin_agg)
/
423100 . com34
423400 . com34
423600 . com34
423800 . com34
423A00 . com34
424200 . com34
424400 . com34
424700 . com34
424A00 . com34
425000 . com34
4200ID . com34
441000 . com35
445000 . com36
452000 . com37
444000 . com38
446000 . com38
447000 . com38
448000 . com38
454000 . com38
4B0000 . com38
481000 . com39
482000 . com40
483000 . com41
484000 . com42
485000 . com43
486000 . com44
48A000 . com45
492000 . com45
493000 . com46
/
;

sets
margin_agg_map(margin_agg,margins)
/
com34 . wholesale
com35 . retail
com36 . retail
com37 . retail
com38 . retail
com39 . transport
com40 . transport
com41 . transport
com42. transport
com43 . transport
com44 . transport
com45 . transport
com46 . transport
/
;

* Aggregate principal data parameters and check for summary-level consistency (in aggregate)

parameter
make_agg(*,*)
com_make_db
ind_make_db

va_agg(*,*)
ind_va_db

imp_adj_agg(*)
imp_adj_db

use_goods_agg(*,*)
use_margin_agg(*,*,*)
com_use_db
ind_use_db

final_use_goods_agg(*,final_use_det)
final_use_margin_agg(*,final_use_det,*)
com_final_use_db

pce_agg(pce_det,*)
;


make_agg(bea_ind_agg0,bea_com_agg0) = sum(bea_ind_det0,map_ind_agg0(bea_ind_det0,bea_ind_agg0) * sum(bea_com_det0,map_com_agg0(bea_com_det0,bea_com_agg0)*make(bea_ind_det0,bea_com_det0)));
ind_make_db = sum(bea_ind_agg0,sum(bea_com_agg0,make_agg(bea_ind_agg0,bea_com_agg0))) -  sum(bea_ind_sum0,ind_make%DataYr%_tot(bea_ind_sum0));
com_make_db = sum(bea_ind_agg0,sum(bea_com_agg0,make_agg(bea_ind_agg0,bea_com_agg0))) -  sum(bea_com_sum0,com_make%DataYr%_tot(bea_com_sum0));

va_agg(value_added_det,bea_ind_agg0) = sum(bea_ind_det0,map_ind_agg0(bea_ind_det0,bea_ind_agg0)*value_added(value_added_det,bea_ind_det0));
ind_va_db = sum(bea_ind_agg0,sum(value_added_det,va_agg(value_added_det,bea_ind_agg0))) - sum(bea_ind_sum0,ind_value_added_%DataYr%_tot(bea_ind_sum0));

imp_adj_agg(bea_com_agg0) = sum(bea_com_det0,map_com_agg0(bea_com_det0,bea_com_agg0)*imp_adj_%DataYr%_det(bea_com_det0));
imp_adj_db = sum(bea_com_agg0,imp_adj_agg(bea_com_agg0)) - sum(bea_com_sum0,imp_adj_%DataYr%(bea_com_sum0));

use_goods_agg(bea_com_agg0,bea_ind_agg0) = sum(bea_com_det0,map_com_agg0(bea_com_det0,bea_com_agg0) * sum(bea_ind_det0,map_ind_agg0(bea_ind_det0,bea_ind_agg0)*use_goods(bea_com_det0,bea_ind_det0)));
use_margin_agg(bea_com_agg0,bea_ind_agg0,margin_agg) = sum(bea_com_det0,map_com_agg0(bea_com_det0,bea_com_agg0) * sum(bea_ind_det0,map_ind_agg0(bea_ind_det0,bea_ind_agg0) * sum(margin_com,map_margin_agg(margin_com,margin_agg)*use_margin_com(bea_com_det0,bea_ind_det0,margin_com))));
com_use_db = sum(bea_ind_agg0,sum(bea_com_agg0,use_goods_agg(bea_com_agg0,bea_ind_agg0) +sum(margin_agg,use_margin_agg(bea_com_agg0,bea_ind_agg0,margin_agg)))) - sum(bea_com_sum0,com_use%DataYr%_tot(bea_com_sum0));
ind_use_db = sum(bea_ind_agg0,sum(bea_com_agg0,use_goods_agg(bea_com_agg0,bea_ind_agg0) +sum(margin_agg,use_margin_agg(bea_com_agg0,bea_ind_agg0,margin_agg)))) - sum(bea_ind_sum0,ind_use%DataYr%_tot(bea_ind_sum0));


final_use_goods_agg(bea_com_agg0,final_use_det) = sum(bea_com_det0,map_com_agg0(bea_com_det0,bea_com_agg0)*final_use_goods(bea_com_det0,final_use_det));
final_use_margin_agg(bea_com_agg0,final_use_det,margin_agg) = sum(bea_com_det0,map_com_agg0(bea_com_det0,bea_com_agg0) * sum(margin_com,map_margin_agg(margin_com,margin_agg)*final_use_margin_com(bea_com_det0,final_use_det,margin_com)));
com_final_use_db = sum(final_use_det,sum(bea_com_agg0,final_use_goods_agg(bea_com_agg0,final_use_det)+sum(margin_agg,final_use_margin_agg(bea_com_agg0,final_use_det,margin_agg)))) - sum(final_use_sum,sum(bea_com_sum0,final_use_%DataYr%_in(bea_com_sum0,final_use_sum)));


pce_agg(pce_det,bea_com_agg0) = sum(bea_com_det0,map_com_agg0(bea_com_det0,bea_com_agg0)*pce_%DataYr%_det(pce_det,bea_com_det0,"Producers' Value"));

display
ind_make_db
com_make_db
ind_va_db
imp_adj_db
com_use_db
ind_use_db
com_final_use_db
;

* Check for consistency by summary-plus commodity/industry

parameter
com_agg_tot
com_agg_diff

ind_agg_tot
ind_agg_diff
;

com_agg_tot(bea_com_agg0) = sum(bea_ind_agg0,use_goods_agg(bea_com_agg0,bea_ind_agg0)) +
         sum(bea_com_agg00,sum(bea_ind_agg0,use_margin_agg(bea_com_agg00,bea_ind_agg0,bea_com_agg0))) +
         sum(final_use_det,final_use_goods_agg(bea_com_agg0,final_use_det)) +
         sum(bea_com_agg00,sum(final_use_det,final_use_margin_agg(bea_com_agg00,final_use_det,bea_com_agg0))) +
         imp_adj_agg(bea_com_agg0);

com_agg_diff(bea_com_agg0) = com_agg_tot(bea_com_agg0) -  sum(bea_ind_agg0,make_agg(bea_ind_agg0,bea_com_agg0));


ind_agg_tot(bea_ind_agg0) = sum(bea_com_agg0,use_goods_agg(bea_com_agg0,bea_ind_agg0)) +
         sum(margin_agg,sum(bea_com_agg0,use_margin_agg(bea_com_agg0,bea_ind_agg0,margin_agg)))  +
         sum(value_added_det,va_agg(value_added_det,bea_ind_agg0));

ind_agg_diff(bea_ind_agg0) = ind_agg_tot(bea_ind_agg0) - sum(bea_com_agg0,make_agg(bea_ind_agg0,bea_com_agg0));

display
com_agg_diff
ind_agg_diff
;


Parameter
final_agg_db
ind_agg_db
ind_aggtot_db
fd_db_agg_tot
va_db_agg_tot
va_fd_db_agg_diff 
;

final_agg_db(final_use_det) = sum(bea_com_agg0,final_use_goods_agg(bea_com_agg0,final_use_det))/1000000 + sum(bea_com_agg00,sum(bea_com_agg0,final_use_margin_agg(bea_com_agg00,final_use_det,bea_com_agg0)))/1000000;
fd_db_agg_tot = sum(final_use_det,final_agg_db(final_use_det));
va_db_agg_tot = sum(bea_ind_agg0,sum(value_added_det,va_agg(value_added_det,bea_ind_agg0)))/1000000;
va_fd_db_agg_diff = va_db_agg_tot - fd_db_agg_tot;
ind_agg_db(bea_ind_agg0) = sum(bea_com_agg0,use_goods_agg(bea_com_agg0,bea_ind_agg0))/1000000 + sum(bea_com_agg00,sum(bea_com_agg0,use_margin_agg(bea_com_agg00,bea_ind_agg0,bea_com_agg0)))/1000000;
ind_aggtot_db = sum(bea_ind_agg0,ind_agg_db(bea_ind_agg0));

display
final_agg_db
ind_agg_db
ind_aggtot_db
va_fd_db_agg_diff 
;






