function plot_state_sequences(del_t, signals, seqs, state_means, names)
    % Plot a set of signals and the associated optimal state sequences,
    % where each state is identified by the mean signal.
    
    spacing = 2.5;
    % seqs to state_means
    seqs_with_means = cell(size(seqs));
    for i = 1:numel(seqs)
        seq = seqs{i};
        seq2 = 0*seq;
        for j = 1:numel(seq)
            seq2(j) = state_means(seq(j));
        end
        seqs_with_means{i} = seq2;
    end
    
    yshift_mult = spacing*(max(state_means) - min(state_means));
    
    
    figure;hold on;
    for i = 1:numel(seqs)
        yshift = yshift_mult*(i-1);
        plot(del_t*(1:numel(signals{i})), signals{i} + yshift,'r','LineWidth',3);
        plot(del_t*(1:numel(seqs_with_means{i})), seqs_with_means{i} + yshift, 'b','LineWidth',3);
        for j = state_means
            plot(del_t*(1:numel(signals{i})), j*ones(1,numel(signals{i})) + yshift,'k','LineStyle',':');
        end
    end
    
    xlabel('time (s)');
    title('Traces and optimal state sequences','FontSize',20)
    if nargin<5
        set(gca, 'ytick',[]);
        set(gca, 'yticklabel',[]);
    else
        set(gca, 'ytick',(yshift_mult)*(0:1:(numel(seqs)-1)) + median(state_means));
        set(gca, 'yticklabel',names);
    end
    ylim([0 numel(seqs)*yshift_mult+2*max(state_means)]);
end