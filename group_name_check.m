% check how group names are being assigned
% (wielgosz 2017-06-18)

i = 1

%%

% Code from prep_1b_prep_behavioral_data_example1.m

% DAT.BETWEENPERSON.group = contrast_code(group  - 1.5);
% DAT.BETWEENPERSON.group_descrip = '-1 is first group name, 1 is 2nd';

%%
% code extracted from h_group_differences.m

DAT.BETWEENPERSON.groupnames
DAT.BETWEENPERSON.group

mydat = DAT.NPSsubregions.(mysubrfield){i};
    

y = {mydat(group == 1, j) mydat(group == -1, j)}
% Should this be: 
% y = {mydat(group == -1, j) mydat(group == 1, j)};
% ??? 


% here, 1 is mapping to first groupname, -1 to second groupname
% opposite of instructions in prep_1b_prep_behavioral_data_example1
barplot_columns(y, 'nofig', 'colors', groupcolors, 'noviolin', 'noind', 'names', groupnames );

%%

% comparison

% group means, explicitly mapping -1 to first groupname, 1 goes to second groupname
% consistent w/ instructions in prep_1b_prep_behavioral_data_example1
y_tab = table(mydat(group == -1, j), mydat(group == 1, j), 'VariableNames', groupnames)
varfun(@mean,y_tab)
