% ----------��������----------
T=100;    % time steps
Bian=50;    % ���д���,loop

gamma=0.5;         % �ָ���
lamda=0.15;         %��Ⱦ��

% ----------��Ϣ�洢----------
N=length(A);      % �ڵ����
s=zeros(N,T);       % ��¼�ڵ�״̬��S̬Ϊ0,I̬Ϊ1

% ----------��ʼ����----------
Index=randperm(N,1);    % ���ȡ1-N֮���һ������
s(Index,1)=1;       % ��ʼI̬λ��      

% ----------ͳ��----------
aver_ki=zeros(1,T);
aver_ks=zeros(1,T);
ever_ki=zeros(Bian,T);
ever_ks=zeros(Bian,T);

% ----------loop��time----------
for z=1:Bian
	% time
    for t=1:T-1         %��1��T-1ʱ�̴���,���������Tʱ��
        s(:,t+1)=s(:,t);    % ÿһ����ʱ�䣬��¼ÿһ��ʱ�䲽
        % nodes
        for i=1:N
        	% ��Ⱦ�׶Σ��ڵ�i
            if s(i,t)==0  % ���tʱ�̵�i���ڵ㴦��S̬
                k=0;      % �ýڵ���Χ�д���I̬�Ľڵ����/���߸���,��ʼΪ0
                Adjac=find(A(i,:)==1); % ��ѯ��i���ж��ٸ�����Ԫ��,���ýڵ���Χ�ж��ٸ�����I̬�Ľڵ�,������λ�õ����������ھ���ֵ��
                mun_Adjac=length(Adjac); % ͳ����Щ����Ԫ�صĸ������ھ�������
                for g=1:mun_Adjac
                    if s(Adjac(g),t)==1 %���ĳ������Ԫ�ش���I̬,��k+1���ھ��Ǹ�Ⱦ�ģ�
                        k=k+1; % ͳ�Ƹ�Ⱦ�ھ�����
                    end
                end
                % �����Ⱦ���
                p_lamda=1-(1-lamda)^k; %�ýڵ��ΪI̬�ĸ���Ϊ1-(1-lamda)^k
                p1=rand(1,1); %�������һ��0��1����
                if p1<p_lamda
                    s(i,t+1)=1;
                end
            % �����׶Σ��ڵ�i
            elseif s(i,t)==1  %���tʱ�̵�i���ڵ㴦��I̬
                p2=rand(1,1); 
                if p2<gamma
                    s(i,t+1)=0;
                end
            end
        end
    end %һ�������Ĵ�������
    % ÿ��һ��loop��ÿ����ʱ�䲽��ÿ��loop��ÿ��ʱ�����ֽڵ������
    for k2=1:T
        ever_ki(z,k2)=length(find(s(:,k2)==1));
        ever_ks(z,k2)=length(find(s(:,k2)==0));
    end
end

% ----------����ƽ������----------
% ÿ��ʱ�䲽��ƽ��ֵ
aver_ki=sum(ever_ki)./Bian;
aver_ks=sum(ever_ks)./Bian;

% ----------��ͼ----------
plot(aver_ki./N, '-o', 'color', 'k', 'linewidth',1.2);    
xlabel('ʱ��');ylabel('�ڵ�״̬�ܶ�');   % ���������
legend('I(t)');
hold off;


