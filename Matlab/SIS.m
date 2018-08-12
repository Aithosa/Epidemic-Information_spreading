% function [Nodes_SIS] = SIS(A, T = 50, rate = 0.001, u = 0.02)
    
% clear;clc;clf;
% load BC;    % BC似乎是矩阵或者保存矩阵的东西，矩阵名字是B
clear T rate u N Nodes_SIS p I S t i k1 v1 x1 x2 j t1;
% 自定义参数
T = 50;    % 时间步数
rate = 0.15;     % 感染概率
u = 0.5;    % 恢复概率

N = length(A);    % 网络节点数
Nodes_SIS = zeros(T, N);   % N行代表时间步数，T列代表节点数，展示每一步所有节点的状态快照

p = round(rand * N);    % 初始感染节点的位置；rand返回0-1之间的一个数字（比例的作用），round()四舍五入
Nodes_SIS(1, p) =1 ;    % 第一步标出初始感染节点的位置

% 每一步两个状态的节点数量
I = zeros(T, 1);    % 多少bian平均后的值 健康群体
S = zeros(T, 1);    % 多少bian平均后的值 感染群体

for t = 2 : T+1     % 保证按照设定的T步

    Nodes_SIS(t, :) = Nodes_SIS(t-1, :);    % 给上一个状态取一个快照

    % 这个循环不会造成并行冲突吗？
    for i = 1 : N    % 考察遍每一个节点

        % 本段求出一个健康节点可能被感染的情况k1
        if Nodes_SIS(t-1, i) == 0    % 0代表易感(S)，如果上一步节点i健康，就看他的邻居有没有被感染的

            k1 = 0;     % 用于记录已感染邻居节点个数
            for j = 1:N
                if A(i, j) == 1 && Nodes_SIS(t-1, j) == 1    % 如果从邻接矩阵看出是邻居并且上一步快照看出是S状态
                    k1 = k1 + 1;   % 已感染邻居节点数的累加
                end
            end

            % 求出感染概率
            v1 = 1 - (1 - rate) ^ k1;   % 为什么这样算
            x1 = rand;
            if x1 < v1
                Nodes_SIS(t, i) = 1;
            end

        % 本段求出一个感染节点康复概率
        elseif Nodes_SIS(t-1, i) == 1 
            x2 = rand;
            if x2 < u
                Nodes_SIS(t, i) = 0;
            end
        end
    end

    % 计算上一个时间步两种节点的比例？这里不会少算一次吗？最后一次T+1没算入
    % 也可以把length换成sum(不行)
    I(t-1) = length(find(Nodes_SIS(t-1, :) == 1))/N;
    S(t-1) = length(find(Nodes_SIS(t-1, :) == 0))/N;
end

t1 = (1 : 1 : T);   % t1(1,50)且是线性增加
% t1 = linspace(1,50,50)
plot(t1,I(t1),'-o','color','k','linewidth',1.2);
hold on;
plot(t1,S(t1),'-o','color','b','linewidth',1.2);
hold on;

xlabel('t');ylabel('节点密度');   % 坐标轴解释
legend('I(t)','S(t)');
% end
