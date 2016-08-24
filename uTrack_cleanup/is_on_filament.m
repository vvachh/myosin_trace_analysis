function [z,roi] = is_on_filament(rois, xy, thresh1, thresh2)
    % decides if the point xy is within any of the filaments listed
    % in rois.
    % rois: the segmented line roi used in ImageJ.
    mindist = Inf;
    roi = Inf;
    for i = 1:numel(rois)
        for j = 1:(size(rois{i},1)-1)
            % Heron's formula, remember that?
            a = norm(xy-rois{i}(j,1:2));
            b = norm(xy-rois{i}(j+1,1:2));
            c = rois{i}(j,3);
            s = (a+b+c)/2;
            
            dist = 2*sqrt(s*(s-a)*(s-b)*(s-c))/c;
            if and(dist<mindist, min([a,b])<thresh2)
                mindist = dist;
                roi = i;
            end
        end
    end
    if mindist<thresh1
        z = 1;
    else
        z = 0;
    end
end