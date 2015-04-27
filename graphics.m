figure;
loglog(NMD,Ec_m(NMD),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
hold on;
loglog(NMD,Ec2_m(NMD),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g') 
hold on;
loglog(NMD,Eloc_m(NMD),'k-v','MarkerFaceColor','k','MarkerEdgeColor','k')
hold on;
loglog(NMD,EcOD_m(NMD),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b')
hold on;
loglog(NMD,Egd_m(NMD),'k-*','MarkerFaceColor','b','MarkerEdgeColor','b')
hold on;
loglog(NMD,Egd_m01(NMD),'k-*','MarkerFaceColor','k','MarkerEdgeColor','k')


title(['Average Energy Consumption']);
xlabel(['Mobile Devices [n]']);
ylabel('Energy Consumption [W $\cdot$ s]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation','Total Offloading','GD Algorithm p=0.75','GD Algorithm p=0.1');
grid on;

figure;
loglog(NMD,Tc_m(NMD),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
hold on;
loglog(NMD,Tc2_m(NMD),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g') 
hold on;
loglog(NMD,Tloc_m(NMD),'k-v','MarkerFaceColor','k','MarkerEdgeColor','k') 
hold on;
loglog(NMD,TOD_m(NMD),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b')
hold on;
loglog(NMD,Tgd_m(NMD),'k-*','MarkerFaceColor','b','MarkerEdgeColor','b')
hold on;
loglog(NMD,Tgd_m01(NMD),'k-*','MarkerFaceColor','k','MarkerEdgeColor','k')


title(['Average Calculation Time']);
xlabel(['Mobile Devices [n]']);
ylabel('Calculation Time [s]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Local Computation','Total Offloading','GD Algorithm p=0.75','GD Algorithm p=0.1');
grid on;

figure;
loglog(NMD,Sc_m(NMD),'k-o','MarkerFaceColor','r','MarkerEdgeColor','r' )
hold on;
loglog(NMD,Sc2_m(NMD),'k-s','MarkerFaceColor','g','MarkerEdgeColor','g' )
hold on;
loglog(NMD,ScOD_m(NMD),'k-d','MarkerFaceColor','b','MarkerEdgeColor','b' )
hold on;
loglog(NMD,Sgd_m(NMD),'k-*','MarkerFaceColor','b','MarkerEdgeColor','b' )
hold on;
loglog(NMD,Sgd_m01(NMD),'k-*','MarkerFaceColor','k','MarkerEdgeColor','k' )

title(['Throughput']);
xlabel(['Mobile Devices [n]']);
ylabel('Throughput [pbs]','interpreter','latex');
legend('Utility Function Algorithm','Nearest Node Algorithm','Total Offloading','GD Algorithm p=0.75','GD Algorithm p=0.1');
grid on;

