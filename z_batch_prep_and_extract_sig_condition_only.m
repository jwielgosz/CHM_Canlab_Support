% publish script

% Run this from the 'scripts' directory where it is stored

close all
clear all

a_set_up_paths_always_run_first

prep_1_set_conditions_contrasts_colors
prep_1b_prep_behavioral_data

%% --------------------------------------------------------------
% prep_2

if exist(fullfile(resultsdir, 'prep2_completed'), 'file')
    disp('Already completed prep_2, skipping and loading saved files')
    b_reload_nps_response_only
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

%%

z_save_sig_response_to_tables