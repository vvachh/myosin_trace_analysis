function plf = plfuneval_v(func, t_)
    %return the velocity of the the pl function along the vector t_
    plf = 0.*t_;
    if size(func,1)==1
        plf = func(1,3)*(0*t_+1);
    else
        for i = 1:numel(t_)
            t__ = t_(i);
            lowerbds = func(:,2)<=t__;
            this_seg = min(numel(find(lowerbds))+1, size(func,1));
            plf(i) = func(this_seg,3);
        end
    end
end