% function [Nodes_SIS] = SIS(A, T = 50, rate = 0.001, u = 0.02)

% ----------清空变量,但保留邻接矩阵----------
% clear;clc;clf;
clear T rate u N Nodes_SIS p I S t i k1 v1 x1 x2 j t1;

% ----------加载数据----------
% load BC;    % 加载邻接矩阵A

% ----------自定义参数----------
T = 100;    % 时间步数
loop = 50;    % 用于平滑数据的循环
rate = 0.15;     % 感染概率
u = 0.5;    % 恢复概率

% ----------初始化----------
N = length(A);    % 网络节点数

% 每一个循环两个状态的节点数量的比例
I = zeros(T+1, loop);    % 每个loop平均后的值 健康群体
S = zeros(T+1, loop);    % 每个loop平均后的值 感染群体

infected = zeros(T+1, 1);
healthy = zeros(T+1, 1); 

% Nodes_SIS = zeros(T+1, N);   % N行代表时间步数,T列代表节点数,矩阵的每一行展示每个时间步所有节点的状态快照

% p = round(rand * N);    % 初始感染节点的位置;rand返回0-1之间的一个数字(比例位置),round()四舍五入
% Nodes_SIS(1, p) = 1;    % 第一步标出初始感染节点的位置

% ----------loop平滑循环---------
for l = 1 : loop

    % 初始化状态存储
    Nodes_SIS = zeros(T+1, N);

    p = round(rand * N);
    Nodes_SIS(1, p) = 1; 

    I(1, l) = length(find(Nodes_SIS(1, :) == 1))/N;
    S(1, l) = length(find(Nodes_SIS(1, :) == 0))/N;

% ----------开始感染循环----------
    for t = 2 : T+1     % 保证按照设定的T步

        Nodes_SIS(t, :) = Nodes_SIS(t-1, :);    % 先从上一个状态获取快照

        % 感染和康复的过程会有冲突吗
        for i = 1 : N    % 考察遍每一个节点

            % 本段求出一个健康节点可能被感染的情况k1
            if Nodes_SIS(t-1, i) == 0    % 0代表易感(S),如果上一步节点i健康,就看他的邻居有没有被感染的

                k1 = 0;     % 用于记录已感染邻居节点个数
                for j = 1:N
                    if A(i, j) == 1 && Nodes_SIS(t-1, j) == 1    % 如果从邻接矩阵看出是邻居，且上一步是S状态
                        k1 = k1 + 1;   % 已感染邻居节点数的累加
                    end
                end

                % 求出感染概率
                v1 = 1 - (1 - rate) ^ k1;   % 感染概率，为什么这样算？
                x1 = rand;    % 感染阈值
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

        % 计算上一个时间步两种节点的比例？这里不会少算一次吗？最后一次T+1没算入，存的1-T步的
        % 也可以把length换成sum(不行)
        I(t, l) = length(find(Nodes_SIS(t, :) == 1))/N;
        S(t, l) = length(find(Nodes_SIS(t, :) == 0))/N;
    end

    infected = sum(I, 2)/loop;
    healthy = sum(I, 2)/loop; 
end
% ----------处理数据----------
t1 = (1 : 1 : T);   % t1(1,50)且是线性增加
% t1 = linspace(1,T,T)
plot(t1,infected(t1),'-o','color','k','linewidth',1.2);
hold on;
plot(t1,healthy(t1),'-o','color','b','linewidth',1.2);
hold on;

xlabel('时间');ylabel('节点状态密度');   % 坐标轴解释
legend('I(t)','S(t)');
hold off;

% end
