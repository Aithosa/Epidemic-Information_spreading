% clear all;
% load BA;
clearvars -except A;

% ---------- SIS�Զ������ ----------
T = 100;    % ʱ�䲽��
active_rounds = T;    % 

rate = 0.01;     % ��Ⱦ����
u = 0.02;    % �ָ�����

N = length(A);    % ����ڵ���
Nodes_SIS = zeros(T, N);   % N�д���ʱ�䲽����T�д���ڵ�����չʾÿһ�����нڵ��״̬����
% Nodes_SIS_init = zeros(1, N);

p = ceil(rand(1, 1) * N);    % һ��ʼ���ѡ��һ����Ⱦ�ڵ�
% p = round(rand * N);    % ��ʼ��Ⱦ�ڵ��λ�ã�rand����0-1֮���һ�����֣����������ã���round()��������
Nodes_SIS(1, p) = 1 ;    % ��һ�������ʼ��Ⱦ�ڵ��λ��

% ÿһ������״̬�Ľڵ�����
I = zeros(T, 1);    % ����bianƽ�����ֵ ����Ⱥ��
S = zeros(T, 1);    % ����bianƽ�����ֵ ��ȾȺ��

% ---------- IC�Զ������ ----------
Gamma = 1;    % ��Ⱦ��
ic_capable = zeros(active_rounds, N);    % �洢������ÿ���ڵ�Ĵ�������

init_p = p;    % һ��ʼ���ѡ��һ����Ⱦ�ڵ�

old_set = zeros(1, N);    % n���ڵ�״̬�Ŀ���
new_set = zeros(1, N);

new_set(init_p) = 1;    % �����ʼ��һ���ڵ�ʹ�䴦�ڸ�Ⱦ̬����ǰ�ɸ�Ⱦ״̬�ڵ�Ŀ���
ic_capable(1, :) = new_set;

old_active_t = zeros(1, active_rounds);   % ÿ���ķǻ�Ծ��Ⱦ�ڵ������

% ʱ���ݻ�
for t = 1 : T     % 

    %%%% IC�ݻ�

    active_node = find((new_set(:) == 1));    % �ҵ��д������Ľڵ��λ��
    len_active_node = length(active_node);    % ͳ���д������ڵ������

    if len_active_node > 0    % ������нڵ���д�������

        for i = 1:len_active_node    % ������Щ���д�Ⱦ���Ľڵ�
            i_nebor = find(A(active_node(i), :) == 1);    % �ҵ���i���д�Ⱦ���ڵ���ھ�
            victim = setdiff(i_nebor, active_node);    % ����i_nebor�ж�active_nodeû�е��ھӣ�Ӧ���ų��Ѿ���Ⱦ���ھ�

            old_active_node = find((old_set(:) == 1));
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
            new_set(active_node(i)) = 0;    % �ڵ�i��Ⱦ��֮��ʧЧ��new_setĿǰ�������¸�Ⱦ�ڵ�
            old_set(active_node(i)) = 1;    % �ڵ�i������ʷ
        end
    end

    ic_capable(t+1, :) = new_set;    % ���ÿ��һ���Ļ�Ծ�ڵ�
    % ic_capable(t, :) = old_set;    % �Ѿ�ʧЧ�Ľڵ��ܺ�

    % ͳ��ÿһ���ļ���ڵ�仯
    len_old_set = length(find(old_set == 1));    % ������һ���Ѵ�Ⱦ���Ľڵ���
    old_active_t(t) = len_old_set;


    %%%% SIS�ݻ�
    Nodes_SIS(t+1, :) = Nodes_SIS(t, :);    % ��ǰ״̬Ϊ��һ��״̬ȡ�Ŀ���

    % ��ʱNodes_SIS(t, ��)��¼�˵�ǰ�ڵ�״��������IC�㱾�λ�Ծ�ڵ�
    % new_set = Nodes_SIS(t+1, ��)

    % 
    for i = 1 : N    % �����ÿһ���ڵ�

        rate_temp = rate;

        % �������һ�������ڵ���ܱ���Ⱦ�����k1
        if Nodes_SIS(t, i) == 0    % 0�����׸�(S)�������һ���ڵ�i�������Ϳ������ھ���û�б���Ⱦ��

            % ���֪����Ⱦ״�������Ⱦ�ʽ���2/3
            if ic_capable(t+1, i) == 1
                rate_temp = rate_temp * 2/3;
            end

            % for j = 1:N
            %     if A(i, j) == 1 & ic_capable(t+1, j) == 1    % ������ڽӾ��󿴳����ھӲ�����һ�����տ�����S״̬
            %         
            %     end
            % end

            k1 = 0;     % ���ڼ�¼�Ѹ�Ⱦ�ھӽڵ����
            for j = 1:N
                if A(i, j) == 1 & Nodes_SIS(t, j) == 1    % ������ڽӾ��󿴳����ھӲ�����һ�����տ�����S״̬
                    k1 = k1 + 1;   % �Ѹ�Ⱦ�ھӽڵ������ۼ�
                end
            end

            % �����Ⱦ����
            v1 = 1 - (1 - rate_temp) ^ k1;   % Ϊʲô������
            % v1 = 1 - (1 - (rate_temp - )) ^ k1;   % Ϊʲô������
            x1 = rand;
            if x1 < v1
                Nodes_SIS(t+1, i) = 1;
            end

        % �������һ����Ⱦ�ڵ㿵������
        elseif Nodes_SIS(t, i) == 1 
            x2 = rand;
            if x2 < u
                Nodes_SIS(t+1, i) = 0;

            end
        end
    end

    new_set = Nodes_SIS(t+1, :);    % ����һ���ĸ�Ⱦ״��������IC��һʱ�̵�Ծ�ڵ�

    % ������һ��ʱ�䲽���ֽڵ�ı��������ﲻ������һ�������һ��T+1û����
    % Ҳ���԰�length����sum
    I(t) = length(find(Nodes_SIS(t, :) == 1))/N;
    S(t) = length(find(Nodes_SIS(t, :) == 0))/N;
    
end

% SISͳ��
t1 = (1 : 1 : T);   % t1(1,50)������������
% t1 = linspace(1,50,50)
plot(t1,I(t1),'-o','color','k','linewidth',1.2);
hold on;
plot(t1,S(t1),'-o','color','b','linewidth',1.2);
hold on;

% ICͳ��
% t = (1 : 1 : active_rounds);   % 
% t1 = linspace(1,50,50)
plot(t1,old_active_t./N,'-x','color','r','linewidth',1.2);    % ����ÿһ���д�Ⱦ���Ľڵ����
% xlabel('t');ylabel('�ڵ��ܶ�');   % 
xlabel('t');ylabel('�ڵ��ܶ�');   % ���������
legend('I(t)','S(t)','IC(t)');
hold off;