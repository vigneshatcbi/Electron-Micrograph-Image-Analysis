function circ = cbi_meascirc(x, y)

if(numel(x)>3 && numel(y)>3)
    cov_mat = cov([x(:) y(:)]);
    [evec eval] = eigs(cov_mat);
    circ = eval(2,2) / eval(1,1);
else
    circ = 0;
end

