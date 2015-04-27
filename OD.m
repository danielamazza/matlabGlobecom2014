for N = NMD
ScOD=zeros(j,1) ;
EcOD=zeros(j,1);
TOD=zeros(j,1);
    for j = 1:N
       ScOD(j) = Str(RAT(RATvicina2(j)), MD(j));
       EcOD(j)= EnergiaOD(RAT(RATvicina2(j)),MD(j),app(j),CS1);
       TOD(j)= TempoOD(RAT(RATvicina2(j)),MD(j),app(j),CS1); 
    end
    ScOD_m(N) = mean(ScOD);
    EcOD_m(N) = mean(EcOD);
    TOD_m(N) = mean(TOD);
end