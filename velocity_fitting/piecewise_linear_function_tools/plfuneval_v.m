function plf = plfuneval_v(func, t_)
    %return the velocity of the the pl function along the vector t_
    plf = 0.*t_;
    for i = 1:numel(t_)
        t__ = t_(i);
        lowerbds = func(:,2)<t__;
        this_seg = numel(find(lowerbds))+1;
        plf(i) = func(this_seg,3);
    end
end