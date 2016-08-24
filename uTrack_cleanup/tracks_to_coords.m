function [coords, roiss] = tracks_to_coords(tracks, rois, thresh1, thresh2)
    % turn tracks into lists of xy-coordinates.
    
    % Loop through the rows of the struct tracks
    coords = {};
    roiss = {};
    for i = 1:numel(tracks)
        disp(i)
        coordampcg = tracks(i).tracksCoordAmpCG;
        this_coords = nan*ones(numel(coordampcg)/8,2);
        confused = 0;
        for j = 1:(numel(coordampcg)/8)
            this_coords(j,1) = coordampcg(8*j-7);
            this_coords(j,2) = coordampcg(8*j-6);
            if or(isnan(this_coords(j,1)),isnan(this_coords(j,2)));
                confused=1;
            end
        end
        if and(length(this_coords)>3, not(confused));
            if tracks(i).classification(1)==1
                if is_coord_on_filament(rois, this_coords, thresh1, thresh2)
                    [~,roi] = is_coord_on_filament(rois, this_coords, thresh1, thresh2);
                    coords{end+1} = this_coords;
                    roiss{end+1} = roi;
                end
            end
        end
    end
end