function EnergiaLocale = EnergiaLocale(MD,App)
    % Rappresenta l'energia consumata dall'MD per 
    % effettuare il calcolo in locale 
      EnergiaLocale = MD.Pl * App.O / MD.Smd; 
end

