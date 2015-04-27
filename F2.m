function F2 = F2( E, App )
%sigmoid (inverse) of energy
    F2 = 1-(1 /(1+exp(-0.000001*(E-App.Eo))));  
end

