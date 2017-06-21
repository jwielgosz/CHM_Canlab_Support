signatures_to_plot = {'NPS', 'NPSpos', 'NPSneg', 'SIIPS'};  % NPS, VPS, SIIPS, etc., etc.
myscaling = 'raw';          % 'raw' or 'scaled'
mymetric = 'dotproduct';    % 'dotproduct' or 'cosine_sim'

% Controlling for group admin order covariate (mean-centered by default)

group = [];
if isfield(DAT, 'BETWEENPERSON') && isfield(DAT.BETWEENPERSON, 'group')
    group = DAT.BETWEENPERSON.group; % empty for no variable to control/remove
    
    printstr('Controlling for data in DAT.BETWEENPERSON.group');
end

% Format: The prep_4_apply_signatures_and_save script extracts signature responses and saves them.
% These fields contain data tables:
% DAT.SIG_conditions.(data scaling).(similarity metric).(signaturename)
% DAT.SIG_contrasts.(data scaling).(similarity metric).(signaturename)
%
% signaturenames is any of those from load_image_set('npsplus')
% (data scaling) is 'raw' or 'scaled', using DATA_OBJ or DATA_OBJsc
% (similarity metric) is 'dotproduct' or 'cosine_sim'
%
% Each of by_condition and contrasts contains a data table whose columns
% are conditions or contrasts, with variable names based on DAT.conditions
% or DAT.contrastnames, but with spaces replaced with underscores.
%
% Convert these to numerical arrays using table2array:
% table2array(DAT.SIG_contrasts.scaled.dotproduct.NPSneg)
%
% DAT.SIG_conditions.raw.dotproduct = apply_all_signatures(DATA_OBJ, 'conditionnames', DAT.conditions);
% DAT.SIG_contrasts.raw.dotproduct = apply_all_signatures(DATA_OBJ_CON, 'conditionnames', DAT.conditions);

kc = length(DAT.contrastnames);
n_sigs = length(signatures_to_plot);
mysignames = strcat(signatures_to_plot{:});

covtables = DAT.BETWEENPERSON.contrast_covs;


% Prepare covariates
for i = 1:kc
    
    % mycovs = table2array(covtables{i});
    covs{i} = covtables{i};
    whid = strcmp(covtables{i}.Properties.VariableNames, 'id');
    covs{i}(:, whid) = [];
    n_covs(i) = size(covs{i}, 2);
    
    covnames{i} = covs{i}.Properties.VariableNames;
    
end


%% Signature Response - contrasts
% ------------------------------------------------------------------------

if ~isfield(DAT, 'contrasts') || isempty(DAT.contrasts)
    % skip
    return
end
% ------------------------------------------------------------------------

reg_type_str = {'single covariate', 'simultaneous regression'};

tabrow = 1; % for output table
clear rtab
clear partialcor_tab


for simultaneous_reg = 0:1
    
    for n = 1:n_sigs
        
        mysignature = signatures_to_plot{n};
        
        mydata = table2array(DAT.SIG_contrasts.(myscaling).(mymetric).(mysignature));
        
        
        % Generate separate plots for each contrast
        for i = 1:kc
            
            contr_name = DAT.contrastnames{i};
            
            allcov_str = strjoin(covnames{i}, ", ");
            
            printhdr(sprintf('%s %s %s %s, %s: %s ', mysignature, contr_name, myscaling, mymetric, reg_type_str{simultaneous_reg + 1}, allcov_str))
            
            % Get brain data of interest for this contrast
            braindata = mydata(:, i);
            
            % Get covariates - single cov of interest is first is array
            
            for j = 1:n_covs(i)
                
                %xname = covs{i}.Properties.VariableNames(j);
                xname = covnames{i}(j);
                xname = format_strings_for_legend(xname{1}); % ONLY 1 ALLOWED FOR NOW!
                
                %extracov_names = covs{i}.Properties.VariableNames([1:j-1 j+1:end]);
                extracov_names = covnames{i}([1:j-1 j+1:end]);
                extracov_str = strjoin(extracov_names, ", ");
                
                if simultaneous_reg
                    figtitle = sprintf('%s %s, %s with %s [ + group ], %s %s', mysignature, contr_name, xname{1}, extracov_str, myscaling, mymetric);
                    %                   printstr(sprintf('%s (with %s)', xname{1}, extracov_str));
                else
                    figtitle = sprintf('%s %s, %s only [+ group] %s %s', mysignature, contr_name, xname{1}, myscaling, mymetric);
                    %                    printstr(sprintf('%s', xname{1}));
                end
                
                printstr(sprintf('%s', xname{1}));
                %create_figure(figtitle);
                
                % only one partial correlation at a time with group
                if simultaneous_reg
                    %printstr(sprintf('Covariate: %s with %s [ + group ]', xname{1}, extracov_str]);
                    covs_partcor = [ covs{i}{:,:} group ];
                    wh_of_interest = j;
                    rtab.model = allcov_str;
                else
                    %disp(['Covariate: %s only [+ group]', xname{1}']);
                    covs_partcor = [ covs{i}{:,j} group ];
                    wh_of_interest = 1;
                    rtab.model = xname{1};
                end
                
                
                rtab.signature = mysignature;
                rtab.scaling = myscaling;
                rtab.metric = mymetric;
                rtab.contrast = xname{1};
             
                rtab.reg_type = reg_type_str{simultaneous_reg + 1};
                
                [covresid, brainresid,rtab.r,rtab.p,rtab.se,rtab.mean_y,stats] = partialcor(covs_partcor, braindata, wh_of_interest, true, false);
                rtab.sig = sigstars(rtab.p);
                
                partialcor_tab(tabrow) = rtab;
                tabrow = tabrow + 1;
                
                %Partial correlation scatterplot
                plot_correlation_samefig(covresid, brainresid);
                xlabel(xname);
                ylabel(mysignature);
                
                drawnow, snapnow
                
                savename = fullfile(figsavedir, [figtitle '.png']);
                saveas(gcf, savename);
                
            end
            
        end % contrast
        
    end % figures/signatures
    
end % single vs simultaneous regression

%tab_id = regexprep(figtitle, '([ ,]+)|(\[ \+ group \])', '_');
tab_f = fullfile(resultsdir, ['NPS_contrast_between_person_correlations.csv']);
printhdr('Saving results table')
writetable(struct2table(partialcor_tab), tab_f)

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
