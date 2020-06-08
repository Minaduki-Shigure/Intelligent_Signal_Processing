clear
tic
t=0:0.25:7.5;%4 periods;period is 2.5;2.5/10=0.25;
f=1/2.5;
x=sin(2*pi*f*t);
t1=0:0.025:7.5;
x1=sin(2*pi*f*t1);
P=0:0.25:5;
T=x(1:length(P));
PR=[0 7.5];
%ANN 1-20-1;
net=newff(PR,[20,1],{'tansig','purelin'},'trainscg');
net.trainParam.epochs=200;
net.trainParam.min_grad=0;
net.trainParam.goal=0;%eps;
%net.trainParam.mu_max=inf;
net=train(net,P,T);
toc
%pause
Y=sim(net,t1);
plot(t1,x1,t1,Y);
%hold on
%plot(P,x(1:length(P)),'o');
%net1=net;
%load net;
%Y=sim(net,t);
%plot(t,Y,':');
%net=net1;
%save net
