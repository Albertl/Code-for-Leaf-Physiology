% Method IV, The Ethier and Livingston model is used here: 

function [f,error]=myfunc4(a, t, ci, pho)

%% This is the Ethier and Livingston model (2004)
R=8.314;
T0=273.14;
O=21;                    % Partial pressure of O2 (Pa)
%global t                 % Leaf temperature in oC
%global pho
%global ci               %Observed CO2 concentration in the intercellular airspace

Tleaf=T0+t;
 
 
% The following temperature adjusted coefficient are taken from Sharkey % et al. 2007, Plant cell and Environment, 30, 1035-1040 
 
kc=exp(35.9774-80.99*1000./(R*Tleaf));
ko=exp(12.3772-23.72*1000./(R*Tleaf));
Gstar=exp(11.187-24.46*1000./(R*Tleaf));
 
% Parameters needed to be estimated
 
gm=parameter(1);
Vcmax=parameter(2);
Rd=parameter(3);
Jmax=parameter(4);
TPU=parameter(5);
 
% Ethier & Livingston Model,
 
% Ac is calculated from the following Eqns.
 
a1=-1/gm;
b1=(Vcmax-Rd)/gm+ci+kc.*(1+O./ko);
c1=Rd*(ci+kc.*(1+O./ko))-Vcmax.*(ci-Gstar);
Ac=(-b1+sqrt(b1.^2-4*a1.*c1))./(2*a1);
 
%Aj is calculated from the following Eqns.
 
a2=-1/gm;
alfa=.3;
I=1500;
theta=.9;
J=(alfa*I+Jmax-sqrt((alfa*I+Jmax).^2-4*theta*I*alfa*Jmax))./(2*theta);
b2=(J/4-Rd)/gm+ci+2*Gstar;
c2=Rd*(ci+2*Gstar)-J/4*(ci-Gstar);
Aj=(-b2+sqrt(b2.^2-4*a2.*c2))./(2*a2);
 
%Ap is calculated from the following Eqns.
 
Apv=3*TPU;
n=size(Ac,1);
Ap=ones(n,1)*Apv;
 
%Net photosynthesis rate is the minimum of Ac, Aj and Ap
 
media=min(Ac,Aj);
for i=1:n
    if media(i)<0
        media(i)=Ac(i);
    end
end
Anet=min(Ap,media);
Anet=Anet-Rd;                       % The net photosynthesis rate
error=sum((Anet-pho).^2);
f=1/(error+0.01);                 % Fitness function                                                      
