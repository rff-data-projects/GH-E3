*This File Prepares Data for the E3 model
*(1) Define sets necessary for data input
*(2) Read in raw summary level data and harmonize the data
*(3) Read in raw detailed level data and harmonize the data
*(4) Disaggregate summary level dataset into detailed level
*(5) Read in and disaggregate PCE bridge dataset
*(6) Aggregate data to "summary-plus" level
*(7) Disaggregate oil/gas and electric power; create commodity-commodity SAM
*(8) Replace BEA energy expenditure data with EIA energy expenditure data
*(9) Read in BEA capital stock data



* 7/1/22

*create an easy filepath
$setglobal RootDir    \GH-E3-2022
$setglobal Process    %RootDir%\DataFiles
$setglobal DataYr       2019
$setglobal BenchYr      2012
$setglobal SedsYr       2019

*(1) Define sets necessary for data input
$include GH-E3_set_declaration.gms

*(2) Read in raw summary level data and harmonize the data
$include GH-E3_data_input_summary_v0.gms

*(3) Read in raw detailed level data and harmonize the data
$include GH-E3_data_input_detail_v0.gms

*(4) Disaggregate summary level dataset into detailed level
$include GH-E3_data_input_disagg_v0.gms

*(4) Calculate margin requirements at detailed level
$include GH-E3_data_input_margins_v0.gms

*(5) Read in and disaggregate pce bridge data
$include GH-E3_data_input_pce_v0.gms

*(6) Aggregate the data to "summary-plus"
$include GH-E3_data_input_agg_v0.gms

*(7) Disaggregate oil/gas and electric power
$include GH-E3_data_input_SAM_v0.gms

*(8) Replace BEA energy expenditure data with EIA energy expenditure data
$include GH-E3_data_input_SEDS_v0.gms

*(9) Read in BEA capital stock data
$include GH-E3_data_input_capital_v0.gms



