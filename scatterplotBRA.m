scatter(0,0,40,'r','filled') % RAT1 = RAT(1,22,[0,0],100,0);
hold on;
scatter(500,999,40,'g','filled')% RAT2 = RAT(1,22,[500,999],100,0);
hold on;
scatter(500,500,40,'b','square','filled')%LTE  = RAT(1,100,[500,500],500,0);
hold on;
scatter(1000,0,40,'m','filled')%RAT3 = RAT(1,22,[1000,0],100,0);
hold on;


for i = 1:N
if ratsceltaRND(i) == 0    
   scatter(MD(i).pos(1), MD(i).pos(2),10,'k')
   hold on;
elseif ratsceltaRND(i) == 1
   scatter(MD(i).pos(1), MD(i).pos(2),10,'r')
   hold on;
elseif ratsceltaRND(i) == 2
   scatter(MD(i).pos(1), MD(i).pos(2),10,'g')
   hold on;
elseif ratsceltaRND(i) == 3
   scatter(MD(i).pos(1), MD(i).pos(2),10,'b')
   hold on;
elseif ratsceltaRND(i) == 4
   scatter(MD(i).pos(1), MD(i).pos(2),10,'m')
   hold on;
end
end