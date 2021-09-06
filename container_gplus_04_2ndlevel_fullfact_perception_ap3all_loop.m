%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% 2ndLevel Script for G+ Data %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% FOR ANALYSIS WITH SPM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% by Lydia Riedl %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% runs on server 11.08.2020 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% summary
% This script performs 2nd level analysis (specification + estimation)
... using the SPM12 jobman utilities. 
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
%       firstlevel_path :           directory with 1st level contrast
%                                   images
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
subj_g = {'sub-gi01', 'sub-gi02', 'sub-gi03', 'sub-gi04', 'sub-gi06', 'sub-gi07', 'sub-gi12', 'sub-gi14', 'sub-gi16', 'sub-gi17', 'sub-gi18', 'sub-gi19', 'sub-gw01', 'sub-gw03', 'sub-gw05', 'sub-gw06', 'sub-gw07'}; % CHECK!
subj_s = {'sub-si01', 'sub-si02', 'sub-si03', 'sub-si04', 'sub-si05', 'sub-si06', 'sub-si07', 'sub-si08', 'sub-si09', 'sub-si10', 'sub-si11', 'sub-si13', 'sub-si14', 'sub-si15', 'sub-si16', 'sub-si17', 'sub-si18', 'sub-si19', 'sub-si20', 'sub-si21', 'sub-sw01', 'sub-sw02', 'sub-sw03', 'sub-sw05', 'sub-sw07', 'sub-sw09', 'sub-sw10', 'sub-sw11', 'sub-sw12'}; % CHECK!

%% assessments
assess = {'ses-pre', 'ses-bl', 'ses-post'};

%% target directory's name
tgt_dir = {'2ndlevel_task-perception/model-fullfact/group-g-s/ses-pre-post'};

%% directories
firstlevel_path = '/YOUR/PATH/derivatives/analyses/1stlevel_task-perception_contrasts'; % CHECK! directory path with 1st level contrast images
%logfile_path = '/YOUR/PATH/derivatives/analyses/import_fmriprep_for_spm_analyses'; % CHECK! logfile path
tgt_path = '/YOUR/PATH/derivatives/analyses'; % CHECK! target directory, where SPM.mat file will be saved
jobfile = {'/YOUR/PATH/scripts/container_gplus_04_2ndlevel_fullfact_perception_ap3all_job.m'}; % CHECK! directory where the SPM-jobfile is stored

%% loop settings
nrun = 1; %length(subj); % CHECK! enter the number of runs here - as default, the script will run over all subjects defined in the above section
jobs = repmat(jobfile, 1, nrun); % jobs will be executed as defined under "loop settings"
inputs = cell(25, nrun); % script will loop as defined under "loop settings"
% List of open inputs
% File Selector (Batch Mode): Directory - cfg_files
% fMRI model specification: Directory - cfg_files

%% loop
for crun = 1:nrun
    %% creating a path to the current subject's 1st level contrasts directory
    %subj_path = fullfile(firstlevel_path, subj{crun}, assess{1});  % creating a path of current subject's folder
    
    %% group g
    
    % session pre
    for i = 1:length(subj_g) 
        con1_g_pre = dir([firstlevel_path, '/', subj_g{i}, '/', assess{1}, '/con_0001.nii']); % find all con_0001-nii images (1st contrast from 1st level)
        con2_g_pre = dir([firstlevel_path, '/', subj_g{i}, '/', assess{1}, '/con_0002.nii']); % find all con_0002-nii images (1st contrast from 1st level)
        con3_g_pre = dir([firstlevel_path, '/', subj_g{i}, '/', assess{1}, '/con_0003.nii']); % find all con_0003-nii images (1st contrast from 1st level)
        con4_g_pre = dir([firstlevel_path, '/', subj_g{i}, '/', assess{1}, '/con_0004.nii']); % find all con_0004-nii images (1st contrast from 1st level)
        con5_g_pre = dir([firstlevel_path, '/', subj_g{i}, '/', assess{1}, '/con_0005.nii']); % find all con_0005-nii images (1st contrast from 1st level)
        con6_g_pre = dir([firstlevel_path, '/', subj_g{i}, '/', assess{1}, '/con_0006.nii']); % find all con_0006-nii images (1st contrast from 1st level)
        
        con_1_g_pre(i) = cellstr(strcat(fullfile(con1_g_pre.folder, con1_g_pre.name), ',1'));
        con_2_g_pre(i) = cellstr(strcat(fullfile(con2_g_pre.folder, con2_g_pre.name), ',1'));
        con_3_g_pre(i) = cellstr(strcat(fullfile(con3_g_pre.folder, con3_g_pre.name), ',1'));
        con_4_g_pre(i) = cellstr(strcat(fullfile(con4_g_pre.folder, con4_g_pre.name), ',1'));
        con_5_g_pre(i) = cellstr(strcat(fullfile(con5_g_pre.folder, con5_g_pre.name), ',1'));
        con_6_g_pre(i) = cellstr(strcat(fullfile(con6_g_pre.folder, con6_g_pre.name), ',1'));
    end
    
    % session post
    for i = 1:length(subj_g)
        con1_g_post = dir([firstlevel_path, '/', subj_g{i}, '/', assess{3}, '/con_0001.nii']); % find all con_0001-nii images (1st contrast from 1st level)
        con2_g_post = dir([firstlevel_path, '/', subj_g{i}, '/', assess{3}, '/con_0002.nii']); % find all con_0002-nii images (1st contrast from 1st level)
        con3_g_post = dir([firstlevel_path, '/', subj_g{i}, '/', assess{3}, '/con_0003.nii']); % find all con_0003-nii images (1st contrast from 1st level)
        con4_g_post = dir([firstlevel_path, '/', subj_g{i}, '/', assess{3}, '/con_0004.nii']); % find all con_0004-nii images (1st contrast from 1st level)
        con5_g_post = dir([firstlevel_path, '/', subj_g{i}, '/', assess{3}, '/con_0005.nii']); % find all con_0005-nii images (1st contrast from 1st level)
        con6_g_post = dir([firstlevel_path, '/', subj_g{i}, '/', assess{3}, '/con_0006.nii']); % find all con_0006-nii images (1st contrast from 1st level)
        
        con_1_g_post(i) = cellstr(strcat(fullfile(con1_g_post.folder, con1_g_post.name), ',1'));
        con_2_g_post(i) = cellstr(strcat(fullfile(con2_g_post.folder, con2_g_post.name), ',1'));
        con_3_g_post(i) = cellstr(strcat(fullfile(con3_g_post.folder, con3_g_post.name), ',1'));
        con_4_g_post(i) = cellstr(strcat(fullfile(con4_g_post.folder, con4_g_post.name), ',1'));
        con_5_g_post(i) = cellstr(strcat(fullfile(con5_g_post.folder, con5_g_post.name), ',1'));
        con_6_g_post(i) = cellstr(strcat(fullfile(con6_g_post.folder, con6_g_post.name), ',1'));
   
    end
    
    
    %% group s
    
    % session pre
    for i = 1:length(subj_s)
        con1_s_pre = dir([firstlevel_path, '/', subj_s{i}, '/', assess{1}, '/con_0001.nii']); % find all con_0001-nii images (1st contrast from 1st level)
        con2_s_pre = dir([firstlevel_path, '/', subj_s{i}, '/', assess{1}, '/con_0002.nii']); % find all con_0002-nii images (1st contrast from 1st level)
        con3_s_pre = dir([firstlevel_path, '/', subj_s{i}, '/', assess{1}, '/con_0003.nii']); % find all con_0003-nii images (1st contrast from 1st level)
        con4_s_pre = dir([firstlevel_path, '/', subj_s{i}, '/', assess{1}, '/con_0004.nii']); % find all con_0004-nii images (1st contrast from 1st level)
        con5_s_pre = dir([firstlevel_path, '/', subj_s{i}, '/', assess{1}, '/con_0005.nii']); % find all con_0005-nii images (1st contrast from 1st level)
        con6_s_pre = dir([firstlevel_path, '/', subj_s{i}, '/', assess{1}, '/con_0006.nii']); % find all con_0006-nii images (1st contrast from 1st level)
        
        con_1_s_pre(i) = cellstr(strcat(fullfile(con1_s_pre.folder, con1_s_pre.name), ',1'));
        con_2_s_pre(i) = cellstr(strcat(fullfile(con2_s_pre.folder, con2_s_pre.name), ',1'));
        con_3_s_pre(i) = cellstr(strcat(fullfile(con3_s_pre.folder, con3_s_pre.name), ',1'));
        con_4_s_pre(i) = cellstr(strcat(fullfile(con4_s_pre.folder, con4_s_pre.name), ',1'));
        con_5_s_pre(i) = cellstr(strcat(fullfile(con5_s_pre.folder, con5_s_pre.name), ',1'));
        con_6_s_pre(i) = cellstr(strcat(fullfile(con6_s_pre.folder, con6_s_pre.name), ',1'));
   
    end
    
    % session post
    for i = 1:length(subj_s)
        con1_s_post = dir([firstlevel_path, '/', subj_s{i}, '/', assess{3}, '/con_0001.nii']); % find all con_0001-nii images (1st contrast from 1st level)
        con2_s_post = dir([firstlevel_path, '/', subj_s{i}, '/', assess{3}, '/con_0002.nii']); % find all con_0002-nii images (1st contrast from 1st level)
        con3_s_post = dir([firstlevel_path, '/', subj_s{i}, '/', assess{3}, '/con_0003.nii']); % find all con_0003-nii images (1st contrast from 1st level)
        con4_s_post = dir([firstlevel_path, '/', subj_s{i}, '/', assess{3}, '/con_0004.nii']); % find all con_0004-nii images (1st contrast from 1st level)
        con5_s_post = dir([firstlevel_path, '/', subj_s{i}, '/', assess{3}, '/con_0005.nii']); % find all con_0005-nii images (1st contrast from 1st level)
        con6_s_post = dir([firstlevel_path, '/', subj_s{i}, '/', assess{3}, '/con_0006.nii']); % find all con_0006-nii images (1st contrast from 1st level)
        
        con_1_s_post(i) = cellstr(strcat(fullfile(con1_s_post.folder, con1_s_post.name), ',1'));
        con_2_s_post(i) = cellstr(strcat(fullfile(con2_s_post.folder, con2_s_post.name), ',1'));
        con_3_s_post(i) = cellstr(strcat(fullfile(con3_s_post.folder, con3_s_post.name), ',1'));
        con_4_s_post(i) = cellstr(strcat(fullfile(con4_s_post.folder, con4_s_post.name), ',1'));
        con_5_s_post(i) = cellstr(strcat(fullfile(con5_s_post.folder, con5_s_post.name), ',1'));
        con_6_s_post(i) = cellstr(strcat(fullfile(con6_s_post.folder, con6_s_post.name), ',1'));
   
    end
    
    %% creating a new directory for each subject in order to prevent spm from overwriting existing SPM.mat files
    mkdir(fullfile(tgt_path, tgt_dir{1})) % naming the new target directory as defined in variable tgt_dir
    inputs{1, crun} = cellstr(fullfile(tgt_path, tgt_dir{1})); % fMRI model specification: Directory - cfg_files % target directory where the SPM.mat file will be written
    
    %% defining the inputs for the SPM job-file  
    % CAVE! The order of the contrasts in 1st level is alphabetical (if you
    % used Lydia's Gplus container scripts) - consider to change the order
    % of the contrasts in the way you need it for 2nd level!
    % group g, session pre
    inputs{2, crun} = con_5_g_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0005.nii images
    inputs{3, crun} = con_3_g_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0003.nii images
    inputs{4, crun} = con_1_g_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0001.nii images
    inputs{5, crun} = con_6_g_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0006.nii images
    inputs{6, crun} = con_4_g_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0004.nii images
    inputs{7, crun} = con_2_g_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0002.nii images
        
    % group g, session post
    inputs{8, crun} = con_5_g_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0005.nii images
    inputs{9, crun} = con_3_g_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0003.nii images
    inputs{10, crun} = con_1_g_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0001.nii images
    inputs{11, crun} = con_6_g_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0006.nii images
    inputs{12, crun} = con_4_g_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0004.nii images
    inputs{13, crun} = con_2_g_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0002.nii images
    
    % group s, session pre
    inputs{14, crun} = con_5_s_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0005.nii images
    inputs{15, crun} = con_3_s_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0003.nii images
    inputs{16, crun} = con_1_s_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0001.nii images
    inputs{17, crun} = con_6_s_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0006.nii images
    inputs{18, crun} = con_4_s_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0004.nii images
    inputs{19, crun} = con_2_s_pre'; % Factorial design specification: Scans - cfg_files % diretory with con_0002.nii images
        
    % group s, session post
    inputs{20, crun} = con_5_s_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0005.nii images
    inputs{21, crun} = con_3_s_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0003.nii images
    inputs{22, crun} = con_1_s_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0001.nii images
    inputs{23, crun} = con_6_s_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0006.nii images
    inputs{24, crun} = con_4_s_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0004.nii images
    inputs{25, crun} = con_2_s_post'; % Factorial design specification: Scans - cfg_files % diretory with con_0002.nii images
    
end

spm('defaults', 'FMRI'); % using the default settings in SPM
spm_jobman('run', jobs, inputs{:}); % executing jobman





