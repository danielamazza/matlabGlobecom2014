figure('Name','GA distribution')
scatter(0,0,100,'r','filled') % RAT1 = RAT(1,22,[0,0],100,0);
hold on;
scatter(500,999,100,'g','filled')% RAT2 = RAT(1,22,[500,999],100,0);
hold on;
scatter(500,500,100,'b','square','filled')%LTE  = RAT(1,100,[500,500],500,0);
hold on;
scatter(1000,1000,100,'k','square','filled')%LTE2  = RAT(1,100,[1000,1000],500,0);
hold on;

for i = 1:N
if ratscelta(i) == 0    
   scatter(MD(i).pos(1), MD(i).pos(2),50,'k')
   hold on;
elseif ratscelta(i) == 1
   scatter(MD(i).pos(1), MD(i).pos(2),50,'r')
   hold on;
elseif ratscelta(i) == 2
   scatter(MD(i).pos(1), MD(i).pos(2),50,'g')
   hold on;
elseif ratscelta(i) == 3
   scatter(MD(i).pos(1), MD(i).pos(2),50,'b')
   hold on;
elseif ratscelta(i) == 4
   scatter(MD(i).pos(1), MD(i).pos(2),50,'m')
   hold on;
elseif ratscelta(i) == 5
   scatter(MD(i).pos(1), MD(i).pos(2),50,'k')
   hold on;
end
end