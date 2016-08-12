function bic(data,n)
    % confirm that i know what the hell the BIC is. I don't like MATLAB's
    % black box even though it's amazing.
    
    gm = fitgmdist(data,n,'Options',statset('MaxIter',1000));
    
    disp(gm.BIC);
    disp(-2*sum(log(gm.pdf(data))) + (3*n-1)*log(numel(data)));
    
    %ok thank goodness. I'm not crazy.
end