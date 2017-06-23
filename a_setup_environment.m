opengl info

% Fixed by Tor
% disp('Setting default save format to MAT v7.3 (for >2GB output)')
% disp('NOTE: This setting will persist beyond this session!')
% com.mathworks.services.Prefs.setStringPref('MatfileSaveFormat', 'v7.3')

% Base directory for whole study/analysis
if exist('/Volumes', 'dir')
    
    disp('Running on Mac workstation')
    add_canlab = @(p) addpath(genpath(['/Users/wielgosz/Box Sync/chm_canlab/tools/' p]));
    projectdir='/Volumes/study2/nc2p/canlab';

    % note that older spm12 binaries don't work for macOS 10.12 + R2017a
    addpath('~/bin/spm12') 
    
elseif exist('/study/nc2p', 'dir')
    
    disp('Running in UW Keck BI environment')
    projectdir = '/study/nc2p/canlab';
    add_canlab = @(p) addpath(genpath(['/study2/nc2p/canlab/tools/' p]));
    
else
    warning('Unknown environment.')
    add_canlab = @(p) warning(['Make sure ' p ' is on matlab path']); 
    projectdir = fileparts(fileparts(fileparts(pwd))); % get directory three levels up (projectdir/dset/datasetname/scripts)
    warning(['Assuming this is dir for dsets: ' dsetdir ])
end

warning('off', 'MATLAB:rmpath:DirNotFound')
dset_pattern = [projectdir '/dsets/nc2*'];
disp(['Removing previously set ' dset_pattern '/scripts from path'])
dset_script_paths = arrayfun(@(x) fullfile(x.folder, x.name, 'scripts'), dir(dset_pattern), 'UniformOutput', false);
rmpath(dset_script_paths{:})

add_canlab('CANlab_help_examples/Second_level_analysis_template_scripts');
add_canlab('CanlabCore/CanlabCore');
add_canlab('MasksPrivate/Masks_private');

% Needed for parcellation
add_canlab('2015_Rosenberg_NatNeuro_SustainedAttention')

% Needed for between-person correlations
add_canlab('RobustToolbox/robust_toolbox')

dsetdir = fullfile(projectdir, 'dsets');

supportdir = fullfile(projectdir, 'tools/CHM_Canlab_Support');
if ~exist(supportdir, 'dir')
    warning(['Missing support folder: ' supportdir]);
else
    addpath(supportdir)
end