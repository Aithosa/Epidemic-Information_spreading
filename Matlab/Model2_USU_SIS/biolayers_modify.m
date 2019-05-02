% ----------��������----------
%clearvars -except A;
clear all;
load BA_2000_2;    % �����ڽӾ���A

% ---------- ������������ʼ�� ----------
total_steps = 50;    % �ܵ�ʱ�䲽��
N = length(A);    % ����ڵ���
p = round(rand * N);    % һ��ʼ���ѡ��һ����Ⱦ�ڵ㣬��������

% ---------- SIS��������ʼ�� ----------
rate = 0.2;     % ��Ⱦ����
u = 0.5;    % �ָ�����

Nodes_SIS = zeros(total_steps, N);   % N�д���ʱ�䲽����T�д���ڵ�����չʾÿһ�����нڵ��״̬����
Nodes_SIS(1, p) = 1 ;    % ��һ�������ʼ��Ⱦ�ڵ��λ��

% ÿһ������״̬�Ľڵ�����
I = zeros(1, total_steps);    % ����bianƽ�����ֵ ����Ⱥ��
% S = zeros(1, total_steps);    % ����bianƽ�����ֵ ��ȾȺ��

% ---------- IC��������ʼ�� ----------
Gamma = 0.3;    % ��Ⱦ��

ic_capable = zeros(total_steps, N);    % �洢������ÿ���ڵ��״̬����
ic_capable(1, p) = 1;    % �����ʼ��һ���ڵ�ʹ�䴦�ڸ�Ⱦ̬����ǰ�ɸ�Ⱦ״̬�ڵ�Ŀ���

% normal_num = zeros(1, total_steps);    % ÿ�������ڵ������
invalid_num = zeros(1, total_steps);   % ÿ����ʧ���Ⱦ�ڵ������
infective_source = zeros(1, total_steps);    % ÿ����Ծ�ڵ�����

% ---------- ʱ���ݻ� ----------
for t = 1 : total_steps 

    % ---------- IC�ݻ� ----------

    % �ҵ����Դ����Ļ�Ծ�ڵ�
    active_node = find((ic_capable(t, :) == 1));    % �ҵ���ǰ�д������Ľڵ��λ��
    len_active_node = length(active_node);    % ͳ����һ���д������ڵ������
    infective_source(t) = len_active_node;    % ��ǰ��Ծ�ڵ�����
    
    if len_active_node > 0    % ������нڵ���д�������

        for i = 1:len_active_node    % ������Щ���д�Ⱦ���Ľڵ�
            i_nebor = find(A(active_node(i), :) == 1);    % �ҵ���i���д�Ⱦ���ڵ���ھ�
            victim = setdiff(i_nebor, active_node);    % ����i_nebor�ж�active_nodeû�е��ھӣ�Ӧ���ų��Ѿ���Ⱦ���ھ�

            old_active_node = find((ic_capable(t, :) == -1));    % �ҵ��Ѿ�ʧЧ�Ľڵ�
            victim_final = setdiff(victim, old_active_node);    % �ڵ�i�����ɴ�Ⱦ���ھ�
            % ʵ�����ҵ��ǵ�ǰ���Ϊ0�Ľڵ㣬����ֱ���ҳ���i_nebor�Ƚ�
            Num_victim_final = length(victim_final);    % ������Щ�����ܱ���Ⱦ�Ľڵ��ж���

            % ��Ⱦ���̣���Щ�ɸ�Ⱦ�Ľڵ��Ӧ��i����ȾԴ������������Ⱦ��Щ�ڵ�
            for j = 1:Num_victim_final    % �����ڵ�i�����пɴ����ڵ�
                p1 = rand;
                % p2 = 1 / (length(find(A(victim_final(j), :))));
                % p2 = rand(1, 1);
                if p1 <= Gamma
                    ic_capable(t+1, victim_final(j)) = 1;    % ����ڵ㱻��Ⱦ
                end
            end
            % active_rounds+1 ��ʧ����Ч��
            ic_capable(t:total_steps+1, active_node(i)) = -1;     % �ڵ�����ʧ��
        end
    end

    % ͳ��ÿһ���ļ���ڵ�仯
    invalid_num(t) = length(find(ic_capable(t, :) == -1));    % ������һ���ǻ�Ծ���Ѹ�Ⱦ�ڵ���/��һ���Ѿ���Ⱦ�Ľڵ�
    % normal_num(t) = length(find(ic_capable(t, :) == 0));
    

    % ---------- SIS�ݻ� ----------
    % Nodes_SIS(t+1, :) = Nodes_SIS(t, :);    % ��һ���ĳ�ʼ״̬�Ե�ǰΪ����

    % ��ʱNodes_SIS(t, ��)��¼�˵�ǰ�ڵ�״��������IC�㱾�λ�Ծ�ڵ�

    for i = 1 : N    % �����ÿһ���ڵ�

        rate_temp = rate;    % ��ǰ��ʱ��Ⱦ��

        % ---------- SIS��Ⱦ���� ----------
        if Nodes_SIS(t, i) == 0    % 0�����׸�(S)�������һ���ڵ�i�������Ϳ������ھ���û�б���Ⱦ��

            % ---------- SIS��Ⱦ�ʸı���� ----------

            % �����õ���t+1��״̬����Ϊtʱ�̵��Ѿ���ɱ仯��û��1���״̬�ˡ�
            if ic_capable(t+1, i) == 1
                rate_temp = rate_temp * 2/3;    % ���֪����Ⱦ״�������Ⱦ�ʽ���1/3��Ҳ���Կ��Ǹ��ݱ���Ϣ�ɹ���Ⱦ�Ĵ������ɹ�һ�ξ�+1��Ȼ���������ֵ������Ⱦ������½�
            end

            k1 = 0;     % ���ڼ�¼�Ѹ�Ⱦ�ھӽڵ����
            for j = 1:N
                if A(i, j) == 1 && Nodes_SIS(t, j) == 1    % ������ڽӾ��󿴳����ھӲ�����һ�����տ�����S״̬
                    k1 = k1 + 1;   % �Ѹ�Ⱦ�ھӽڵ������ۼ�
                end
            end

            % �����Ⱦ����
            v1 = 1 - (1 - rate_temp) ^ k1;   % Ϊʲô������
            x1 = rand;
            if x1 < v1
                Nodes_SIS(t+1, i) = 1;

                % ��Ⱦ���˻��ΪIC�Ļ�Ծ�ڵ㣬�����ζ���ٴγ�Ϊ�����ڵ�ἤ��֮ǰ������ʧ��״̬
				ic_capable(t+1:total_steps+1, i) = 0;
				ic_capable(t+1, i) = 1;
            end

        % ---------- SIS�������� ----------
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


% ---------- ���ݿ��ӻ� ----------
t = (1 : 1 : total_steps);

% SISͳ��
plot(t,I(t)./N,'-o','color','y','linewidth',1.2);
hold on;
% plot(t,S(t)./N,'-o','color','b','linewidth',1.2);
% hold on;

% ICͳ��
plot(t, invalid_num./N, '-o', 'color', 'k', 'linewidth', 1.2);
hold on;
% plot(t, normal_num./N, '-o', 'color', 'r', 'linewidth', 1.2);
% hold on;
xlabel('steps');ylabel('density of nodes');   % ���������
legend('SIS_I(t)','IC_I(t)');    % ���޸�
hold off;