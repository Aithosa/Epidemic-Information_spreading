% 有两层网络，其邻接矩阵分别为A和B，规模为10^4
% 上层为UAU，传播率是lambda，遗忘率是delta
% 下层是SIS，感染率是bata，恢复率是mu
% 信息上传率是aplha
% 已感染I节点信息遗忘率衰减sigma_forget
% 已知信息S节点感染率衰减sigma_infect
% I节点在知道信息后的传染率衰减sigma_I
% S节点在知道信息后的防御系数sigma_S
% S节点在不知情时接触I节点后知道信息的概率K(是和I节点接触还是分知情与?)-可以暂时不??虑
% I节点在知道信息后的康复加快率sigma_recover

% ----------加载数据----------
%clearvars -except A;
%clear all;
load BA_2000_3;	% 加载接触层邻接矩阵A
load WS_2000_4_03? % 加载信息层邻接矩阵B

% ---------- 公共参数及初始化 ----------
loop = 100;	% 蒙特卡洛模拟次数
total_steps = 50;	% 总的时间步数
N = length(A);	% 网络节点?
p = round(rand * N);	% ??始随机??出?个感染节点，四舍五入

% ---------- SIS参数及初始化 ----------
bata = 0.2;	 % 感染概率
mu = 0.5;	% 恢复概率

Nodes_SIS = zeros(total_steps, N);   % N行代表时间步数，T列代表节点数，展示每?步所有节点的状??快?
Nodes_SIS(1, p) = 1;	% 第一步标出初始感染节点的位置

infective_count = zeros(1, total_steps);	% 每步感染点数?,用于?终统?

% 每一步两个状态的节点数量
I = zeros(1, total_steps);	% 多少loop平均后的? 健康群体
% S = zeros(1, total_steps);	% 多少loop平均后的? 感染群体

% ---------- UAU参数及初始化 ----------
lambda = 0.3;	% 传播?
delta = 0.3;	% 遗忘?

Nodes_UAU = zeros(total_steps, N);	% 存储网络中每个节点的状??快?
Nodes_UAU(1, p) = 1;	% 随机初始化一个节点使其处于感染??，当前可感染状态节点的快照

awareness_count = zeros(1, total_steps);	% 每步知晓节点数量,用于?终统?

% ---------- 其他参数 ----------
aplha = 0.8;	% 信息上传?
K = 0.3;	% S节点在不知情时接触I节点后知道信息的概率
sigma_forget = 0.8;	% 已知信息I节点信息遗忘率衰?
% sigma_infect = 0.3;	% 已知信息S节点感染率衰?
sigma_I = 0.6;	% I节点在知道信息后的感染率衰减
sigma_S = 0.3;	% S节点在知道信息后的防御系?
sigma_recover = 1.3;	% I节点在知道信息后的康复加快率

% ---------- 蒙特卡罗次数 ----------
for circles = 1 : loop

	% ---------- 时间演化 ----------
	for t = 1 : total_steps 

		% ---------- UAU演化 ----------

		% 找到可以传播的活跃节?
		active_node = find((Nodes_UAU(t, :) == 1));	% 找到当前有传播力的节点的位置
		Num_active_node = length(active_node);	% 统计这一刻有传播力节点的数量
		infective_source = Num_active_node;	% 当前活跃节点数量

		awareness_count(t) = awareness_count(t) + sum(Nodes_UAU(t, :));

		if len_active_node > 0	% 如果还有节点具有传播能力
			for i = 1 : Num_active_node	% 遍历这些具有传染力的节点

				spread_rate_current = lambda;	% 这个暂时放这里，看能不能省掉
				forget_rate_current = delta;	% 

				% ---------- UAU传播过程 ----------
				neighbor_total = find(B(active_node(i), :) == 1);	% 找到第i个有传染力节点的邻居
				neighbor_listener = setdiff(neighbor_total, active_node);	% 从neighbor_total去除active_node的节点，应是排除已经感染的邻?
				Num_neighbor_listener = length(neighbor_listener);	% 计算这些真正能被传播的节点数
				
				for j = 1 : Num_neighbor_listener
					num = neighbor_listener(j);

					p1 = rand;
					if p1 >= spread_rate_current
						Nodes_UAU(t+1, num) = 1;	% 这个节点已知
					end
				end

				% ---------- UAU遗忘过程 ----------
				p2 = rand;
				if Nodes_SIS(i) == 0
					if p2 >= forget_rate_current
						Nodes_UAU(t+1, i) = 0;	% 这个节点遗忘
					end
				elseif Nodes_SIS(i) == 1
					forget_rate_current = forget_rate_current * sigma_forget;
					if p2 >= forget_rate_current
						Nodes_UAU(t+1, i) = 0;
				end
			end
		end

		% ---------- SIS演化 ----------

		infective_count(t) = infective_count(t) + sum(Nodes_SIS(t, :));
		for i = 1 : N	% 考察遍每?个节?

			% ---------- SIS感染过程 ----------
			if Nodes_SIS(t, i) == 0	% 0代表易感(S)，如果上?步节点i健康，就看他的邻居有没有被感染的
				
				neighbor_total = find((A(i, :) == 1));	% 查找其邻?
				infective_nodes = find((Nodes_SIS(t, :) == 1));
				neighbor_infective = setdiff(neighbor_total, infective_nodes);	% 
				Num_neighbor_infective = length(neighbor_infective);

				% ---------- SIS感染率改变规? ----------
				if Nodes_UAU(t, i) == 0
					rate_temp = 1;	% 用于计算感染?

					for j = 1 : Num_neighbor_infective

						infect_rate_current = bata;	% 当前临时感染?

						if Nodes_UAU(t, neighbor_infective(j)) == 0
							rate_temp = rate_temp * (1 - infect_rate_current);
						elseif Nodes_UAU(t, neighbor_infective(j)) == 1
							infect_rate_current = infect_rate_current * sigma_I;
							rate_temp = rate_temp * (1 - infect_rate_current);

							% ---------- S节点和I节点接触后知? ----------
							wake_rate = rand;
							if wake_rate <= K
								Nodes_UAU(t+1, i) = 1;
							end

						end
					end
				end

				elseif Nodes_UAU(t, i) == 1
					rate_temp = 1;

					for j = 1 : Num_neighbor_infective

						infect_rate_current = bata * sigma_S;	% 当前临时感染?

						if Nodes_UAU(t, neighbor_infective(j)) == 0
							rate_temp = rate_temp * (1 - infect_rate_current);
						elseif Nodes_UAU(t, neighbor_infective(j)) == 1
							infect_rate_current = infect_rate_current * sigma_I;
							rate_temp = rate_temp * (1 - infect_rate_current);
						end
					end
				end

				v1 = 1 - rate_temp;
				x1 = rand;
				if x1 <= v1	% 这里有点问题? 可以问问师姐
					Nodes_SIS(t+1, i) = 1;
				end

				% ---------- 感染节点信息上传(知晓) ----------
				x2 = rand;
				if aplha <= x2
					Nodes_UAU(t+1, i) = 1;
				end

			% ---------- SIS康复过程 ----------
			elseif Nodes_SIS(t, i) == 1

				recover_rate_current = mu;
				x2 = rand;

				if Nodes_UAU(t, i) == 0
					if x2 >= recover_rate_current
						Nodes_SIS(t+1, i) = 0;
					end
				elseif Nodes_UAU(t, i) == 1
					recover_rate_current = mu * aplha;
					if x2 >= recover_rate_current
						Nodes_SIS(t+1, i) = 0;
					end
				end
			end
		end
	end
end

infective_count(t) = infective_count(t) / loop;
awareness_count(t) = awareness_count(t) / loop;

% ---------- 数据可视? ----------
t = (1 : 1 : total_steps);

% SIS统计
plot(t,infective_count,'-o','color','y','linewidth',1.2);
hold on;

% UAU统计
plot(t, awareness_count, '-o', 'color', 'k', 'linewidth', 1.2);
hold on;

xlabel('steps');ylabel('density of nodes');
legend('SIS_I(t)','UAU_I(t)');
hold off;