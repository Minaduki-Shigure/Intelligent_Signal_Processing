function [K,time]=basic()
    clear;tic
    Namef='Schaffer6';
    %Namef='DeJong2';
    N=2;
    for k=1:N;
        RX(k,:)=[-100,100];
        %RX(k,:)=[-2.048,2.048];
    end
    
    Popsize=1000;
    %E=0.51;
    Ps=(Popsize:-1:1);
    %Ps=1:Popsize
    Ps=Ps/sum(Ps);
    Ps=cumsum(Ps);
    Pc=0.8;
    Pm=0.9;
    Generation=10000;
    Lvalue=9*10^(-3);
    [Z,Zg]=initialize(Namef,N,RX,Popsize); %Z:(N+1)xpopsize
    K=0;
    while Zg(N+1,1)>Lvalue & K<Generation;
        %Z=selection(Z,E,Zg)
        Z=selection1(Z,Ps,Zg);
        [Z,Zg]=crossover(Z,Pc,Namef,Zg);
        [Z,Zg]=mutation(Z,Pm,Namef,RX,Zg);
        K=K+1
        Zg(:,1)
    end
    
    K
    Zg(:,1)
    time=toc
end

function [Z,Zg]=initialize(Namef,N,RX,Popsize);
    X=zeros(N,Popsize);
    for k=1:N;
        X(k,:)=RX(k,1)+(RX(k,2)-RX(k,1))*rand(1,Popsize);
    end
    Y=zeros(1,Popsize);
    for k=1:Popsize;
        Y(k)=feval(Namef,X(:,k));
    end
    Z=[X;Y];
    Z=sortrows(Z',3);
    Z=Z';
    Zg=Z(:,1);
end

function Z=selection1(Z,Ps,Zg);
    Popsize=size(Z,2);
    N=size(Z,1)-1;
    Ztemp=zeros(N+1,Popsize);
    for k=1:Popsize-1;
        n=rand(1,1);
        ps=Ps-n;
        I=find(ps>=0);
        I=I(1);
        Ztemp(:,k)=Z(:,I);
        k;
        end
    Ztemp(:,Popsize)=Zg;
    Z=Ztemp;
end

function [Z,Zg]=crossover(Z,Pc,Namef,Zg)
    Popsize=size(Z,2);
    N=size(Z,1)-1;
    Ztemp=zeros(N+1,Popsize);
    for k=1:Popsize/2
        nn=ceil(Popsize*rand(1,2));
        n=rand(1,1);
        if n<=Pc
            r=-0.25+1.5*rand(N,1);
            Ztemp(1:N,2*k-1)=Z(1:N,nn(1))+r.*(Z(1:N,nn(2))-Z(1:N,nn(1)));
            r=-0.25+1.5*rand(N,1);
            Ztemp(1:N,2*k)=Z(1:N,nn(1))+r.*(Z(1:N,nn(2))-Z(1:N,nn(1)));
            Ztemp(N+1,2*k-1)=feval(Namef,Ztemp(1:N,2*k-1));
            Ztemp(N+1,2*k)=feval(Namef,Ztemp(1:N,2*k));
        else
            Ztemp(1:N,2*k-1)=Z(1:N,nn(1));
            Ztemp(1:N,2*k)=Z(1:N,nn(2));
            Ztemp(N+1,2*k-1)=Z(N+1,nn(1));
            Ztemp(N+1,2*k)=Z(N+1,nn(2));
        end
    end
    Z=Ztemp;
    Z=sortrows(Z',3);
    Z=Z';
    if Z(N+1,1)<Zg(N+1,1)
        Zg=Z(:,1);
    end
end

function [Z,Zg]=mutation(Z,Pm,Namef,RX,Zg);
    Popsize=size(Z,2);
    N=size(Z,1)-1;
    Ztemp=zeros(N+1,Popsize);
    for k=1:Popsize;
        for J=1:N
            n=rand(1,1);
            if n<=Pm;
                Ztemp(J,k)=RX(J,1)+(RX(J,2)-RX(J,1)).*rand(1,1);
            else
                Ztemp(J,k)=Z(J,k);
            end
        end
        Ztemp(N+1,k)=feval(Namef,Ztemp(1:N,k));
    end
    Z=Ztemp;
    Z=sortrows(Z',3);
    Z=Z';
    if Z(N+1,1)<Zg(N+1,1);
        Zg=Z(:,1);
    end
end

function y=Schaffer6(x)
    yup=sin(sqrt(sum(x.^2)));
    yup=yup^2-0.5;
    ydown=[sum(x.^2)*0.001+1.0].^2;
    y=yup/ydown+0.5;
end

function y=DeJong2(x)
    y=100*(x(1)^2-x(2))^2+(1-x(1))^2;
end