function [transition_matrix, seqs] = hmm_exp_max(signals,gmm)
    % uses expectation-maximization to find the maximum likelihood
    % transition probabilities for an HMM, where the observations are given
    % by signal and the hidden states and their emission probabilities are
    % given by the Gaussian mixture model clusters from gmm.
    
    numiter = 10;
    num_states = gmm.NumComponents;
    [obsfun_all, obsfun] = observation_probability(gmm);
    obsfun_all(0)
    
    %completely naive assumption
    transition_matrix = 1/num_states*ones(num_states);
    seqs = cell(1,numel(signals));
    %keep track of optimization progress
    lls = zeros(1,numiter);
    
    
    for i = 1:numiter
        % "expectation": Viterbi Algorithm to get ML estimate of states
        % given current estimate of transition matrix.
        lltot = 0;
        for j = 1:numel(signals)
            signal = signals{j};
            [seq,ll] = viterbi_algorithm(signal,transition_matrix, obsfun_all, obsfun);
            seqs{j} = seq;
            lltot = lltot+ll;
        end
        
        % "maximization": Estimate Markov parameters from the current
        % estimate of the state sequence
        transition_matrix = markov_params_from_signal(seqs,num_states);
        
%         mixing = histcounts([seqs{:}], 1:(num_states+1));
%         mixing = mixing/sum(mixing)
        [obsfun_all, obsfun] = observation_probability(gmm);
        
        
        lls(i) = lltot
    end
    plot(lls);
end