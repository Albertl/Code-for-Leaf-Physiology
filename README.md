Code-for-Leaf-Physiology
========================

The goals for this code include:
(1) Automatically extract environmental variables for each ACI curve
(2) Run the batch analysis for extracting key physiological parameters

%%%Folder: Matlab-code%%%
    subfolder: tests for Jin
        subfolder: Matlab Code_For_Loren

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
