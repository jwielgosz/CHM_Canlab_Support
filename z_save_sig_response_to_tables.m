% Save signature responses to csv tables
%
%
% created: wielgosz 2017-06-19


%% SETUP

% Make this script runnable on its own
if ~exist('DAT', 'var')
    close all
    clear all
    a_set_up_paths_always_run_first
    b_reload_nps_response_only
    prep_1b_prep_behavioral_data % make sure up-to-date
    
end

%tabledir = fullfile(resultsdir, 'tables');

mysignature =   {'NPS', 'NPSpos', 'NPSneg', 'SIIPS'};
scalenames =    {'raw'};                                % or scaled
simnames =      {'dotproduct'};                         % or 'cosine_sim' 'dotproduct'

%% CONDITIONS

tabrow = 1; % for output table
clear rtab
tab_colnames = {'signature', 'scale', 'metric', 'condition_type', 'condition_name', 'id', 'response'};
out_tab = emptytable(tab_colnames);

ctype = 'condition';

for s = 1:length(mysignature)
    %for s = 1:1
    signame = mysignature{s};
    scale_name = scalenames{1};
    sim_name = simnames{1};
    
    condition_names = DAT.SIG_conditions.(scale_name).(sim_name).conditionnames;
    
    for c = 1:length(condition_names )
        responses = DAT.SIG_conditions.(scalenames{1}).(simnames{1}).(signame).(c);

        try 
            id_col = DAT.BETWEENPERSON.condition_covs{c}.id;
        catch
            id_col = 1:length(responses);
        end
        
        cname = condition_names{c};
        %img_idx = 
        rtab = filltable(signame, scale_name, sim_name, ctype, cname, id_col, responses);
        rtab.Properties.VariableNames = tab_colnames;
        out_tab = [ out_tab ; rtab ];
        
    end
    
end

% out_tab
%
% %% SAVE CONDITIONS TABLE
%
% tab_f = fullfile(resultsdir, 'sig_response_by_contrast.csv');
% printhdr('Saving results table')
% writetable(out_tab, tab_f)

%% CONTRASTS

tabrow = 1; % for output table
clear rtab
%clear out_tab
tab_colnames = {'signature', 'scale', 'metric', 'condition_type', 'condition_name', 'id', 'response'};
%out_tab = emptytable(tab_colnames);

ctype = 'contrast';

for s = 1:length(mysignature)
    %for s = 1:1
    signame = mysignature{s};
    scale_name = scalenames{1};
    sim_name = simnames{1};
    
    contrast_names = DAT.SIG_contrasts.(scale_name).(sim_name).conditionnames;
    
    for c = 1:length(contrast_names )
        try 
            id_col = DAT.BETWEENPERSON.contrast_covs{c}.id;
        catch
            id_col = 1:length(responses);
        end
        
        cname = contrast_names{c};
        responses = DAT.SIG_contrasts.(scalenames{1}).(simnames{1}).(signame).(c);
        img_idx = 1:length(responses);
        rtab = filltable(signame, scale_name, sim_name, ctype, cname, id_col, responses);
        rtab.Properties.VariableNames = tab_colnames;
        out_tab = [ out_tab ; rtab ];
    end
end


%% SAVE CONTRASTS TABLE

% tab_f = fullfile(tabledir, 'signature_responses_by_condition.csv');
% if ~exist(tabledir, 'dir')
%     printstr('Creating table directory')
%     mkdir(tabledir)
% end

tab_f = fullfile(resultsdir, 'signature_responses_by_condition.csv');
printhdr('Saving results table')
writetable(out_tab, tab_f)





%%
% Create table with named columns and zero rows
%
%
% created: wielgosz 2017-06-19

function tbl = emptytable(varnames)

tbl = cell2table(cell(0,length(varnames)), 'VariableNames', varnames);

end

%%
% Generate a table from cell vectors of uneven length.
% Shorter vectors are repeated and trimmed to match the longest.
%
% created: wielgosz 2017-06-19

function tbl = filltable(varargin)
tbl_nrow = max(cellfun(@length, varargin));
tbl_ncol = nargin;

V = cell(tbl_nrow, tbl_ncol);
for i = 1:tbl_ncol
    if isnumeric(varargin{i})
        c = num2cell(varargin{i});
    elseif ischar(varargin{i})
        c = {varargin{i}};
    else
        c = varargin{i};
    end
    n_to_cover = ceil(tbl_nrow / length(c));
    arg_stretched = repmat(c(:), n_to_cover, 1);
    V(:,i) = arg_stretched(1:tbl_nrow);
end

tbl = cell2table(V);


end

