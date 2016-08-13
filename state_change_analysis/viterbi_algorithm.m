function [seq,ll] = viterbi_algorithm(signal, trans, emis_all, emis, init)
    % implementation of the Viterbi algorithm. 
    % Inputs:
    % - signal: set of observations
    % - trans:  state transition matrix. trans(i,j) corresponds to prob of
    %           transitioning *from* i *to* j
    % - emis_all: function that takes (observation) to a vector of emission
    %           probabilities of every state.
    % - emis:   function that takes (state,observation) to emission 
    %           probability. Not an emission matrix because the
    %           observations are continuous.
    % Outputs:
    % - seq:    optimal sequence of states
    % - ll:     log likelihood of this sequence
    
    len = numel(signal);
    num_states = length(trans);
    
    probabilities = zeros(num_states, len);
    traceback = zeros(num_states, len);
    
    % naive prior for starting state.
    if nargin<5
        probabilities(:,1) = log(1/num_states*(ones(num_states,1)))+log(emis_all(signal(1)));
    else
        probabilities(:,1) = log(init) + log(emis_all(signal(1)));
    end
    
    for i = 2:len
        for j = 1:num_states
            %probabilities of observing the latest emission as a result of a
            %move to state j.
            options = probabilities(:,i-1) + log(trans(:,j)) + log(emis(signal(i),j));
            %pick the highest value from options and assign it to
            %traceback. This is the likelihood of the most likely path that
            %ends so far in state j.
            [prob, tback] = max(options);
            probabilities(j,i) = prob;
            traceback(j,i) = tback;
        end
    end
    
    %trace back and return the ll.
    [ll, last_state] = max(probabilities(:,len)); 
    backwards_path = zeros(1,len);
    backwards_path(1) = last_state;
    for i = 0:(len-2)
        last_state = traceback(last_state,len-i);
        backwards_path(i+2) = last_state;
    end
    seq = backwards_path(end:-1:1);
    
end