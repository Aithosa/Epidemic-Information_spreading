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

% ���������ԭ���ĳ��������޸ģ�����ӽ�Դ����
% ���޸�V0�汾������

% ---------- �������� ----------
% clearvars -except A B;
% clear all;
% load BA_2000_3;   % ���ؽӴ����ڽӾ���A
% load WS_2000_4_03 % ������Ϣ���ڽӾ���B

% ---------- ������������ʼ�� ----------
loop = 10;  % ���ؿ���ģ�����
% valid_loop = 0;
time_steps = 200;   % �ܵ�ʱ�䲽��
N = length(A);  % ����ڵ���
% p = round(rand * N);  % ��ʼʼ���ѡ��һ����Ⱦ�ڵ㣬��������
% p = randi([1 N]);    % randi ���ɾ��ȷֲ���α�������
% rng(5)

% ---------- �洢���� ----------
% Node_states = zeros(2, N);    % ��¼ÿ���ڵ��״̬����һ���Ǽ���״̬���ڶ�������Ϣ״̬

% Nodes_SIS = zeros(time_steps, N);   % N�д���ʱ�䲽����T�д���ڵ�������¼ÿ�����нڵ��״̬
% Nodes_UAU = zeros(time_steps, N);   % �洢������ÿ���ڵ��״̬����

infective_count = zeros(loop, time_steps); % ÿ����Ⱦ�ڵ���,��������ͳ��
awareness_count = zeros(loop, time_steps); % ÿ��֪���ڵ�����,��������ͳ��

% ---------- SIS��������ʼ�� ----------
bata = 0.5;  % ��Ⱦ����
mu = 0.1;   % �ָ�����

% Nodes_SIS(1, p) = 1;    % ��һ�������ʼ��Ⱦ�ڵ��λ��
% infective_count(1) = 1;    % Ҳ���Եȵ�ѭ����������׷��һ��

% ---------- UAU��������ʼ�� ----------
lambda = 0.6;   % ������
delta = 0.1;    % ������

% Nodes_UAU(1, p) = 1;    % �����ʼ��һ���ڵ�ʹ�䴦�ڸ�Ⱦ״̬����ǰ�ɸ�Ⱦ״̬�ڵ�Ŀ���
% awareness_count(1) = 1;

% ---------- �������� ----------
% aplha = 0.8;  % ��Ϣ�ϴ��ʣ��ݲ�����
% K = 0.3;  % S�ڵ��ڲ�֪��ʱ�Ӵ�I�ڵ��֪����Ϣ�ĸ���
sigma_forget = 0.8; % ��֪��ϢI�ڵ���Ϣ������˥��
% sigma_infect = 0.3;   % ��֪��ϢS�ڵ��Ⱦ��˥��
sigma_I = 0.6;  % I�ڵ���֪����Ϣ��ĸ�Ⱦ��˥��
sigma_S = 0.3;  % S�ڵ���֪����Ϣ��ķ���ϵ��/��Ⱦ��˥��
sigma_recover = 1.5;    % I�ڵ���֪����Ϣ��Ŀ����ӿ���

tic;

% ---------- ���ؿ��޴��� ----------
for circles = 1 : loop

    circles

    p = randi([1 N]);    % randi ���ɾ��ȷֲ���α�������

    Nodes_SIS = zeros(time_steps, N);   % N�д���ʱ�䲽����T�д���ڵ�������¼ÿ�����нڵ��״̬
    Nodes_UAU = zeros(time_steps, N);   % �洢������ÿ���ڵ��״̬����

    Nodes_SIS(1, p) = 1;    % ��һ�������ʼ��Ⱦ�ڵ��λ��
    Nodes_UAU(1, p) = 1;    % �����ʼ��һ���ڵ�ʹ�䴦�ڸ�Ⱦ״̬����ǰ�ɸ�Ⱦ״̬�ڵ�Ŀ���

    % ---------- ʱ���ݻ� ----------
    for t = 1 : time_steps

		% if t == 2
		% 	return
		% end

        infective_count(circles, t) = sum(Nodes_SIS(t, :));
        awareness_count(circles, t) = sum(Nodes_UAU(t, :));

        % ---------- UAU�ݻ� ----------

        % �ҵ����Դ����Ļ�Ծ�ڵ�
        active_node = find((Nodes_UAU(t, :) == 1)); % �ҵ���ǰ�д������Ľڵ��λ��
        awareness_source = length(active_node); % ͳ����һ���д������ڵ������ /��ǰ��Ծ�ڵ�����

        % ͳ�Ƶ�ǰ��֪��Ϣ�ڵ��� - ���Էŵ�����ͳ�ƣ�Ȼ��ѵ�һ���ķŵ�ѭ���⣬��������Ľڵ��ͳ��
        % awareness_count(t) = awareness_count(t) + sum(Nodes_UAU(t, :));

        % if awareness_source > 0 % ������нڵ���д�������
            for i = 1 : awareness_source    % ������Щ���д�Ⱦ���Ľڵ�

                spread_rate_current = lambda;   % �����ʱ��������ܲ���ʡ��
                forget_rate_current = delta;    % 

                % ---------- UAU�������� ----------
                neighbor_total = find(B(active_node(i), :) == 1);   % �ҵ���i���д�Ⱦ���ڵ���ھ�
                neighbor_listener = setdiff(neighbor_total, active_node);   % ��neighbor_totalȥ��active_node�Ľڵ㣬Ӧ���ų��Ѿ���Ⱦ����?
                Num_neighbor_listener = length(neighbor_listener);  % ������Щ�����ܱ������Ľڵ���
                
                for j = 1 : Num_neighbor_listener
                    p1 = rand;
                    if p1 <= spread_rate_current
                        Nodes_UAU(t+1, neighbor_listener(j)) = 1;    % ����ڵ���֪
                    end
                end

                % ---------- UAU�������� ----------
                p2 = rand;
                if Nodes_SIS(t, active_node(i)) == 0
                    if p2 <= forget_rate_current
                        Nodes_UAU(t+1, active_node(i)) = 0;  % ����ڵ�����
                    end
                elseif Nodes_SIS(t, active_node(i)) == 1
                    % forget_rate_current = forget_rate_current * sigma_forget;
                    if p2 <= forget_rate_current * sigma_forget
                        Nodes_UAU(t+1, active_node(i)) = 0;
                    end
                end
            end
        % end

        % ---------- SIS�ݻ� ----------

        % infective_count(t) = infective_count(t) + sum(Nodes_SIS(t, :));

        % ---------- SIS��Ⱦ���� - ����1 ----------
        susceptible_nodes = find((Nodes_SIS(t, :) == 0));
        Num_susceptible_nodes = length(susceptible_nodes);

        for i = 1 : Num_susceptible_nodes   % �����ÿ���׸нڵ�

            neighbor_total = find((A(susceptible_nodes(i), :) == 1));   % �������ھ�
            infective_nodes = find((Nodes_SIS(t, :) == 1));
            neighbor_infective = intersect(infective_nodes, neighbor_total);    % ȡ�������������Ը�Ⱦ�����ھ�
            Num_neighbor_infective = length(neighbor_infective);
            
            % infect_rate_current = bata; % ��ǰ��ʱ��Ⱦ��
            rate_temp = 1;  % ���ڼ����Ⱦ��

            % if Num_neighbor_infective ~= 0    % ������и�Ⱦ�ڵ�

                % ---------- SIS��Ⱦ�ʸı���� ----------
                if Nodes_UAU(t, susceptible_nodes(i)) == 0    % S(-)�ڵ�

                	infect_rate_current = bata; % ��ǰ��ʱ��Ⱦ��

                    for j = 1 : Num_neighbor_infective

                        if Nodes_UAU(t, neighbor_infective(j)) == 0
                            rate_temp = rate_temp * (1 - infect_rate_current);
                        elseif Nodes_UAU(t, neighbor_infective(j)) == 1
                            % infect_rate_current = infect_rate_current * sigma_I;
                            rate_temp = rate_temp * (1 - infect_rate_current * sigma_I);

                            % % ---------- S�ڵ����֪��Ϣ��I�ڵ�Ӵ���֪�� ----------
                            % wake_rate = rand;
                            % if wake_rate <= K
                            %   Nodes_UAU(t+1, susceptible_nodes(i)) = 1;
                            % end

                        end
                    end

                elseif Nodes_UAU(t, susceptible_nodes(i)) == 1    % S(+)�ڵ�

                    infect_rate_current = infect_rate_current * sigma_S;    % ��ǰ��ʱ��Ⱦ��

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

            %  ---------- SIS��Ⱦ ----------
            v1 = 1 - rate_temp;    % �������ռ���ĸ�Ⱦ�ʣ�
            x1 = rand;
            if x1 <= v1
                Nodes_SIS(t+1, susceptible_nodes(i)) = 1;

                % % ---------- ��Ⱦ�ڵ���Ϣ�ϴ�(֪��) ----------
                % x2 = rand;
                % if  x2 <= aplha
                %   Nodes_UAU(t+1, susceptible_nodes(i)) = 1;
                % end
            end
        end

        % ---------- SIS�������� ----------
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

        % % ---------- SIS��Ⱦ���� - ����2 ----------
        % for i = 1 : N % �����ÿ���ڵ�

        %     % ---------- SIS��Ⱦ���� ----------
        %     if Nodes_SIS(t, i) == 0 % 0�����׸�(S)�������һ���ڵ�i�������Ϳ������ھ���û�б���Ⱦ��

        %         neighbor_total = find((A(i, :) == 1));    % �������ھ�
        %         infective_nodes = find((Nodes_SIS(t, :) == 1));   % ���ҵ�ǰ�и�Ⱦ���ڵ� 
        %         neighbor_infective = intersect(infective_nodes, neighbor_total);    % ȡ�������������Ը�Ⱦ�����ھ�
        %         Num_neighbor_infective = length(neighbor_infective);

        %         % infect_rate_current = bata; % ��ǰ��ʱ��Ⱦ��
        %         rate_temp = 1;  % ���ڼ����Ⱦ��

        %         % if Num_neighbor_infective ~= 0    % ������и�Ⱦ�ڵ�

        %             % ---------- SIS��Ⱦ�ʸı���� ----------
        %             if Nodes_UAU(t, i) == 0    % S(-)�ڵ�

        %             	infect_rate_current = bata; % ��ǰ��ʱ��Ⱦ��

        %                 for j = 1 : Num_neighbor_infective

        %                     if Nodes_UAU(t, neighbor_infective(j)) == 0
        %                       rate_temp = rate_temp * (1 - infect_rate_current);
        %                     elseif Nodes_UAU(t, neighbor_infective(j)) == 1
        %                       % infect_rate_current = infect_rate_current * sigma_I;
        %                       rate_temp = rate_temp * (1 - infect_rate_current * sigma_I);

        %                       % % ---------- S�ڵ����֪��Ϣ��I�ڵ�Ӵ���֪�� ----------
        %                       % wake_rate = rand;
        %                       % if wake_rate <= K
        %                       %   Nodes_UAU(t+1, i) = 1;
        %                       % end
        %                     end
        %                 end

        %             elseif Nodes_UAU(t, i) == 1    % S(+)�ڵ�

        %                 infect_rate_current = infect_rate_current * sigma_S;    % ��ǰ��ʱ��Ⱦ��

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

        %         %  ---------- SIS��Ⱦ���� ----------
        %         v1 = 1 - rate_temp;    % �������ռ���ĸ�Ⱦ�ʣ�����
        %         x1 = rand;
        %         if x1 <= v1    % �����е�����? ��������ʦ��
        %             Nodes_SIS(t+1, i) = 1;

        %             % % ---------- ��Ⱦ�ڵ���Ϣ�ϴ�(֪��) ----------
        %             % x2 = rand;
        %             % if  x2 <= aplha
        %             %   Nodes_UAU(t+1, i) = 1;
        %             % end
        %         end

        %     % ---------- SIS�������� ----------
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

% ---------- �޳�û�д����Ĵ��� ----------


I_mean_counts = mean(infective_count);
A_mean_counts = mean(awareness_count);

% infective_count = infective_count ./ loop;
% awareness_count = awareness_count ./ loop;

% ---------- ���ݿ��ӻ� ----------
t = (1 : 1 : time_steps);

% % SISͳ��
% plot(t, I_mean_counts ./ N,'-o','color','r','linewidth',1.2);
% hold on;

% % UAUͳ��
% plot(t, A_mean_counts ./ N, '-o', 'color', 'k', 'linewidth', 1.2);
% hold on;

% SISͳ��
plot(t, I_mean_counts ./ N,'-o','color','r');
hold on;

% UAUͳ��
plot(t, A_mean_counts ./ N, '-o', 'color', 'k');
hold on;

xlabel('steps');ylabel('density of nodes');
legend('SIS_I(t)','UAU_A(t)');
hold off;