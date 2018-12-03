% 有两层网络，其邻接矩阵分别为A和B，规模为10^4
% 上层为UAU，传播率是lambda，遗忘率是delta
% 下层是SIS，感染率是bata，恢复率是mu
% 信息上传率是aplha
% 已感染I节点信息遗忘率衰减sigma_forget
% 已知信息S节点感染率衰减sigma_infect
% I节点在知道信息后的传染率衰减sigma_I
% S节点在知道信息后的防御系数sigma_S
% S节点在不知情时接触I节点后知道信息的概率K(是和I节点接触还是分知情与?)-可以暂时不考虑
% I节点在知道信息后的康复加快率sigma_recover

% 本程序根据原论文程序做出修改，力求接近源程序
% 已修复V0版本的问题

% ---------- 加载数据 ----------
% clearvars -except A B;
% clear all;
% load BA_2000_3;   % 加载接触层邻接矩阵A
% load WS_2000_4_03 % 加载信息层邻接矩阵B

% ---------- 公共参数及初始化 ----------
loop = 10;  % 蒙特卡洛模拟次数
% valid_loop = 0;
time_steps = 200;   % 总的时间步数
N = length(A);  % 网络节点数
% p = round(rand * N);  % 初始始随机选出一个感染节点，四舍五入
% p = randi([1 N]);    % randi 生成均匀分布的伪随机整数
% rng(5)

% ---------- 存储容器 ----------
% Node_states = zeros(2, N);    % 记录每个节点的状态，第一行是疾病状态，第二行是信息状态

% Nodes_SIS = zeros(time_steps, N);   % N行代表时间步数，T列代表节点数，记录每步所有节点的状态
% Nodes_UAU = zeros(time_steps, N);   % 存储网络中每个节点的状态快照

infective_count = zeros(loop, time_steps); % 每步感染节点数,用于最终统计
awareness_count = zeros(loop, time_steps); % 每步知晓节点数量,用于最终统计

% ---------- SIS参数及初始化 ----------
bata = 0.5;  % 感染概率
mu = 0.1;   % 恢复概率

% Nodes_SIS(1, p) = 1;    % 第一步标出初始感染节点的位置
% infective_count(1) = 1;    % 也可以等到循环结束了再追加一次

% ---------- UAU参数及初始化 ----------
lambda = 0.6;   % 传播率
delta = 0.1;    % 遗忘率

% Nodes_UAU(1, p) = 1;    % 随机初始化一个节点使其处于感染状态，当前可感染状态节点的快照
% awareness_count(1) = 1;

% ---------- 其他参数 ----------
% aplha = 0.8;  % 信息上传率，暂不考虑
% K = 0.3;  % S节点在不知情时接触I节点后知道信息的概率
sigma_forget = 0.8; % 已知信息I节点信息遗忘率衰减
% sigma_infect = 0.3;   % 已知信息S节点感染率衰减
sigma_I = 0.6;  % I节点在知道信息后的感染率衰减
sigma_S = 0.3;  % S节点在知道信息后的防御系数/感染率衰减
sigma_recover = 1.5;    % I节点在知道信息后的康复加快率

tic;

% ---------- 蒙特卡罗次数 ----------
for circles = 1 : loop

    circles

    p = randi([1 N]);    % randi 生成均匀分布的伪随机整数

    Nodes_SIS = zeros(time_steps, N);   % N行代表时间步数，T列代表节点数，记录每步所有节点的状态
    Nodes_UAU = zeros(time_steps, N);   % 存储网络中每个节点的状态快照

    Nodes_SIS(1, p) = 1;    % 第一步标出初始感染节点的位置
    Nodes_UAU(1, p) = 1;    % 随机初始化一个节点使其处于感染状态，当前可感染状态节点的快照

    % ---------- 时间演化 ----------
    for t = 1 : time_steps

		% if t == 2
		% 	return
		% end

        infective_count(circles, t) = sum(Nodes_SIS(t, :));
        awareness_count(circles, t) = sum(Nodes_UAU(t, :));

        % ---------- UAU演化 ----------

        % 找到可以传播的活跃节点
        active_node = find((Nodes_UAU(t, :) == 1)); % 找到当前有传播力的节点的位置
        awareness_source = length(active_node); % 统计这一刻有传播力节点的数量 /当前活跃节点数量

        % 统计当前已知信息节点数 - 可以放到后面统计，然后把第一步的放到循环外，刚随机到的节点后统计
        % awareness_count(t) = awareness_count(t) + sum(Nodes_UAU(t, :));

        % if awareness_source > 0 % 如果还有节点具有传播能力
            for i = 1 : awareness_source    % 遍历这些具有传染力的节点

                spread_rate_current = lambda;   % 这个暂时放这里，看能不能省掉
                forget_rate_current = delta;    % 

                % ---------- UAU传播过程 ----------
                neighbor_total = find(B(active_node(i), :) == 1);   % 找到第i个有传染力节点的邻居
                neighbor_listener = setdiff(neighbor_total, active_node);   % 从neighbor_total去除active_node的节点，应是排除已经感染的邻?
                Num_neighbor_listener = length(neighbor_listener);  % 计算这些真正能被传播的节点数
                
                for j = 1 : Num_neighbor_listener
                    p1 = rand;
                    if p1 <= spread_rate_current
                        Nodes_UAU(t+1, neighbor_listener(j)) = 1;    % 这个节点已知
                    end
                end

                % ---------- UAU遗忘过程 ----------
                p2 = rand;
                if Nodes_SIS(t, active_node(i)) == 0
                    if p2 <= forget_rate_current
                        Nodes_UAU(t+1, active_node(i)) = 0;  % 这个节点遗忘
                    end
                elseif Nodes_SIS(t, active_node(i)) == 1
                    % forget_rate_current = forget_rate_current * sigma_forget;
                    if p2 <= forget_rate_current * sigma_forget
                        Nodes_UAU(t+1, active_node(i)) = 0;
                    end
                end
            end
        % end

        % ---------- SIS演化 ----------

        % infective_count(t) = infective_count(t) + sum(Nodes_SIS(t, :));

        % ---------- SIS感染过程 - 方法1 ----------
        susceptible_nodes = find((Nodes_SIS(t, :) == 0));
        Num_susceptible_nodes = length(susceptible_nodes);

        for i = 1 : Num_susceptible_nodes   % 考察遍每个易感节点

            neighbor_total = find((A(susceptible_nodes(i), :) == 1));   % 查找其邻居
            infective_nodes = find((Nodes_SIS(t, :) == 1));
            neighbor_infective = intersect(infective_nodes, neighbor_total);    % 取交集，真正可以感染它的邻居
            Num_neighbor_infective = length(neighbor_infective);
            
            % infect_rate_current = bata; % 当前临时感染率
            rate_temp = 1;  % 用于计算感染率

            % if Num_neighbor_infective ~= 0    % 如果还有感染节点

                % ---------- SIS感染率改变规则 ----------
                if Nodes_UAU(t, susceptible_nodes(i)) == 0    % S(-)节点

                	infect_rate_current = bata; % 当前临时感染率

                    for j = 1 : Num_neighbor_infective

                        if Nodes_UAU(t, neighbor_infective(j)) == 0
                            rate_temp = rate_temp * (1 - infect_rate_current);
                        elseif Nodes_UAU(t, neighbor_infective(j)) == 1
                            % infect_rate_current = infect_rate_current * sigma_I;
                            rate_temp = rate_temp * (1 - infect_rate_current * sigma_I);

                            % % ---------- S节点和已知信息的I节点接触后知晓 ----------
                            % wake_rate = rand;
                            % if wake_rate <= K
                            %   Nodes_UAU(t+1, susceptible_nodes(i)) = 1;
                            % end

                        end
                    end

                elseif Nodes_UAU(t, susceptible_nodes(i)) == 1    % S(+)节点

                    infect_rate_current = infect_rate_current * sigma_S;    % 当前临时感染率

                    for j = 1 : Num_neighbor_infective

                        if Nodes_UAU(t, neighbor_infective(j)) == 0
                            rate_temp = rate_temp * (1 - infect_rate_current);
                        elseif Nodes_UAU(t, neighbor_infective(j)) == 1
                            % infect_rate_current = infect_rate_current * sigma_I;
                            rate_temp = rate_temp * (1 - infect_rate_current * sigma_I);
                        end
                    end
                end
            % end

            %  ---------- SIS感染 ----------
            v1 = 1 - rate_temp;    % 这是最终计算的感染率？
            x1 = rand;
            if x1 <= v1
                Nodes_SIS(t+1, susceptible_nodes(i)) = 1;

                % % ---------- 感染节点信息上传(知晓) ----------
                % x2 = rand;
                % if  x2 <= aplha
                %   Nodes_UAU(t+1, susceptible_nodes(i)) = 1;
                % end
            end
        end

        % ---------- SIS康复过程 ----------
        infective_nodes = find((Nodes_SIS(t, :) == 1));
        Num_infective_nodes = length(infective_nodes);

        recover_rate_current = mu;

        for k = 1 : Num_infective_nodes

	        x2 = rand;

            if Nodes_UAU(t, infective_nodes(k)) == 0
                if x2 <= recover_rate_current
                    Nodes_SIS(t+1, infective_nodes(k)) = 0;
                end
            elseif Nodes_UAU(t, infective_nodes(k)) == 1
                % recover_rate_current = mu * sigma_recover;
                if x2 <= recover_rate_current * sigma_recover
                    Nodes_SIS(t+1, infective_nodes(k)) = 0;
                end
            end
        end

        % % ---------- SIS感染过程 - 方法2 ----------
        % for i = 1 : N % 考察遍每个节点

        %     % ---------- SIS感染过程 ----------
        %     if Nodes_SIS(t, i) == 0 % 0代表易感(S)，如果上一步节点i健康，就看他的邻居有没有被感染的

        %         neighbor_total = find((A(i, :) == 1));    % 查找其邻居
        %         infective_nodes = find((Nodes_SIS(t, :) == 1));   % 查找当前有感染力节点 
        %         neighbor_infective = intersect(infective_nodes, neighbor_total);    % 取交集，真正可以感染它的邻居
        %         Num_neighbor_infective = length(neighbor_infective);

        %         % infect_rate_current = bata; % 当前临时感染率
        %         rate_temp = 1;  % 用于计算感染率

        %         % if Num_neighbor_infective ~= 0    % 如果还有感染节点

        %             % ---------- SIS感染率改变规则 ----------
        %             if Nodes_UAU(t, i) == 0    % S(-)节点

        %             	infect_rate_current = bata; % 当前临时感染率

        %                 for j = 1 : Num_neighbor_infective

        %                     if Nodes_UAU(t, neighbor_infective(j)) == 0
        %                       rate_temp = rate_temp * (1 - infect_rate_current);
        %                     elseif Nodes_UAU(t, neighbor_infective(j)) == 1
        %                       % infect_rate_current = infect_rate_current * sigma_I;
        %                       rate_temp = rate_temp * (1 - infect_rate_current * sigma_I);

        %                       % % ---------- S节点和已知信息的I节点接触后知晓 ----------
        %                       % wake_rate = rand;
        %                       % if wake_rate <= K
        %                       %   Nodes_UAU(t+1, i) = 1;
        %                       % end
        %                     end
        %                 end

        %             elseif Nodes_UAU(t, i) == 1    % S(+)节点

        %                 infect_rate_current = infect_rate_current * sigma_S;    % 当前临时感染率

        %                 for j = 1 : Num_neighbor_infective

        %                     if Nodes_UAU(t, neighbor_infective(j)) == 0
        %                       rate_temp = rate_temp * (1 - infect_rate_current);
        %                     elseif Nodes_UAU(t, neighbor_infective(j)) == 1
        %                       % infect_rate_current = infect_rate_current * sigma_I;
        %                       rate_temp = rate_temp * (1 - infect_rate_current * sigma_I);
        %                     end
        %                 end
        %             end
        %         % end

        %         %  ---------- SIS感染过程 ----------
        %         v1 = 1 - rate_temp;    % 这是最终计算的感染率？？？
        %         x1 = rand;
        %         if x1 <= v1    % 这里有点问题? 可以问问师姐
        %             Nodes_SIS(t+1, i) = 1;

        %             % % ---------- 感染节点信息上传(知晓) ----------
        %             % x2 = rand;
        %             % if  x2 <= aplha
        %             %   Nodes_UAU(t+1, i) = 1;
        %             % end
        %         end

        %     % ---------- SIS康复过程 ----------
        %     elseif Nodes_SIS(t, i) == 1

        %         recover_rate_current = mu;
        %         x2 = rand;

        %         if Nodes_UAU(t, i) == 0
        %             if x2 <= recover_rate_current
        %                 Nodes_SIS(t+1, i) = 0;
        %             end
        %         elseif Nodes_UAU(t, i) == 1
        %             % recover_rate_current = mu * sigma_recover;
        %             if x2 <= recover_rate_current * sigma_recover
        %                 Nodes_SIS(t+1, i) = 0;
        %             end
        %         end
        %     end
        % end

    end

    toc

end

% ---------- 剔除没有传开的次数 ----------


I_mean_counts = mean(infective_count);
A_mean_counts = mean(awareness_count);

% infective_count = infective_count ./ loop;
% awareness_count = awareness_count ./ loop;

% ---------- 数据可视化 ----------
t = (1 : 1 : time_steps);

% % SIS统计
% plot(t, I_mean_counts ./ N,'-o','color','r','linewidth',1.2);
% hold on;

% % UAU统计
% plot(t, A_mean_counts ./ N, '-o', 'color', 'k', 'linewidth', 1.2);
% hold on;

% SIS统计
plot(t, I_mean_counts ./ N,'-o','color','r');
hold on;

% UAU统计
plot(t, A_mean_counts ./ N, '-o', 'color', 'k');
hold on;

xlabel('steps');ylabel('density of nodes');
legend('SIS_I(t)','UAU_A(t)');
hold off;