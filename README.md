Code-for-Leaf-Physiology
========================

The goals for this code include:
(1) Automatically extract environmental variables for each ACI curve
(2) Run the batch analysis for extracting key physiological parameters

%%%Folder: Matlab-code%%%
-->subfolder: tests for Jin
----> subfolder: Matlab Code_For_Loren

Script descriptions:
Test_Environmental_Variable_Extraction_V1.m
includes Part 1: automatically extract the environmental variables and Part 2: automatically extract physiological parameter
This script produces output:
Environmental variable is saved as ./Env_Variables_Output/
Physiological variables is saved as ./Physiology_Output/
The internal model and observed A-CI plot is also saved as ./Physiology_Output/

Scripts/functions based on Sun et al. 2009 paper for A-Cc curve fitting using a genetic
algorithm:
ACC_Parametrization.m
crossover.m
decode.m
encode.m
mutation.m
myfunc.m
myfunc2.m
myfunc3.m
preidbound.m
select.m

(Double check other script functions with Jin)

Notes:

We discussed some changes to make to the original code from Sun et al. 2009.  Here is an email
from Jin describing some of the changes (changes made before I forked this copy of 
Code-for-Leaf-Physiology)

"Hi Loren,

I just did a quick check on the model. I found if I change the boundary of the parameter space, it indeeds can help the model optimization, but that neccessary means it is right. You can double check it then. 
I am now leaving the code there, and let me know when you have questions.
Also, can you send me some new version of data very soon? Scott and I plan to submit my manuscript around Dec 10th then.

%% Here is what I did for the code in
test=ACC_Parameterization(t, ci, pho, expansion_rate)


lbvc=Vcmax0-50; % Low boundary of Vcmax

if lbvc<0

lbvc=0;

end

lbJ=Jmax0-60; % Low boundary of Jmax

if lbJ<0

lbJ=0;

end

bound(1,:)=[.1 lbvc 0 lbJ TPU0-10];

bound(2,:)=[30 Vcmax0+70 20 Jmax0+70 TPU0+10];

sca_var=10^(-20);

popusize=200;
