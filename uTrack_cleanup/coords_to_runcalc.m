function coords_to_runcalc(coords, rois,deltaT)
    for i=1:numel(coords)
        this_coord = coords{i};
        filroi = rois{i};
        degree = min([length(this_coord)-2,5]);
        [t,s] = runcalc_single(this_coord,deltaT,degree, filroi);
        filename = ['runx' num2str(mean(this_coord(:,1))) 'y' num2str(mean(this_coord(:,2))) '.txt']
        if max(abs(diff(s(2:end-1))))<2
            % save in an Igor-like format
            
            txtFid = fopen(filename, 'w');
            %data
            for z=1:numel(t)%z=2:frames
                fprintf(txtFid, [num2str(t(z)) ' ' num2str(s(z)) '\r\n']);
            end
            fclose(txtFid);
        else
            disp('Run too jumpy; not saving...');
        end
    end
end