clear
tic
f=1;
t=0:0.025:10;
x=sin(2*pi*f*t);
N=length(x);
t1=0:0.025:5;
n=length(t1);
P=[x(1:n);x(2:n+1)];
T=x(3:n+2);
PR=[-1 1;-1 1];
%ANN 1-20-1;
%net=newff(PR,[20,1],{'tansig','purelin'},'trainbr');
net=newff(PR,[1],{'purelin'},'trainbr');
net.trainParam.epochs=200;
net.trainParam.min_grad=0;
net.trainParam.goal=0;%eps;
%net.trainParam.mu_max=inf;
net=train(net,P,T);
toc
%pause
xp=[x(1:N-2);x(2:N-1)];
Y=sim(net,xp);
plot(t(3:end),x(3:end),t(3:end),Y);