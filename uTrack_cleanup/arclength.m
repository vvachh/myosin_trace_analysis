function dist = arclength(params, x, y)
% Borrowed from TDS
if size(params,2) == 3 % quadratic
    a = params(1); 
    b = params(2);
    c = params(3);

    %S = ((2*a*x+b)*sqrt(4*a^2*x^2+4*a*b*x+b^2+1)+log(4*a*sqrt(4*a^2*x^2+4*a*b*x+b^2+1)+16*a^2*x+4*a*b))/(4*a)
    m = sqrt(4*a.^2*x.^2+(4*a*b).*x+b^2+1);
    n = asinh(b + (2*a).*x);
    S = (((2*a).*x+b).*m +n)/(4*a);
    dist = S;
    %{
    a = params(1); 
    b = params(2);
        
    G=@(X) sqrt(1 + (2*a*X + b).^2);
    
    for point = 1:length(x)
        S(point) = quad(G,0,x(point));
    end
    
    dist = S;
    %}
elseif size(params,2) == 4 % cubic

    a = params(1); 
    b = params(2);
    c = params(3);
    
    G=@(X) sqrt(1 + (3*a*X.^2 + 2*b*X + c).^2);
    
    for point = 1:length(x)
        S(point) = quad(G,0,x(point));
    end
    
    dist = S;
elseif size(params,2) == 5 % quartic 
    
    a = params(1); 
    b = params(2);
    c = params(3);
    d = params(4);
    
    G=@(X) sqrt(1 + (4*a*X.^3 + 3*b*X.^2 + 2*c*X + d).^2);
    
    for point = 1:length(x)
        S(point) = quad(G,0,x(point));
    end
    
    dist = S;
elseif size(params,2) == 6 % fifth 
    
    a = params(1); 
    b = params(2);
    c = params(3);
    d = params(4);
    e = params(5);
    
    G=@(X) sqrt(1 + (5*a*X.^4 + 4*b*X.^3 + 3*c*X.^2 + 2*d*X + e).^2);
    
    for point = 1:length(x)
        S(point) = quad(G,0,x(point));
    end
    
    dist = S;
elseif size(params,2) == 7 % sixth 
    
    a = params(1); 
    b = params(2);
    c = params(3);
    d = params(4);
    e = params(5);
    f = params(6);
    
    G=@(X) sqrt(1 + (6*a*X.^5 + 5*b*X.^4 + 4*c*X.^3 + 3*d*X.^2 + 2*e*X + f).^2);
    
    for point = 1:length(x)
        S(point) = quad(G,0,x(point));
    end
    
    dist = S;
elseif size(params,2) == 8 % seventh 
    
    a = params(1); 
    b = params(2);
    c = params(3);
    d = params(4);
    e = params(5);
    f = params(6);
    g = params(7);
    
    G=@(X) sqrt(1 + (7*a*X.^6 + 6*b*X.^5 + 5*c*X.^4 + 4*d*X.^3 + 3*e*X.^2 + 2*f*X + g).^2);
    
    for point = 1:length(x)
        S(point) = quad(G,0,x(point));
    end
    
    dist = S;
else
    fit_order_error = true
end   