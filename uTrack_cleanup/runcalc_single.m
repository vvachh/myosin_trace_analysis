% Borrowed from TDS
% projects 2D trace onto fit actin filament to make a staircase

function [tL, distL] = runcalc_single(data, deltaT, degree, filroi, showplots)

if nargin<5
    showplots=0;
end

%change this output from distL to distance for calculations without
%fitting along actin filament

%xL = data.Lxm;
%yL = data.Lym;

xL=data(:,1);
yL=data(:,2);

% data given in px

postL = [xL, yL];
xLeft = postL(:,1);
yLeft = postL(:,2);

[paramsxy,normrxy]=polyfit([xLeft],[yLeft],degree);
[paramsyx,normryx]=polyfit([yLeft],[xLeft],degree);

%[paramsxy,normrxy]=polyfit([xLeft],[yLeft],2);
%[paramsyx,normryx]=polyfit([yLeft],[xLeft],2);
if (normryx.normr<normrxy.normr)
    % flip!
    xtemp = xLeft;
    xLeft = yLeft;
    yLeft = xtemp;
    
    params = paramsyx;
else
    params = paramsxy;
end
    
if showplots    
    figure;
else
    figure('Visible','Off');
end
    clf reset

    subplot(2,2,1)
    plot(xLeft, yLeft,'bO-');
    hold on

    xlabel('microns')
    ylabel('microns')
    grid on
    zoom on

    title('x vs y')
    % make them square
    oldxlim=xlim;
    oldylim=ylim;
    deltax=oldxlim(2)-oldxlim(1);
    deltay=oldylim(2)-oldylim(1);
    achsenfaktor=max(deltax,deltay);
    newxmax=oldxlim(1)+achsenfaktor;
    newymax=oldylim(1)+achsenfaktor;
    xlim( [oldxlim(1) newxmax]  );
    ylim( [oldylim(1) newymax] );


    xstart=oldxlim(1);
    xend=newxmax;
    numberOfPoints=20;
    fitdeltax=abs(xend-xstart)/numberOfPoints;
    fitxdata=[xstart:fitdeltax:xend] ;     
    fitydata=polyval(params,fitxdata);
    
    % check polarity:
    polarity = 1;
    [~, roiendpt1] = is_on_this_filament(filroi, [fitxdata(1),fitydata(1)], 5, 5);
    [~, roiendpt2] = is_on_this_filament(filroi, [fitxdata(end),fitydata(end)], 5, 5);
    if roiendpt2<roiendpt1
        polarity = -1;
    end
    
    %fitydata=fitxdata.^2*params(1)+fitxdata*params(2)+params(3);
if showplots
    plot(fitxdata,fitydata,'r')
    hold on
    hold off
end

% find the minimum distance from each data pair to the curve
[xfitL,yfitL]=closestapproach(params,xLeft,yLeft);
distL = polarity*arclength(params, xfitL, yfitL);
distL = distL-distL(1);

if showplots
    subplot(2,2,2);

    numco = length(xLeft);
    plot(xfitL,yfitL, 'r');hold on
    plot(xLeft,yLeft,'bo');



    subplot(2,2,3)
end
    NumberOfFramesL=length(xLeft);
    maxtimeL=(NumberOfFramesL*deltaT-deltaT);    
    tL=[0:deltaT:maxtimeL];

if showplots
    plot(tL,distL, 'b-O')

    grid on 
    zoom on
    if (NumberOfFramesL>1)
        velL = abs(distL(end)-distL(1))/maxtimeL;
    else
        velL = 0;
    end

    ylabel('distance moved along actin (um)')
    xlabel(['time (sec) cy3 vel = ' num2str(velL,3)])
end


% % Use code below to just measure distance from starting point
% distance=sqrt((xL-xL(1)).*(xL-xL(1))+(yL-yL(1)).*(yL-yL(1)))
% NumberOfFramesL=length(xLeft);
% maxtimeL=(NumberOfFramesL*deltaT-deltaT);
% tL=[0:deltaT:maxtimeL];
% plot(tL,distance, 'b-O')
% grid on
% zoom on
% if (NumberOfFramesL>1)
%     velL = abs(distance(end)-distance(1))/maxtimeL*1000;
% else
%     velL=0;
% end
% 
% ylabel('distance moved from start (microns)')
% xlabel(['time (sec) avg vel = ' num2str(velL,3)])