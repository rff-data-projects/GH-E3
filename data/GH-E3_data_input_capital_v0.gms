
*====== Load capital stock data =========

* Define capital sets and mapping to com0

sets
kk0 /k0_s,k0_e,k0_i,k0_r/
bea_k0 /
3
4
6
7
8
9
10
13
14
15
16
17
18
19
20
21
22
23
25
26
27
28
29
30
31
32
33
34
36
37
38
39
40
41
42
43
45
46
47
48
50
51
52
53
54
56
57
59
60
61
62
64
65
66
68
69
70
71
73
74
76
77
78
/

map_cap(bea_k0,*)   /
3         .        com1
4         .        com2
6         .        'oil extraction'
6         .        'gas extraction'
7         .        com4
7         .        com5
8         .        com6
9         .        'trans/dist'
9         .        'coal generation'
9         .        'oil generation'
9         .        'gas generation'
9         .        'nuclear generation'
9         .        'hydro generation'
9         .        'wind generation'
9         .        'solar generation'
9         .        'bio generation'
9         .        'geo generation'
9         .        'other generation'
9         .        com8
9         .        com9
10        .        com10
13        .        com11
14        .        com12
14        .        com13
15        .        com14
15        .        com15
15        .        com16
16        .        com17
17        .        com18
18        .        com19
19        .        com20
20        .        com21
21        .        com22
22        .        com23
23        .        com24
25        .        com25
26        .        com26
27        .        com27
28        .        com28
29        .        com29
30        .        com30
30        .        com31
31        .        com32
32        .        com33
33        .        com34
34        .        com35
34        .        com36
34        .        com37
34        .        com38
36        .        com39
37        .        com40
38        .        com41
39        .        com42
40        .        com43
41        .        com44
42        .        com45
43        .        com46
45        .        com47
46        .        com48
47        .        com49
48        .        com50
50        .        com51
51        .        com51
52        .        com52
53        .        com53
54        .        com54
56        .        com55
56        .        com56
57        .        com57
59        .        com58
60        .        com59
61        .        com60
62        .        com61
64        .        com62
65        .        com63
66        .        com64
68        .        com65
69        .        com66
70        .        com67
71        .        com68
73        .        com69
74        .        com70
76        .        com71
77        .        com72
78        .        com73
/

;

* Load in BEA capital stock data

parameters
k_%DataYr%_in(bea_k0,kk0)
d_%DataYr%_in(bea_k0,kk0)
k_final_(*,kk0)
d_final_(*,kk0)
;

*$CALL GDXXRW.EXE %Process%\capital_%DataYr%_NoLabels.xlsx o=%Process%\capital_%DataYr%_NoLabels.gdx par=k_%DataYr%_in rng=A1:d64 cdim = 1 rdim = 1
*$CALL GDXXRW.EXE %Process%\depreciation_%DataYr%_NoLabels.xlsx o=%Process%\depreciation_%DataYr%_NoLabels.gdx par=d_%DataYr%_in rng=A1:d64 cdim = 1 rdim = 1

$GDXIN %Process%\capital_%DataYr%_NoLabels.gdx
$LOAD k_%DataYr%_in
$GDXIN

$GDXIN %Process%\depreciation_%DataYr%_NoLabels.gdx
$LOAD d_%DataYr%_in
$GDXIN



k_final_(com_sum0,kk0) = sum(bea_k0,map_cap(bea_k0,com_sum0)*k_%DataYr%_in(bea_k0,kk0));
d_final_(com_sum0,kk0) = sum(bea_k0,map_cap(bea_k0,com_sum0)*d_%DataYr%_in(bea_k0,kk0));



* For capital stock data that needs to be disaggregated, use va_final(GOS) shares to disaggregate

parameter
k1
k2
k3a
k3b
k3c
k4
k5a
k5b
k5c
k6
;

alias(com_disagg_gen,com_disagg_gen2);

k1 = va_final_('V00300','oil extraction')/(va_final_('V00300','oil extraction')+va_final_('V00300','gas extraction'));
k2 = va_final_('V00300','com4')/(va_final_('V00300','com4')+va_final_('V00300','com5'));
k3a = va_final_('V00300','trans/dist')/(va_final_('V00300','trans/dist') + sum(com_disagg_gen,va_final_('V00300',com_disagg_gen)) + va_final_('V00300','com8') + va_final_('V00300','com9'));
k3b(com_disagg_gen) = va_final_('V00300',com_disagg_gen)/(va_final_('V00300','trans/dist') + sum(com_disagg_gen2,va_final_('V00300',com_disagg_gen2)) + va_final_('V00300','com8') + va_final_('V00300','com9'));
k3c = va_final_('V00300','com8')/(va_final_('V00300','trans/dist') + sum(com_disagg_gen,va_final_('V00300',com_disagg_gen)) + va_final_('V00300','com8') + va_final_('V00300','com9'));
k4 = va_final_('V00300','com30')/(va_final_('V00300','com30')+va_final_('V00300','com31'));
k5a = va_final_('V00300','com35')/(va_final_('V00300','com35')+va_final_('V00300','com36')+va_final_('V00300','com37')+va_final_('V00300','com38'));
k5b = va_final_('V00300','com36')/(va_final_('V00300','com35')+va_final_('V00300','com36')+va_final_('V00300','com37')+va_final_('V00300','com38'));
k5c = va_final_('V00300','com37')/(va_final_('V00300','com35')+va_final_('V00300','com36')+va_final_('V00300','com37')+va_final_('V00300','com38'));
k6 = va_final_('V00300','com55')/(va_final_('V00300','com55')+va_final_('V00300','com56'));


k_final_('oil extraction',kk0) = k_final_('oil extraction',kk0)*k1;
k_final_('gas extraction',kk0) = k_final_('gas extraction',kk0)*(1-k1);
k_final_('com4',kk0) = k_final_('com4',kk0)*k2;
k_final_('com5',kk0) = k_final_('com5',kk0)*(1-k2);
k_final_('trans/dist',kk0) = k_final_('trans/dist',kk0)*k3a;
k_final_(com_disagg_gen,kk0) = k_final_(com_disagg_gen,kk0)*k3b(com_disagg_gen);
k_final_('com8',kk0) = k_final_('com8',kk0)*k3c;
k_final_('com9',kk0) = k_final_('com9',kk0)*(1-k3a-sum(com_disagg_gen,k3b(com_disagg_gen))-k3c);
k_final_('com30',kk0) = k_final_('com30',kk0)*k4;
k_final_('com31',kk0) = k_final_('com31',kk0)*(1-k4);
k_final_('com35',kk0) = k_final_('com35',kk0)*k5a;
k_final_('com36',kk0) = k_final_('com36',kk0)*k5b;
k_final_('com37',kk0) = k_final_('com37',kk0)*k5c;
k_final_('com38',kk0) = k_final_('com38',kk0)*(1-k5a-k5b-k5c);
k_final_('com55',kk0) = k_final_('com55',kk0)*k6;
k_final_('com56',kk0) = k_final_('com56',kk0)*(1-k6);

d_final_('oil extraction',kk0) = d_final_('oil extraction',kk0)*k1;
d_final_('gas extraction',kk0) = d_final_('gas extraction',kk0)*(1-k1);
d_final_('com4',kk0) = d_final_('com4',kk0)*k2;
d_final_('com5',kk0) = d_final_('com5',kk0)*(1-k2);
d_final_('trans/dist',kk0) = d_final_('trans/dist',kk0)*k3a;
d_final_(com_disagg_gen,kk0) = d_final_(com_disagg_gen,kk0)*k3b(com_disagg_gen);
d_final_('com8',kk0) = d_final_('com8',kk0)*k3c;
d_final_('com9',kk0) = d_final_('com9',kk0)*(1-k3a-sum(com_disagg_gen,k3b(com_disagg_gen))-k3c);
d_final_('com30',kk0) = d_final_('com30',kk0)*k4;
d_final_('com31',kk0) = d_final_('com31',kk0)*(1-k4);
d_final_('com35',kk0) = d_final_('com35',kk0)*k5a;
d_final_('com36',kk0) = d_final_('com36',kk0)*k5b;
d_final_('com37',kk0) = d_final_('com37',kk0)*k5c;
d_final_('com38',kk0) = d_final_('com38',kk0)*(1-k5a-k5b-k5c);
d_final_('com55',kk0) = d_final_('com55',kk0)*k6;
d_final_('com56',kk0) = d_final_('com56',kk0)*(1-k6);

k_final_('com55','k0_r') = k_final_('com55','k0_s');
d_final_('com55','k0_r') = d_final_('com55','k0_s');
k_final_('com55','k0_s') = 0;
d_final_('com55','k0_s') = 0;

* Add/adjust based on government enterprise (Source: Table 7.1, Fixed Assets Accounts Tables



k_final_(com_disagg_gen,'k0_s') = k_final_(com_disagg_gen,'k0_s') + 428.7*share_gen(com_disagg_gen);
d_final_(com_disagg_gen,'k0_s') = d_final_(com_disagg_gen,'k0_s') + 7.7*share_gen(com_disagg_gen);

k_final_('com76','k0_s') = (3528.7-428.7)*va_final_('V00300','com76')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
k_final_('com76','k0_e') = 122.9*va_final_('V00300','com76')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
k_final_('com76','k0_i') = 11.4*va_final_('V00300','com76')/(va_final_('V00300','com76')+va_final_('V00300','com79'));

k_final_('com79','k0_s') = (3528.7-428.7)*va_final_('V00300','com79')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
k_final_('com79','k0_e') = 122.9*va_final_('V00300','com79')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
k_final_('com79','k0_i') = 11.4*va_final_('V00300','com79')/(va_final_('V00300','com76')+va_final_('V00300','com79'));

d_final_('com76','k0_s') = (57.7-7.7)*va_final_('V00300','com76')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
d_final_('com76','k0_e') = 17.5*va_final_('V00300','com76')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
d_final_('com76','k0_i') = 57.7*va_final_('V00300','com76')/(va_final_('V00300','com76')+va_final_('V00300','com79'));

d_final_('com79','k0_s') = (55.2-7.3)*va_final_('V00300','com79')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
d_final_('com79','k0_e') = 17.5*va_final_('V00300','com79')/(va_final_('V00300','com76')+va_final_('V00300','com79'));
d_final_('com79','k0_i') = 57.7*va_final_('V00300','com79')/(va_final_('V00300','com76')+va_final_('V00300','com79'));

