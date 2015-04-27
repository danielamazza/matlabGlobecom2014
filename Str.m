function Str = Str(RAT, MD)
         dist = Distanza(RAT, MD);
         Str = (RAT.BWtot/RAT.n) * log2(1+MD.SNR/(dist^2));
end