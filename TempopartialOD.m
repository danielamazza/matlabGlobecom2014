function TempopartialOD = TempopartialOD(RAT,MD,App,CS)
    % poiché si presume che le operazioni vengano effettuate in parallelo,
    % consideriamo il massimo tra i due tempi
         TempoLocale = App.O *(1 - App.gamma) / MD.Smd; 
         Strc = Str(RAT,MD);
         TempoOD = App.O * App.gamma / CS.Scs + App.D * App.delta /Strc;
     TempopartialOD = max(TempoLocale,TempoOD);
end