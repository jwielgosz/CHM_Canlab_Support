%% Load and display JSON file with study info, if we have it

plugin_display_study_info_json;

%% Load DAT structure with setup info
% ------------------------------------------------------------------------

savefilename = fullfile(resultsdir, 'image_names_and_setup.mat');
load(savefilename, 'DAT')
% For publish output
disp(basedir)
fprintf('Loaded DAT from results%simage_names_and_setup.mat\n', filesep);



