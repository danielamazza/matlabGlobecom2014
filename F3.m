function F3 = F3( T, App )
%sigmoid (inverse) of time
    F3 = 1 - (1 /(1+exp(-0.000001*(T-App.To))));
end