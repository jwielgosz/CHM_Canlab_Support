% Create table with named columns and zero rows
%  
% 
% created: wielgosz 2017-06-19

function tbl = emptytable(varnames)

    tbl = cell2table(cell(0,length(varnames)), 'VariableNames', varnames);

end
