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
        if numel(rois)==0
            for j = 1:(numel(coordampcg)/8)
                this_coords(j,1) = coordampcg(8*j-7);
                this_coords(j,2) = coordampcg(8*j-6);
            end
            
            % replace nan tracks with linear interpolation
            nanbegin = -1;
            nanend = 0;
            for j = 1:(numel(coordampcg)/8)
                if isnan(this_coords(j,1))
                    if nanbegin<nanend
                        nanbegin=j;
                    end
                    if not(isnan(this_coords(j+1,1)))
                            nanend = j;
                            c1 = this_coords(nanbegin-1,1); c2 = this_coords(nanend+1,1);
                            this_coords((nanbegin-1):(nanend+1),1) = linspace(c1,c2,nanend-nanbegin+3);
                            c1 = this_coords(nanbegin-1,2); c2 = this_coords(nanend+1,2);
                            this_coords((nanbegin-1):(nanend+1),2) = linspace(c1,c2,nanend-nanbegin+3);
                    end
                end
            end
            
            if and(length(this_coords)>3, not(confused));
                if or(tracks(i).classification(1)==1, isnan(tracks(i).classification(1)))
                    coords{end+1} = this_coords;
                end
            end
        else
            for j = 1:(numel(coordampcg)/8)
                this_coords(j,1) = coordampcg(8*j-7);
                this_coords(j,2) = coordampcg(8*j-6);
            end
            % replace nan tracks with linear interpolation
            nanbegin = -1;
            nanend = 0;
            for j = 1:(numel(coordampcg)/8)
                if isnan(this_coords(j,1))
                    if nanbegin<nanend
                        nanbegin=j;
                    end
                    if not(isnan(this_coords(j+1,1)))
                            nanend = j;
                            c1 = this_coords(nanbegin-1,1); c2 = this_coords(nanend+1,1);
                            this_coords((nanbegin-1):(nanend+1),1) = linspace(c1,c2,nanend-nanbegin+3);
                            c1 = this_coords(nanbegin-1,2); c2 = this_coords(nanend+1,2);
                            this_coords((nanbegin-1):(nanend+1),2) = linspace(c1,c2,nanend-nanbegin+3);
                    end
                end
            end

            if and(length(this_coords)>3, not(confused));
                if or(tracks(i).classification(1)==1, isnan(tracks(i).classification(1)))
                    if is_coord_on_filament(rois, this_coords, thresh1, thresh2)
                        [~,roi] = is_coord_on_filament(rois, this_coords, thresh1, thresh2);
                        coords{end+1} = this_coords;
                        roiss{end+1} = roi;
                    end
                end
            end
        end
    end
end