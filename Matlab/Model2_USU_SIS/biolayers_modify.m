% ----------加载数据----------
%clearvars -except A;
clear all;
load BA_2000_2;    % 加载邻接矩阵A

% ---------- 公共参数及初始化 ----------
total_steps = 50;    % 总的时间步数
N = length(A);    % 网络节点数
p = round(rand * N);    % 一开始随机选出一个感染节点，四舍五入

% ---------- SIS参数及初始化 ----------
rate = 0.2;     % 感染概率
u = 0.5;    % 恢复概率

Nodes_SIS = zeros(total_steps, N);   % N行代表时间步数，T列代表节点数，展示每一步所有节点的状态快照
Nodes_SIS(1, p) = 1 ;    % 第一步标出初始感染节点的位置

% 每一步两个状态的节点数量
I = zeros(1, total_steps);    % 多少bian平均后的值 健康群体
% S = zeros(1, total_steps);    % 多少bian平均后的值 感染群体

% ---------- IC参数及初始化 ----------
Gamma = 0.3;    % 感染率

ic_capable = zeros(total_steps, N);    % 存储网络中每个节点的状态快照
ic_capable(1, p) = 1;    % 随机初始化一个节点使其处于感染态，当前可感染状态节点的快照

% normal_num = zeros(1, total_steps);    % 每步健康节点的数量
invalid_num = zeros(1, total_steps);   % 每步的失活感染节点的数量
infective_source = zeros(1, total_steps);    % 每步活跃节点数量

% ---------- 时间演化 ----------
for t = 1 : total_steps 

    % ---------- IC演化 ----------

    % 找到可以传播的活跃节点
    active_node = find((ic_capable(t, :) == 1));    % 找到当前有传播力的节点的位置
    len_active_node = length(active_node);    % 统计这一刻有传播力节点的数量
    infective_source(t) = len_active_node;    % 当前活跃节点数量
    
    if len_active_node > 0    % 如果还有节点具有传播能力

        for i = 1:len_active_node    % 遍历这些具有传染力的节点
            i_nebor = find(A(active_node(i), :) == 1);    % 找到第i个有传染力节点的邻居
            victim = setdiff(i_nebor, active_node);    % 返回i_nebor有而active_node没有的邻居，应是排除已经感染的邻居

            old_active_node = find((ic_capable(t, :) == -1));    % 找到已经失效的节点
            victim_final = setdiff(victim, old_active_node);    % 节点i真正可传染的邻居
            % 实际上找的是当前标记为0的节点，可以直接找出和i_nebor比较
            Num_victim_final = length(victim_final);    % 计算这些真正能被传染的节点有多少

            % 感染过程：这些可感染的节点对应第i个传染源，他会轮流感染这些节点
            for j = 1:Num_victim_final    % 遍历节点i的所有可传播节点
                p1 = rand;
                % p2 = 1 / (length(find(A(victim_final(j), :))));
                % p2 = rand(1, 1);
                if p1 <= Gamma
                    ic_capable(t+1, victim_final(j)) = 1;    % 这个节点被感染
                end
            end
            % active_rounds+1 是失活有效期
            ic_capable(t:total_steps+1, active_node(i)) = -1;     % 节点永久失活
        end
    end

    % 统计每一步的激活节点变化
    invalid_num(t) = length(find(ic_capable(t, :) == -1));    % 计算这一步非活跃的已感染节点数/上一步已经感染的节点
    % normal_num(t) = length(find(ic_capable(t, :) == 0));
    

    % ---------- SIS演化 ----------
    % Nodes_SIS(t+1, :) = Nodes_SIS(t, :);    % 下一步的初始状态以当前为基础

    % 此时Nodes_SIS(t, ：)记录了当前节点状况，传给IC层本次活跃节点

    for i = 1 : N    % 考察遍每一个节点

        rate_temp = rate;    % 当前临时感染率

        % ---------- SIS感染过程 ----------
        if Nodes_SIS(t, i) == 0    % 0代表易感(S)，如果上一步节点i健康，就看他的邻居有没有被感染的

            % ---------- SIS感染率改变规则 ----------

            % 这里用的是t+1的状态，因为t时刻的已经完成变化，没有1这个状态了。
            if ic_capable(t+1, i) == 1
                rate_temp = rate_temp * 2/3;    % 如果知晓传染状况，则感染率降低1/3。也可以考虑根据被消息成功传染的次数，成功一次就+1，然后根据最终值决定传染率如何下降
            end

            k1 = 0;     % 用于记录已感染邻居节点个数
            for j = 1:N
                if A(i, j) == 1 && Nodes_SIS(t, j) == 1    % 如果从邻接矩阵看出是邻居并且上一步快照看出是S状态
                    k1 = k1 + 1;   % 已感染邻居节点数的累加
                end
            end

            % 求出感染概率
            v1 = 1 - (1 - rate_temp) ^ k1;   % 为什么这样算
            x1 = rand;
            if x1 < v1
                Nodes_SIS(t+1, i) = 1;

                % 感染的人会成为IC的活跃节点，这句意味着再次成为生病节点会激活之前的永久失活状态
				ic_capable(t+1:total_steps+1, i) = 0;
				ic_capable(t+1, i) = 1;
            end

        % ---------- SIS康复过程 ----------
        elseif Nodes_SIS(t, i) == 1 
            x2 = rand;
            if x2 < u
                Nodes_SIS(t+1, i) = 0;

            end
        end
    end

    I(t) = length(find(Nodes_SIS(t, :) == 1));
    % S(t) = length(find(Nodes_SIS(t, :) == 0));
    
end


% ---------- 数据可视化 ----------
t = (1 : 1 : total_steps);

% SIS统计
plot(t,I(t)./N,'-o','color','y','linewidth',1.2);
hold on;
% plot(t,S(t)./N,'-o','color','b','linewidth',1.2);
% hold on;

% IC统计
plot(t, invalid_num./N, '-o', 'color', 'k', 'linewidth', 1.2);
hold on;
% plot(t, normal_num./N, '-o', 'color', 'r', 'linewidth', 1.2);
% hold on;
xlabel('steps');ylabel('density of nodes');   % 坐标轴解释
legend('SIS_I(t)','IC_I(t)');    % 待修改
hold off;