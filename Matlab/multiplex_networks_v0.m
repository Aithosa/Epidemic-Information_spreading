% ���������磬���ڽӾ���ֱ�ΪA��B����ģΪ10^4
% �ϲ�ΪUAU����������lambda����������delta
% �²���SIS����Ⱦ����bata���ָ�����mu
% ��Ϣ�ϴ�����aplha
% �Ѹ�ȾI�ڵ���Ϣ������˥��sigma_forget
% ��֪��ϢS�ڵ��Ⱦ��˥��sigma_infect
% I�ڵ���֪����Ϣ��Ĵ�Ⱦ��˥��sigma_I
% S�ڵ���֪����Ϣ��ķ���ϵ��sigma_S
% S�ڵ��ڲ�֪��ʱ�Ӵ�I�ڵ��֪����Ϣ�ĸ���K(�Ǻ�I�ڵ�Ӵ����Ƿ�֪����?)-������ʱ������
% I�ڵ���֪����Ϣ��Ŀ����ӿ���sigma_recover

% ----------��������----------
% clearvars -except A;
% clear all;
% load BA_2000_3;	% ���ؽӴ����ڽӾ���A
% load WS_2000_4_03 % ������Ϣ���ڽӾ���B

% ---------- ������������ʼ�� ----------
loop = 100;	% ���ؿ���ģ�����
total_steps = 50;	% �ܵ�ʱ�䲽��
N = length(A);	% ����ڵ���
p = round(rand * N);	% ��ʼʼ���ѡ��һ����Ⱦ�ڵ㣬��������

% ---------- SIS��������ʼ�� ----------
bata = 0.05;	 % ��Ⱦ����
mu = 0.1;	% �ָ�����

Nodes_SIS = zeros(total_steps, N);   % N�д���ʱ�䲽����T�д���ڵ�������¼ÿ�����нڵ��״̬
Nodes_SIS(1, p) = 1;	% ��һ�������ʼ��Ⱦ�ڵ��λ��

infective_count = zeros(1, total_steps);	% ÿ����Ⱦ�ڵ���,��������ͳ��

% ---------- UAU��������ʼ�� ----------
lambda = 0.6;	% ������
delta = 0.1;	% ������

Nodes_UAU = zeros(total_steps, N);	% �洢������ÿ���ڵ��״̬����
Nodes_UAU(1, p) = 1;	% �����ʼ��һ���ڵ�ʹ�䴦�ڸ�Ⱦ״̬����ǰ�ɸ�Ⱦ״̬�ڵ�Ŀ���

awareness_count = zeros(1, total_steps);	% ÿ��֪���ڵ�����,��������ͳ��

% ---------- �������� ----------
aplha = 0.8;	% ��Ϣ�ϴ���
% K = 0.3;	% S�ڵ��ڲ�֪��ʱ�Ӵ�I�ڵ��֪����Ϣ�ĸ���
sigma_forget = 0.8;	% ��֪��ϢI�ڵ���Ϣ������˥��
% sigma_infect = 0.3;	% ��֪��ϢS�ڵ��Ⱦ��˥��
sigma_I = 0.6;	% I�ڵ���֪����Ϣ��ĸ�Ⱦ��˥��
sigma_S = 0.3;	% S�ڵ���֪����Ϣ��ķ���ϵ��/��Ⱦ��˥��
sigma_recover = 1.5;	% I�ڵ���֪����Ϣ��Ŀ����ӿ���

% aplha = 0;	% ��Ϣ�ϴ���
% K = 0;	% S�ڵ��ڲ�֪��ʱ�Ӵ�I�ڵ��֪����Ϣ�ĸ���
% sigma_forget = 1;	% ��֪��ϢI�ڵ���Ϣ������˥��
% % sigma_infect = 0.3;	% ��֪��ϢS�ڵ��Ⱦ��˥��
% sigma_I = 1;	% I�ڵ���֪����Ϣ��ĸ�Ⱦ��˥��
% sigma_S = 1;	% S�ڵ���֪����Ϣ��ķ���ϵ��/��Ⱦ��˥��
% sigma_recover = 1;	% I�ڵ���֪����Ϣ��Ŀ����ӿ���

% ---------- ���ؿ��޴��� ----------
for circles = 1 : loop

	% ---------- ʱ���ݻ� ----------
	for t = 1 : total_steps

		% if t == 3
		% 	return
		% end

		% ---------- UAU�ݻ� ----------

		% �ҵ����Դ����Ļ�Ծ�ڵ�
		active_node = find((Nodes_UAU(t, :) == 1));	% �ҵ���ǰ�д������Ľڵ��λ��
		Num_active_node = length(active_node);	% ͳ����һ���д������ڵ������
		infective_source = Num_active_node;	% ��ǰ��Ծ�ڵ�����

		% ͳ�Ƶ�ǰ��֪��Ϣ�ڵ���
		awareness_count(t) = awareness_count(t) + sum(Nodes_UAU(t, :));

		if Num_active_node > 0	% ������нڵ���д�������
			for i = 1 : Num_active_node	% ������Щ���д�Ⱦ���Ľڵ�

				spread_rate_current = lambda;	% �����ʱ��������ܲ���ʡ��
				forget_rate_current = delta;	% 

				% ---------- UAU�������� ----------
				neighbor_total = find(B(active_node(i), :) == 1);	% �ҵ���i���д�Ⱦ���ڵ���ھ�
				neighbor_listener = setdiff(neighbor_total, active_node);	% ��neighbor_totalȥ��active_node�Ľڵ㣬Ӧ���ų��Ѿ���Ⱦ����?
				Num_neighbor_listener = length(neighbor_listener);	% ������Щ�����ܱ������Ľڵ���
				
				for j = 1 : Num_neighbor_listener
					num = neighbor_listener(j);

					p1 = rand;
					if p1 <= spread_rate_current
						Nodes_UAU(t+1, num) = 1;	% ����ڵ���֪
					end
				end

				% ---------- UAU�������� ----------
				p2 = rand;
				if Nodes_SIS(i) == 0
					if p2 <= forget_rate_current
						Nodes_UAU(t+1, i) = 0;	% ����ڵ�����
					end
				elseif Nodes_SIS(i) == 1
					forget_rate_current = forget_rate_current * sigma_forget;
					if p2 <= forget_rate_current
						Nodes_UAU(t+1, i) = 0;
					end
				end
			end
		end

		% ---------- SIS�ݻ� ----------

		infective_count(t) = infective_count(t) + sum(Nodes_SIS(t, :));

		for i = 1 : N	% �����ÿ���ڵ�

			% ---------- SIS��Ⱦ���� ----------
			if Nodes_SIS(t, i) == 0	% 0�����׸�(S)�������һ���ڵ�i�������Ϳ������ھ���û�б���Ⱦ��

				neighbor_total = find((A(i, :) == 1));	% �������ھ�
				infective_nodes = find((Nodes_SIS(t, :) == 1));
				neighbor_infective = intersect(infective_nodes, neighbor_total);	% ȡ�������������Ը�Ⱦ�����ھ�
				Num_neighbor_infective = length(neighbor_infective);

				infect_rate_current = bata;	% ��ǰ��ʱ��Ⱦ��
				rate_temp = 1;	% ���ڼ����Ⱦ��

				if Num_neighbor_infective ~= 0

					% ---------- SIS��Ⱦ�ʸı���� ----------
					if Nodes_UAU(t, i) == 0
						
						for j = 1 : Num_neighbor_infective

							if Nodes_UAU(t, neighbor_infective(j)) == 0
								rate_temp = rate_temp * (1 - infect_rate_current);
							elseif Nodes_UAU(t, neighbor_infective(j)) == 1
								infect_rate_current = infect_rate_current * sigma_I;
								rate_temp = rate_temp * (1 - infect_rate_current);

								% % ---------- S�ڵ����֪��Ϣ��I�ڵ�Ӵ���֪�� ----------
								% wake_rate = rand;
								% if wake_rate <= K
								% 	Nodes_UAU(t+1, i) = 1;
								% end

							end
						end

					elseif Nodes_UAU(t, i) == 1

						infect_rate_current = infect_rate_current * sigma_S;	% ��ǰ��ʱ��Ⱦ��

						for j = 1 : Num_neighbor_infective

							if Nodes_UAU(t, neighbor_infective(j)) == 0
								rate_temp = rate_temp * (1 - infect_rate_current);
							elseif Nodes_UAU(t, neighbor_infective(j)) == 1
								infect_rate_current = infect_rate_current * sigma_I;
								rate_temp = rate_temp * (1 - infect_rate_current);
							end
						end
					end
				end

				%  ---------- SIS��Ⱦ���� ----------
				v1 = 1 - rate_temp;    % �������ռ���ĸ�Ⱦ�ʣ�����
				x1 = rand;
				if x1 <= v1	% �����е�����? ��������ʦ��
					Nodes_SIS(t+1, i) = 1;

					% % ---------- ��Ⱦ�ڵ���Ϣ�ϴ�(֪��) ----------
					% x2 = rand;
					% if  x2 <= aplha
					% 	Nodes_UAU(t+1, i) = 1;
					% end
				end

			% ---------- SIS�������� ----------
			elseif Nodes_SIS(t, i) == 1

				recover_rate_current = mu;
				x2 = rand;

				if Nodes_UAU(t, i) == 0
					if x2 <= recover_rate_current
						Nodes_SIS(t+1, i) = 0;
					end
				elseif Nodes_UAU(t, i) == 1
					recover_rate_current = mu * sigma_recover;
					if x2 <= recover_rate_current
						Nodes_SIS(t+1, i) = 0;
					end
				end
			end
		end
	end
end

infective_count = infective_count ./ loop;
awareness_count = awareness_count ./ loop;

% ---------- ���ݿ��ӻ� ----------
t = (1 : 1 : total_steps);

% SISͳ��
plot(t,infective_count ./ N,'-o','color','y','linewidth',1.2);
hold on;

% UAUͳ��
plot(t, awareness_count ./ N, '-o', 'color', 'k', 'linewidth', 1.2);
hold on;

xlabel('steps');ylabel('density of nodes');
legend('SIS_I(t)','UAU_I(t)');
hold off;