for i = 1:500
    for j = 1:M
        Eloc_prova(i,j) = EnergiaLocale(MD(i),app(i));
        Epart_prova(i,j)= EnergiapartialOD(RAT(j),MD(i),app(i),CS1);
        Etot_prova(i,j)= EnergiaOD(RAT(j),MD(i),app(i),CS1);
    end
end
