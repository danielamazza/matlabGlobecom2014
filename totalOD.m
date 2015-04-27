% caso 4 - total od
NMD = [1 2 5 10 20 50 100 200 500 1000 2000 5000]; % numero di dispositivi 1 2 5 10 20 50 100 200 500 1000 2000 5000 

for N = NMD
    
    for j = 1:N
       Sc4(j) = Str(RAT(RATvicina2(j)), MD(j));
       Ec4(j)= EnergiapartialOD(RAT(RATvicina2(j)),MD(j),app(j),CS1);
       Tc4(j)= TempopartialOD(RAT(RATvicina2(j)),MD(j),app(j),CS1); 
    end
    Sc4_m(N) = mean(Sc2);
    Ec4_m(N) = mean(Ec2);
    Tc4_m(N) = mean(Tc2);
end