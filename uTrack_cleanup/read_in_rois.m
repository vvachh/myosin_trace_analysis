function roiCoords = read_in_rois
    [ROIfilename, ROIpathname]=uigetfile({'*.txt;*.txt','Text file (*.txt)'},'ROI file to load');
    ROIfid=fopen([ROIpathname ROIfilename],'r');
    labelTemp=fscanf(ROIfid, 'ROI%d');
    
    while(labelTemp)
        coordsTemp=fscanf(ROIfid, '%g %g',[2,inf])';
        lengths = zeros(size(coordsTemp,1),1);
        diffs = diff(coordsTemp,1);
        for i = 1:(numel(lengths)-1)
            lengths(i) = norm(diffs(i,:));
        end

        roiCoords{labelTemp}=[coordsTemp + 1,lengths];
        %the addition of 1 is because imageJ has top left point as (0,0)
        %and matlab wants it to be (1,1)
        labelTemp=fscanf(ROIfid, 'ROI%d');
    end

end