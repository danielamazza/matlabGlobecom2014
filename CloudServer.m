classdef CloudServer
    % CloudServer  è il Cloud Server su cui viene 
    % effettuato l'OD
    properties
        Scs % velocità di calcolo del cloud server   
    end
    methods
        function CS = CloudServer(Scs)
            CS.Scs = Scs;        
        end
    end  
end

