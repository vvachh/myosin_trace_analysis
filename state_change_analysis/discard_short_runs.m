function y = discard_short_runs(x)
    % assuming x is made up of chunks of the same value, replaces chunks of
    % size <=2 with the average value of the two adjacent chunks.
    y = x;
    chunk_beg = 1;
    chunk_end = 1;
    for i = 1:(numel(x)-1)
        if x(i+1)~=x(i)
            chunk_end=i;
            if chunk_end-chunk_beg<=1
                y(chunk_beg:chunk_end) = mean([y(max([chunk_beg-1, 1])), y(min([chunk_end+1, numel(x)]))]);
            end
            chunk_beg=i+1;
        end
    end
end