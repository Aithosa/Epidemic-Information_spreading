% clear all;
% load BA;
clearvars -except A;

% ---------- SIS自定义参数 ----------
T = 100;    % 时间步数
active_rounds = T;    % 

rate = 0.01;     % 感染概率
u = 0.02;    % 恢复概率

N = length(A);    % 网络节点数
Nodes_SIS = zeros(T, N);   % N行代表时间步数，T列代表节点数，展示每一步所有节点的状态快照
% Nodes_SIS_init = zeros(1, N);

p = ceil(rand(1, 1) * N);    % 一开始随机选出一个感染节点
% p = round(rand * N);    % 初始感染节点的位置；rand返回0-1之间的一个数字（比例的作用），round()四舍五入
Nodes_SIS(1, p) = 1 ;    % 第一步标出初始感染节点的位置

% 每一步两个状态的节点数量
I = zeros(T, 1);    % 多少bian平均后的值 健康群体
S = zeros(T, 1);    % 多少bian平均后的值 感染群体

% ---------- IC自定义参数 ----------
Gamma = 1;    % 感染率
ic_capable = zeros(active_rounds, N);    % 存储网络中每个节点的传播能力

init_p = p;    % 一开始随机选出一个感染节点

old_set = zeros(1, N);    % n个节点状态的快照
new_set = zeros(1, N);

new_set(init_p) = 1;    % 随机初始化一个节点使其处于感染态，当前可感染状态节点的快照
ic_capable(1, :) = new_set;

old_active_t = zeros(1, active_rounds);   % 每步的非活跃感染节点的数量

% 时间演化
for t = 1 : T     % 

    %%%% IC演化

    active_node = find((new_set(:) == 1));    % 找到有传播力的节点的位置
    len_active_node = length(active_node);    % 统计有传播力节点的数量

    if len_active_node > 0    % 如果还有节点具有传播能力

        for i = 1:len_active_node    % 遍历这些具有传染力的节点
            i_nebor = find(A(active_node(i), :) == 1);    % 找到第i个有传染力节点的邻居
            victim = setdiff(i_nebor, active_node);    % 返回i_nebor有而active_node没有的邻居，应是排除已经感染的邻居

            old_active_node = find((old_set(:) == 1));
            victim_final = setdiff(victim, old_active_node);    % 节点i真正可传染的邻居
            Num_victim_final = length(victim_final);    % 

            for j = 1:Num_victim_final    % 遍历节点i的所有可传播节点
                p1 = rand(1, 1);
                % p2 = 1 / (length(find(A(victim_final(j), :))));
                % p2 = rand(1, 1);
                if p1 <= Gamma
                    new_set(victim_final(j)) = 1;    % 这个节点被感染
                end
            end
            new_set(active_node(i)) = 0;    % 节点i传染过之后失效，new_set目前保存有新感染节点
            old_set(active_node(i)) = 1;    % 节点i放入历史
        end
    end

    ic_capable(t+1, :) = new_set;    % 存放每下一步的活跃节点
    % ic_capable(t, :) = old_set;    % 已经失效的节点总和

    % 统计每一步的激活节点变化
    len_old_set = length(find(old_set == 1));    % 计算这一步已传染过的节点数
    old_active_t(t) = len_old_set;


    %%%% SIS演化
    Nodes_SIS(t+1, :) = Nodes_SIS(t, :);    % 当前状态为上一个状态取的快照

    % 此时Nodes_SIS(t, ：)记录了当前节点状况，传给IC层本次活跃节点
    % new_set = Nodes_SIS(t+1, ：)

    % 
    for i = 1 : N    % 考察遍每一个节点

        rate_temp = rate;

        % 本段求出一个健康节点可能被感染的情况k1
        if Nodes_SIS(t, i) == 0    % 0代表易感(S)，如果上一步节点i健康，就看他的邻居有没有被感染的

            % 如果知晓传染状况，则感染率降低2/3
            if ic_capable(t+1, i) == 1
                rate_temp = rate_temp * 2/3;
            end

            % for j = 1:N
            %     if A(i, j) == 1 & ic_capable(t+1, j) == 1    % 如果从邻接矩阵看出是邻居并且上一步快照看出是S状态
            %         
            %     end
            % end

            k1 = 0;     % 用于记录已感染邻居节点个数
            for j = 1:N
                if A(i, j) == 1 & Nodes_SIS(t, j) == 1    % 如果从邻接矩阵看出是邻居并且上一步快照看出是S状态
                    k1 = k1 + 1;   % 已感染邻居节点数的累加
                end
            end

            % 求出感染概率
            v1 = 1 - (1 - rate_temp) ^ k1;   % 为什么这样算
            % v1 = 1 - (1 - (rate_temp - )) ^ k1;   % 为什么这样算
            x1 = rand;
            if x1 < v1
                Nodes_SIS(t+1, i) = 1;
            end

        % 本段求出一个感染节点康复概率
        elseif Nodes_SIS(t, i) == 1 
            x2 = rand;
            if x2 < u
                Nodes_SIS(t+1, i) = 0;

            end
        end
    end

    new_set = Nodes_SIS(t+1, :);    % 把下一步的感染状况传给活IC下一时刻的跃节点

    % 计算上一个时间步两种节点的比例？这里不会少算一次吗？最后一次T+1没算入
    % 也可以把length换成sum
    I(t) = length(find(Nodes_SIS(t, :) == 1))/N;
    S(t) = length(find(Nodes_SIS(t, :) == 0))/N;
    
end

% SIS统计
t1 = (1 : 1 : T);   % t1(1,50)且是线性增加
% t1 = linspace(1,50,50)
plot(t1,I(t1),'-o','color','k','linewidth',1.2);
hold on;
plot(t1,S(t1),'-o','color','b','linewidth',1.2);
hold on;

% IC统计
% t = (1 : 1 : active_rounds);   % 
% t1 = linspace(1,50,50)
plot(t1,old_active_t./N,'-x','color','r','linewidth',1.2);    % 画出每一步有传染力的节点比例
% xlabel('t');ylabel('节点密度');   % 
xlabel('t');ylabel('节点密度');   % 坐标轴解释
legend('I(t)','S(t)','IC(t)');
hold off;