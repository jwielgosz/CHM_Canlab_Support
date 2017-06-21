% customized to run behavioral analyses (wielgosz 2017-06-17)

% publish script

% Run this from the 'scripts' directory where it is stored

close all
clear all

a_set_up_paths_always_run_first

b_reload_saved_matfiles           % done in indivdidual scripts to save output info in html, but re-run here so vars are available

prep_1b_prep_behavioral_data        % apply any changes to behavioral data

pubdir = fullfile(resultsdir, 'published_output');
if ~exist(pubdir, 'dir'), mkdir(pubdir), end


% ------------------------------------------------------------------------

pubfilename = ['analysis_signature_analyses_with_correlations' scn_get_datetime];

p = struct('useNewFigure', false, 'maxHeight', 800, 'maxWidth', 1600, ...
    'format', 'html', 'outputDir', fullfile(pubdir, pubfilename), 'showCode', false);

% modified to include correlations (wielgosz 2017-06-17)
publish('z_batch_signature_analyses_with_correlations.m', p)

close all
