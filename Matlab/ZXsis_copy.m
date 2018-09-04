% ----------参数设置----------
T=100;    % time steps
Bian=50;    % 运行次数,loop

gamma=0.5;         % 恢复率
lamda=0.15;         %感染率

% ----------信息存储----------
N=length(A);      % 节点个数
s=zeros(N,T);       % 记录节点状态，S态为0,I态为1

% ----------初始设置----------
Index=randperm(N,1);    % 随机取1-N之间的一个整数
s(Index,1)=1;       % 初始I态位置      

% ----------统计----------
aver_ki=zeros(1,T);
aver_ks=zeros(1,T);
ever_ki=zeros(Bian,T);
ever_ks=zeros(Bian,T);

% ----------loop，time----------
for z=1:Bian
	% time
    for t=1:T-1         %在1到T-1时刻传播,结果保存在T时刻
        s(:,t+1)=s(:,t);    % 每一列是时间，记录每一个时间步
        % nodes
        for i=1:N
        	% 感染阶段，节点i
            if s(i,t)==0  % 如果t时刻第i个节点处于S态
                k=0;      % 该节点周围有处于I态的节点个数/连边个数,初始为0
                Adjac=find(A(i,:)==1); % 查询第i行有多少个非零元素,即该节点周围有多少个处于I态的节点,返回其位置的列向量（邻居真值）
                mun_Adjac=length(Adjac); % 统计这些非零元素的个数（邻居数量）
                for g=1:mun_Adjac
                    if s(Adjac(g),t)==1 %如果某个非零元素处于I态,则k+1（邻居是感染的）
                        k=k+1; % 统计感染邻居数量
                    end
                end
                % 计算感染与否
                p_lamda=1-(1-lamda)^k; %该节点变为I态的概率为1-(1-lamda)^k
                p1=rand(1,1); %随机产生一个0到1的数
                if p1<p_lamda
                    s(i,t+1)=1;
                end
            % 康复阶段，节点i
            elseif s(i,t)==1  %如果t时刻第i个节点处于I态
                p2=rand(1,1); 
                if p2<gamma
                    s(i,t+1)=0;
                end
            end
        end
    end %一次完整的传播结束
    % 每行一个loop，每列是时间步（每个loop，每个时间两种节点个数）
    for k2=1:T
        ever_ki(z,k2)=length(find(s(:,k2)==1));
        ever_ks(z,k2)=length(find(s(:,k2)==0));
    end
end

% ----------数据平滑处理----------
% 每个时间步的平均值
aver_ki=sum(ever_ki)./Bian;
aver_ks=sum(ever_ks)./Bian;

% ----------画图----------
plot(aver_ki./N, '-o', 'color', 'k', 'linewidth',1.2);    
xlabel('时间');ylabel('节点状态密度');   % 坐标轴解释
legend('I(t)');
hold off;


