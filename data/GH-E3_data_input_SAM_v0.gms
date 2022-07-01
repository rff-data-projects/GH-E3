


* No SEDS adjustments


*====== Create and Modify the Summary-Plus Commodity by Commodity SAM =========

* ======= remove government and "other" commodities from Make/Use Tables ======

sets
ind0_(*)
com0_(*)
mcom0_(*)
;
com0_(bea_com_agg0)=yes;
com0_('com74') = 0;
com0_('com75') = 0;
com0_('com78') = 0;

com0_('com81') = 0;
com0_('com82') = 0;
com0_('com83') = 0;
com0_('com84') = 0;

ind0_(bea_ind_agg0)=yes;
ind0_('ind74') = 0;
ind0_('ind75') = 0;
ind0_('ind78') = 0;

ind0_('ind81') = 0;
ind0_('ind82') = 0;
ind0_('ind83') = 0;
ind0_('ind84') = 0;


mcom0_(margin_agg)=yes;


alias (com0_,com00_);
alias (com0_,com000_);

alias (ind0_,ind00_);
alias (ind0_,ind000_);

Parameters
make_agg_
use_goods_agg_
use_margin_agg_
final_use_goods_agg_
final_use_margin_agg_
va_agg_
pce_agg_
imp_adj_agg_

;


make_agg_(ind0_,com0_) = make_agg(ind0_,com0_);
use_goods_agg_(com0_,ind0_) = use_goods_agg(com0_,ind0_);
use_margin_agg_(com0_,ind0_,com000_) = use_margin_agg(com0_,ind0_,com000_);
final_use_goods_agg_(com0_,final_use_det) = final_use_goods_agg(com0_,final_use_det);
final_use_margin_agg_(com0_,final_use_det,com000_) = final_use_margin_agg(com0_,final_use_det,com000_) ;
final_use_margin_agg_(com0_,final_use_det,com000_) = final_use_margin_agg(com0_,final_use_det,com000_) ;
va_agg_(value_added_det,ind0_) = va_agg(value_added_det,ind0_);

pce_agg_(com0_,pce_det) = pce_agg(pce_det,com0_);
imp_adj_agg_(com0_) = imp_adj_agg(com0_);

* Step 2: Use Percent-Make table to convert to a commodity-by-commodity SAM table

* Determine total commodity value made by each industry
* Create a percent make matrix - for each industry, commodity share of total commodity value made
* Verify percent make matrix
* Create IO table IO = Use * Pct_Make
* Convert value added from industry value added to commodity value added
* Check for consistency

parameters
total_commodities(*)
pct_make(*,*)
check_pct_make(*)
;



total_commodities(ind0_) = sum(com0_,make_agg_(ind0_,com0_));
pct_make(ind0_,com0_) $ (total_commodities(ind0_)<>0) = make_agg_(ind0_,com0_)/total_commodities(ind0_);
check_pct_make(ind0_) = sum(com0_,pct_make(ind0_,com0_));

display
check_pct_make
make_agg_
use_goods_agg_
use_margin_agg_
;


parameters
IO_agg(*,*)
va_agg_com(value_added_det,*)
io_margin_agg(*,*,*)
fgd_agg
fgd_margin_agg
fgd_agg_db
fgd_agg_db2
db1
db2
db3
;

IO_agg(com0_,com00_) = sum(ind0_,use_goods_agg_(com0_,ind0_)*pct_make(ind0_,com00_));
IO_margin_agg(com0_,com00_,mcom0_) = sum(ind0_,use_margin_agg_(com0_,ind0_,mcom0_)*pct_make(ind0_,com00_));
va_agg_com(value_added_det,com0_) = sum(ind0_,va_agg_(value_added_det,ind0_)*pct_make(ind0_,com0_));

fgd_agg(com0_,final_use_det) = final_use_goods_agg_(com0_,final_use_det);
fgd_margin_agg(com0_,final_use_det,mcom0_) =  final_use_margin_agg_(com0_,final_use_det,mcom0_);

fgd_agg_db(final_use_det) = (sum(com0_,fgd_agg(com0_,final_use_det)) + sum(com0_,sum(mcom0_,fgd_margin_agg(com0_,final_use_det,mcom0_))))/1000000;
fgd_agg_db2(final_use_det) = (sum(com0_,final_use_goods_agg(com0_,final_use_det)) + sum(com0_,sum(mcom0_,final_use_margin_agg(com0_,final_use_det,mcom0_))))/1000000;

db1(final_use_det) = sum(bea_com_agg00,sum(mcom0_,final_use_margin_agg(bea_com_agg00,final_use_det,mcom0_)))/1000000; 
db2(final_use_det) = sum(com0_,sum(mcom0_,final_use_margin_agg(com0_,final_use_det,mcom0_)))/1000000;


db3(bea_com_agg00,final_use_det) = sum(mcom0_,final_use_margin_agg(bea_com_agg00,final_use_det,mcom0_))/1000000;
final_use_goods_agg(bea_com_agg0,final_use_det) = final_use_goods_agg(bea_com_agg0,final_use_det)/1000000;






*====== Create and Modify the Summary-Plus-Plus (S++) Commodity by Commodity SAM by disaggregating oil/gas and electric power =========

* Step 1: Define disaggregated commodities, new S++ commodity set, and mappings

sets
com_disagg
/
'oil extraction'
'gas extraction'

'trans/dist'
'coal generation'
'oil generation'
'gas generation'
'nuclear generation'
'hydro generation'
'wind generation'
'solar generation'
'bio generation'
'geo generation'
'other generation'

/

com_disagg_og
/
'oil extraction'
'gas extraction'
/

com_disagg_elec
/
'trans/dist'
'coal generation'
'oil generation'
'gas generation'
'nuclear generation'
'hydro generation'
'wind generation'
'solar generation'
'bio generation'
'geo generation'
'other generation'
/
com_disagg_gen
/
'coal generation'
'oil generation'
'gas generation'
'nuclear generation'
'hydro generation'
'wind generation'
'solar generation'
'bio generation'
'geo generation'
'other generation'
/
com_sum0(*)
com_sum0_ind(*)
;

com_sum0(com0_)$(not (sameas(com0_,'com3') or sameas(com0_,'com7')))=yes;
com_sum0(com_disagg)=yes;

com_sum0_ind(bea_com_agg0_ind) = yes;
com_sum0_ind('com3') = no;
com_sum0_ind(com_disagg_og) = yes;


alias (com_sum0,com_sum00);
alias (com_sum0,com_sum000);


sets
map_com_disagg(bea_com_agg0,com_disagg)
/
com3  .  'oil extraction'
com3  .  'gas extraction'

com7  .  'trans/dist'
com7  .  'coal generation'
com7  .  'oil generation'
com7  .  'gas generation'
com7  .  'nuclear generation'
com7  .  'hydro generation'
com7  .  'wind generation'
com7  .  'solar generation'
com7  .  'bio generation'
com7  .  'geo generation'
com7  .  'other generation'

/

map_com_sum(*,*)



;



map_com_sum(com0_,com0_)$(sameas(com0_,com0_))=yes;
map_com_sum('com3','com3')=no;
map_com_sum('com7','com7')=no;
map_com_sum(map_com_disagg)=yes;





* Step 2: create shares of the old commodity categories that go in the new commodity categories.

*share_vert determines share of commodity use/value added goes to each new industry (e.g. 2/3 of 'oil and gas extraction' use of labor goes to 'oil extraction')
*share_hori determines share of industry/final good use is assigned to each new commodity (e.g. all spending on elec power is assigned to trans/dist)

parameter
share_vert(*)
share_hori(*)
share_gen(*)
;
share_vert(com0_)=1;
share_vert('oil extraction')=0.71;
share_vert('gas extraction')=0.29;



share_vert('trans/dist')=0.5;
share_vert('generation')=0.5;
share_vert('coal generation')=0.22000*0.5;
share_vert('gas generation')=0.27705*0.5;
share_vert('nuclear generation')=0.29024*0.5;
share_vert('hydro generation')=0.05117*0.5;
share_vert('wind generation')=0.06474*0.5;
share_vert('solar generation')=0.02141*0.5;
share_vert('oil generation')=0.04165*0.5;
share_vert('bio generation')=0.01010*0.5;
share_vert('geo generation')=0.01705*0.5;
share_vert('other generation')=0.00659*0.5;


share_hori(com0_)=1;
share_hori('oil extraction')=0;
share_hori('gas extraction')=1;

share_hori('trans/dist')=1;
share_hori('coal generation')=0;
share_hori('gas generation')=0;
share_hori('nuclear generation')=0;
share_hori('hydro generation')=0;
share_hori('wind generation')=0;
share_hori('solar generation')=0;
share_hori('oil generation')=0;
share_hori('bio generation')=0;
share_hori('geo generation')=0;
share_hori('other generation')=0;

share_gen(com0_)=0;
share_gen('coal generation')=0.23377;
share_gen('gas generation')=0.38417;
share_gen('nuclear generation')=0.19608;
share_gen('hydro generation')=(0.06974-.00127);
share_gen('wind generation')=0.07168;
share_gen('solar generation')=0.01743;
share_gen('oil generation')=(0.00279+.00165+.00305);
share_gen('bio generation')=0.01393;
share_gen('geo generation')=0.00375;
share_gen('other generation')=0.00323;

display
share_vert
share_hori
share_gen
;



* Step 3:

*create new use and pct_make table, final demand matrix, value added matrix, and margin requirements
*that have the new indices and appropriate values.

parameters
*ns stands for "no shares." These matrices have the new indices but haven't yet had their values modified by "shares" to reflect the amount of oil/gas that goes to oil as opposed to gas.
io_ns(*,*)
io_margin_ns(*,*,*)
fgd_ns(*,*)
fgd_margin_ns(*,*,*)
va_ns(value_added_det,*)
imp_adj_ns(*)
*The new matrices
io_(*,*)
io_margin_(*,*,*)
fgd_(*,*)
fgd_margin_(*,*,*)
va_(*,*)
imp_adj_(*)
pce_(*,*)
;

*change indices from com0_ to com_sum0

io_ns(com_sum0,com_sum00) = sum(com0_,map_com_sum(com0_,com_sum0)*sum(com00_,map_com_sum(com00_,com_sum00)*io_agg(com0_,com00_)));
io_margin_ns(com_sum0,com_sum00,mcom0_) =  sum(com0_,map_com_sum(com0_,com_sum0)*sum(com00_,map_com_sum(com00_,com_sum00)*io_margin_agg(com0_,com00_,mcom0_)));
fgd_ns(com_sum0,final_use_det) = sum(com0_,map_com_sum(com0_,com_sum0)*fgd_agg(com0_,final_use_det));
fgd_margin_ns(com_sum0,final_use_det,mcom0_) =  sum(com0_,map_com_sum(com0_,com_sum0)*fgd_margin_agg(com0_,final_use_det,mcom0_));
va_ns(value_added_det,com_sum00) = sum(com0_,map_com_sum(com0_,com_sum00)*va_agg_com(value_added_det,com0_));
imp_adj_ns(com_sum0) = sum(com0_,map_com_sum(com0_,com_sum0)*imp_adj_agg(com0_));


*modify new columns and rows appropriately with shares

io_(com_sum0,com_sum00) = share_hori(com_sum0)*share_vert(com_sum00)*io_ns(com_sum0,com_sum00);
io_margin_(com_sum0,com_sum00,mcom0_) = share_hori(com_sum0)*share_vert(com_sum00)*io_margin_ns(com_sum0,com_sum00,mcom0_);
fgd_(com_sum0,final_use_det) = share_hori(com_sum0)*fgd_ns(com_sum0,final_use_det);
va_(value_added_det,com_sum0) = share_vert(com_sum0)*va_ns(value_added_det,com_sum0);
imp_adj_(com_sum0) = share_hori(com_sum0)*imp_adj_ns(com_sum0);
fgd_margin_(com_sum0,final_use_det,mcom0_) = share_hori(com_sum0)*fgd_margin_ns(com_sum0,final_use_det,mcom0_);

pce_(com_sum0,pce_det) = sum(com0_,pce_agg(pce_det,com0_)*map_com_sum(com0_,com_sum0)*share_hori(com_sum0));




*special case adjustments

* Oil and gas

IO_('oil extraction','oil extraction')=IO_('gas extraction','oil extraction');
IO_('oil extraction','gas extraction')=0;
IO_('gas extraction','oil extraction')=0;

IO_margin_('oil extraction','oil extraction',mcom0_)=IO_margin_('gas extraction','oil extraction',mcom0_);
IO_margin_('oil extraction','gas extraction',mcom0_)=0;
IO_margin_('gas extraction','oil extraction',mcom0_)=0;

* OIl refining uses oil and very little amount of gas
IO_('oil extraction','com30')=IO_ns('oil extraction','com30')*.985;
IO_margin_('oil extraction','com30',mcom0_)=IO_margin_ns('oil extraction','com30',mcom0_)*.985;

IO_('gas extraction','com30')=IO_ns('oil extraction','com30')*.015;
IO_margin_('gas extraction','com30',mcom0_)=IO_margin_ns('oil extraction','com30',mcom0_)*.015;

fgd_('oil extraction','f04000') = fgd_ns('oil extraction','f04000')*0.77;
fgd_('gas extraction','f04000') = fgd_ns('oil extraction','f04000')*0.23;
fgd_('oil extraction','f05000') = fgd_ns('oil extraction','f05000')*0.96;
fgd_('gas extraction','f05000') = fgd_ns('oil extraction','f05000')*0.04;


* Electric Power Sector

*generation input into trans/dist
IO_('trans/dist','trans/dist') = 0;
IO_(com_disagg_elec,'trans/dist') = 235000*share_gen(com_disagg_elec);
*coal input
IO_('com4',com_disagg_elec) = 0;
IO_margin_('com4',com_disagg_elec,mcom0_) = 0;
IO_('com4','coal generation') = IO_ns('com4','coal generation');
IO_margin_('com4','coal generation',mcom0_) = IO_margin_ns('com4','coal generation',mcom0_);
*natural gas input
IO_('gas extraction',com_disagg_elec) = 0;
IO_margin_('gas extraction',com_disagg_elec,mcom0_) = 0;
IO_('gas extraction','gas generation') = IO_ns('gas extraction','gas generation');
IO_margin_('gas extraction','gas generation',mcom0_) = IO_margin_ns('gas extraction','gas generation',mcom0_);
*natural gas distribution input
IO_('com8',com_disagg_elec) = 0;
IO_margin_('com8',com_disagg_elec,mcom0_) = 0;
IO_('com8','gas generation') = IO_ns('com8','gas generation');
IO_margin_('com8','gas generation',mcom0_) = IO_margin_ns('com8','gas generation',mcom0_);
*refined petroleum product input
IO_('com30',com_disagg_elec) = 0;
IO_margin_('com30',com_disagg_elec,mcom0_) = 0;
IO_('com30','oil generation') = IO_ns('com30','oil generation');
IO_margin_('com30','oil generation',mcom0_) = IO_margin_ns('com30','oil generation',mcom0_);
*other mining product input (uranium for nukes)
IO_('com5',com_disagg_elec) = 0;
IO_margin_('com5',com_disagg_elec,mcom0_) = 0;
IO_('com5','nuclear generation') = IO_ns('com5','nuclear generation');
IO_margin_('com5','nuclear generation',mcom0_) = IO_margin_ns('com5','nuclear generation',mcom0_);

*assign all TOPI to utility
va_('v00200','trans/dist') = va_ns('v00200','trans/dist');
va_('v00200',com_disagg_elec)$(not (sameas(com_disagg_elec,'trans/dist'))) = 0;

* ======= Define government variables from Use table ======



parameter
io_final__
io_margin_final__
fgd_final__
fgd_margin_final__
va_final__
va_gfed__
va_greg__
pce_producer_final__
inv_final__
fgd_impadj_final__
;

io_final__(com_sum0,com_sum00) = io_(com_sum0,com_sum00);
io_margin_final__(com_sum0,com_sum00,mcom0_) = io_margin_(com_sum0,com_sum00,mcom0_);

fgd_final__(com_sum0,finuse) = sum(final_use_det,map_finuse(finuse,final_use_det)*fgd_(com_sum0,final_use_det));
fgd_final__(com_sum0,finuse_gfed) = sum(com0_,map_com_sum(com0_,com_sum0)*(use_goods_agg(com0_,'ind74') + use_goods_agg(com0_,'ind75')));
fgd_final__(com_sum0,finuse_greg) = sum(com0_,map_com_sum(com0_,com_sum0)*(use_goods_agg(com0_,'ind78')));
fgd_final__(com_disagg_gen,finuse_gfed) = 0;
fgd_final__(com_disagg_gen,finuse_greg) = 0;

fgd_margin_final__(com_sum0,finuse,mcom0_) = sum(final_use_det,map_finuse(finuse,final_use_det)*fgd_margin_(com_sum0,final_use_det,mcom0_));
fgd_margin_final__(com_sum0,finuse_gfed,mcom0_) = sum(com0_,map_com_sum(com0_,com_sum0)*(use_margin_agg(com0_,'ind74',mcom0_) + use_margin_agg(com0_,'ind75',mcom0_)));
fgd_margin_final__(com_sum0,finuse_greg,mcom0_) = sum(com0_,map_com_sum(com0_,com_sum0)*(use_margin_agg(com0_,'ind78',mcom0_)));
fgd_margin_final__(com_disagg_gen,finuse_gfed,mcom0_) = 0;
fgd_margin_final__(com_disagg_gen,finuse_greg,mcom0_) = 0;


va_final__(value_added_det,com_sum0) = va_(value_added_det,com_sum0);
va_gfed__(value_added_det) = va_agg(value_added_det,'ind74') + va_agg(value_added_det,'ind75');
va_greg__(value_added_det) = va_agg(value_added_det,'ind78');

pce_producer_final__(com_sum0,pce_det) = pce_(com_sum0,pce_det);


inv_final__(com_sum0) = fgd_(com_sum0,'f03000');

fgd_impadj_final__(com_sum0) = imp_adj_(com_sum0);


