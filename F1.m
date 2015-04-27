function F1 = F1( Str, App )
%Sigmoid of data rate
    F1 = 1/(1+exp(-0.0005*(Str-App.Stro)));
end

