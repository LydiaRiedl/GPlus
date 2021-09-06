%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% 1stLevel Script for G+ Data %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% FOR ANALYSIS WITH SPM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% by Lydia Riedl %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% runs on server 28.01.2020 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% summary
% This script performs 1st level analysis (specification + estimation)
... of a single subject using the SPM12 jobman utilities. Specifically, 
... it creates an SPM.mat file containing all parameters for 1st level.
... Data where preprocessed with fMRIPrep
... and are provided in BIDS standardized format.

%% references
% for further infos regarding BIDS format, 
...please check https://bids.neuroimaging.io/
% for further infos regarding fMRIPrep pipeline, 
...please check https://fmriprep.readthedocs.io
% for further infos about G+ project, 
...please check https://osf.io/uh4f9/

%% CAVE
% it is important to always run analyses on the same server and with the 
...same matlab/spm version earlier subjects were run with!!

% server: mri008
%
% matlab: MATLAB 9.2.0 (R2017a)
%
% spm: SPM12 - started by typing 'spm12' in terminal (on server, SPM12 does
... not start automatically!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inputs
%       subj     : subject ID       In G+ project, the subjects'directories 
%                                   are in BIDS format and named according 
%                                   to BIDS standards with 's' being the 
%                                   patient group and 'g' being the control 
%                                   group.
%       assess   : assessments      According to BIDS standards, the
%                                   structural measurement's directory is 
%                                   named 'anat' and the functional 
%                                   measurement's directory is named
%                                   'func'.
%       dir_path : directory path   directory with preprocessed EPIs
%       logfile_path: logfile path  directory with the output files with
%                                   the stimulus onset times and durations
%                                   grouped after stimulus condition
%       tgt_path : target directory ...for newly written SPM-mat files
%       jobfile  : jobfile          path, where the SPM-jobfile is stored
%                                   and name of the correct jobfile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% HERE THE VARIABLES AND PATHS ARE DEFINED %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% PLEASE ADJUST THE NAMES AND PATHS TO YOUR DATA %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use ctrl-F to find parameters that need to be checked...
...when adjusting to different datasets ("CHECK!")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% as default, clearing all old variables in the workspace
clear,clc;

%% changing working directory and adding it to the path
... CAVE! In our departement, please use the scratch directory!!
addpath('/YOUR/PATH/derivatives/analyses'); % CHECK!
cd '/YOUR/PATH/derivatives/analyses' % CHECK!

%% starting SPM
spm12 % start SPM12 to enable executing spm_jobman()

%% subjects' IDs
subj = {'sub-si01', 'sub-si02', 'sub-si03', 'sub-si04', 'sub-si05', 'sub-si06', 'sub-si07', 'sub-si08', 'sub-si09', 'sub-si10', 'sub-si11', 'sub-si13', 'sub-si14', 'sub-si15', 'sub-si16', 'sub-si17', 'sub-si18', 'sub-si19', 'sub-si20', 'sub-si21', 'sub-sw01', 'sub-sw02', 'sub-sw03', 'sub-sw05', 'sub-sw07', 'sub-sw09', 'sub-sw10', 'sub-sw11', 'sub-sw12', 'sub-gi01', 'sub-gi02', 'sub-gi03', 'sub-gi04', 'sub-gi06', 'sub-gi07', 'sub-gi12', 'sub-gi14', 'sub-gi16', 'sub-gi17', 'sub-gi18', 'sub-gi19', 'sub-gw01', 'sub-gw03', 'sub-gw05', 'sub-gw06', 'sub-gw07'}; 

%% assessments
assess = {'ses-pre', 'ses-bl', 'ses-post'};

%% directories
dir_path = '/YOUR/PATH/derivatives/analyses/import_fmriprep_for_spm_analyses'; % CHECK! directory path with EPIs
logfile_path = '/YOUR/PATH/derivatives/analyses/import_fmriprep_for_spm_analyses'; % CHECK! logfile path
tgt_path = '/YOUR/PATH/derivatives/analyses/1stlevel_task-perception'; % CHECK! target directory, where SPM.mat file will be saved
jobfile = {'/YOUR/PATH/scripts/container_gplus_02_1stlevel_perception_keywordtimes_job.m'}; % CHECK! directory where the SPM-jobfile is stored

%% loop settings
nrun = length(subj); % CHECK! enter the number of runs here - as default, the script will run over all subjects defined in the above section

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%DON'T CHANGE ANYTHING FROM HERE!!!%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

jobs = repmat(jobfile, 1, nrun); % jobs will be executed as defined under "loop settings"
inputs = cell(10, nrun); % script will loop as defined under "loop settings"
% List of open inputs
% File Selector (Batch Mode): Directory - cfg_files
% fMRI model specification: Directory - cfg_files

%% loop
for crun = 1:nrun
    %% creating a path to the current subject's BIDS-directory
    subj_path = fullfile(dir_path, subj{crun}, assess{3});  % creating a path of current subject's folder
    
    %% defining the inputs for the SPM job-file 
    % if the needed inputs where imported from fmriprep using the
    % "import_fmriprep" script from Lydia, all the needed files should be stored in the same directory (subj_path) 
    inputs{1, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with conditions files, run 1
    inputs{2, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with conditions files, run 2
    inputs{3, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with conditions files, run 3
    inputs{4, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with regressions rp files, run 1
    inputs{5, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with regressions rp files, run 2
    inputs{6, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with regressions rp files, run 3
    inputs{7, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with preprocessed nii files, run 1
    inputs{8, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with preprocessed nii files, run 2
    inputs{9, crun} = cellstr(subj_path); % File Selector (Batch Mode): Directory - cfg_files % diretory with preprocessed nii files, run 3
    
    %% creating a new directory for each subject in order to prevent spm from overwriting existing SPM.mat files
    new_tgt_dir = mkdir(fullfile(tgt_path, subj{crun}, assess{3})) % naming the new directory after the current subject ID
    
    inputs{10, crun} = cellstr(fullfile(tgt_path, subj{crun}, assess{3})); % fMRI model specification: Directory - cfg_files % target directory where the SPM.mat file will be written
end

spm('defaults', 'FMRI'); % using the default settings in SPM
spm_jobman('run', jobs, inputs{:}); % executing jobman



