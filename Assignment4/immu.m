function [K, time] = immu();
% ԭʼ�������ԡ������Ż��㷨����2�棩����demo
    %%%%%%%%%%%%%%%%%�����㷨������ֵ%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%��ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%
    clear all;                                %������б���
    clc;                                      %����
    D=2;                                      %���߸���ά��
    NP=1000;                                    %���߸�����Ŀ
    Xs=100;                                     %ȡֵ����
    Xx=-100;                                    %ȡֵ����
    G=10000;                                    %������ߴ���
    pm=0.9;                                   %�������
    alpha=2;                                   %������ϵ��
    beta=1;                                  %������ϵ��   
    detas=1*10^(-5);                                %���ƶ���ֵ
    gen=0;                                    %���ߴ���
    Ncl=5;                                    %��¡����
    deta0=0.5*Xs;                             %����Χ��ֵ
    tic;
    %%%%%%%%%%%%%%%%%%%%%%%��ʼ��Ⱥ%%%%%%%%%%%%%%%%%%%%%%%%
    f=rand(D,NP)*(Xs-Xx)+Xx;
    for np=1:NP
        MSLL(np)=func(f(:,np));
    end
    %%%%%%%%%%%%%%%%%�������Ũ�Ⱥͼ�����%%%%%%%%%%%%%%%%%%%
    for np=1:NP
        for j=1:NP     
            nd(j)=sum(sqrt((f(:,np)-f(:,j)).^2));
            if nd(j)<detas
                nd(j)=1;
            else
                nd(j)=0;
            end
        end
        ND(np)=sum(nd)/NP;
    end
    MSLL =  alpha*MSLL- beta*ND;
    %%%%%%%%%%%%%%%%%%%�����Ȱ���������%%%%%%%%%%%%%%%%%%%%%%
    [SortMSLL,Index]=sort(MSLL);
    Sortf=f(:,Index);
    %%%%%%%%%%%%%%%%%%%%%%%%����ѭ��%%%%%%%%%%%%%%%%%%%%%%%%
    while gen<G
        for i=1:NP/2
            %%%%%%%%ѡ������ǰNP/2����������߲���%%%%%%%%%%%
            a=Sortf(:,i);
            Na=repmat(a,1,Ncl);
            deta=deta0/gen;
            for j=1:Ncl
                for ii=1:D
                    %%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%
                    if rand<pm
                        Na(ii,j)=Na(ii,j)+(rand-0.5)*deta;
                    end
                    %%%%%%%%%%%%%%�߽���������%%%%%%%%%%%%%%%
                    if (Na(ii,j)>Xs)  |  (Na(ii,j)<Xx)
                        Na(ii,j)=rand * (Xs-Xx)+Xx;
                    end
                end
            end
            Na(:,1)=Sortf(:,i);               %������¡Դ����
            %%%%%%%%%%��¡���ƣ������׺Ͷ���ߵĸ���%%%%%%%%%%
            for j=1:Ncl
                NaMSLL(j)=func(Na(:,j));
            end
            [NaSortMSLL,Index]=sort(NaMSLL);
            aMSLL(i)=NaSortMSLL(1);
            NaSortf=Na(:,Index);
            af(:,i)=NaSortf(:,1);
        end 
        %%%%%%%%%%%%%%%%%%%%������Ⱥ������%%%%%%%%%%%%%%%%%%%
        for np=1:NP/2
            for j=1:NP/2
                nda(j)=sum(sqrt((af(:,np)-af(:,j)).^2));         
                if nda(j)<detas
                    nda(j)=1;
                else
                    nda(j)=0;
                end
            end
            aND(np)=sum(nda)/NP/2;
        end
        aMSLL =  alpha*aMSLL-  beta*aND;
        %%%%%%%%%%%%%%%%%%%%%%%��Ⱥˢ��%%%%%%%%%%%%%%%%%%%%%%%
        bf=rand(D,NP/2)*(Xs-Xx)+Xx;
        for np=1:NP/2
            bMSLL(np)=func(bf(:,np));
        end
        %%%%%%%%%%%%%%%%%%%��������Ⱥ������%%%%%%%%%%%%%%%%%%%%
        for np=1:NP/2
            for j=1:NP/2
                ndc(j)=sum(sqrt((bf(:,np)-bf(:,j)).^2));
                if ndc(j)<detas
                    ndc(j)=1;
                else
                    ndc(j)=0;
                end
            end
            bND(np)=sum(ndc)/NP/2;
        end
        bMSLL =  alpha*bMSLL-  beta*bND;
        %%%%%%%%%%%%%%������Ⱥ��������Ⱥ�ϲ�%%%%%%%%%%%%%%%%%%%
        f1=[af,bf];
        MSLL1=[aMSLL,bMSLL];
        [SortMSLL,Index]=sort(MSLL1);
        Sortf=f1(:,Index);
        gen=gen+1;
        trace(gen)=func(Sortf(:,1));
        
        if trace(end) < detas
            break;
        end
    end
    K = gen
    time = toc
    Bestf=Sortf(:,1)                 %���ű���
    trace(end)                       %����ֵ
end

function y=func(x)
    yup=sin(sqrt(sum(x.^2)));
    yup=yup^2-0.5;
    ydown=[sum(x.^2)*0.001+1.0].^2;
    y=yup/ydown+0.5;
end