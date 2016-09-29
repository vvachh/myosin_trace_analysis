function gm = GMM_cluster(X)
    % takes a velocity profile, fits a mixture of Gaussians, and uses the
    % Bayesian Information Criterion to decide the best number of clusters.
    % Then returns that model fit.
    
    max_num_clusters = 2;
    
    bics = zeros(1,max_num_clusters);
    lls = zeros(1,max_num_clusters);
    for i = 1:max_num_clusters
        
        % Thank you, MATLAB ML toolbox, for not making me write EM, or even
        % write out the expression for the BIC...
        gm = fitgmdist(X,i,'Options',statset('MaxIter',2000));
        
        % Because we're doing soft clustering here (we do hard state
        % assignment later on, with a Hidden Markov model), the likelihood
        % function is just the gaussian mixture density.
        bics(i) = gm.BIC;
        lls(i) = sum(log(gm.pdf(X)));
    end
    
    opt_num_clusters = find(bics==min(bics));
    opt_num_clusters = opt_num_clusters(1)
    
    second_best_num_clusters = find(bics==min(bics(bics ~= min(bics))));
    second_best_num_clusters = second_best_num_clusters(1)
    
    plot(1:max_num_clusters,bics);
    xlabel('number of clusters');
    ylabel('SIC');
    
    gm = fitgmdist(X,opt_num_clusters,'Options',statset('MaxIter',1000));
    gm2 = fitgmdist(X,second_best_num_clusters,'Options',statset('MaxIter',1000));
    figure;
    histogram(X,20);hold on; 
    lsx = linspace(min(X),max(X),50);
    plot(lsx,gm.pdf(lsx'));
    xlabel('Value');
    ylabel('Frequency');
    
    % a measure of log(likelihood ratio) for the two lowest BIC values. How
    % much more predictive is the "optimal" number of clusters than the
    % second best? Gives some idea as to the comparative advantage of the
    % fit.
    ll_best = sum(log(gm.pdf(X)))
    ll_second_best = sum(log(gm2.pdf(X)))
    
    llr = ll_best-ll_second_best;
    
    disp('Log likelihood ratio between best and second best possible clustering:');
    disp(llr);
end