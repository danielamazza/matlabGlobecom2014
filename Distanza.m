function Distanza = Distanza(RAT,MD) 
    pos1 = RAT.pos;
    pos2 = MD.pos;
    Distanza  =   sqrt((pos1(1)-pos2(1))^2+(pos1(2)-pos2(2))^2); 
    
end