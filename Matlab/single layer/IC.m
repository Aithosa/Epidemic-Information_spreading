% function [ic_capable] = ic(A, active_rounds = 50, Gamma = 0.4)

% ----------�����㷨----------
% ��������ģ�͵��㷨���£�
% 1����ʼ�Ļ�Ծ�ڵ㼯��A��
% 2����tʱ�̣��½�������Ľڵ�u�������ڽӽڵ�v����Ӱ�죬�ɹ��ĸ���Ϊp����v�ж���ھӽڵ㶼���½�������Ľڵ㣬��ô��Щ�ڵ㽫������˳���Լ���ڵ�v��
% 3������ڵ�v������ɹ�����ô��t+1ʱ�̣��ڵ�vתΪ��Ծ״̬���������ڽӷǻ�Ծ�ڵ����Ӱ�죻���򣬽ڵ�v��t+1ʱ��״̬�������仯��
% 4���ù��̲��Ͻ����ظ���ֱ�������в�������Ӱ�����Ļ�Ծ�ڵ�ʱ���������̽�����

% ���������������⣬������ͼ�������Ȳ����Ǳ���, Ӧ���Ǵ���������

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

old_set = zeros(1, N);    % n���ڵ�״̬�Ŀ���
new_set = zeros(1, N);

old_active_t = zeros(1, active_rounds);   % ÿ���ķǻ�Ծ��Ⱦ�ڵ������

% ----------
init_p = ceil(rand(1, 1) * N);     % һ��ʼ���ѡ��һ����Ⱦ�ڵ�

new_set(init_p) = 1;    % �����ʼ��һ���ڵ�ʹ�䴦�ڸ�Ⱦ̬����ǰ�ɸ�Ⱦ״̬�ڵ�Ŀ���

% ----------
% while((length(active_nodes) ~= prev_length) && length(active_nodes) ~= size(G.Nodes, 1) )
for steps = 1:active_rounds
    
    active_node = find((new_set(:) == 1));    % �ҵ��д������Ľڵ��λ��
    len_active_node = length(active_node);    % ͳ���д������ڵ������

    if len_active_node > 0    % ������нڵ���д�������

        for i = 1:len_active_node    % ������Щ���д�Ⱦ���Ľڵ�
        	% ����ɸѡ����һ��ɸѡ�ɱ���Ⱦ�Ľڵ㣻�ڶ����ٻ�����ɸѡ��δʧЧ����
            i_nebor = find(A(active_node(i), :) == 1);    % �ҵ���i���д�Ⱦ���ڵ���ھ�
            victim = setdiff(i_nebor, active_node);    % ����i_nebor�ж�active_nodeû�е��ھӣ�Ӧ���ų��Ѿ���Ⱦ���ھ�

            old_active_node = find((old_set(:) == 1));    % �ҵ��Ѿ�ʧЧ�Ľڵ�
            victim_final = setdiff(victim, old_active_node);    % �ڵ�i�����ɴ�Ⱦ���ھ�
            Num_victim_final = length(victim_final);    % 

            for j = 1:Num_victim_final    % �����ڵ�i�����пɴ����ڵ�
                p1 = rand(1, 1);
                % p2 = 1 / (length(find(A(victim_final(j), :))));
                % p2 = rand(1, 1);
                if p1 <= Gamma
                    new_set(victim_final(j)) = 1;    % ����ڵ㱻��Ⱦ
                end
            end
            new_set(active_node(i)) = 0;    % �ڵ�i��Ⱦ��֮��ʧЧ
            old_set(active_node(i)) = 1;    % �ڵ�i������ʷ
        end
    end

    % ͳ��ÿһ���ļ���ڵ�仯
    len_old_set = length(find(old_set));    % ������һ���ǻ�Ծ���Ѹ�Ⱦ�ڵ���/��һ���Ѿ���Ⱦ�Ľڵ�
    old_active_t(steps) = len_old_set;

    ic_capable(steps,:) = old_set;    % 
    % ic_capable(steps, :) = old_set + new_set;    % 
    % ic_capable(steps,:) = old_set;    % 

end

% ----------���ݿ��ӻ�----------
t = (1 : 1 : active_rounds);   % 
% y = zeros(1, active_rounds);
% for t = 1:active_rounds
%     y(t) = sum(ic_capable(t,:)) ./ N;
% end
% t1 = linspace(1,50,50)
plot(t, old_active_t./N, '-o', 'color', 'k', 'linewidth', 1.2);
hold on;
xlabel('t');ylabel('midu');   % ���������
legend('I(t)','S(t)');    % ���޸�
hold off��

% end