masterscriptdir = which('Second_level_analysis_template_scripts/0_begin_here_readme');

if isempty(masterscriptdir)
    error('Add Second_level_analysis_template_scripts folder from CANlab_help_examples repository to your path'); 
end


%% SUMMARY

% Load and print summary of study from study_info.json and contrast info
% -------------------------------------------------------------------------
scriptname = which(fullfile('Second_level_analysis_template_scripts', 'core_scripts_to_run_without_modifying', 'b_reload_saved_matfiles'));
run(scriptname); % Run from master script, not local script. This script should not need to be edited for individual studies.

% LOAD ALL SUMMARY TEXT FILES AND DISPLAY IN REPORT
% -------------------------------------------------------------------------

myfiles = dir(fullfile(resultsdir, '*summary_text'));

for i = 1:length(myfiles)
    
    mytext = fileread(fullfile(resultsdir, myfiles(i).name));
    printhdr(myfiles(i).name);
    disp(mytext);
    disp(' ');
    
end


%% GROUP DIFFERENCES

printhdr('GROUP DIFFERENCES IN NPS RESPONSES')

scriptname = which(fullfile('Second_level_analysis_template_scripts', 'core_scripts_to_run_without_modifying',  'h_group_differences_custom'));
run(scriptname); % Run from master script, not local script. This script should not need to be edited for individual studies.


%% CONTRAST BETWEEN PERSON CORRELATIONS

printhdr('BETWEEN-PERSON CORRELATIONS WITH NPS RESPONSES')

% Run custom local copy 
h_NPS_contrasts_between_person_correlations_multiple


