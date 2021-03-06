function [z, filroi] = is_coord_on_filament(rois, coord, thresh1,thresh2)
    % determine if the entire trajectory cood is on one filament.
    
    % which filament is the first point on?
    [z,roi] = is_on_filament(rois, coord(1,:), thresh1, thresh2);
    if not(z)
        z = 0;
    %check if the rest of the trajectory is close enough to this point.
    else
        for i = 1:size(coord,1)
            z = and(z,is_on_this_filament(rois{roi},coord(i,:),thresh1, thresh2));
        end
    end
    if roi<Inf
        filroi = rois{roi};
    else
        filroi = 0;
    end
end