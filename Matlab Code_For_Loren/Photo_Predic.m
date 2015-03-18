function [A R2 RMSE]=Photo_Predic(parameter, t, ci, pho)
R=8.314; 
O=21;
T0=273.15

%global t                 % leaf temperature in oC
%global pho               % Observed photosynthesis rate 
%global ci                %Observed CO2 concentration in the intercellular airspace

T=T0+t;                   % Leaf temperature in K

% The following temperature adjusted coefficient are taken from Sharkey % et al. 2007, Plant cell and Environment, 30, 1035-1040

c1=35.9774;
Ha1=80.99;
c2=12.3772;
Ha2=23.72;
c3=11.187;
Ha3=24.46;
kcc=exp(c1-Ha1./(R/1000*T));
koo=exp(c2-Ha2./(R/1000*T));
FSS=exp(c3-Ha3./(R/1000*T));
 
%  parameter is the parameter need to be estimaed
gm=parameter(1);
Vcmax=parameter(2);
Rd=parameter(3);
Jmax=parameter(4);
TPU=parameter(5);
 
%%% Ac 
cc=ci-pho/gm;
Acc=Vcmax.*(cc-FSS)./(cc+kcc.*(1+O./koo));
 
%%% Aj
alfa=.3;
I=1500;
theta=.9;
J=(alfa*I+Jmax-sqrt((alfa*I+Jmax).^2-4*theta*I*alfa*Jmax))./(2*theta);
Ajj=J*(cc-FSS)./(4*cc+8*FSS);
 
%%% Ap
Ap=3*TPU;
 
media=min(Ajj,Acc);
n=size(Ajj,2);
for i=1:n
    if media(i)<0
        media(i)=max(Ajj(i),Acc(i));
    end
end
A=min(media,ones(1,size(Acc,2)).*Ap);
A=A-Rd;
error=sum((A-pho).^2);
f=1/(error+0.01);       % Fitness function

R2=corr(A,pho).^2;
RMSE=std(A-pho);

