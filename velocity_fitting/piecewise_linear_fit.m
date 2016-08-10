function plf = piecewise_linear_fit(t,z,name)
    % Shifts data so that z(1) == 0, then fits piecewise linear functions.
    % The goal is to fit the smallest number of pieces so that the total
    % R^2 is more than R2_thresh.
    
%     %% Naive method: maximize R^2
%     R2_thresh = 0.999;
%         
%     % Fit piecewise linear functions of increasingly many pieces.
%     z_shift = z - z(1);
%     for n_pieces = 1:(numel(t)-1)
%         [plf, R2] = pl_fit(t,z_shift,n_pieces);
%         
%         if R2>R2_thresh
%             break
%         end
%     end
%     t_space = linspace(t(1),t(end),50);
%     figure;
%     plot(t_space, plfuneval(plf,t_space),'g');hold on;
%     plot(t,z_shift,'ro');
%     plf
%     R2
    
%     %% Another method: counter-fitting (doi:10.1038/nature04928)
%     z_shift = z - z(1);
%     scores = zeros(1,5);
%     for n_pieces = 2:5
%         [plf, ~] = pl_fit(t,z_shift,n_pieces);
%         scores(n_pieces) = adversarial_score(plf, t, z_shift);
%     end
%     opt_n_pieces = find(scores==max(scores));
%     [plf, ~] = pl_fit(t,z_shift,opt_n_pieces);
%     
%     t_space = linspace(t(1),t(end),50);
%     figure;
%     plot(t_space, plfuneval(plf,t_space),'g');hold on;
%     plot(t,z_shift,'ro');
%     figure;
%     plot(scores); xlabel('number pieces'); ylabel('Quality score');

    %% Yet another method: Schwarz Information Criterion.
    z_shift = z-z(1);
    sics = zeros(1,floor(numel(t)/3-1));
    if numel(sics)<1
        sics = [0];
    end
    for n_pieces = 1:numel(sics)
        [plf,~] = pl_fit(t,z_shift,n_pieces);
        sics(n_pieces) = sic_plf(plf, t, z_shift);
    end
    
    if nargin>2
        
        
        figure('Visible','off');
        plot(sics); xlabel('number pieces'); ylabel('SIC');
        opt_n_pieces = find(sics==min(sics));
        [plf, ~] = pl_fit(t,z_shift,opt_n_pieces);
        saveas(gcf,strcat(name,'_sicplot.png'));
        csvwrite(strcat(name,'_plfit.csv'),plf);
        
        t_space = linspace(t(1),t(end),50);
        plot(t_space, plfuneval(plf,t_space),'g');hold on;
        plot(t,z_shift,'ro');hold off;
        saveas(gcf,strcat(name,'_fitplot.png'));
    end
end