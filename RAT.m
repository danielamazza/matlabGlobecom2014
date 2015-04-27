classdef RAT
    % Radio Access Node
    %  
    % BW  banda max assegnata a un dispositivo
    % BWtot capacità di canale
    % pos  posizione [x,y]
    % n_max  numero massimo di dispositivi ammessi al collegamento
    % n = numero di dispositivi collegati
    properties
        BW
        BWtot
        pos
        n_max
        n
    end
    
    methods
        function RAT = RAT(BW,BWtot,pos,n_max,n)
            RAT.BW = BW;
            RAT.BWtot = BWtot;
            RAT.pos = pos;
            RAT.n_max = n_max;
            RAT.n = n;
        end
    end    
end