function score = piecewise_linear_score(plfunc, t, z)
    % goodness of fit (R^2) for a piecewise linear function given by plfunc
    % to the data t, z, where z(1)=0.
    % plfunc is specified by [t0, t1, m1; t1, t2, m2;...], where t0 = t(1)
    % The piecewise linear function f specified by plfunc
    % is continuous, has f(t0)==0, and has slope mi between t[i-1] and ti.
    
    % compute values of plfunction at timepoints t
    z_fit = plfuneval(plfunc, t);
    
    % compute R^2
    SS_fit = sum(z_fit.^2);
    SS_res = sum((z_fit-z).^2);
    
    R2 = 1 - SS_res/SS_fit;
    
    score = R2;
end