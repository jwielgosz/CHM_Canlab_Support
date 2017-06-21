% Runs a two-sample t-test for a set of signature responses, for each
% contrast.  Also runs NPS subregions. 
% Signatures, scaling, etc. are defined below.


% Define test conditions of interest
% -------------------------------------------------------------------------

mysignature =   {'NPS', 'NPSpos', 'NPSneg', 'SIIPS'};   % 'NPS' 'NPSpos' 'NPSneg' 'SIIPS' etc.  See load_image_set('npsplus')
scalenames =    {'raw'};                                % or scaled
simnames =      {'dotproduct'};                         % or 'cosine_sim' 'dotproduct'

% Define groups
% There are two ways to define groups. The other is condition- and
% contrast-specific.  These are entered in DAT.BETWEENPERSON.conditions and
% DAT.BETWEENPERSON.contrasts, in cells.  1 -1 codes work best. 
% These are set up in prep_1b_prep_behavioral_data.m
% If they are missing, using DAT.BETWEENPERSON.group will be used as a
% generic option.
% -------------------------------------------------------------------------

tabrow = 1; % for output table
clear rtab
clear out_tab


% Loop through signatures, create one plot per contrast
% -------------------------------------------------------------------------
for s = 1:length(mysignature)
    
    % Get data
    % -------------------------------------------------------------------------
    conditiondata = table2array(DAT.SIG_conditions.(scalenames{1}).(simnames{1}).(mysignature{s}));
    contrastdata = table2array(DAT.SIG_contrasts.(scalenames{1}).(simnames{1}).(mysignature{s}));
    
    kc = size(contrastdata, 2);
    
    % Plot
    % -------------------------------------------------------------------------
    printhdr(sprintf('%s responses: Scale = %s Metric = %s', mysignature{s}, scalenames{1}, simnames{1}));
    
    
    for i = 1:kc

        figtitle = sprintf('%s %s group diffs %s %s', mysignature{s}, DAT.contrastnames{i}, scalenames{1}, simnames{1});
        create_figure(figtitle, 1, 1);
%         create_figure(figtitle, 1, kc);
        
        mygroupnamefield = 'contrasts';  % 'conditions' or 'contrasts'
        
        % Load group variable
        [group, groupnames, groupcolors] = plugin_get_group_names_colors(DAT, mygroupnamefield, i);
        
        if isempty(group), continue, end % skip this condition/contrast - no groups
        
        %y = {DAT.(myfield){i}(group > 0) DAT.(myfield){i}(group < 0)};
        y = {contrastdata(group > 0, i) contrastdata(group < 0, i)};
        
        %subplot(1, kc, i)
        
        printstr(' ');
        printstr(sprintf('Group differences: %s, %s', mysignature{s}, DAT.contrastnames{i}));
        printstr(dashes)
        
        barplot_columns(y, 'nofig', 'colors', groupcolors, 'names', groupnames);
        
        title(DAT.contrastnames{i})
        xlabel('Group');
        ylabel(sprintf('%s Response', mysignature{s}));

        rtab.signature = mysignature{s};
        rtab.scaling = scalenames{1};
        rtab.metric = simnames{1};
        rtab.contrast = DAT.contrastnames{i};
        rtab.group_names = sprintf("%s-%s", groupnames{2}, groupnames{1});
        
        printstr('Between-groups test:');
        
        [rtab.H,rtab.p,rtab.ci,stats] = ttest2_printout(y{1}, y{2});
        out_tab(tabrow) = rtab;
        tabrow = tabrow + 1;
        
        printstr(dashes)
   
        drawnow, snapnow

    end % panels
    
    
end % signature

tab_f = fullfile(resultsdir, 'NPS_contrast_group_diffs.csv');
printhdr('Saving results table')
writetable(struct2table(out_tab), tab_f)


%% Subregions - Pos

% for tabular output (wielgosz 2017-06-19)
tab_vars = {'RegionGroup' 'Contrast' 'Groups' 'Region' 'means' 'T' 'p'};
out_tab = cell2table(cell(0,length(tab_vars)), 'VariableNames', tab_vars);

% which variables to use
mysubrfield = 'npspos_by_region_contrasts'; % 'npspos_by_region_cosinesim';     %'npspos_by_regionsc';
mysubrfieldneg = 'npsneg_by_region_contrasts'; % 'npsneg_by_region_cosinesim';  % 'npsneg_by_regionsc';

posnames = DAT.NPSsubregions.posnames;
negnames = DAT.NPSsubregions.negnames;

clear means p T

tabrow = 1; % for output table


for i = 1:kc  % for each contrast
    
    mygroupnamefield = 'contrasts';  % 'conditions' or 'contrasts'
    [group, groupnames, groupcolors] = plugin_get_group_names_colors(DAT, mygroupnamefield, i);
    if isempty(group), continue, end % skip this condition/contrast - no groups
    
    mydat = DAT.NPSsubregions.(mysubrfield){i};
    k = size(mydat, 2);
    
    create_figure(sprintf('NPS subregions by group %s', DAT.contrastnames{i}), 1, k);
    pos = get(gcf, 'Position');
    pos(4) = pos(4) .* 2.5;
    set(gcf, 'Position', pos);
    
    clear means p T
    
    for j = 1:k  % for each subregion
        
       subplot(1, k, j);
        
        y = {mydat(group == 1, j) mydat(group == -1, j)};
        
        printhdr(posnames{j});
        
       barplot_columns(y, 'nofig', 'colors', groupcolors, 'noviolin', 'noind', 'names', groupnames );
        
        title(posnames{j})
        xlabel('Group');
        if j == 1, ylabel('NPS Response'); end
        
        printstr('Between-groups test:');
        [H,p(j, 1),ci,stats] = ttest2_printout(y{1}, y{2});
        
        means(j, :) = stats.means;
        T(j, 1) = stats.tstat;
        
    end
    
   drawnow, snapnow
    
    % Print between-subject Table
    printhdr('Between-group tests');
    Region = posnames';
    col_group = repmat({'NPSpos'}, length(Region), 1);
    col_contrast = repmat({DAT.contrastnames{i}}, length(Region), 1);
    col_grpnames = repmat({strjoin(groupnames, " ")}, length(Region), 1);
    regionmeans = table(col_group, col_contrast, col_grpnames, Region, means, T, p, 'VariableNames', tab_vars);
    
    disp(regionmeans);
    
    out_tab = [ out_tab ; regionmeans ];
    
end % panels

%% Subregions - Neg

for i = 1:kc
    
    mygroupnamefield = 'contrasts';  % 'conditions' or 'contrasts'
    [group, groupnames, groupcolors] = plugin_get_group_names_colors(DAT, mygroupnamefield, i);
    
    if isempty(group), continue, end % skip this condition/contrast - no groups
    
    mydat = DAT.NPSsubregions.(mysubrfieldneg){i};
    k = size(mydat, 2);
    
    create_figure(sprintf('NPS neg subregions by group %s', DAT.contrastnames{i}), 1, k);
    pos = get(gcf, 'Position');
    pos(4) = pos(4) .* 2.5;
    set(gcf, 'Position', pos);
    
    clear means p T
    
    for j = 1:k
        
        subplot(1, k, j);
        
        y = {mydat(group == 1, j) mydat(group == -1, j)};
        
        printhdr(negnames{j});
        
        barplot_columns(y, 'nofig', 'colors', groupcolors, 'noviolin', 'noind', 'names', groupnames );
        
        title(negnames{j})
        xlabel('Group');
        if j == 1, ylabel('NPS Response'); end
        
        printstr('Between-groups test:');
        [H,p(j, 1),ci,stats] = ttest2_printout(y{1}, y{2});
        
        means(j, :) = stats.means;
        T(j, 1) = stats.tstat;
        
    end
    
    drawnow, snapnow
    
    % Print between-subject Table
    printhdr('Between-group tests');
    Region = negnames';
    col_group = repmat({'NPSneg'}, length(Region), 1);
    col_contrast = repmat({DAT.contrastnames{i}}, length(Region), 1);
    col_grpnames = repmat({strjoin(groupnames, " ")}, length(Region), 1);
    regionmeans = table(col_group, col_contrast, col_grpnames, Region, means, T, p, 'VariableNames', tab_vars);
  
    
    disp(regionmeans);
    
    out_tab = [ out_tab ; regionmeans ];

    
end

out_tab.sig = arrayfun(@sigstars, out_tab{:,'p'}, 'UniformOutput', false);

tab_f = fullfile(resultsdir, 'NPS_contrast_group_diffs_by_region.csv');
printhdr('Saving results table')
writetable(out_tab, tab_f)

function stars = sigstars(p)
if (p < .001)
    stars = '***';
elseif (p < .01)
    stars =  '**';
elseif (p < .05)
    stars =  '*';
else
    stars = '';
end
end

% function [group, groupnames, groupcolors] = plugin_get_group_names_colors(DAT, mygroupnamefield, i)
% 
% group = []; groupnames = []; groupcolors = [];
% 
% if isfield(DAT, 'BETWEENPERSON') && ...
%         isfield(DAT.BETWEENPERSON, mygroupnamefield) && ...
%         iscell(DAT.BETWEENPERSON.(mygroupnamefield)) && ...
%         length(DAT.BETWEENPERSON.(mygroupnamefield)) >= i && ...
%         ~isempty(DAT.BETWEENPERSON.(mygroupnamefield){i})
%     
%     group = DAT.BETWEENPERSON.(mygroupnamefield){i};
%     
% elseif isfield(DAT, 'BETWEENPERSON') && ...
%         isfield(DAT.BETWEENPERSON, 'group') && ...
%         ~isempty(DAT.BETWEENPERSON.group)
%     
%     group = DAT.BETWEENPERSON.group;
% 
% end
% 
% 
% if isfield(DAT, 'BETWEENPERSON') && isfield(DAT.BETWEENPERSON, 'groupnames')
%     groupnames = DAT.BETWEENPERSON.groupnames;
% elseif istable(group)
%     groupnames = group.Properties.VariableNames(1);
% else
%     groupnames = {'Group-Pos' 'Group-neg'};
% end
% 
% if isfield(DAT, 'BETWEENPERSON') && isfield(DAT.BETWEENPERSON, 'groupcolors')
%     groupcolors = DAT.BETWEENPERSON.groupcolors;
% else
%     groupcolors = seaborn_colors(2);
% end
% 
% if istable(group), group = table2array(group); end
% 
% end
