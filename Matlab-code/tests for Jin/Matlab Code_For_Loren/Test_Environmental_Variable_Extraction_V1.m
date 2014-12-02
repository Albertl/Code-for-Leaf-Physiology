%Enter file contents here
% The goal of this code is to help automatically extract the environmental
% variables from .csv files in the 'files-for-import-into-masterScript'
% folder. 
% Loren and Jin, 2014 November, University of Arizona

% Notes:
% 1)  Each of the .csv files in 'files-for-import-into-masterScript' is one
% curve.  This script only uses the .csv files of A/Ci curves
% 2) There are two parts to this script.  The first part extracts useful
% environmental information from the .csv files.  The second part runs
% scripts to fit A/Cc curves (based script in supplemental information from
% Su et al. 2009 PC&E paper)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc 
clear

% Using mac or PC?  Choose comp=0 for PC, choose comp=1 for mac
comp = 1;

% Set directory (automatic, based on 'comp)
if comp == 0;
    folder='.\files-for-import-into-masterScript'; % Keep in mind: in Mac, we should use     folder='./files-for-import-into-masterScript'
    fn_output='.\Env_Variables_Output\'; % for Mac user, it should be    fn_output='./Env_Variables/';
    fn_physiogy_output='.\Physiology_Output\'; % for Mac user, it should be  fn_physiogy_output='./Physiology_Output/';
elseif comp == 1;
    folder='./files-for-import-into-masterScript';
    fn_output='./Env_Variables/';
    fn_physiogy_output='./Physiology_Output/';
end


%% PART 1: Automatically extract environmental variables 
% (from 'files-for-import-into-masterScript' folder

listing = dir(folder); % navigate to where we locate the master excel spreadsheet
n1=length(listing); %% How many files within this folder

% Among n1 files, the first 3 are not .csv files, while the last one is the
% readme file

count=0;
for i=4:n1 % using the for-loop to automatically search each file
    str=listing(i,1); % extracting the file name for each file
    str_name=str.name;
    if str_name(1,1)=='A' % Only applicable for those ACI-curves
        count=count+1;
        
        if comp == 0
            fn=[folder '\' str_name];   % PC
        elseif comp ==1
            fn=[folder '/' str];        % in MAC, we use fn=[folder '/' str];
        end
        
        
        [num txt raw]=xlsread(fn); % although it is a csv file, I use xlsread function instead                
        Output(count,1)=length(num(:,1)); %% the number of observations
        
        Output(count,2)=num(1,1); %% the starting of observation number
        Output(count,3)=num(end,1); %% the ending of observation number
        
        Output(count,4)=mean(num(num(:,10)>0,10)); %% mean-conductance
        Output(count,5)=std(num(num(:,10)>0,10)); %% std-conductance
        
        Output(count,6)=mean(num(num(:,20)>0,20)); %% mean-Leaf-Temp
        Output(count,7)=std(num(num(:,20)>0,20)); %% std-Leaf-Temp
        
        Output(count,8)=mean(num(num(:,19)>0,19)); %% mean-Air-Temp
        Output(count,9)=std(num(num(:,19)>0,19)); %% std-Air-Temp
        
        Output(count,10)=mean(num(num(:,29)>0,29)); %% mean-PARi
        Output(count,11)=std(num(num(:,29)>0,29)); %% std-PARi
        
        Output(count,12)=mean(num(num(:,13)>0,13)); %% mean-VPDL
        Output(count,13)=std(num(num(:,13)>0,13)); %% std-VPDL
        
        Output(count,14)=mean(num(num(:,27)>0,27)); %% mean-RH_S
        Output(count,15)=std(num(num(:,27)>0,27)); %% std-RH_S
        
        fn_track(count,1)={str_name};
        
        clear num txt raw fn 
    end
    % conductance
    % Tleaf
    % Tair
    % PARi
    % VPDL
    % Observation matrix, # of observations
    % RH_sample 
    clear str str_name
end

Environment_Mat(1,1)={'filename'};
Environment_Mat(1,2)={'# of obs'};
Environment_Mat(1,3)={'obs start'};
Environment_Mat(1,4)={'obs end'};
Environment_Mat(1,5)={'mean cond'};
Environment_Mat(1,6)={'std cond'};
Environment_Mat(1,7)={'mean LeafT'};
Environment_Mat(1,8)={'std LeafT'};
Environment_Mat(1,9)={'mean AirT'};
Environment_Mat(1,10)={'std AirT'};
Environment_Mat(1,11)={'mean PARi'};
Environment_Mat(1,12)={'std PARi'};
Environment_Mat(1,13)={'mean VPDL'};
Environment_Mat(1,14)={'std VPDL'};
Environment_Mat(1,15)={'mean RH_S'};
Environment_Mat(1,16)={'std RH_S'};

n2=length(Output(:,1));

Environment_Mat(2:n2+1,1)=fn_track; 
for i=1:n2
    for j=1:15
        Environment_Mat(i+1,j+1)={Output(i,j)};
    end
end

xlswrite([fn_output 'Env_Variable_Master_Sheet.xlsx'],Environment_Mat);
clear n1 n2 fn_track Output

save Loren_Environmental_Variable






%% PART 2: Automatically Photosynthesis Parameterization

expansion_rate=1; % if equal to 1, the default version of the code; >1, it will generate bigger boundary than the default
n1=length(listing);
count=0;
for i=4:n1 % using the for-loop to automatically search each file
    str=listing(i,1); % extracting the file name for each file
    str_name=str.name;
    if str_name(1,1)=='A' % Only applicable for those ACI-curves
        count=count+1;
        
        if comp == 0
        fn=[folder '\' str_name]; 
        elseif comp == 1
        fn=[folder '/' str]; % in MAC, we use fn=[folder '/' str];
        end
        
        
        
        
        
        [num txt raw]=xlsread(fn); % although it is a csv file, I use xlsread function instead 
        t=mean(num(num(:,20)>0,20)); % leaf temperature
        ci=num(num(:,11)>0,11);
        [ci1 ind]=sort(ci);
        
        pho=num(num(:,11)>0,9);
        pho1=pho(ind);
        
        test=ACC_Parameterization(t, ci1, pho1, expansion_rate);
        [A R2 RMSE]=Photo_Predic(test.va, t, ci1, pho1);
        
        close all
        
        figure('color','white');
        plot(ci1,pho1,'ko','MarkerSize',8,'MarkerFaceColor',[0.6 0.6 0.6]);
        hold on
        plot(ci1,A,'r-','LineWidth',2);
        xlabel('Ci','fontsize',16);
        ylabel('An','fontsize',16);
        set(gca,'fontsize',14);
        xmin=min(ci);
        xmax=max(ci);
        
        ymin=min(pho);
        ymax=max(pho);
        axis([xmin-0.1*(xmax-xmin) xmax+0.1*(xmax-xmin) ymin-0.1*(ymax-ymin) ymax+0.1*(ymax-ymin)]);
        title(str_name(1:end-4),'fontsize',16);
        
        saveas(1,[fn_physiogy_output 'Exp_' num2str(expansion_rate) '_' str_name(1:end-4)]);
        close(1);
        
        Va(count,:)=test.va;
        Va_25(count,:)=test.va_25;
        Va_Scale(count,:)=test.Scale;
        
        Output1(count,1)=expansion_rate;
        Output1(count,2)=R2; 
        Output1(count,3)=RMSE;
        Output1(count,4)=length(A);
        Output1(count,5)=t;
        
        clear R2 RMSE A
        clear ci pho test ci1 pho1
        
        fn_track(count,1)={str_name};
        
        clear t ci pho
        clear num txt raw fn 
    end     
    clear str str_name
end


Physiology_Output(1,1)={'filename'};
Physiology_Output(1,2)={'expan_rate'};
Physiology_Output(1,3)={'R2'};
Physiology_Output(1,4)={'RMSE'};
Physiology_Output(1,5)={'# of obs'};
Physiology_Output(1,6)={'LeafT'};

Physiology_Output(1,7)={'gm'};
Physiology_Output(1,8)={'Vcmax'};
Physiology_Output(1,9)={'Rd'};
Physiology_Output(1,10)={'Jmax'};
Physiology_Output(1,11)={'TPU'};

Physiology_Output(1,12)={'gm_25'};
Physiology_Output(1,13)={'Vcmax_25'};
Physiology_Output(1,14)={'Rd_25'};
Physiology_Output(1,15)={'Jmax_25'};
Physiology_Output(1,16)={'TPU_25'};

Physiology_Output(1,17)={'gm_scale'};
Physiology_Output(1,18)={'Vcmax_scale'};
Physiology_Output(1,19)={'Rd_scale'};
Physiology_Output(1,20)={'Jmax_scale'};
Physiology_Output(1,21)={'TPU_scale'};

n2=length(Output1(:,1));

Physiology_Output(2:n2+1,1)=fn_track;

for i=1:n2
    for j=2:6
        Physiology_Output(i+1,j)={Output1(i,j-1)};
    end
end

for i=1:n2
    for j=7:11
        Physiology_Output(i+1,j)={Va(i,j-6)};
    end
end

for i=1:n2
    for j=12:16
        Physiology_Output(i+1,j)={Va_25(i,j-11)};
    end
end

for i=1:n2
    for j=17:21
        Physiology_Output(i+1,j)={Va_Scale(i,j-16)};
    end
end


xlswrite([fn_physiogy_output 'Physiology_Variable_Master_Sheet.xlsx'],Physiology_Output);

save Loren_Physiology_Variable