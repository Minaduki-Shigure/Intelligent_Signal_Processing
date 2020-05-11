function [K,time]=monkey()
    tic
    Namef='Schaffer6';
    dim=2;
    temp=[-100,100];
    Rx=repmat(temp,dim,1);
    popsiz=20;%dim.*40;
    generation=1000;
    %??????¡Á?????
    temp=Rx(:,2)-Rx(:,1);
    MRx=[-temp/20,temp/20];
    Mgeneration=10;
    IntervalM=1;%10
    Mpopsiz=20;
    lemda=4;
    lemda1=2;
    %Initialization
    for k=1:dim
        X(k,:)=Rx(k,1)+(Rx(k,2)-Rx(k,1))*rand(1,popsiz);
    end
    Y=target(X,Namef);
    Z=[X;Y];
    Z=sortrows(Z',dim+1); %?????¨®???¨°
    Z=Z';
    X=Z(1:dim,:);%after sorting
    Y=Z(dim+1,:);
    Lr=1;
    Lrb=popsiz-Lr;
    for k=1:dim
        R(k,:)=Rx(k,1)+(Rx(k,2)-Rx(k,1))*rand(1,Lrb);
    end
    X=[X(:,1:popsiz-Lrb),R];
    Y=target(X,Namef);
    Z=[X;Y];
    Z=sortrows(Z',dim+1);
    Z=Z';
    X=Z(1:dim,:);%after sorting
    Y=Z(dim+1,:);
    for i=1:generation
        for k=Lr+1:popsiz;
            for J=1:dim;
                temp=0; %xx=1;
                while 0<1; 
                    temp=X(J,1)-0.5*lemda*(X(J,1)-X(J,k-Lr+1))+rand*lemda*(X(J,1)-X(J,k-Lr+1));
                    %temp=X(J,1)+(-0.25+1.5*rand)*(X(J,k-Lr+1)-X(J,1));
                    if (temp>=Rx(J,1))&(temp<=Rx(J,2)),break,end
                    %xx=xx+1;
                end
                X(J,k)=temp;
            end
        end
        Y=target(X,Namef);
        %Y=penalty(X,Y,Rx,pan);
        Z=[X;Y];
        Z=sortrows(Z',dim+1);
        Z=Z';
        X=Z(1:dim,:);%after sorting
        Y=Z(dim+1,:);

        for k=1:dim
            R(k,:)=Rx(k,1)+(Rx(k,2)-Rx(k,1))*rand(1,Lrb);
        end
        X=[X(:,1:popsiz-Lrb),R];
        Y=target(X,Namef);
        %Y=penalty(X,Y,Rx,pan);
        Z=[X;Y];
        Z=sortrows(Z',dim+1);
        Z=Z';
        X=Z(1:dim,:);
        Y=Z(dim+1,:);

        %????¡¤¡§??¡Á?
        if rem(generation,IntervalM)==0;
            Z=MGAMonkey(Z,Namef,dim,Rx,MRx,Mpopsiz,Mgeneration,lemda1);
            X=Z(1:dim,:);
            Y=Z(dim+1,:);
        end
        i
        Z(1:dim,1);
        Z(dim+1,1)

        if Z(dim+1,1)<10^(-8)
            break
        end
    end
    Zoptim=Z(:,1);
    K=i
    time=toc
end

function Z=MGAMonkey(Z,Namef,dim,Rx,MRx,Mpopsiz,Mgeneration,lemda);
    %Initialization
    X1=Z(1:dim,1);
    Xc=repmat(X1,1,Mpopsiz);
    for k=2:Mpopsiz;
        for J=1:dim;
            temp=0;
            while 0<1;
                temp=X1(J,1)+MRx(J,1)+(MRx(J,2)-MRx(J,1)).*rand(1,1);
                if (temp>=Rx(J,1))&(temp<=Rx(J,2)),break,end
            end
            Xc(J,k)=temp;
        end
    end
    Yc=target(Xc,Namef);
    Zc=[Xc;Yc];
    Zc=[Zc,Z(:,1)];%Mpopsiz
    Zc=sortrows(Zc',dim+1);
    Zc=Zc';
    Xc=Zc(1:dim,:);;%Mpopsiz
    Yc=Zc(dim+1,:);;%Mpopsiz
    for i=1:Mgeneration
        for k=2:Mpopsiz;
            for J=1:dim;
                temp=0;xx=0;
                while 0<1;
                    temp=Xc(J,1)-0.5*lemda*(Xc(J,1)-Xc(J,k))+rand*lemda*(Xc(J,1)-Xc(J,k));
                    if(temp>=(Xc(J,1)+MRx(J,1)))&(temp<=(Xc(J,1)+MRx(J,2)))&(temp>=Rx(J,1))&(temp<=Rx(J,2)),break,end
                    xx=xx+1;
                    if xx>10 break, end
                end
                if xx<=10,
                    Xc(J,k)=temp;
                end
            end
        end
        Yc=target(Xc,Namef);
        Zc=[Xc;Yc];
        Zc=sortrows(Zc',dim+1);
        Zc=Zc';
        Xc=Zc(1:dim,:);%after sorting
        Yc=Zc(dim+1,:);
    end
    Z(:,1)=Zc(:,1);
end

function Y=target(X,Namef);
    popsiz=size(X,2);
    Z=zeros(1,popsiz);
    for k=1:popsiz;
        Z(k)=feval(Namef,X(:,k));
    end
    Y=Z;
end

function y=Schaffer6(x)
    yup=sin(sqrt(sum(x.^2)));
    yup=yup^2-0.5;
    ydown=[sum(x.^2)*0.001+1.0].^2;
    y=yup/ydown+0.5;
end