function score = adversarial_score(plfunc, t, z)
    %% (similar to approach taken by Kerssemakers et al 2006 (doi:10.1038/nature04928))
    %compute values of plfunction at t
    z_fit = plfuneval(plfunc, t);
    
    % compute R^2 for this fit.
    SS_fit = sum(z_fit.^2);
    SS_res = sum((z_fit-z).^2);
    
    R2 = 1 - SS_res/SS_fit;
    
    % compute adversarial function
    z_adv_fit = plfuneval(adversarial_piecewise_linear_func(plfunc, t, z), t);
    
    % R^2 for that fit.
    SS_fit = sum(z_adv_fit.^2);
    SS_res = sum((z_adv_fit-z).^2);
    
    R2_adv = 1 - SS_res/SS_fit;
    
    % ratio of R2
    score = R2/R2_adv;
end