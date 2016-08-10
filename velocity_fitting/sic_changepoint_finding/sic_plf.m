function sic = sic_plf(plfunc,t,z)
    % Calculates the Schwarz Information Criterion for the piecewise linear
    % function plfunc used to fit the data t,z. The likelihood function
    % assumes a model of additive Gaussian noise, where the variance s2 is
    % estimated using the MLE assuming the fit.
    siz = size(plfunc);
    
    % parameters for SIC
    k = siz(1); %number of rows, proportional to number of parameters.
    n = numel(z); %number of data
     
    % estimate s2
    z_fit = plfuneval(plfunc,t);
    resid = z-z_fit;
    s2 = mean(resid.^2);
    
    % calculate SIC, up to a constant.
    sic = (2*k+2)*log(n) + n*log(s2);
end