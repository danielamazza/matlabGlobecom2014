


figure;
loglog(NMD,Sc_m(NMD),'b-o',NMD,Sc2_m(NMD),'b-s') %,'b-o',NMD,Sc2_m(NMD),'b-s',NMD,Sloc_m(NMD),'b-v'
title(['Throughput']);
xlabel(['Mobile Devices [n]']);
ylabel('Throughput [bps]','interpreter','latex');
legend('Adaptive Offloading','Nearest Node');
grid on;