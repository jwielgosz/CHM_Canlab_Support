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
