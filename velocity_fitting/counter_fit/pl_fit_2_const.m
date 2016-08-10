function [plfun,R2] = pl_fit_2_const(tt,zz, m)
    % Fit a piecewise linear function of 2 pieces, with the first slope
    % given.
    % represents a pl function by the n-1 internal endpoints, 
    % followed by the n slopes.
    function plf = plfunc_from_vector(x)
        plf = zeros(2,3);
        plf(1,:) = [tt(1), x(1), m];
        m2 = x(2);
        plf(2,:) = [x(1), tt(end), m2];
    end

    costfunc = @(x) -piecewise_linear_score(plfunc_from_vector(x), tt, zz);

    % configure constrained optimization
    t2_guess = (tt(1)+tt(end))/2;

    % configure slope guess
    tti = tt(tt>=t2_guess);
    zzi = zz(tt>=t2_guess);
    m_polyfit = polyfit(tti,zzi,1);
    m_guess = m_polyfit(1);

    x_guess = [t2_guess, m_guess];

%     plff = plfunc_from_vector(x_guess);
%     t_space = linspace(tt(1),tt(end),50);
%     plot(t_space, plfuneval(plff,t_space),'g');hold on;
%     plot(tt,z_shift,'ro');

    lb = [tt(1),-Inf]; ub = [tt(end),Inf];
    options = optimoptions('fmincon','MaxFunctionEvaluations',10000);

    [minx,fval] = fmincon(costfunc, x_guess,[],[],[],[],lb,ub,[],options);

    plfun = plfunc_from_vector(minx);
    R2 = -fval;

end