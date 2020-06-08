clear
tic
%Data (Sample)
% Z=[0 1 0 1;
% 1 0 0 1;
% 1 1 0 0];
% n1=2;n2=2;n=4; D=2;
% Z=[0 1 2 3;
% 0 1.5 1 0.5;
% -0.95 0.95 0.95 0.95];
% n1=1;n2=3;n=4;D=2;
% Z=[3 1 2 1 3 3 4;
% 3 3 2.5 1 1 2.5 3;
% -1 -1 -1 1 1 1 1];
% n1=3;n2=4;n=7;D=2;
Z=[3 1 2 1.5 1 3 3 4 1;
 3 3 2.5 1.5 1 1 2.5 3 2;
 -1 -1 -1 -1 1 1 1 1 1]
n1=4;n2=5;n=9;D=2;
X=Z(1:2,:);X1=X(:,1:n1); X2=X(:,n1+1:n);
Y=Z(3,:);Y1=Y(1:n1); Y2=Y(n1+1:n);
P=X;
T=Y;
PR=[-10 10;-10 10];
%ANN 1-20-1;
net=newff(PR,[40,1],{'tansig','purelin'},'trainscg');
net.trainParam.epochs=200;
net.trainParam.min_grad=0;
net.trainParam.goal=0;%eps;
%net.trainParam.mu_max=inf;
net=train(net,P,T);
m1=net.IW;
m2=net.b;
m3=net.LW;
IW=m1{1,1};
b1=m2{1,1};
b2=m2{2,1};
LW=m3{2,1};
figure
hold on
for I=min(X(1,:))-0.5:0.08:max(X(1,:))+0.5
 for J=min(X(2,:))-0.5:0.08:max(X(2,:))+0.5
 x=[I;J];
 fx=LW*tansig(IW*x+b1)+b2;

 if fx<=0
 %if temp(1)<=m
 plot([I],[J],'g.','linewidth',4);
 else
 plot([I],[J],'b.','linewidth',4);
 end
 end
end
plot(X1(1,:),X1(2,:),'ko','linewidth',4);
plot(X2(1,:),X2(2,:),'k*','linewidth',4);
toc