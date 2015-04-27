x = [1:100];
y1 = geopdf(x,0.1);   % For p = 0.1
y2 = geopdf(x,0.25);  % For p = 0.25
y3 = geopdf(x,0.75);  % For p = 0.75

figure;
plot(x,y1,'kd')
hold on
plot(x,y2,'ro')
plot(x,y3,'b+')
legend({'p = 0.1','p = 0.25','p = 0.75'})
hold off

x = [1:10];
z1 = geocdf(x,0.1);   % For p = 0.1
z2 = geocdf(x,0.25);  % For p = 0.25
z3 = geocdf(x,0.75);  % For p = 0.75

figure;
plot(x,z1,'kd')
hold on
plot(x,z2,'ro')
plot(x,z3,'b+')
legend({'p = 0.1','p = 0.25','p = 0.75'})
hold off