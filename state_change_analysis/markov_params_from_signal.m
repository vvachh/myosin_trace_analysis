function trans = markov_params_from_signal(signals,num_states)
    % Estimate of Markov model parameters from signal data 
    next_count = zeros(num_states);
    for k = 1:numel(signals)
        signal = signals{k};
        for j = 1:(numel(signal)-1)
            %Tally up all the transitions
            next_count(signal(j), signal(j+1)) = ...
                next_count(signal(j), signal(j+1)) + 1;
        end
    end
    
    trans = diag(1./sum(next_count,2))*next_count;
end