Scripts tested with Matlab 2018a.

1. Setup: Open install.m and before running change 'root' directory to fit the directory in your PC. 
   'root' should point to the 'Analysis' folder.

2. Process Raw Data: Under the folder 'Raw-Data' you shall find experimental raw data ordered in 
   directories that correspond to the experiments presented in the manuscript. The script 
   'preprocessing.m' within this folder will reproduce the mat files within the 'Processed-Data' 
   directory. This script will take approximately 45-60 min to run.

3. Reproduce manuscript figure-components*: Navigate to one of the experiment folders. Within each 
   folder there is a folder named 'Output' which contains the figure-components appearing in the 
   manuscript, a folder named 'Processed-Data' which contains essential data used to produce the figure, 
   and one or more scripts that produce both data (xlsx files) and figures-components. The list below 
   shows the correspondence between scripts and figures:

	cc_heatmaps.m		--> Figure S7
	cc_tms.m		--> Figure S6		

	ce_process.m 		--> Figure 3C	

	dynamics_ss_heatmaps,m 	--> Figure 2A (S4A), Figure S1A
	dynamics_heatmaps.m 	--> Figure S1B, Figure S4B (Left Panel)

	growth_iso.m		--> Figure 2D, Figure S3A
	growth_comp.m		--> Figure 2C (S9A), Figure 4D
	growth_hypoxia_iso.m	--> Figure 5C, Figure S3B
	growth_hypoxia_comp.m	--> Figure 5D, Figure S9B
	growth_hypoxia_sign_iso.m --> Figure 5F, Figure S3C-D
	growth_hypoxia_sign_comp.m --> Figure 5G, Figure S9C-D

	sensitivity_analysis_O2.m --> Figure S10A
	sensitivity_analysis_EGF.m --> Figure S10C

	shape.m			--> Figure 2E (S8A), Figure S8





* please note that the manuscript figures consist of several figure-components
