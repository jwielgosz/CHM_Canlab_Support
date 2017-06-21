function x = desktop (varargin)
% (wielgosz 2017-06-03)
% Created to override the Matlab built-in because spm_check_registration tries to call
% it in batch mode, causing failure
x = false;


