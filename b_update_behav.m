% Update behavioral settings without having to load everything else
%  
% 
% created: wielgosz 2017-06-19


a_set_up_paths_always_run_first

%% Load DAT structure with setup info
% ------------------------------------------------------------------------

savefilename = fullfile(resultsdir, 'image_names_and_setup.mat');
load(savefilename, 'DAT')
% For publish output
disp(basedir)
fprintf('Loaded DAT from results%simage_names_and_setup.mat\n', filesep);

%%

% oops - this will actually erase the DAT structure!
%prep_1_set_conditions_contrasts_colors

% Second command will resave DAT
prep_1b_prep_behavioral_data
