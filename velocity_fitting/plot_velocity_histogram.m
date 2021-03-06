function velos = plot_velocity_histogram(velocities, unsigned, mostly_unidirectional)
    % given the output of velocity_fit_folder, plot a histogram.
    % also compatible with parallel_velocity_fit_folder.
    if nargin<3
        mostly_unidirectional = 0;
        if nargin<2
            unsigned=0;
        end
    end
    
    if mostly_unidirectional>0
        siz = size(velocities);
        % flip the runs so that every run has mostly positive velocities.
        for i=1:siz(1)
            veli = velocities(i,:);
            disp(sum(veli>=0))
            disp(sum(veli<0))
            if sum(veli>=0)<sum(veli<0)
                disp('flipping')
                velocities(i,:) = -veli;
            end
        end
    else
        if unsigned
            velocities = abs(velocities);
        end
    end
    velos = velocities(not(isnan(velocities)));
    num_bins = input('num bins? ');
    histogram(velos, num_bins);
    ylabel('number of subruns');
    if unsigned
        xlabel('speed (um/s)');
    else
        xlabel('velocity (um/s)');
    end
end