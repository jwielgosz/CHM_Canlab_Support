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

