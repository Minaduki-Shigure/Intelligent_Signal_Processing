function [K,time]=niche()
    %Namefun:function name, a string
    %N:the number of variables
    %X0/X:is a matrix; each column is an individual
    %RX: a matrix(Nx2), each row is a range of a variable
    %D:divition parameter of the population.The greater D,the more variation
    %C:indicating the degree of decreasing the range.The larger C, the larger the degree;
    % determining the variation quantity of an individual.
    %GLocal1: generations evoluting in local area, for the better individuals.
    %GLocal2: generations evoluting in local area, for the random generated individuals.
    clear;tic
    %%%%%%%%%%%%%%%%%%%%%%%%%
    Namefun='Schaffer6(x)';
    N=2; %number of variables;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    RX=zeros(N,2);
    for k=1:N;
        RX(k,:)=[-100,100];
    end
    Generation=100;popsize=100;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    [X0,ValueOptimized]=init(Namefun,N,RX,popsize);
    X=X0;
    D=2;C=20;GLocal1=4;GLocal2=16;
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    for J=1:Generation
        %pause(0.0000005);
        a=ceil(popsize/D);%1<=D<=popsize
        tempX1=X(:,1:a);
        tempX1=evolutionLocal(Namefun,N,tempX1,RX,a,C,GLocal1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        b=popsize-a;
        if b>0
            tempX2=zeros(N,b);
            Range=zeros(N,b);
            tempR=RX(:,2)-RX(:,1);
            Range=tempR(:,ones(1,b));
            Rang0=zeros(N,b);
            tempR1=RX(:,1);
            Rang0=tempR1(:,ones(1,b));
            tempX2=Range.*rand(N,b)+Rang0; %initializing every variable
            tempX2=evolutionLocal(Namefun,N,tempX2,RX,b,C,GLocal2);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tempX=zeros(N,2*popsize);
        tempX=[tempX1,tempX2,X0];
        f=inline(Namefun);
        Y=zeros(1,2*popsize);
        for II=1:2*popsize;
            Y(II)=f(tempX(:,II));
        end
        [Y,I]=sort(Y); %sort in ascending order
        J
        ValueOptimized=Y(1)
        X=zeros(N,popsize);
        X=tempX(:,I(1:popsize));
        if abs(ValueOptimized)<9*10^(-3)|J==Generation;%10^(-6) %| (J==Generation) %10^(-10);
            J
            X(:,1)
            ValueOptimized
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K=J
    time=toc
end

function [X,ValueOptimized]=init(Namefun,N,RX,popsize)
    %N:the number of variables
    f=inline(Namefun); %function of variables
    X=zeros(N,popsize);
    Range=zeros(N,popsize);
    tempR=RX(:,2)-RX(:,1);
    Range=tempR(:,ones(1,popsize));
    Rang0=zeros(N,popsize);
    tempR1=RX(:,1);
    Rang0=tempR1(:,ones(1,popsize));
    X=Range.*rand(N,popsize)+Rang0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Y=zeros(1,popsize);
    for J=1:popsize; %functions for initial points
        Y(J)=f(X(:,J));
    end
    [Y,I]=sort(Y); %sort in ascending order
    ValueOptimized=Y(1);
    X=X(:,I(1:popsize)); %sorting
end

function X=evolutionLocal(Namefun,N,X0,RX,popsize,C,GLocal)
    f=inline(Namefun);
    for NL=1:GLocal
        X=zeros(N,popsize);
        tempR=RX(:,2)-RX(:,1);
        Range=tempR(:,ones(1,popsize));
        temp=Range.*(rand(N,popsize)-0.5)/C;
        X=X0+temp;
        tempX=zeros(N,2*popsize);
        tempX=[X0,X];
        X=tempX;
        Y=zeros(1,2*popsize);
        for J=1:2*popsize;
            Y(J)=f(X(:,J));
        end
        %comparing the new point and its old one
        I0=find(Y(1:popsize)<=Y(popsize+1:2*popsize));
        I1=popsize+find(Y(popsize+1:2*popsize)<Y(1:popsize));
        I=[I0,I1];
        tempX=zeros(N,popsize);
        tempX=X(:,I); %the number of the kth variable values is popsize
        X0=tempX;
    end
    X=X0;
end