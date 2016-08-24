function [signals,filenames] = batch_velocity_signals(mostly_unidirectional)
    % Extract time-dependent velocities from to all runs in a folder, 
    % keep track of all the velocities for each run.
    % Corresponds to the observed signal in an Hidden Markov Model of
    % switchable motors
    
    curdir = pwd;
    signals = {};
    filenames = {};
    
    %Ask for the folder
    workdir = uigetdir(curdir,'Select Directory containing runs');
    cd(workdir);
    %loop through the files
    files = dir('*.txt');
    for file=files'
        csv = load(file.name);
        name = file.name(1:end-4)
        t = csv(:,1); s = csv(:,2);
        del_t = t(2)-t(1); %assumes data are evenly spaced.
        
        %fit velocities, store them, checking if we have already fit them
        %before.
        if not(exist(strcat(name,'_plfit.csv'),'file'))
            plf = piecewise_linear_fit(t,s,name);
        else
            plf = csvread(strcat(name,'_plfit.csv'));
            disp('found previous fit of this trace.');
        end
        flipit = 1;
        if nargin>0
            if sum(plf(:,3)<0)>sum(plf(:,3)>0)
                flipit = -1;
            end
        end
%         % use the piecewise linear fit to give a velocity signal
%         signals{end+1} = flipit*plfuneval_v(plf,t);
        % use the piecewise linear fit, but account for the short runs
        % which were discarded before
        signals{end+1} = flipit*discard_short_runs(plfuneval_v(plf,t));
%         % Directly use frame-to-frame velocities
%         signals{end+1} = smooth(flipit*diff(s)./del_t,'lowess');
        filenames{end+1} = name;
    end
    
    cd(curdir);
end