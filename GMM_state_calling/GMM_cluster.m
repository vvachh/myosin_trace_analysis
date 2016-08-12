function gm = GMM_cluster(X)
    % takes a velocity profile, fits a mixture of Gaussians, and uses the
    % Bayesian Information Criterion to decide the best number of clusters.
    % Then returns that model fit.
    
    max_num_clusters = 10;
    
    bics = zeros(1,max_num_clusters);
    
    for i = 1:max_num_clusters
        
        % Thank you, MATLAB ML toolbox, for not making me write EM, or even
        % write out the expression for the BIC...
        gm = fitgmdist(X,i,'Options',statset('MaxIter',2000));
        
        % Because we're doing soft clustering here (we do hard state
        % assignment later on, with a Hidden Markov model), the likelihood
        % function is just the gaussian mixture density.
        bics(i) = gm.BIC;
    end
    
    opt_num_clusters = find(bics==min(bics));
    opt_num_clusters = opt_num_clusters(1);
    
    plot(1:max_num_clusters,bics);
    xlabel('number of clusters');
    ylabel('SIC');
    
    gm = fitgmdist(X,opt_num_clusters,'Options',statset('MaxIter',1000));
end