clear all;
close all;
% Scenario
RAT1 = RAT(1E6,1E6,[0,0],100,0);
RAT2 = RAT(1E6,1E6,[500,999],100,0);
LTE  = RAT(1E6,1E6,[500,500],500,0);
RAT3 = RAT(1E6,1E6,[1000,0],100,0);
RAT  = [RAT1,RAT2,LTE, RAT3]; % vettore RAT disponibili
% parametri: RAT(BW,BWtot,pos,n_max,n)
% BW banda iniziale da assegnare ad una richiesta
% BWtot capacità di canale
% pos vettore (x,y) della posizione in cui si trova il nodo
% n_max  numero massimo di dispositivi ammessi al collegamento (per questa
% simulazione praticamente infinito)
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


N = 20; % numero dei dispositivi
M = length(RAT); % numero delle antenne
assign = zeros(N,M); % matrice di assegnazione

% algorithm 1: User Satisfaction Cell Association

% per misurare il tempo di esecuzione di questo programma

    tStart1 = tic;
    fprintf(1,'First loop - here''s my N:  ');
    fprintf(1,'\b%d',N); pause(.1)
    fprintf('\n')
    
 % posiziono casualmente N dispositivi che richiedono una app casuale
for j=1:N       
        MD(j) = MobileDevice(0.3,400,1000,0.9,1.3,[random('unid',1000),random('unid',1000)],800,true);
        app(j) = App(random('unid',3));
end
    
    
% inizializzo le matrici per calcolare la utility function
 
S = zeros(N,M); % Throughput
E = zeros(N,M); % Energy
T = zeros(N,M); % Time
U = zeros(N,M);
El = zeros(N,1);
Tl = zeros(N,1);
ratscelta = zeros(N,1);
Umax = zeros(N,1);
Ec = zeros(N,1);

% calcolo la utility functon considerando un dispositivo alla volta, 
% tenendo conto delle precedenti assegnazioni    
for j=1:N  
    % calcolo la Utility Function che avrebbe il dispositivo
    % se si connettesse ad una delle RAT
    cont = 1;
    while cont <= M
        RAT(cont).n = RAT(cont).n + 1;
        S(j,cont)= Str(RAT(cont),MD(j));
        E(j,cont)= EnergiapartialOD(RAT(cont),MD(j),app(j),CS1);
        T(j,cont)= TempopartialOD(RAT(cont),MD(j),app(j),CS1);
        F_1(j,cont) = F1(S(j,cont),app(j));
        F_2(j,cont) = F2(E(j,cont),app(j));
        F_3(j,cont) = F3(T(j,cont),app(j));
        U(j,cont) = app(j).c1 * F_1(j,cont) + app(j).c2 * F_2(j,cont) + app(j).c3 * F_3(j,cont); % funzione di costo per MD(j) se usa la RAT cont 
        cont = cont + 1;
    end
    % trovo la RAT con la funzione di costo massima
    Umax(j) = max(U(j,:));
    % scelgo la RAT con la funzione di costo massima
    ratscelta(j) = find(U(j,:)==Umax(j),1, 'first');

    % rimetto a posto la banda e il numero di dispositivi per le altre
    % RAT (le non scelte)
    for i = 1:4
        if i ~= ratscelta(j)
            RAT(i).n = RAT(i).n - 1;
        end
    end
end

% calcolo il valore definitivo delle Utility function e delle
% caratteristiche S E T, data la distribuzione scelta

% valore definitivo dei dispositivi connessi a ciascuna RAT
for i = 1:4
        RAT(i).n = sum(ratscelta == i);
end
for j=1:N
   S_M(j)= Str(RAT(ratscelta(j)),MD(j));
   E_M(j)= EnergiapartialOD(RAT(ratscelta(j)),MD(j),app(j),CS1);
   T_M(j)= TempopartialOD(RAT(ratscelta(j)),MD(j),app(j),CS1);
   F_1M(j) = F1(S_M(j),app(j));
   F_2M(j,cont) = F2(E_M(j),app(j));
   F_3M(j,cont) = F3(T_M(j),app(j));
   U_M(j) = app(j).c1 * F_1M(j) + app(j).c2 * F_2M(j) + app(j).c3 * F_3M(j); % funzione di costo per MD(j) se usa la RAT cont 
end

%calcolo i valori medi su tutti i dispositivi (per il plot)
S_M_av = mean(S_M);
E_M_av = mean(E_M);
T_M_av = mean(T_M);

%%%%%%%%%%%%%%%%%%%
%
%  Biased Randomization
%
%%%%%%%%%%%%%%%%%%%%%

% riazzero i dispositivi connessi alle RAT
for i = 1:4
    RAT(i).n=0;
end
        
%          % aggiorno il valore della funzione di costo di ttti i MD già collegati, poiché è stato collegato un MD in più
%         for w = 1:j % per tutti i precedenti dispositivi
%           S_f(w)= Str(RAT(ratscelta(w)),MD(w));
%           E_f(w)= EnergiapartialOD(RAT(ratscelta(w)),MD(w),app(w),CS1);
%           T_f(w)= TempopartialOD(RAT(ratscelta(w)),MD(w),app(w),CS1);
%           F_1_f(w) = F1(S_f(w),app(w));
%           F_2_f(w) = F1(E_f(w),app(w));
%           F_3_f(w) = F3(T_f(w),app(w));
%           U_f(w) = app(w).c1 * F_1_f(w) + app(w).c2 * F_2_f(w) + app(w).c3 * F_3_f(w); 
%         end
%         
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %
%         %    Randomization
%         %
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % added for randomization
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Usorted = zeros(N,4);
%  
%         % sort of the U function
%         Usorted(j,:) = sort(U(j,:),'descend');
%         % choice of a value with geometric distribution
%         choice = mod(geoinv(0.95,rand()),4)+1;
%         Uchosen(j) = Usorted(j,choice);
%         % to which RAT?
%         ratsceltaRND(j) = find(U(j,:)==Uchosen(j),1, 'first');
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        
%     
%     %calcolo i valori medi su tutti i dispositivi (per il plot)
%     Sc_m(N) = mean(S_f);
%     Ec_m(N) = mean(E_f);
%     Tc_m(N) = mean(T_f);
% 
%     for h=1:4
%         MD_distrib(1,h)= RAT(h).n;
%     end
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %
%     %   Randomization results
%     %
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     % calculates how many MD for each RAT with the randomization and updates RAT.n
%     counter = 1;
%     for rat = RAT 
%        rat.n = sum(ratsceltaRND == counter);
%        rat.BW = min(1E6, rat.BWtot/rat.n);
%        counter = counter+1;
%     end
%     % Updates the value of S,E,T for every MD 
%     for w = 1:N 
%         S_gd(w)= Str(RAT(ratsceltaRND(w)),MD(w));
%         E_gd(w)= EnergiapartialOD(RAT(ratsceltaRND(w)),MD(w),app(w),CS1);
%         T_gd(w)= TempopartialOD(RAT(ratsceltaRND(w)),MD(w),app(w),CS1);
%         Fgd_1_f(w) = F1(S_gd(w),app(w));
%         Fgd_2_f(w) = F1(E_gd(w),app(w));
%         Fgd_3_f(w) = F3(T_gd(w),app(w));
%         Ugd_f(w) = app(w).c1 * Fgd_1_f(w) + app(w).c2 * Fgd_2_f(w) + app(w).c3 * Fgd_3_f(w); 
%     end
%     Sgd_m(N) = mean(S_gd);
%     Egd_m(N) = mean(E_gd);
%     Tgd_m(N) = mean(T_gd); 
%     tElapsed1 = toc(tStart1);
%     fprintf(1,'time:  ');
%     fprintf(1,'\b%d',tElapsed1); pause(.1)
%     fprintf('\n')
% 
% 
% 
% 
% % caso 2
% % calcolo della RAT più vicina a ciascun MD
% 
%     fprintf(1,'Second loop - here''s my N:  ');
%     fprintf(1,'\b%d',N); pause(.1)
%     fprintf('\n')
%     dist2 = zeros(N,4);  
%     for j = 1:N
%         cont = 0;
%         for rat = RAT 
%             cont = cont + 1;
%             dist2(j,cont) = Distanza(rat,MD(j));
%         end
%         [dist2min,RATvicina2]= min(dist2,[],2);
%     end 
%     % calcolo dei dispositivi collegati a ciascuna RAT
%     for l = 1:4
%       RAT(l).n = 0;
%     end
%     for h = 1:4
%         for k = 1:N
%             if RATvicina2(k) == h
%                 RAT(h).n = RAT(h).n + 1;
%             end
%         end
%     end
%     % per ogni RAT, la banda assegnata ad un dispositivo è uguale alla
%     % banda totale, che assumo 22MHz per AP e 100MHz per LTE
%     RAT(1).BW = 22E6/RAT(1).n;
%     RAT(2).BW = 22E6/RAT(2).n;
%     RAT(3).BW = 100E6/RAT(3).n;
%     RAT(4).BW = 22E6/RAT(4).n;
%     for j = 1:N
%        Sc2(j) = Str(RAT(RATvicina2(j)), MD(j));
%        Ec2(j)= EnergiapartialOD(RAT(RATvicina2(j)),MD(j),app(j),CS1);
%        Tc2(j)= TempopartialOD(RAT(RATvicina2(j)),MD(j),app(j),CS1); 
%     end
%     Sc2_m(N) = mean(Sc2);
%     Ec2_m(N) = mean(Ec2);
%     Tc2_m(N) = mean(Tc2);
%     for h=1:4
%         MD_distrib2(1,h)= RAT(h).n;
%     end
%     
%     
% % caso OD totale con RATvicina2
% 
%     fprintf(1,'Third loop - here''s my N:  ');
%     fprintf(1,'\b%d',N); pause(.1)
%     fprintf('\n')
%     for j = 1:N
%        ScOD(j) = Str(RAT(RATvicina2(j)), MD(j));
%        EcOD(j)= EnergiaOD(RAT(RATvicina2(j)),MD(j),app(j),CS1);
%        TOD(j)= TempoOD(RAT(RATvicina2(j)),MD(j),app(j),CS1); 
%     end
%     ScOD_m(N) = mean(ScOD);
%     EcOD_m(N) = mean(EcOD);
%     TOD_m(N) = mean(TOD);
% 
% 
% 
% 
% % caso  - locale
% 
%     fprintf(1,'Forth loop - here''s my N:  ');
%     fprintf(1,'\b%d',N); pause(.1)
%     fprintf('\n')
%    for j = 1:N
%         Eloc(j)=EnergiaLocale(MD(j),app(j));
%         Tloc(j)=TempoLocale(MD(j),app(j));
%    end 
%    Eloc_m(N) = mean(Eloc);
%    Tloc_m(N) = mean(Tloc);
% 
% 
% 
% 
% figure;
% loglog(N,Ec_m(N),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
% hold on;
% loglog(N,Ec2_m(N),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g') 
% hold on;
% loglog(N,Eloc_m(N),'k-v','MarkerFaceColor','k','MarkerEdgeColor','k')
% hold on;
% loglog(N,EcOD_m(N),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b')
% hold on;
% loglog(N,Egd_m(N),'k-*','MarkerFaceColor','m','MarkerEdgeColor','m')
% title(['Average Energy Consumption']);
% xlabel(['Mobile Devices [n]']);
% ylabel('Energy Consumption [W $\cdot$ s]','interpreter','latex');
% legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation','Total Offloading','Geometric Distribution ALgorithm');
% grid on;
% 
% figure;
% loglog(N,Tc_m(N),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
% hold on;
% loglog(N,Tc2_m(N),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g') 
% hold on;
% loglog(N,Tloc_m(N),'k-v','MarkerFaceColor','k','MarkerEdgeColor','k') 
% hold on;
% loglog(N,TOD_m(N),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b')
% hold on;
% loglog(N,Tgd_m(N),'k-*','MarkerFaceColor','m','MarkerEdgeColor','m')
% 
% title(['Average Calculation Time']);
% xlabel(['Mobile Devices [n]']);
% ylabel('Calculation Time [s]','interpreter','latex');
% legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation','Total Offloading','Geometric Distribution ALgorithm');
% grid on;
% 
% figure;
% loglog(N,Sc_m(N),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
% hold on;
% loglog(N,Sc2_m(N),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g' )
% hold on;
% loglog(N,ScOD_m(N),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b' )
% hold on;
% loglog(N,Sgd_m(N),'k-*','MarkerFaceColor','m','MarkerEdgeColor','m' )
% 
% title(['Throughput']);
% xlabel(['Mobile Devices [n]']);
% ylabel('Throughput [pbs]','interpreter','latex');
% legend('Utility Function Algorithm','Nearest Node Algorithm','Total Offloading','Geometric Distribution ALgorithm');
% grid on;
% 
