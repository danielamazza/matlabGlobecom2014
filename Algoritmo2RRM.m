clear all;
close all;
% Scenario
RAT1 = RAT(1E6,22E6,[0,0],100,0);
RAT2 = RAT(1E6,22E6,[500,999],100,0);
LTE  = RAT(1E6,100E6,[500,500],500,0);
RAT3 = RAT(1E6,22E6,[1000,0],100,0);
RAT  = [RAT1,RAT2,LTE, RAT3]; % vettore RAT disponibili
% parametri: RAT(BW,BWtot,pos,n)
% BW banda iniziale da assegnare ad una richiesta
% BWtot capacità di canale
% pos vettore (x,y) della posizione in cui si trova il nodo
% n_max  numero massimo di dispositivi ammessi al collegamento
% n numero di dispositivi che il nodo sta collegando contemporaneamente

App1 = Application(10E7,10E5,0.9,0.25,0.6,0.2,0.2,0.52e3,     2.9e3      ,25000 ); % applicazione 1
App2 = Application(10E5,10E7,0.1,0.07,0.2,0.2,0.6,1.42e3,     3.6e3       ,2500 ); % applicazione 2
App3 = Application(10E7,10E7,0.7,0.35,0.2,0.6,0.2,0.93e3,     7.1e3      ,75000 ); % applicazione 3
App = [App1,App2,App3]; % vettore classi applicazioni

% parametri: Application
% O  numero totale di operazioni da eseguire
% D dati da scambiare (bit)
% gamma percentuale operazioni da fare in OD
% delta percentuale dati da trasferire in OD
% c1 percentuale in U di f1(Str)
% c2 percentuale in U di f2(E)
% c3 percentuale in U di f3(T)
% Stro valore di riferimento data rate 
% Eo valore di riferimento energia 
% To valore di riferimento tempo

CS1 = CloudServer(8000); % unico cloudserver
% parametri: CloudServer(Scs)
% Scs velocità di calcolo del cloud server


NMD = [1 2 5 10 20 ]; % numero di dispositivi 1 2 5 10 20 50 100 200 500 1000 2000 5000 
MD_distrib = zeros(length(NMD),4);  
MD_distrib2 = zeros(length(NMD),4);

% algorithm 1: User Satisfaction Cell Association
cont1 = 1;
while cont1 <= length(NMD)
for N = NMD
    S = zeros(N,4);
    E = zeros(N,4); 
    T = zeros(N,4);
    U = zeros(N,4);
    El = zeros(N,1);
    Tl = zeros(N,1);
    ratscelta = zeros(N,1);
    Umax = zeros(N,1);
    Ec = zeros(N,1);
    
    
% inizializzo le antenne con zero dispositivi connessi
    for l = 1:4
      RAT(l).n = 0;
    end
% posiziono casualmente N dispositivi che richiedono una app casuale
    for j=1:N       
        MD(j) = MobileDevice(0.3,400,1000,0.9,1.3,[random('unid',1000),random('unid',1000)],800,true);
        app(j) = App(random('unid',3));
        
        cont = 0;
        % Calcola il valore della funzione di costo associata alla scelta
        % di ciascuna RAT
        for rat = RAT
            rat.BW = min(app(j).Stro,rat.BWtot/(rat.n+1)); % la banda è Stro se l'antenna non ha già la capacità di canale completamente occupata
                                                           % altrimenti è suddivisa equamente tra tutti i device
            cont = cont + 1;
                S(j,cont)= Str(rat,MD(j));
                E(j,cont)= EnergiapartialOD(rat,MD(j),app(j),CS1);
                T(j,cont)= TempopartialOD(rat,MD(j),app(j),CS1);
                F_1(j,cont) = F1(S(j,cont),app(j));
                F_2(j,cont) = F2(E(j,cont),app(j));
                F_3(j,cont) = F3(T(j,cont),app(j));
                U(j,cont) = app(j).c1 * F_1(j,cont) + app(j).c2 * F_2(j,cont) + app(j).c3 * F_3(j,cont); 
        end
        Umax(j) = max(U(j,:));
        
        if Umax(j) == 0 % questo è un controllo inutile
            ratscelta(j) = 0; % dispositivo non connesso (non utilizzata)
        else    
            ratscelta(j) = find(U(j,:)==Umax(j),1, 'first');
            RAT(ratscelta(j)).n = RAT(ratscelta(j)).n + 1;
        end
        for w = 1:j
          S_f(w)= Str(RAT(ratscelta(w)),MD(w));
          E_f(w)= EnergiapartialOD(RAT(ratscelta(w)),MD(w),app(w),CS1);
          T_f(w)= TempopartialOD(RAT(ratscelta(w)),MD(w),app(w),CS1);
          F_1_f(w) = F1(S_f(w),app(w));
          F_2_f(w) = F1(E_f(w),app(w));
          F_3_f(w) = F3(T_f(w),app(w));
          U_f(w) = app(w).c1 * F_1_f(w) + app(w).c2 * F_2_f(w) + app(w).c3 * F_3_f(w); 
        end
    end
    Sc_m(N) = mean(S_f);
    Ec_m(N) = mean(E_f);
    Tc_m(N) = mean(T_f);

    for h=1:4
        MD_distrib(cont1,h)= RAT(h).n;
    end
    
    cont1 = cont1 + 1;
end
    
end


% caso 2
% calcolo della RAT più vicina a ciascun MD
cont2 =1;
while cont2 <= length(NMD)
for N = NMD
    dist2 = zeros(N,4);  
    for j = 1:N
        cont = 0;
        for rat = RAT 
            cont = cont + 1;
            dist2(j,cont) = Distanza(rat,MD(j));
        end
        [dist2min,RATvicina2]= min(dist2,[],2);
    end 
    % calcolo dei dispositivi collegati a ciascuna RAT
    for l = 1:4
      RAT(l).n = 0;
    end
    for h = 1:4
        for k = 1:N
            if RATvicina2(k) == h
                RAT(h).n = RAT(h).n + 1;
            end
        end
    end
    % per ogni RAT, la banda assegnata ad un dispositivo è uguale alla
    % banda totale, che assumo 22MHz per AP e 100MHz per LTE
    RAT(1).BW = 22E6/RAT(1).n;
    RAT(2).BW = 22E6/RAT(2).n;
    RAT(3).BW = 100E6/RAT(3).n;
    RAT(4).BW = 22E6/RAT(4).n;
    for j = 1:N
       Sc2(j) = Str(RAT(RATvicina2(j)), MD(j));
       Ec2(j)= EnergiapartialOD(RAT(RATvicina2(j)),MD(j),app(j),CS1);
       Tc2(j)= TempopartialOD(RAT(RATvicina2(j)),MD(j),app(j),CS1); 
    end
    Sc2_m(N) = mean(Sc2);
    Ec2_m(N) = mean(Ec2);
    Tc2_m(N) = mean(Tc2);
    for h=1:4
        MD_distrib2(cont2,h)= RAT(h).n;
    end
    
    cont2 = cont2 + 1;
    
end
end

% caso OD totale con RATvicina2
for N = NMD
    for j = 1:N
       ScOD(j) = Str(RAT(RATvicina2(j)), MD(j));
       EcOD(j)= EnergiaOD(RAT(RATvicina2(j)),MD(j),app(j),CS1);
       TOD(j)= TempoOD(RAT(RATvicina2(j)),MD(j),app(j),CS1); 
    end
    ScOD_m(N) = mean(ScOD);
    EcOD_m(N) = mean(EcOD);
    TOD_m(N) = mean(TOD);
end



% caso  - locale
for N = NMD
   for j = 1:N
        Eloc(j)=EnergiaLocale(MD(j),app(j));
        Tloc(j)=TempoLocale(MD(j),app(j));
   end 
   Eloc_m(N) = mean(Eloc);
   Tloc_m(N) = mean(Tloc);
end
figure;
loglog(NMD,Ec_m(NMD),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
hold on;
loglog(NMD,Ec2_m(NMD),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g') 
hold on;
loglog(NMD,Eloc_m(NMD),'k-v','MarkerFaceColor','k','MarkerEdgeColor','k')
hold on;
loglog(NMD,EcOD_m(NMD),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b')
title(['Average Energy Consumption']);
xlabel(['Mobile Devices [n]']);
ylabel('Energy Consumption [W $\cdot$ s]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation','Total Offloading');
grid on;

figure;
loglog(NMD,Tc_m(NMD),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
hold on;
loglog(NMD,Tc2_m(NMD),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g') 
hold on;
loglog(NMD,Tloc_m(NMD),'k-v','MarkerFaceColor','k','MarkerEdgeColor','k') 
hold on;
loglog(NMD,TOD_m(NMD),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b')
title(['Average Calculation Time']);
xlabel(['Mobile Devices [n]']);
ylabel('Calculation Time [s]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation','Total Offloading');
grid on;

% figure;
% loglog(NMD,Tc_m(NMD),'k-o',NMD,Tc2_m(NMD),'k-s',NMD,Tloc_m(NMD),'k-v',NMD,TOD_m(NMD),'k-d','MarkerFaceColor',[0.5,0.5,0.5]) %,NMD,Tc4_m(NMD),'k-^'
% title(['Average Calculation Time']);
% xlabel(['Mobile Devices [n]']);
% ylabel('Calculation Time [s]','interpreter','latex');
% legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation','Total Offloading');
% grid on;



figure;
loglog(NMD,Sc_m(NMD),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
hold on;
loglog(NMD,Sc2_m(NMD),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g' )
hold on;
loglog(NMD,ScOD_m(NMD),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b' )
title(['Throughput']);
xlabel(['Mobile Devices [n]']);
ylabel('Throughput [pbs]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Total Offloading');
grid on;

