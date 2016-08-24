function [z,roiendpt] = is_on_this_filament(roi, xy, thresh1, thresh2)
    % decides if the point xy is within any of the filaments listed
    % in rois.
    % rois: the segmented line roi used in ImageJ.
    mindist = Inf;
    roiendpt = Inf;
    for j = 1:(size(roi,1)-1)
        % Heron's formula, remember that?
        a = norm(xy-roi(j,1:2));
        b = norm(xy-roi(j+1,1:2));
        c = roi(j,3);
        s = (a+b+c)/2;

        dist = 2*sqrt(s*(s-a)*(s-b)*(s-c))/c;
        if and(dist<mindist, min([a,b])<thresh2)
            mindist = dist;
            % where along the roi is the point closest?
            if a<b
                roiendpt = j;
            else
                roiendpt = j+1;
            end
        end
    end
    if mindist<thresh1
        z = 1;
    else
        z = 0;
    end
end