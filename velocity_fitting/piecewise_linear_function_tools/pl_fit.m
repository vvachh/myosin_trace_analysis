function [plfun,R2] = pl_fit(tt,zz,n)
    % Fit a piecewise linear function of n pieces
    % represents a pl function by the n-1 internal endpoints, 
    % followed by the n slopes.
    function plf = plfunc_from_vector(x)
        plf = zeros(n,3);
        t2 = [tt(1), sort(x(1:n-1)), tt(end)];
        m = x(n:end);
        for i = 1:n
            plf(i,:) = [t2(i), t2(i+1), m(i)];
        end
    end

    costfunc = @(x) -piecewise_linear_score(plfunc_from_vector(x), tt, zz);

    % configure constrained optimization
    t2_linspace = linspace(tt(1),tt(end), n+1); 
    if n>1
        t2_guess = t2_linspace(2:end-1);
    else
        t2_guess = [];
    end

    % configure slope guess
    m_guess = zeros(1,n);
    for k = 1:n
        tti = tt(and(tt>=t2_linspace(k), tt<=t2_linspace(k+1)));
        zzi = zz(and(tt>=t2_linspace(k), tt<=t2_linspace(k+1)));
        m_polyfit = polyfit(tti,zzi,1);
        m_guess(k) = m_polyfit(1);
    end

    x_guess = [t2_guess, m_guess];

    lb = [tt(1)*ones(1,n-1),-Inf*ones(1,n)]; ub = [tt(end)*ones(1,n-1),Inf*ones(1,n)];
    options = optimoptions('fmincon','MaxFunctionEvaluations',10000,'Display','off');

    [minx,fval] = fmincon(costfunc, x_guess,[],[],[],[],lb,ub,[],options);

    plfun = plfunc_from_vector(minx);
    R2 = -fval;

end
