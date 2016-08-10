function all_velocities = velocity_fit_folder
    % Fit velocities to all runs in a folder, keep track of all the 
    % velocities for each run.
    % Does not keep track of state transitions: runs with velocities do not
    % correspond to states yet.
    
    curdir = pwd;
    all_velocities = [];
    
    %Ask for the folder
    workdir = uigetdir(curdir,'Select Directory containing runs');
    cd(workdir);
    
    %loop through the files
    files = dir('*.txt');
    for file=files'
        csv = load(file.name);
        name = file.name(1:end-4)
        t = csv(:,1); s = csv(:,2);
        del_t = t(2)-t(1); %assumes data are evenly spaced...
        
        %fit velocities, store them, checking if we have already fit them
        %before.
        if not(exist(strcat(name,'_plfit.csv'),'file'))
            plf = piecewise_linear_fit(t,s,name);
        else
            plf = csvread(strcat(name,'_plfit.csv'));
            disp('found previous fit of this trace.');
        end
        siz = size(plf);
        for i = 1:siz(1)
            % filter out subruns containing fewer than 3 points.
            if plf(i,2)-plf(i,1)>=2*del_t
                all_velocities(end+1) = plf(i,3);
            end
        end
    end
    
    cd(curdir);
end