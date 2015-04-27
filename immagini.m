
loglog(NMD,Ec_m(NMD),'k-o',NMD,Ec2_m(NMD),'k-s',NMD,Eloc_m(NMD),'k-v')
title(['Average Energy Consumption']);
xlabel(['Mobile Devices [n]']);
ylabel('Energy Consumption [W $\cdot$ s]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation');
grid on;




loglog(NMD,Tc_m(NMD),'k-o',NMD,Tc2_m(NMD),'k-s',NMD,Tloc_m(NMD),'k-v') %,NMD,Tc4_m(NMD),'k-^'
title(['Average Calculation Time']);
xlabel(['Mobile Devices [n]']);
ylabel('Calculation Time [s]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation'); %, 'Total Offloading'
grid on;

figure;
loglog(NMD,Sc_m(NMD),'k-o',NMD,Sc2_m(NMD),'k-s') %,NMD,Sc4_m(NMD),'k-^'
title(['Throughput']);
xlabel(['Mobile Devices [n]']);
ylabel('Throughput [pbs]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm'); %,'Total Offloading'
grid on;