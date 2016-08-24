function [x,y]=closestapproach(params,datax,datay)
% Borrowed from TDS
% closestapproach-- function to return the point on the polynomial
% curve given by vector params (see polyfit) that is closest to 
% (datax,datay)
%
% datax and datay can be vectors, in which case x and y are of the same size.
%
% Used in myosin V run length analysis to take out the y scatter.
%
% 
% No longer assuming 3rd order.  Below is description for old way of assuming 2nd order
% which I have now commented out.
% 
% 
% For now, assume 2nd order polynomial
%
% method: minimize R=((x-datax)^2 + (y-datay)^2)
% ==> minimize R=((x-datax)^2 + (Ax^2 + Bx + C - datay)^2)
% ==> R=A^2x^4 + 2ABx^3 + (2A(C-datay) + B^2 + 1)x^2 + (2B(C-datay)-2datax)x +
% ...... ((C-datay)^2 + datax^2)
%
% could use fmin or fmins to do this, but I calculated dR/dx and found the 
% roots here.
%
% dR/dx=4A^2x^3 + 6ABx^2 + (4A(C-datay) + 2B^2 +2)x + (2B(C-datay)-2datax)

x=[];
y=[];
min1=min(datax)-abs(min(datax)*2);
max1=max(datax)+abs(max(datax)*2);

for j=1:length(datax)
	R=@(x) (x-datax(j))^2+(polyval(params,x)-datay(j))^2;
    xval=fminbnd(R,min1,max1);
    
%     c(1)=4*params(1)^2;
% 	c(2)=6*params(1)*params(2);
% 	c(3)=(4*params(1)*(params(3)-datay(j))+2*params(2)^2+2);
% 	c(4)=(2*params(2)*(params(3)-datay(j))-2*datax(j));
%     
%     
%     result=roots(c);
% 	R = [];
%     xtemp = [];
% 	% pluck out the real result
% 	xval=0;
% 	for i=1:length(result)
% 		if isreal(result(i))
%             xtemp = [xtemp; result(i)];
%             ytemp=polyval(params,result(i));
%             R = [R;((result(i)-datax(j))^2 + (ytemp - datay(j))^2)];
%             
%             %if (R<Rmin)
% 			  %  xval=result(i);
%                % Rmin = R;
%                %end
% 		end
% 	end
% 	[C,I]= min(R);
%     xval = xtemp(I);
% 	if xval==0
% 		error(['no real result found on iteration' j]);
% 	end
% 	
	yval=polyval(params,xval);
	x=[x xval];
	y=[y yval];
end

x=x';
y=y';