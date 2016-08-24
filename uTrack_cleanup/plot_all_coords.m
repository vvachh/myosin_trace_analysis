function plot_all_coords(coords,frmt)
    %plot all the trajectories in coords
    hold on;
    for i = 1:numel(coords)
        coord = coords{i};
        plot(coord(:,1),coord(:,2), frmt);
    end
end