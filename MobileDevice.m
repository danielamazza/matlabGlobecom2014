classdef MobileDevice
    % Mobile Device Properties
    properties
        Pid % Power for idle while the MD is waiting for 
            % the remote computing
        Smd % Computation speed of the MD (for local computation)
         % Str Transmission speed
        SNR % di riferimento a distanza 1m
        Pl  % 
        Ptr % 
        pos % position (x,y)
        do  % raggio di copertura
        Energy  % True if the mobile device has limited battery lifetime
    end
    methods
        function MD = MobileDevice(Pid,Smd,SNR, Pl,Ptr,pos,do,Energy)
            if nargin > 0 % Support calling with 0 arguments
                MD.Pid = Pid;
                MD.Smd = Smd;
                MD.SNR = SNR;
                MD.Pl = Pl;
                MD.Ptr = Ptr;
                MD.pos = pos;
                MD.do = do; % raggio di copertura
                MD.Energy = Energy;
            end
        end
    end
    
end

