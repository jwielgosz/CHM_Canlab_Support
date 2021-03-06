% Run this script once to prep data files, save them, calculate contrast
% image objects, and get ready to run analyses.
%
% Before running, you need to customize two scripts for your analysis:
% a_set_up_paths_always_run_first.m
% prep_1_set_conditions_contrasts_colors.m
%
% If you have behavioral data and between-subject contrasts, you should
% customize prep_1b_prep_behavioral_data.m and put in your run path.
%
% You do not have to copy over all the scripts from the master
% "Second_level_analysis_template_scripts" folder to use them.
% The standard versions of most scripts will run without editing.
% But if you choose, you can copy any of them to your individual project directory
% and customize them, and run those customized versions instead of the
% standard versions.

% Other scripts you can copy over and edit if you want to:
%prep1b_prep_behavioral_data


% Scripts that you must copy over and edit:

a_set_up_paths_always_run_first
disp('Running prep_1')
prep_1_set_conditions_contrasts_colors
prep_1b_prep_behavioral_data

%% --------------------------------------------------------------
% prep_2

if exist(fullfile(resultsdir, 'prep2_completed'), 'file')
    disp('Already completed prep_2, skipping and loading saved files')
    b_reload_saved_matfiles
else
    disp('Running prep_2')
    prep_2_load_image_data_and_save
end


%% --------------------------------------------------------------
% prep_3

if exist(fullfile(resultsdir, 'prep3_completed'), 'file')
    disp('Already completed prep_3, skipping')
else
    disp('Running prep_3')
    prep_3_calc_univariate_contrast_maps_and_save
end

%% --------------------------------------------------------------
% prep_4

if exist(fullfile(resultsdir, 'prep4_completed'), 'file')
    disp('Already completed prep_4, skipping')
else
    disp('Running prep_4')
    prep_4_apply_signatures_and_save
end

