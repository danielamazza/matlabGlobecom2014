function EnergiapartialOD = EnergiapartialOD(RAT,MD,App,CS)
    % Rappresenta l'energia consumata dall'MD per 
    % trasferire parzialmente il calcolo all'AP 
      Strc = Str(RAT, MD);
      EnergiapartialOD = (MD.Pl * App.O * (1 - App.gamma)) / MD.Smd + ...
            (MD.Pid * App.O * App.gamma) / CS.Scs + ...
            (MD.Ptr * App.D * App.delta)/ Strc;

end

