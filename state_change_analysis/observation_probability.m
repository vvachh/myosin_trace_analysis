function [obsfun_all, obsfun] = observation_probability(gmm)
    % returns a function which computes p(observation|state),
    % given a gaussian mixture model where states are cluster ids and
    % observations are the modeled data.
    
    mus = gmm.mu(:);
    sigmas = gmm.Sigma(:);
    
    function a = all_obs(x)
        a = normpdf(x,mus, sigmas);
        a = a/sum(a);
    end

    function y = obs(x,s)
        a = normpdf(x,mus, sigmas);
        a = a/sum(a);
        y = a(s);
    end

    obsfun_all = @all_obs;
    obsfun = @obs;
end