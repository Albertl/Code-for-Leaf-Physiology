% Approximate estimations for Vcmax, Jmax, and TPU were given by:

function [Vcmax0,Jmax0,TPU0]=preidbound( t, ci, pho)
R=8.314;
T0=273.14;
O=21;                                                                 
Tleaf=T0+t;
% Temperature coefficient
kc=exp(35.9774-80.99*1000./(R*Tleaf));
ko=exp(12.3772-23.72*1000./(R*Tleaf));
Gstar=exp(11.187-24.46*1000./(R*Tleaf));
% proximate estimation of Vcmax, Jmax and TPU
dAdCi=(pho(3)-pho(1))/(ci(3)-ci(1));
Vcmax0=dAdCi*(Gstar+kc*(1+O/ko));
Jmax0=mean(pho(end-3:end))*4;
TPU0=(pho(end)+pho(end-1))/2/3;
