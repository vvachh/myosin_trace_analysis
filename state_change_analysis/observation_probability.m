function [obsfun_all, obsfun] = observation_probability(gmm, mixing)
    % returns a function which computes p(observation|state),
    % given a gaussian mixture model where states are cluster ids and
    % observations are the modeled data.
    
    mus = gmm.mu(:);
    sigmas = sqrt(gmm.Sigma(:));
%     mixing = gmm.ComponentProportion(:);
    if nargin<2
        mixing = 1+0*mus;
    end
%     lsa = 0:0.001:0.5;
%     plot(lsa, normpdf(lsa,mus(1),sigmas(1)));hold on;
%     plot(lsa, normpdf(lsa,mus(2),sigmas(2)));
%     figure;
%     probs1 = normpdf(lsa,mus(1),sigmas(1))*mixing(1)./(normpdf(lsa,mus(1),sigmas(1))*mixing(1)+normpdf(lsa,mus(2),sigmas(2))*mixing(2));
%     probs2 = normpdf(lsa,mus(2),sigmas(2))*mixing(2)./(normpdf(lsa,mus(1),sigmas(1))*mixing(1)+normpdf(lsa,mus(2),sigmas(2))*mixing(2));
% 
%     plot(lsa, probs1);hold on; plot(lsa, probs2);
%     xlabel('observed velocity'); ylabel('p(state 1|v)');
    
    function a = all_obs(x)
        a = (normpdf(x,mus, sigmas)+1e-100).*mixing;
        a = a/sum(a);
    end

    function y = obs(x,s)
        a = (normpdf(x,mus, sigmas)+1e-100).*mixing;
        a = a/sum(a);
        y = a(s);
    end

    obsfun_all = @all_obs;
    obsfun = @obs;
end