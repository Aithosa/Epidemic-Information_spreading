% function [ic_capable] = ic(A, active_rounds = 50, Gamma = 0.4)

% ----------程序算法----------
% 独立级联模型的算法如下：
% 1．初始的活跃节点集合A。
% 2．在t时刻，新近被激活的节点u对它的邻接节点v产生影响，成功的概率为p。若v有多个邻居节点都是新近被激活的节点，那么这些节点将以任意顺序尝试激活节点v。
% 3．如果节点v被激活成功，那么在t+1时刻，节点v转为活跃状态，将对其邻接非活跃节点产生影响；否则，节点v在t+1时刻状态不发生变化。
% 4．该过程不断进行重复，直到网络中不存在有影响力的活跃节点时，传播过程结束。

% 这个程序可能有问题，画出的图纵坐标标度不像是比例, 应该是传播不动了

% ----------清理变量----------
clearvars -except A;

% ----------参数设置----------
% Bian = 50;    % 循环次数
% T = 40;    % 感染步数
active_rounds = 50;    % 活跃步数，类似于时间步数
Gamma = 0.4;    % 感染率
% forget_index = ; % 遗忘概率，可以是恢复概率那样，也可以是个遗忘曲线那样下降

% ----------初始化----------
N = length(A);    % 网络节点数
ic_capable = zeros(active_rounds, N);    % 存储网络中每个节点的状态

old_set = zeros(1, N);    % n个节点状态的快照
new_set = zeros(1, N);

old_active_t = zeros(1, active_rounds);   % 每步的非活跃感染节点的数量

% ----------
init_p = ceil(rand(1, 1) * N);     % 一开始随机选出一个感染节点

new_set(init_p) = 1;    % 随机初始化一个节点使其处于感染态，当前可感染状态节点的快照

% ----------
% while((length(active_nodes) ~= prev_length) && length(active_nodes) ~= size(G.Nodes, 1) )
for steps = 1:active_rounds
    
    active_node = find((new_set(:) == 1));    % 找到有传播力的节点的位置
    len_active_node = length(active_node);    % 统计有传播力节点的数量

    if len_active_node > 0    % 如果还有节点具有传播能力

        for i = 1:len_active_node    % 遍历这些具有传染力的节点
        	% 两次筛选，第一次筛选可被感染的节点；第二次再基础上筛选从未失效过的
            i_nebor = find(A(active_node(i), :) == 1);    % 找到第i个有传染力节点的邻居
            victim = setdiff(i_nebor, active_node);    % 返回i_nebor有而active_node没有的邻居，应是排除已经感染的邻居

            old_active_node = find((old_set(:) == 1));    % 找到已经失效的节点
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
            new_set(active_node(i)) = 0;    % 节点i传染过之后失效
            old_set(active_node(i)) = 1;    % 节点i放入历史
        end
    end

    % 统计每一步的激活节点变化
    len_old_set = length(find(old_set));    % 计算这一步非活跃的已感染节点数/上一步已经感染的节点
    old_active_t(steps) = len_old_set;

    ic_capable(steps,:) = old_set;    % 
    % ic_capable(steps, :) = old_set + new_set;    % 
    % ic_capable(steps,:) = old_set;    % 

end

% ----------数据可视化----------
t = (1 : 1 : active_rounds);   % 
% y = zeros(1, active_rounds);
% for t = 1:active_rounds
%     y(t) = sum(ic_capable(t,:)) ./ N;
% end
% t1 = linspace(1,50,50)
plot(t, old_active_t./N, '-o', 'color', 'k', 'linewidth', 1.2);
hold on;
xlabel('t');ylabel('midu');   % 坐标轴解释
legend('I(t)','S(t)');    % 待修改
hold off；

% end