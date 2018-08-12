% function [Nodes_SIS] = SIS(A, T = 50, rate = 0.001, u = 0.02)
    
% clear;clc;clf;
% load BC;    % BC�ƺ��Ǿ�����߱������Ķ���������������B
clear T rate u N Nodes_SIS p I S t i k1 v1 x1 x2 j t1;
% �Զ������
T = 50;    % ʱ�䲽��
rate = 0.15;     % ��Ⱦ����
u = 0.5;    % �ָ�����

N = length(A);    % ����ڵ���
Nodes_SIS = zeros(T, N);   % N�д���ʱ�䲽����T�д���ڵ�����չʾÿһ�����нڵ��״̬����

p = round(rand * N);    % ��ʼ��Ⱦ�ڵ��λ�ã�rand����0-1֮���һ�����֣����������ã���round()��������
Nodes_SIS(1, p) =1 ;    % ��һ�������ʼ��Ⱦ�ڵ��λ��

% ÿһ������״̬�Ľڵ�����
I = zeros(T, 1);    % ����bianƽ�����ֵ ����Ⱥ��
S = zeros(T, 1);    % ����bianƽ�����ֵ ��ȾȺ��

for t = 2 : T+1     % ��֤�����趨��T��

    Nodes_SIS(t, :) = Nodes_SIS(t-1, :);    % ����һ��״̬ȡһ������

    % ���ѭ��������ɲ��г�ͻ��
    for i = 1 : N    % �����ÿһ���ڵ�

        % �������һ�������ڵ���ܱ���Ⱦ�����k1
        if Nodes_SIS(t-1, i) == 0    % 0�����׸�(S)�������һ���ڵ�i�������Ϳ������ھ���û�б���Ⱦ��

            k1 = 0;     % ���ڼ�¼�Ѹ�Ⱦ�ھӽڵ����
            for j = 1:N
                if A(i, j) == 1 && Nodes_SIS(t-1, j) == 1    % ������ڽӾ��󿴳����ھӲ�����һ�����տ�����S״̬
                    k1 = k1 + 1;   % �Ѹ�Ⱦ�ھӽڵ������ۼ�
                end
            end

            % �����Ⱦ����
            v1 = 1 - (1 - rate) ^ k1;   % Ϊʲô������
            x1 = rand;
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

    % ������һ��ʱ�䲽���ֽڵ�ı��������ﲻ������һ�������һ��T+1û����
    % Ҳ���԰�length����sum(����)
    I(t-1) = length(find(Nodes_SIS(t-1, :) == 1))/N;
    S(t-1) = length(find(Nodes_SIS(t-1, :) == 0))/N;
end

t1 = (1 : 1 : T);   % t1(1,50)������������
% t1 = linspace(1,50,50)
plot(t1,I(t1),'-o','color','k','linewidth',1.2);
hold on;
plot(t1,S(t1),'-o','color','b','linewidth',1.2);
hold on;

xlabel('t');ylabel('�ڵ��ܶ�');   % ���������
legend('I(t)','S(t)');
% end
