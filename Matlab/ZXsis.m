T=100;
Bian=50; %���д���
N=length(A);      %��N����
Index=randperm(N,1);%���ȡ1-N֮���һ������
s=zeros(N,T);       %��¼�ڵ�״̬S̬Ϊ0,I̬Ϊ1
s(Index,1)=1;       %��ʼI̬λ��      
gamma=0.5;         %�ָ���
aver_ki=zeros(1,T);
aver_ks=zeros(1,T);
ever_ki=zeros(Bian,T);
ever_ks=zeros(Bian,T);
lamda=0.15;         %��Ⱦ��

    for z=1:Bian
        for t=1:T-1         %��1��T-1ʱ�̴���,���������Tʱ��
            s(:,t+1)=s(:,t);
            for i=1:N
                if s(i,t)==0  %���tʱ�̵�i���ڵ㴦��S̬
                    k=0;      %�ýڵ���Χ�д���I̬�Ľڵ����/���߸���,��ʼΪ0
                    Adjac=find(A(i,:)==1); %��ѯ��i���ж��ٸ�����Ԫ��,���ýڵ���Χ�ж��ٸ�����I̬�Ľڵ�,������λ�õ�������
                    mun_Adjac=length(Adjac); %ͳ����Щ����Ԫ�صĸ���
                    for g=1:mun_Adjac
                        if s(Adjac(g),t)==1 %���ĳ������Ԫ�ش���I̬,��k+1
                            k=k+1;
                        end
                    end
                    p_lamda=1-(1-lamda)^k; %�ýڵ��ΪI̬�ĸ���Ϊ1-(1-lamda)^k
                    p1=rand(1,1); %�������һ��0��1����
                    if p1<p_lamda
                        s(i,t+1)=1;
                    end
                elseif s(i,t)==1  %���tʱ�̵�i���ڵ㴦��I̬
                    p2=rand(1,1); 
                    if p2<gamma
                        s(i,t+1)=0;
                    end
                end
            end
        end %һ�������Ĵ�������
        for k2=1:T
            ever_ki(z,k2)=length(find(s(:,k2)==1));
            ever_ks(z,k2)=length(find(s(:,k2)==0));
        end
    end
    aver_ki=sum(ever_ki)./Bian;
    aver_ks=sum(ever_ks)./Bian;
 plot(aver_ki./N);    



