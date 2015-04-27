function TempoOD = TempoOD( RAT,MD,App,CS)
    % Rappresenta il tempo consumato per 
    % l'esecuzione della applicazione più il tempo di trasmissione se
    % effettuata sul server
         Strnew2 = Str(RAT, MD);

         TempoOD = App.O / CS.Scs + App.D /Strnew2;
     
end