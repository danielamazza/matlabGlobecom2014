function EnergiaOD = EnergiaOD(RAT,MD,App,CS)
    % Rappresenta l'energia consumata dall'MD per 
    % trasferire il calcolo all'AP (idle + trasmissione)
         Strnew = Str(RAT, MD);
         EnergiaOD = MD.Pid * App.O / CS.Scs + MD.Ptr *App.D /Strnew;
        end

