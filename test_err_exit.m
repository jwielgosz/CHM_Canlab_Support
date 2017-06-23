% Try out returning exit code if matlab script fails
% Main issue is whether stack trace displays properly
% (wielgosz 2017-06-22)
try 
	run('${script}')
	disp 0
    % exit 0
catch
	err = lasterror;
	disp(err);
	disp(err.message);
	disp(err.stack);
	disp(err.identifier);
	disp 1
    % exit 1
end