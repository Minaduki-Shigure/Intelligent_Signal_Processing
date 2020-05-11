function [K, time] = immu();
% 原始代码来自《智能优化算法（第2版）》的demo
    %%%%%%%%%%%%%%%%%免疫算法求函数极值%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%初始化%%%%%%%%%%%%%%%%%%%%%%%%%
    clear all;                                %清除所有变量
    clc;                                      %清屏
    D=2;                                      %免疫个体维数
    NP=1000;                                    %免疫个体数目
    Xs=100;                                     %取值上限
    Xx=-100;                                    %取值下限
    G=10000;                                    %最大免疫代数
    pm=0.9;                                   %变异概率
    alpha=2;                                   %激励度系数
    beta=1;                                  %激励度系数   
    detas=1*10^(-5);                                %相似度阈值
    gen=0;                                    %免疫代数
    Ncl=5;                                    %克隆个数
    deta0=0.5*Xs;                             %邻域范围初值
    tic;
    %%%%%%%%%%%%%%%%%%%%%%%初始种群%%%%%%%%%%%%%%%%%%%%%%%%
    f=rand(D,NP)*(Xs-Xx)+Xx;
    for np=1:NP
        MSLL(np)=func(f(:,np));
    end
    %%%%%%%%%%%%%%%%%计算个体浓度和激励度%%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%激励度按升序排列%%%%%%%%%%%%%%%%%%%%%%
    [SortMSLL,Index]=sort(MSLL);
    Sortf=f(:,Index);
    %%%%%%%%%%%%%%%%%%%%%%%%免疫循环%%%%%%%%%%%%%%%%%%%%%%%%
    while gen<G
        for i=1:NP/2
            %%%%%%%%选激励度前NP/2个体进行免疫操作%%%%%%%%%%%
            a=Sortf(:,i);
            Na=repmat(a,1,Ncl);
            deta=deta0/gen;
            for j=1:Ncl
                for ii=1:D
                    %%%%%%%%%%%%%%%%%变异%%%%%%%%%%%%%%%%%%%
                    if rand<pm
                        Na(ii,j)=Na(ii,j)+(rand-0.5)*deta;
                    end
                    %%%%%%%%%%%%%%边界条件处理%%%%%%%%%%%%%%%
                    if (Na(ii,j)>Xs)  |  (Na(ii,j)<Xx)
                        Na(ii,j)=rand * (Xs-Xx)+Xx;
                    end
                end
            end
            Na(:,1)=Sortf(:,i);               %保留克隆源个体
            %%%%%%%%%%克隆抑制，保留亲和度最高的个体%%%%%%%%%%
            for j=1:Ncl
                NaMSLL(j)=func(Na(:,j));
            end
            [NaSortMSLL,Index]=sort(NaMSLL);
            aMSLL(i)=NaSortMSLL(1);
            NaSortf=Na(:,Index);
            af(:,i)=NaSortf(:,1);
        end 
        %%%%%%%%%%%%%%%%%%%%免疫种群激励度%%%%%%%%%%%%%%%%%%%
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
        %%%%%%%%%%%%%%%%%%%%%%%种群刷新%%%%%%%%%%%%%%%%%%%%%%%
        bf=rand(D,NP/2)*(Xs-Xx)+Xx;
        for np=1:NP/2
            bMSLL(np)=func(bf(:,np));
        end
        %%%%%%%%%%%%%%%%%%%新生成种群激励度%%%%%%%%%%%%%%%%%%%%
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
        %%%%%%%%%%%%%%免疫种群与新生种群合并%%%%%%%%%%%%%%%%%%%
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
    Bestf=Sortf(:,1)                 %最优变量
    trace(end)                       %最优值
end

function y=func(x)
    yup=sin(sqrt(sum(x.^2)));
    yup=yup^2-0.5;
    ydown=[sum(x.^2)*0.001+1.0].^2;
    y=yup/ydown+0.5;
end