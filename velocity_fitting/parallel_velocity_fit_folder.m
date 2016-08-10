function velocities = parallel_velocity_fit_folder
    % Fit velocities to all runs in a folder, keep track of all the 
    % velocities for each run.
    % Does not keep track of state transitions: runs with velocities do not
    % correspond to states yet.
    
    curdir = pwd;
    
    
    %Ask for the folder
    workdir = uigetdir(curdir,'Select Directory containing runs');
    cd(workdir);
    
    %loop through the files
    files = dir('*.txt')';
    velocities = nan*ones(numel(files),20); %negative values for nonexistent velocities
    parfor fileid = 1:numel(files);
        file = files(fileid);
        csv = load(file.name);
        name = file.name(1:end-4)
        t = csv(:,1); s = csv(:,2);
        del_t = t(2)-t(1); %assumes data are evenly spaced...
        
        %fit velocities, store them, checking if they've already been fit
        %before (from, for example, a failed run of this function on the
        %same directory)
            if not(exist(strcat(name,'_plfit.csv'),'file'))
                plf = piecewise_linear_fit(t,s,name);
            else
                plf = csvread(strcat(name,'_plfit.csv'));
            end
            siz = size(plf);
            vels = nan*ones(1,20);
            for i = 1:siz(1)
                % filter out subruns containing fewer than 3 points.
                if plf(i,2)-plf(i,1)>=2*del_t
                    vels(i) = plf(i,3);
                else
                    vels(i) = nan;
                end
            end

        velocities(fileid,:) = vels;
    end
    
    cd(curdir);
end