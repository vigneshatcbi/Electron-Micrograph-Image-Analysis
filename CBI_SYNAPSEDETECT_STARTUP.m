%% CBI_SYNAPSEDETECT_STARTUP.m

% PLEASE CHANGE THIS ACCORDING TO LOCAL DIRECTORIES
patchdir = 'C:\Users\vignesh\Desktop\CBI_SYNAPSEDETECT\data\patch_data\';
datadir = 'C:\Users\vignesh\Desktop\CBI_SYNAPSEDETECT\data\tailor_data\';
featdir = [datadir 'curr_features\'];
rootdir = 'C:\Users\vignesh\Desktop\';


% ADD REQUIRED PATHS
addpath([patchdir]);
addpath([datadir 'con_synapses\']);
addpath([datadir 'non_synapses\']);
addpath([rootdir 'CBI_SYNAPSEDETECT\utils']);
addpath([rootdir 'CBI_SYNAPSEDETECT\utils\BOF\']);
addpath([rootdir 'CBI_SYNAPSEDETECT\utils\gentleboost\']);
addpath([rootdir 'CBI_SYNAPSEDETECT\utils\spectral\']);
addpath([rootdir 'CBI_SYNAPSEDETECT\utils\svm\']);

display('CBI_SYNAPSE_DETECT is ready');