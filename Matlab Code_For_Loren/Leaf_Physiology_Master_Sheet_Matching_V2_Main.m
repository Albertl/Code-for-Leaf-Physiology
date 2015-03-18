%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Based on code for Loren to join the data sheet called 
%'Test_Leaf_Physiology_Master_Sheet_Matching_V1_Main'
% Jin Wu, University of Arizona, 2014-December
% Adapted by Loren, spring 2015
% Gave up on this script on Loren's mac because for a mysterious reason
% many of the filenames in the master_sheet import as 'NAN' when they are
% not empty.  Wrote r script called 'matching_physiology_master_sheet'
% instead.
%
% To do:
% 1) Choose PC or Mac.  If using mac, make sure that
% 'Env_Variable_Master_Sheet' and 'Physiology_Variable_Master_Sheet_mac'
% have a .xls version (and that the version is up to date) since these
% files are saved as .csv after running
% 'Test_Environment_Variable_Extraction_V1.m'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clc
clear

%% Step 0: load data

% Using mac or PC?  Choose comp=0 for PC, choose comp=1 for mac
comp = 1;

if comp == 0;
    folder1='.\';
    fn1='master_curve_list_v7.xls';
    
    folder2='.\Env_Variables_Output\';
    fn2='Env_Variable_Master_Sheet.xlsx';
    
    folder3='.\Physiology_Output\';
    fn3='Physiology_Variable_Master_Sheet.xlsx';
    
    [num1 txt1 raw1]=xlsread([folder1 fn1]);
    [num2 txt2 raw2]=xlsread([folder2 fn2]);
    [num3 txt3 raw3]=xlsread([folder3 fn3]);
    
elseif comp == 1;
    % If mac, use '/' and .xls seems to work but not .xlsx?
    folder1='/Users/lalbert/Documents/Amazon research/Photo Curve-fitting/Curve quality control/Edit-Licor-files-github/';
    fn1='master_curve_list_v7.xls';
    
    folder2='./Env_Variables_Output/';
    fn2='Env_Variable_Master_Sheet_mac.xls';
    
    folder3='./Physiology_Output/';
    fn3='Physiology_Variable_Master_Sheet_mac.xls';
    
    [num1 txt1 raw1]=xlsread([folder1 fn1]);
    [num2 txt2 raw2]=xlsread([folder2 fn2]);
    [num3 txt3 raw3]=xlsread([folder3 fn3]);
    
end

n2=length(raw2(:,1));
Range2=[2:n2];

n3=length(raw3(:,1));
Range3=[2:n3];

temp2=raw2(Range2,1); % filename column in Env_Variables_Output
temp3=raw3(Range3,1); % filename column in Physiology_Variable_Master_Sheet

%% Step 1: Physiology and Master Name Matching

for i=3:length(raw1(:,1))
    a=raw1(i,17); % column 17 has names for match
    a1=a{1};
    a2=[a1(1:end-4) '.csv']; % want '.txt' replaced with '.csv'
    
    ind2=strmatch(a2, temp2,'exact'); % matches filenames for Env_Variables_Output
    ind3=strmatch(a2, temp3,'exact'); % matches filenames for Physiology_Variable_Master_Sheet
    
    if length(ind2)>0
       Output2(i,1:length(raw2(1,:)))=raw2(Range2(ind2(1)),:);
       Output2(i,1)=a;
    end
    
    if length(ind3)>0
       Output3(i,1:length(raw3(1,:)))=raw3(Range3(ind3(1)),:);
       Output3(i,1)=a;
    end
   
    if length(ind2)>0
       Output4(i,1)=ind2(1);
       Output4(i,2)=length(ind2);
    end
    if length(ind3)>0
       Output4(i,3)=ind3(1);
       Output4(i,4)=length(ind3);
    end
    clear a a1 a2 ind2 ind3 
end


%% Step 2: Physiology Display
clear ind
ind=find(Output4(:,1)>0); %% This is the id in raw1
ind1=ind-2; %% This is the id in num1

%% To identify which leaves cannot be matched across datasets.
A=unique(Output4(:,1));
C=1:length(temp2(:,1));
B=setdiff(C,A);

Name_mismatch=raw3(B+1,1); % raw3 is physiology output, indices from raw2, but raw2 and raw3 should have same filenames



% %% Display the results
% [num5 txt5 raw5]=xlsread([folder1 fn1]);
% indx=find(num5(:,26)>0); %% Filter those leaves without leaf physiology
% num51=num5(indx,:);
% raw51=raw5(indx+1,:); %% there is one order off between raw and num

