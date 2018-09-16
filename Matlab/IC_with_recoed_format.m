% ----------�����㷨----------
% ��������ģ�͵��㷨���£�
% 1����ʼ�Ļ�Ծ�ڵ㼯��A��
% 2����tʱ�̣��½�������Ľڵ�u�������ڽӽڵ�v����Ӱ�죬�ɹ��ĸ���Ϊp����v�ж���ھӽڵ㶼���½�������Ľڵ㣬��ô��Щ�ڵ㽫������˳���Լ���ڵ�v��
% 3������ڵ�v������ɹ�����ô��t+1ʱ�̣��ڵ�vתΪ��Ծ״̬���������ڽӷǻ�Ծ�ڵ����Ӱ��;���򣬽ڵ�v��t+1ʱ��״̬�������仯��
% 4���ù��̲��Ͻ����ظ���ֱ�������в�������Ӱ�����Ļ�Ծ�ڵ�ʱ���������̽�����

% �ڵ�������״̬��0-���������ڵ㣬1-�����ѱ���Ⱦ�ڵ㣬-1-����ʧ��/���߽ڵ�; ����ʵ����-1��1�ڵ�Ͳ�һ��������������״̬Ҳ����

% ----------�������----------
clearvars -except A;

% ----------��������----------
% Bian = 50;    % ѭ������
% T = 40;    % ��Ⱦ����
active_rounds = 50;    % ��Ծ������������ʱ�䲽��
Gamma = 0.4;    % ��Ⱦ��
% forget_index = ; % �������ʣ������ǻָ�����������Ҳ�����Ǹ��������������½�

% ----------��ʼ��----------
N = length(A);    % ����ڵ���
ic_capable = zeros(active_rounds, N);    % �洢������ÿ���ڵ��״̬

normal_num = zeros(1, active_rounds);    % ÿ�������ڵ������
invalid_num = zeros(1, active_rounds);   % ÿ����ʧ���Ⱦ�ڵ������

% ----------
init_p = ceil(rand(1, 1) * N);     % һ��ʼ���ѡ��һ����Ⱦ�ڵ㣨����������Զѡ������һ���ˣ�Ӧ�����������룩

new_set(init_p) = 1;    % �����ʼ��һ���ڵ�ʹ�䴦�ڸ�Ⱦ̬����ǰ�ɸ�Ⱦ״̬�ڵ�Ŀ���
ic_capable(1, init_p) = 1;

% ----------
% while((length(active_nodes) ~= prev_length) && length(active_nodes) ~= size(G.Nodes, 1) )
for steps = 1:active_rounds
    
    active_node = find((ic_capable(steps, :) == 1));    % �ҵ��д������Ľڵ��λ��
    len_active_node = length(active_node);    % ͳ���д������ڵ������

    if len_active_node > 0    % ������нڵ���д�������

        for i = 1:len_active_node    % ������Щ���д�Ⱦ���Ľڵ�
        	% ����ɸѡ����һ��ɸѡ�ɱ���Ⱦ�Ľڵ�;�ڶ����ٻ�����ɸѡ��δʧЧ����
            i_nebor = find(A(active_node(i), :) == 1);    % �ҵ���i���д�Ⱦ���ڵ���ھ�
            victim = setdiff(i_nebor, active_node);    % ����i_nebor�ж�active_nodeû�е��ھӣ�Ӧ���ų��Ѿ���Ⱦ���ھ�

            % if steps == 1
            %     old_active_node = [];
            % else
            %     old_active_node = find((ic_capable(steps-1, :) == -1));    % �ҵ��Ѿ�ʧЧ�Ľڵ�
            % end
            old_active_node = find((ic_capable(steps, :) == -1));
            victim_final = setdiff(victim, old_active_node);    % �ڵ�i�����ɴ�Ⱦ���ھ�
            Num_victim_final = length(victim_final);    % ���㴫ȾԴ����

            for j = 1:Num_victim_final    % �����ڵ�i�����пɴ����ڵ�
                p1 = rand;
                % p2 = 1 / (length(find(A(victim_final(j), :))));
                % p2 = rand(1, 1);
                if p1 <= Gamma
                    ic_capable(steps+1, victim_final(j)) = 1;    % ����ڵ㱻��Ⱦ
                end
            end
            ic_capable(steps:active_rounds+1, active_node(i)) = -1;     % �ڵ�ʧ��

        end
    end

    % ͳ��ÿһ���ļ���ڵ�仯
    invalid_num(steps) = length(find(ic_capable(steps, :) == -1));    % ������һ���ǻ�Ծ���Ѹ�Ⱦ�ڵ���/��һ���Ѿ���Ⱦ�Ľڵ�
    normal_num(steps) = length(find(ic_capable(steps, :) == 0));
end

% ----------���ݿ��ӻ�----------
t = (1 : 1 : active_rounds);   % 
% y = zeros(1, active_rounds);
% for t = 1:active_rounds
%     y(t) = sum(ic_capable(t,:)) ./ N;
% end
% t1 = linspace(1,50,50)
plot(t, invalid_num./N, '-o', 'color', 'k', 'linewidth', 1.2);
hold on;
plot(t, normal_num./N, '-o', 'color', 'r', 'linewidth', 1.2);
hold on;
xlabel('steps');ylabel('density of nodes');   % ���������
legend('I(t)','N(t)');    % ���޸�
hold off;
