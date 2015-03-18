% Main program of Method III and Method IV are:

% the main program named testmyfunctionofphotosynthesis.m  

clc
clear all

global t             % Leaf temperature
global ci
global pho

% observed values

t=29;

ci=[2.02 5.05 10.1 15.15 20.2 25.25 30.3 35.35 40.4 50.5 65.65 80.8 101 121.2];
pho=[-7.18 -2.47 4.81 11.45 17.54 20.60 22.83 24.57 25.97 28.06 30.17 31.57 32.85 33.74];

%%% parameters bounds identify 
[Vcmax0 Jmax0 TPU0]=preidbound;
lbvc=Vcmax0-30;   % Low boundary of Vcmax
if lbvc<0
lbvc=0;
end 
lbJ=Jmax0-40;    % Low boundary of Jmax
if lbJ<0
lbJ=0;
end 
bound(1,:)=[.1 lbvc 0  lbJ TPU0-2];
bound(2,:)=[30 Vcmax0+30 10 Jmax0+70 TPU0+3];
 
sca_var=10^(-20);
popusize=150;                   %%% Population sizes
gen=1;

[inpopu,bit_n]=encode(bound,sca_var,popusize);  %generate initial population

while gen<=600
    [x,fit,err]=decode(inpopu,bit_n,bound);
    [minvalue,index]=min(err);    %find the best individual
    BestPopu(gen,1)=minvalue;  %record the best individual in the genth generation
    Trace(gen,:)=[x(index,:)]; %Trace the best individual values in genth generation
    [selpopu]=select(inpopu,fit);
    pc=.6;
    [rcpopu]=crossover(selpopu,pc);
    pm=.1;
    [mupopu]=mutation(rcpopu,pm);  
    [x,fit]=decode(mupopu,bit_n,bound);
    [xx,fitt]=decode(inpopu,bit_n,bound);
    [vale,index2]=sort([fit;fitt],1,'descend');
    newpopu=[mupopu;inpopu];
    for i=1:popusize
        newwpopu(i,:)=newpopu(index2(i),:);
    end
    gen=gen+1;
    inpopu=newwpopu;
    imagesc(inpopu)            % Display the population evolution
    pause(.001)
end
[BeV,xx]=min(BestPopu);     % The best individual in the total generations
va=Trace(xx,:);                    % Estimated parameters
plot(1:gen-1, BestPopu','b-')   % RMSE in every generation 







%% Temperature Scaling
%% Rows: gm, Vcmax, Rd, Jmax, TPU
%% Columns: c, delta-Ha

Coefficient_Scale1=[
    20.01  49.6
    26.355 65.33
    18.715 46.39
    17.71  43.9
    21.46  53.1
    ];

%% gm, TPU
%% Columns: delta-Hd, delta-sum
Coefficient_Scale2=[
    437.4 1.4
    201.8 0.65
    ];

Vcmax_scale=exp(Coefficient_Scale1(2,1)-(Coefficient_Scale1(2,2)/(0.008314*(273.15+t))));
Jmax_scale=exp(Coefficient_Scale1(4,1)-(Coefficient_Scale1(4,2)/(0.008314*(273.15+t))));
Rd_scale=exp(Coefficient_Scale1(3,1)-(Coefficient_Scale1(3,2)/(0.008314*(273.15+t))));

gm1=exp(Coefficient_Scale1(1,1)-(Coefficient_Scale1(1,2)/(0.008314*(273.15+t))));
gm2=1+exp((Coefficient_Scale2(1,2)*(273.15+t)-Coefficient_Scale2(1,1))/(0.008314*(273.15+t)));
gm_scale=gm1/gm2;

tpu1=exp(Coefficient_Scale1(5,1)-(Coefficient_Scale1(5,2)/(0.008314*(273.15+t))));
tpu2=1+exp((Coefficient_Scale2(2,2)*(273.15+t)-Coefficient_Scale2(2,1))/(0.008314*(273.15+t)));
TPU_scale=tpu1/tpu2;

Scale=[gm_scale Vcmax_scale Rd_scale Jmax_scale TPU_scale];

va_25=va./Scale;
