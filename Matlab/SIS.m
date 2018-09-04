% function [Nodes_SIS] = SIS(A, T = 50, rate = 0.001, u = 0.02)

% ----------��ձ���,�������ڽӾ���----------
% clear;clc;clf;
clear T rate u N Nodes_SIS p I S t i k1 v1 x1 x2 j t1;

% ----------��������----------
% load BC;    % �����ڽӾ���A

% ----------�Զ������----------
T = 100;    % ʱ�䲽��
loop = 50;    % ����ƽ�����ݵ�ѭ��
rate = 0.15;     % ��Ⱦ����
u = 0.5;    % �ָ�����

% ----------��ʼ��----------
N = length(A);    % ����ڵ���

% ÿһ��ѭ������״̬�Ľڵ������ı���
I = zeros(T+1, loop);    % ÿ��loopƽ�����ֵ ����Ⱥ��
S = zeros(T+1, loop);    % ÿ��loopƽ�����ֵ ��ȾȺ��

infected = zeros(T+1, 1);
healthy = zeros(T+1, 1); 

% Nodes_SIS = zeros(T+1, N);   % N�д���ʱ�䲽��,T�д���ڵ���,�����ÿһ��չʾÿ��ʱ�䲽���нڵ��״̬����

% p = round(rand * N);    % ��ʼ��Ⱦ�ڵ��λ��;rand����0-1֮���һ������(����λ��),round()��������
% Nodes_SIS(1, p) = 1;    % ��һ�������ʼ��Ⱦ�ڵ��λ��

% ----------loopƽ��ѭ��---------
for l = 1 : loop

    % ��ʼ��״̬�洢
    Nodes_SIS = zeros(T+1, N);

    p = round(rand * N);
    Nodes_SIS(1, p) = 1; 

    I(1, l) = length(find(Nodes_SIS(1, :) == 1))/N;
    S(1, l) = length(find(Nodes_SIS(1, :) == 0))/N;

% ----------��ʼ��Ⱦѭ��----------
    for t = 2 : T+1     % ��֤�����趨��T��

        Nodes_SIS(t, :) = Nodes_SIS(t-1, :);    % �ȴ���һ��״̬��ȡ����

        % ��Ⱦ�Ϳ����Ĺ��̻��г�ͻ��
        for i = 1 : N    % �����ÿһ���ڵ�

            % �������һ�������ڵ���ܱ���Ⱦ�����k1
            if Nodes_SIS(t-1, i) == 0    % 0�����׸�(S),�����һ���ڵ�i����,�Ϳ������ھ���û�б���Ⱦ��

                k1 = 0;     % ���ڼ�¼�Ѹ�Ⱦ�ھӽڵ����
                for j = 1:N
                    if A(i, j) == 1 && Nodes_SIS(t-1, j) == 1    % ������ڽӾ��󿴳����ھӣ�����һ����S״̬
                        k1 = k1 + 1;   % �Ѹ�Ⱦ�ھӽڵ������ۼ�
                    end
                end

                % �����Ⱦ����
                v1 = 1 - (1 - rate) ^ k1;   % ��Ⱦ���ʣ�Ϊʲô�����㣿
                x1 = rand;    % ��Ⱦ��ֵ
                if x1 < v1
                    Nodes_SIS(t, i) = 1;
                end

            % �������һ����Ⱦ�ڵ㿵������
            elseif Nodes_SIS(t-1, i) == 1 
                x2 = rand;
                if x2 < u
                    Nodes_SIS(t, i) = 0;
                end
            end
        end

        % ������һ��ʱ�䲽���ֽڵ�ı��������ﲻ������һ�������һ��T+1û���룬���1-T����
        % Ҳ���԰�length����sum(����)
        I(t, l) = length(find(Nodes_SIS(t, :) == 1))/N;
        S(t, l) = length(find(Nodes_SIS(t, :) == 0))/N;
    end

    infected = sum(I, 2)/loop;
    healthy = sum(I, 2)/loop; 
end
% ----------��������----------
t1 = (1 : 1 : T);   % t1(1,50)������������
% t1 = linspace(1,T,T)
plot(t1,infected(t1),'-o','color','k','linewidth',1.2);
hold on;
plot(t1,healthy(t1),'-o','color','b','linewidth',1.2);
hold on;

xlabel('ʱ��');ylabel('�ڵ�״̬�ܶ�');   % ���������
legend('I(t)','S(t)');
hold off;

% end
