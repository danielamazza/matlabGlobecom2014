clear all;
close all;
% Biased Randomization Values:
p = 0.95; 
Nloop = 100;
N = 20; % numero dei dispositivi

fprintf(1,'*****************************************************');
fprintf('\n')
fprintf(1,'Results for:  ');
fprintf('\n')
fprintf(1,'Number of devices:  ');
fprintf(1,'\b%d',N); 

fprintf(1,'    p:  ');
fprintf(1,'\b%.2f',p);

fprintf(1,'    Number of loop:  ');
fprintf(1,'\b%d',Nloop); 
fprintf('\n')

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
M = length(RAT); % numero delle antenne
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

% algorithm 1: User Satisfaction Cell Association  
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
ratscelta = zeros(N,1);
Umax = zeros(N,1);

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

    % rimetto a il numero di dispositivi per le altre
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
for i = 1:M
    RAT(i).n = sum(ratscelta == i);
end
for j=1:N
    S_M(j)= Str(RAT(ratscelta(j)),MD(j));
    E_M(j)= EnergiapartialOD(RAT(ratscelta(j)),MD(j),app(j),CS1);
    T_M(j)= TempopartialOD(RAT(ratscelta(j)),MD(j),app(j),CS1);
    F_1M(j) = F1(S_M(j),app(j));
    F_2M(j,cont) = F2(E_M(j),app(j));
    F_3M(j,cont) = F3(T_M(j),app(j));
    U_M(j) = app(j).c1 * F_1M(j) + app(j).c2 * F_2M(j) + app(j).c3 * F_3M(j);  
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

ratsceltaRND = zeros(N,1);
% sort of the U function
for j = 1:N
    Usorted(j,:) = sort(U(j,:),'descend');
end

Udef = 0;
ratsceltaMAT = zeros(N,Nloop);
for w=1:Nloop
    for j = 1:N
        % choice of a value with geometric distribution
        choice = mod(geoinv(p,rand()),4)+1;
        Uchosen(j) = Usorted(j,choice);
        % to which RAT ?
        ratsceltaRND(j) = find(U(j,:)==Uchosen(j),1, 'first');   
    end
    % valore definitivo dei dispositivi connessi a ciascuna RAT
    for i = 1:M
        RAT(i).n = sum(ratsceltaRND == i);
    end
    for j=1:N
        S_RND(j)= Str(RAT(ratsceltaRND(j)),MD(j));
        E_RND(j)= EnergiapartialOD(RAT(ratsceltaRND(j)),MD(j),app(j),CS1);
        T_RND(j)= TempopartialOD(RAT(ratsceltaRND(j)),MD(j),app(j),CS1);
        F_1RND(j) = F1(S_RND(j),app(j));
        F_2RND(j,cont) = F2(E_RND(j),app(j));
        F_3RND(j,cont) = F3(T_RND(j),app(j));
        U_RND(j) = app(j).c1 * F_1RND(j) + app(j).c2 * F_2RND(j) + app(j).c3 * F_3RND(j);  
    end
    U_media = mean(U_RND);
    if Udef < U_media
        Udef = U_media;
        ratsceltadef = ratsceltaRND;
        %fprintf(1,'miglioramento  ');
        %fprintf(1,'\b%d',ratsceltadef);
        %fprintf('\n')
    end
    
%     fprintf(1,'Loop:  ');
%     fprintf(1,'\b%d',w); pause(.1)
%     fprintf(1,'  Udef:  ');
%     fprintf(1,'\b%d',Udef); pause(.1)
%     fprintf('\n')
    ratsceltaMAT(:,w) = ratsceltaRND;
end

%calcolo i valori medi su tutti i dispositivi (per il plot)

for i = 1:M
    RAT(i).n = sum(ratsceltadef == i);
end
for j=1:N
    S_RND(j)= Str(RAT(ratsceltadef(j)),MD(j));
    E_RND(j)= EnergiapartialOD(RAT(ratsceltadef(j)),MD(j),app(j),CS1);
    T_RND(j)= TempopartialOD(RAT(ratsceltadef(j)),MD(j),app(j),CS1);
    F_1RND(j) = F1(S_RND(j),app(j));
    F_2RND(j,cont) = F2(E_RND(j),app(j));
    F_3RND(j,cont) = F3(T_RND(j),app(j));
    U_RND(j) = app(j).c1 * F_1RND(j) + app(j).c2 * F_2RND(j) + app(j).c3 * F_3RND(j);  
end
    


S_RND_av = mean(S_RND);
E_RND_av = mean(E_RND);
T_RND_av = mean(T_RND);





fprintf(1,'************ Throughput **********');
fprintf('\n')
fprintf(1,'Ref Value:  ');
fprintf(1,'\b%.2f',S_M_av); 
fprintf(1,';   Biased Rand Utility:  ');
fprintf(1,'\b%.2f',S_RND_av); 
fprintf(1,';   ');
fprintf('\n')
if S_M_av <= S_RND_av
    fprintf(1,'  Considering Throughput, Biased RND is better:  ');
else
    fprintf(1,'  Considering Throughput, Biased RND is worse:  ');
end
fprintf(1,'\b%.2f',(S_RND_av-S_M_av)*100/S_M_av);
fprintf(1,'%%');
fprintf('\n')
fprintf('\n')
fprintf(1,'************ Energy **********');
fprintf('\n')
fprintf(1,'Ref Value:  ');
fprintf(1,'\b%.2f',E_M_av); 
fprintf(1,';   Biased Rand Utility:  ');
fprintf(1,'\b%.2f',E_RND_av); 
fprintf(1,';   ');
fprintf('\n')
if E_M_av <= E_RND_av
    fprintf(1,'  Considering Energy, Biased RDM is worse:  ');
else
    fprintf(1,'  Considering Energy, Biased RDM is better:  ');
end
fprintf('\n')
fprintf(1,'\b%.2f',(E_RND_av-E_M_av)*100/E_M_av);
fprintf(1,'%%');
fprintf('\n')
fprintf('\n')
fprintf(1,'************ Time **********');
fprintf('\n')
fprintf(1,'Ref Value:  ');
fprintf(1,'\b%.2f',T_M_av); 
fprintf(1,';   Biased Rand Utility:  ');
fprintf(1,'\b%.2f',T_RND_av);
fprintf(1,';   ');
fprintf('\n')
if T_M_av <= T_RND_av
    fprintf(1,'  Considering Time, Biased RDM is worse:  ');
else
    fprintf(1,'  Considering Time, Biased RDM is better:  ');
end
fprintf('\n')
fprintf(1,'\b%.2f',(T_RND_av-T_M_av)*100/T_M_av);
fprintf(1,'%%');
fprintf('\n')
fprintf('\n')

