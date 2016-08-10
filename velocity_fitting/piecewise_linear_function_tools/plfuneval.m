function plf = plfuneval(func, t_)
    %evaluate the pl function along the vector t_
    plf = 0.*t_;
    for i = 1:numel(t_)
        t__ = t_(i);
        lowerbds = func(:,2)<t__;
        this_seg = numel(find(lowerbds))+1;
        b = sum((func(:,2).*lowerbds - func(:,1).*lowerbds).*(func(:,3).*lowerbds));
        plf(i) = b + (t__-func(this_seg,1))*func(this_seg,3);
    end
end