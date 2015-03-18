% clc
% clear
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % code for Loren to join the data sheet
% % Jin Wu, University of Arizona, 2014-December
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% folder1='.\';
% fn1='master_curve_list_v6.xlsx';
% 
% folder2='.\Env_Variables_Output\';
% fn2='Env_Variable_Master_Sheet.xlsx';
% 
% folder3='.\Physiology_Output\';
% fn3='Physiology_Variable_Master_Sheet.xlsx';
% 
% 
% [num1 txt1 raw1]=xlsread([folder1 fn1]);
% [num2 txt2 raw2]=xlsread([folder2 fn2]);
% [num3 txt3 raw3]=xlsread([folder3 fn3]);
% 
% n2=length(raw2(:,1));
% Range2=[2:n2];
% 
% n3=length(raw3(:,1));
% Range3=[2:n3];
% 
% temp2=raw2(Range2,1);
% temp3=raw3(Range3,1);
% 
% %% Step 1: Physiology and Master Name Matching
% 
% for i=3:length(raw1(:,1))
%     a=raw1(i,17);
%     a1=a{1};
%     a2=[a1(1:end-4) '.csv'];
%     
%     ind2=strmatch(a2, temp2,'exact');
%     ind3=strmatch(a2, temp3,'exact');
%     
%     if length(ind2)>0
%        Output2(i,1:length(raw2(1,:)))=raw2(Range2(ind2(1)),:);
%        Output2(i,1)=a;
%     end
%     
%     if length(ind3)>0
%        Output3(i,1:length(raw3(1,:)))=raw3(Range3(ind3(1)),:);
%        Output3(i,1)=a;
%     end
%    
%     if length(ind2)>0
%        Output4(i,1)=ind2(1);
%        Output4(i,2)=length(ind2);
%     end
%     if length(ind3)>0
%        Output4(i,3)=ind3(1);
%        Output4(i,4)=length(ind3);
%     end
%     clear a a1 a2 ind2 ind3 
% end
% 
% 
% %% Step 2: Physiology Display
% clear ind
% ind=find(Output4(:,1)>0); %% This is the id in raw1 
% ind1=ind-2; %% This is the id in num1
% 
% %% To identify which leaves cannot be matched.
% A=unique(Output4(:,1));
% C=1:length(temp2(:,1));
% B=setdiff(C,A);
% 
% Name_mismatch=raw3(B+1,1);
% 
% 
% 
% %% Display the results
% [num5 txt5 raw5]=xlsread([folder1 fn1]);
% indx=find(num5(:,26)>0); %% Filter those leaves without leaf physiology
% num51=num5(indx,:);
% raw51=raw5(indx+1,:); %% there is one order off between raw and num

SPArray=raw51(:,23); %% JW_UID
SPID={'TR9'}; %% All Species Case
SPID=SPArray;
flag=0; %% Do not separate light environment

%% The Index for Mat1
% 1--Leaf T; 2--Leaf T std; 3--QC-code; 4--Light Environment
Mat1=[50 51 5 13];

%% The Index for Mat2
% 1--Leaf Age; 2--Vcmax; 3--Jmax; 4--TPU; 5--Dark Respiration %% 25
Mat2=[12 34 36 37 35];
Physiology=num51;
flexibility=2;
LE=1;

%% First-Simulation---All Species Case
%% Improved version of Age Index
Age_Index=[1
2
3
2
1
2
3
3
2
2
1
2
1
2
3
3
3
1
2
1
3
3
3
2
2
3
2
1
2
2
2
2
3
1
2
3
2
2
2
2
2
2
2
2
3
2
2
2
2
3
1
2
2
3
2
1
1
3
1
3
1
2
2
1
1
2
3
2
3
3
3
3
2
3
3
1
3
1
3
1
3
2
3
2
2
3
2
3
1
3
3
2
2
1
2
2
2
2
3
3
3
4
2
2
3
2
3
1
];

Physiology(:,12)=Age_Index;

ALLSP=Age_Specific_Leaf_Physiology_All_SP(Physiology, Mat1, Mat2);



%% Species Specific
SP_Specific=Age_Specific_Leaf_Physiology_SP_Dependent(Physiology, Mat1, Mat2, SPArray);

% test=species_specific_leaf_physiology_display(Physiology, SPArray, SPID, flag, Mat1, Mat2, flexibility, LE);
% 