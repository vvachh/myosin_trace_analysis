function plfunc_adv = adversarial_piecewise_linear_func(plfunc, t, z)
    % adversarial piecewise linear function:
    % (similar to approach taken by Kerssemakers et al 2006
    % (doi:10.1038/nature04928))
    % Define "counterfits" by rejecting the knots in plfunc and instead
    % doing sequential fitting to the subintervals defined by the knots:
    % eg. if we have a 2 piece fit with slope m1 in (x0, x1), and slope m2 in 
    % (x1, x2), counterfit as follows:
    % * fit a 2-piece function to (x0, x1) with slopes m1, m2.
    % * fit a 2-piece function to (x1, x2) with slopes m2, m3 (fix m2 and
    % optimize m3). 
    % Compare goodness of fit between fit and counterfit
    % - If the fit has too many steps, then this should not make much of a
    % difference to the goodness of fit. Extraneous steps should cancel out.
    % - If the fit has too few steps, then some steps are missed in both fits,
    % so both fit and counterfit will discover real steps. Goodness of fit
    % should be similar.
    % - If the fit is optimal, then we rejected all good steps and the goodness
    % of fit of the counterfit should be much less.

    subintervals = [plfunc(:,1);plfunc(end,2)]'
    plfunc_adv = [0*plfunc; 0,0,0];
    % First piece
    tt = t(t<subintervals(2));
    zz = z(t<subintervals(2));
    [plf2, ~] = pl_fit(tt,zz,2);
    
    t_linspace = linspace(tt(1), tt(end), 50);
    z_fit = plfuneval(plfunc, t_linspace);
    z_adv_fit = plfuneval(plf2, t_linspace);
    plot(tt,zz-zz(1)); hold on;
    plot(t_linspace,z_fit,'g');
    plot(t_linspace,z_adv_fit, 'r');
    plfunc_adv(1,:) = plf2(1,:);
    knot = plf2(2,1);
    m = plf2(2,3);
    
    %rest of the pieces
    for i = 2:numel(subintervals(2:end))
        %fit another knot and another slope
        tt = t(and(t>subintervals(i), t<(subintervals(i+1))));
        zz = z(and(t>subintervals(i), t<(subintervals(i+1))));
        [plf2, ~] = pl_fit_2_const(tt,zz,m);
        plfunc_adv(i,:) = [knot, plf2(1,2), m];
        
        knot = plf2(1,2);
        m = plf2(2,3);
    end
    plfunc_adv(end,:) = [knot, t(end), m];
    
    plfunc_adv
    t_linspace = linspace(t(1), t(end), 50);
    z_fit = plfuneval(plfunc, t_linspace);
    z_adv_fit = plfuneval(plfunc_adv, t_linspace);
    plot(t,z-z(1)); hold on;
    plot(t_linspace,z_fit,'g');
%     plot(t_linspace,z_adv_fit, 'r');
end