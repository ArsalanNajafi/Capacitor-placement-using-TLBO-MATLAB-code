%% Function of defining input parameters
function definParameters()
global No_Cap_Type Cap_MVar NBus No_pop Iter Cap_Price VLoadMax VLoadMin ...
    PF Loaddata Strdata pMax  pMin Ke Kp T Kl T_OffPeak T_Medium T_Peak ...
    NLoadLevel
No_Cap_Type = 7;  %%% Number of capacitor types
 Cap_MVar = 4*[0 150 300 450 600 900 1200];
 Cap_Price =4*[0 750 975 1140 1320 1650 2040];


No_pop =100;  %%% Number of population
Iter = 200;   %%% Iteration number
VLoadMax = 1.1; %%% Upper voltage bound
VLoadMin = 0.9; %%% Lower voltage bound
PF = 5000;   %%% Penalty factor
Loaddata=xlsread('DLF_case33.xls','Loaddata');
Strdata=xlsread('DLF_case33.xls','Strdata');

NBus = size(Loaddata,1) + 1; %%% Number of buses




pMax = No_Cap_Type;  %%% Maxiumum bound of populations
pMin = 1;  %%% Minimum bound of populations
Ke = 0.06; %%% Coefficent of energy loss
Kp = 300;  %%% coefficent of power loss
T = 8760;   %%% time period
Kl = 168;    %%% 
T_OffPeak = 3000;  %%% Off peak hours
T_Medium = 5300;    %%% Medium load hours
T_Peak = 460;      %%% Peak hours
NLoadLevel = 3;    %%% Number of load levels


