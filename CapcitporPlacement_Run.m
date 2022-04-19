%% Main mfile that should be run
clc
clear all
close all
definParameters();
global No_Cap_Type NBus No_pop Iter Cap_Price Ke Loaddata Strdata ...
    T_OffPeak T_Medium T_Peak NLoadLevel Kp
%%
tic
PLoss = zeros(No_pop,1);
f = zeros(No_pop,1);
LoadDataBase = Loaddata(:,3);
LoadOffPeak = 0.3*LoadDataBase;
LoadMedium = 0.6*LoadDataBase;
LoadPeak = LoadDataBase;
%%%% Evaluating Initial conditions
Loaddata(:,3) = LoadOffPeak;
[PLossOutOffPeak0,VbusOutOffPeak0,IsecOut0]=DLF(Strdata,Loaddata); 
Loaddata(:,3) = LoadMedium;
[PLossOutMedium0,VbusOutMedium0,IsecOut0]=DLF(Strdata,Loaddata);
Loaddata(:,3) = LoadPeak;
[PLossOutPeak0,VbusOutPeak0,Isec0]=DLF(Strdata,Loaddata);
EnergyLossIni = T_OffPeak*PLossOutOffPeak0 + T_Medium*PLossOutMedium0 + T_Peak*PLossOutPeak0;
 Loaddata(:,3) = LoadDataBase;
%%%
p = ceil(rand(No_pop,NBus-1)*No_Cap_Type); %%% Initial popoulation
pop = Cap_Mvar_determine(p);  %%% Allocation MVAr to the generated population

for i = 1:size(p,1)
pop(i,:) = Cap_Mvar_determine(p(i,:));

    Load(:,1) = LoadOffPeak - (pop(i,:))';
    Load(:,2) = LoadMedium - (pop(i,:))';
    Load(:,3) = LoadPeak - (pop(i,:))';
     Total_Cap_Price =sum(Cap_Price((p(i,:))));
for il=1:NLoadLevel 
    Loaddata(:,3) = Load(:,il);
    [PLoss(i,il),Vbus,Isec(i,il,:)]=DLF(Strdata,Loaddata); %%% Running load flow
PenaltyVoltageL(i,il)= PenV(Vbus); %%% Calculating amount of penalties
%%% Objective function      
end  
PenaltyVoltage(i) = sum(PenaltyVoltageL(i,:),2);
   f(i) = Ke*(T_OffPeak*PLoss(i,1) + T_Medium*PLoss(i,2) + ...
       T_Peak*PLoss(i,3)) + Kp*PLoss(i,1) + Total_Cap_Price; %%% Calculating objective function
   f(i) = f(i) + PenaltyVoltage(i);
end
PBest = p;
PBestValue = f;
[GTeacherValue, index] = min(f);
GTeacher = PBest(index,:); %%% The best solution
Xmean = mean(p);
h = waitbar(0,'Please wait...');
for k = 1:Iter
    [f,p,GTeacher, GTeacherValue,Xmean,PenaltyVoltage,PenaltyVoltageBest] = ...
    UpdateSolutions(GTeacher, p,Xmean,f,PenaltyVoltage,LoadOffPeak,LoadMedium,LoadPeak);  %%% Generating new solutions                                                                                     
    CF(k) = GTeacherValue; 
     waitbar(k / Iter)
end
toc
ij = 1:Iter;
hold on
close(h)
plot(ij,CF,'r')
xlabel('Iteration')
ylabel('Cost ($)')





%%%%%%%%%%%%%%%%%%%%%%%%%%%
pop = Cap_Mvar_determine(p);
LoadDataBase = Loaddata(:,3);
LoadOffPeak = 0.3*LoadDataBase;
LoadMedium = 0.6*LoadDataBase;
LoadPeak = LoadDataBase;


%% Collecting results

for i = 1:size(GTeacher,1)
pop(i,:) = Cap_Mvar_determine(GTeacher);

    Load(:,1) = LoadOffPeak - (pop(i,:))';
    Load(:,2) = LoadMedium - (pop(i,:))';
    Load(:,3) = LoadPeak - (pop(i,:))';
     Total_Cap_Price =sum(Cap_Price((p(i,:))));
 
    Loaddata(:,3) = Load(:,1);
    [PLossOutOffPeak,VbusOutOffPeak,IsecOut]=DLF(Strdata,Loaddata);
    PenaltyVoltageL(i,1)= PenV(VbusOutOffPeak); 
%%% Objective function      
    Loaddata(:,3) = Load(:,2);
    [PLossOutMedium,VbusOutMedium,IsecOut]=DLF(Strdata,Loaddata);
    PenaltyVoltageL(i,2)= PenV(VbusOutOffPeak); 

    Loaddata(:,3) = Load(:,3);
    [PLossOutPeak,VbusOutPeak,Isec]=DLF(Strdata,Loaddata);
    PenaltyVoltageL(i,3)= PenV(VbusOutOffPeak); 


end

EnergyLossOptimized = T_OffPeak*PLossOutOffPeak + T_Medium*PLossOutMedium + T_Peak*PLossOutPeak;





