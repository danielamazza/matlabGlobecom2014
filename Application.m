classdef Application 
    % Application Summary of this class goes here
    properties
        O % numero totale di operazioni da eseguire
        D % dati da scambiare 
        gamma % percentuale di calcolo trasferito
        delta % percentuale di dati trasferiti
        c1 % percentuale in U di f1(Str)
        c2 % percentuale in U di f2(E)
        c3 % percentuale in U di f3(T)
        Stro % valore di riferimento data rate 
        Eo % valore di riferimento energia 
        To % valore di riferimento tempo
    end
    
    methods
        function App = Application(O,D,gamma,delta,c1,c2,c3,Stro,Eo,To)
            App.O = O;
            App.D = D;
            App.gamma = gamma;
            App.delta = delta;
            App.c1 = c1;
            App.c2 = c2;
            App.c3 = c3;
            App.Stro = Stro;
            App.Eo = Eo;
            App.To = To;
        end
    end   
end

