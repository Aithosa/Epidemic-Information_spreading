% function [AW_S, AW_I, mean_IP, mean_IN, mean_AW_S, mean_AW_I, I_P, I_N] = SISaware_fluctuations(N, p, beta)     %�̶����߸��ʵ�ER���ͼG(N,p)

% ----------�β�˵��----------
% ��ERSIawareness��ͬ���ǶԴ�������ƽ����
% v1.01 - ԭ�����Ż�

% N�ǽڵ����
% p����������

tic;

% ----------��������----------

N = 2000;
p = 0.0015;

loop = 10
maxt = 200;    % �ݻ���ʱ�䲽�� / maxtΪ�����������
rng(5)

% ������������
beta = 0.5;    % ����ʶ�ĸ�Ⱦ�߸�Ⱦ����ʶ���׸��� / ԭʼ��Ⱦ��
sigma_S = 0.3;    % sigma_S*betaΪ����ʶ�ĸ�Ⱦ�߸�Ⱦ����ʶ���׸���
sigma_I = 0.6;    % sigma_I*betaΪ����ʶ�ĸ�Ⱦ�߸�Ⱦ����ʶ���׸��ߣ�sigma_S*sigma_I*betaΪ����ʶ�ĸ�Ⱦ�߸�Ⱦ����ʶ���׸���
gama = 0.1;    % I(-)�ָ����� / ԭʼ������
epsilon = 1.5;    % epsilon*gama��I(+)�ָ����� / ������������

% ��Ϣ��������
alpha = 0.6;    % ��ʶ��������(��С��)/ ��Ϣ������
lambda=0.1;    % ��ʶ�˻����� / ��Ϣ�����ʣ�
% omega = 0.3;    % ��ʶ���ɸ��� / ��Ϣ�ϴ���
delta = 0.8;    % ����û��I(+)�ڵ�������˥��

ic1 = 0.1;    % ռ�����ڵ����ı���
ic2 = 0.005;    % ռ�����ڵ����ı���

% alpha1 = 0.6;    % ��ʶ��������(�ϴ��)
% sigma_S1 = 0.1;    % sigma_S*betaΪ����ʶ�ĸ�Ⱦ�߸�Ⱦ����ʶ���׸���
% sigma_I1 = 0.3;    % sigma_I*betaΪ����ʶ�ĸ�Ⱦ�߸�Ⱦ����ʶ���׸��ߣ�sigma_S*sigma_I*betaΪ����ʶ�ĸ�Ⱦ�߸�Ⱦ����ʶ���׸���
% lambda1 = 0.1;    % ��ʶ�˻�����
% epsilon1 = 3;    % epsilon*gama��I(+)�ָ�����




% ----------ȫ�ִ洢����----------

I_P = [];     % I_P�����洢times�δ�����I(+)��ֵ
I_N = [];     % I_N�����洢times�δ�����I(-)��ֵ
AW_S = [];     % AW_S�����洢times�δ�����(+)��ֵ
AW_I = [];     % AW_I�����洢times�δ�����(-)��ֵ


% ----------���ؿ���ģ��----------

for times = 1 : loop    % times�������ô�����������������¶���Ϊ�ƴ����ñ���
    times

    % ----------��������----------
    % adj = cell(N, 1);  %����һ��cell������Ϊ�ڽӱ�
    % for i = 1 : N
    %     for j = i+1 : N
    %         if rand < p
    %             adj{i} = [adj{i}, j];
    %             adj{j} = [adj{j}, i];
    %             % A(i, j) = 1;
    %             % A(j, i) = 1;
    %         end
            
    %     end
    % end


    % ----------��������----------

    n = N;    % �ڵ����

    t = 1;    % ��ʼʱ��

    % ----------���δ洢����----------
    B = zeros(2, n);     % ����ÿ���ڵ��״̬���󣬾���ĵ�һ�б�ʾ����״̬��0��ʾ�׸У�1��ʾ��Ⱦ���ڶ��б�ʾ��ʶ״̬��0��ʾ����ʶ��1��ʾ����ʶ
    I_positive = [];   % �����洢ÿ�δ�����I(+)��ֵ
    I_negtive = [];    % �����洢ÿ�δ�����I(-)��ֵ
    Awareness_S = [];
    Awareness_I = [];
    T = [];    % �����洢����

    % ----------��ʼ��Ⱦ�ڵ�----------
    i0 = randi([1 n]);    % randi ���ɾ��ȷֲ���α�������
    B(1, i0) = 1; B(2, i0) = 1;  % ���ѡ�������е�һ���ڵ���Ϊ��ʼ��Ⱦ�㣬��������ʶ���׸��� / Ӧ��������ʶ�ĸ�Ⱦ��
    e0 = adj{i0};       % �ҵ�i0�������ھ�
    el = length(e0);    % i0�ھӵĸ���

    % ----------��ʼ�����ָ�----------

    for i = 1 : el
    	% 3(1) ��ʶ����
        if rand < alpha
            B(2, e0(i)) = 1;
        end

        % 3(2) ��������
        if (B(2, e0(i)) == 0) && (rand < sigma_I * beta)    % S(-)
            B(1, e0(i)) = 1;
        elseif (B(2, e0(i)) == 1) && (rand < sigma_S * sigma_I * beta)    % S(+)
            B(1, e0(i))=1;
        end

    end

    % % 3(2) ��������
    % for i = 1 : el
    %     if (B(2, e0(i)) == 0) && (rand < sigma_I * beta)    % S(-)
    %         B(1, e0(i)) = 1;
    %     elseif (B(2, e0(i)) == 1) && (rand < sigma_S * sigma_I * beta)    % S(+)
    %         B(1, e0(i))=1;
    %     end
    % end

    % 3(3) �����ָ�
    if  rand < epsilon * gama
        B(1, i0) = 0;
    end

    % 3(4) ��ʶ�˻�(i0) / ���￼��I(+)������˥��
    if (B(1, i0) == 1) && (rand < delta * lambda)    % S(-)
        B(2, i0) = 0;
    end

    % if rand < lambda
    %     B(2, i0) = 0;    % Ϊʲô������Ҫ���Ϊ-0.5
    % end

    % ----------3(5) ͳ�ƽڵ�����----------
    n1 = 0;    % n1ͳ��I(-)������
    n2 = 0;    % n2ͳ��I(+)������
    for i = 1 : n
        if B(1, i) == 1 && B(2, i) <= 0    % ������ֻ��1��0��ΪʲôҪ�������ж�
            n1 = n1 + 1;
        elseif B(1, i) == 1 && B(2, i) > 0
            n2 = n2 + 1;
        end
    end
    n3 = 0;    % n3ͳ��S(+)������
    n4 = 0;    % n4ͳ��I(+)������
    for i = 1 : n
        if B(1, i) <= 0 && B(2, i) > 0
            n3 = n3 + 1;
        elseif B(1, i) > 0 && B(2, i) > 0
            n4 = n4 + 1;
        end
    end

    T = [T; t];    % ��������ÿִ��һ��������׷��һ��t
    nn = n1 + n2;    % I�ڵ������
    I_negtive = [I_negtive; n1];    % ���������ֱ�׷�Ӹ���ڵ���������ÿ��ʱ�䲽׷��һ��
    I_positive = [I_positive; n2];
    Awareness_S = [Awareness_S; n3];
    Awareness_I = [Awareness_I; n4];


    %�ж���һ��ʹ�õĲ���
%     if nn<ic*N
%         alpha=0.35;
%         sigma_S=0.6;
%         sigma_I=0.8;
%         lambda=0.3;
%         epsilon=1.5;
%     elseif nn>ic1*N
%         alpha=0.85;
%         sigma_S=0.15;
%         sigma_I=0.3;
%         lambda=0.2;
%         epsilon=3;
%     end

    %4

    % ----------δ֪���λ----------
    flag1 = 0;
    count1 = 0;
    flag2=0;
    count2=0;

    % ----------2-maxt�������----------
    for t = 2 : maxt

        % ----------4(1) ��ʶ����----------
        e11 = find(B(2, :) > 0);    % e11�洢����X(+)/ ����ʶ�Ľڵ���
        e21 = [];

        for i = 1 : length(e11)
            e = adj{e11(i)};    % �ֱ��ҵ�ÿ������ʶ�ڵ���ھ�
            e21 = [e21, e];    % e21�洢��ǰ�ܹ��ɴ�����Ϣ�Ľڵ���
        end
        e21 = unique(e21);    % ���ظ����ھ�ɾ��

        % ������ڵ����⣬���нڵ㶼�ǰ���alpha���ʴ����ģ�û�п��ǵ��и�Ⱦ�����ھ�������Ⱦ�����
        for i = 1 : length(e21)
            if (B(2, e21(i)) == 0) && (rand < alpha)    % ��alpha�ĸ��ʴ���
                B(2, e21(i)) = 1;
            end
        end

        % ----------4(2) ��ʶ����/�ϴ�----------
        % for i = 1 : n
        %   if B(1, i) == 1 && B(2, i) == 0 && rand < omega    % I(-) -> I(+)
        %       B(2, i) = 0.5;    % Ϊʲô��0.5
        %   end
        % end

        % ----------4(21) ����ʶ״̬Ϊ-0.5�Ľڵ����ʶ״̬�ĳ�0----------
        % for i = 1 : n
        %     if B(2, i) == -0.5
        %         B(2, i) = 0;
        %     end
        % end

        % ----------4(3) �����Ĵ���ͳ��----------
        e22 = find(B(1, :) == 1);    % �ҵ�B�м���״̬ΪI�Ľڵ�
        e23 = [];    % �����洢I(-)
        e24 = [];    % �����洢I(+)

        for i = 1 : length(e22)
            if B(2, e22(i)) <= 0    % I(-)
                e23 = [e23; e22(i)];
            elseif B(2, e22(i)) > 0    % I(+)
                e24 = [e24; e22(i)];
            end
        end

        % ----------4(31) I(-)��Ⱦ----------
        e23nei = [];
        for i = 1 : length(e23)
            ee = adj{e23(i)};
            e23nei = [e23nei, ee];    % �ҵ�����I(-)���ھ�
        end

        % ����Ҳ�����⣬�ҵ����п��Ը�Ⱦ���ھ�֮�󣬲�û�м����ۼƸ��ʣ�ֱ�Ӿ��ø�Ⱦ����
        for i = 1 : length(e23nei)
            if (B(1, e23nei(i)) == 0 && B(2, e23nei(i)) <= 0) && (rand < beta)  % a S(-)
                B(1, e23nei(i)) = 1;
            elseif (B(1, e23nei(i)) == 0 && B(2, e23nei(i)) > 0) && (rand < sigma_S * beta)  % b S(+)
                B(1, e23nei(i)) = 1;
            end
        end

        % ----------4(32) I(+)��Ⱦ----------
        e24nei = [];
        for i = 1 : length(e24)
            ee = adj{e24(i)};
            e24nei = [e24nei, ee];    % �ҵ�����I(+)���ھ�
        end

        % ����Ҳ�����⣬�ҵ����п��Ը�Ⱦ���ھ�֮�󣬲�û�м����ۼƸ��ʣ�ֱ�Ӿ��ø�Ⱦ����
        for i = 1 : length(e24nei)
            if  (B(1, e24nei(i)) == 0 && B(2, e24nei(i)) <= 0) && (rand < sigma_I * beta)  % a S(-)
                B(1, e24nei(i)) = 1;
            elseif (B(1, e24nei(i)) == 0 && B(2, e24nei(i)) > 0) && (rand < sigma_S * sigma_I * beta)  % b S(+)
                B(1, e24nei(i)) = 1;
            end
        end

        % ----------4(4) �����ָ�----------
        for i = 1 : n
            if B(1, i) == 1 && B(2, i)==0 && rand < gama    % I(-)�Ļָ�
                B(1, i) = 0;
            elseif B(1, i) == 1 && B(2, i) > 0 && (rand < epsilon * gama)   % I(+)�Ļָ�
                B(1, i) = 0;
            end
        end

        % ----------4(5) ��ʶ���˻�----------
        ea = find(B(2, :) == 1);      % �ҵ�X(+)
        for i = 1 : length(ea)
            if (B(1, ea(i)) == 1) && rand < delta * lambda
                B(2, ea(i)) = 0;
            elseif (B(1, ea(i)) == 0) && rand < lambda
            	B(2, ea(i)) = 0;                	
            end
        end

        % ----------4(6) ����ʶ״̬Ϊ0.5�Ľڵ����ʶ״̬�ĳ�1----------
        % for i = 1:n
        %     if  B(2, i) == 0.5
        %          B(2, i) = 1;
        %     end
        % end

        % ----------4(7) ����ʶ״̬Ϊ2�Ľڵ����ʶ״̬�ĳ�1----------
        % for i = 1 : n
        %     if B(1, i) == 2
        %         B(1, i) = 1;
        %     end
        % end

        % ----------4(8) ͳ�Ƹ���ڵ�����----------
        n1 = 0;  % n1ͳ��I(-)������
        n2 = 0;  % n2ͳ��I(+)������
        for i = 1 : n
            if (B(1, i) == 1) && (B(2, i) <= 0)
                n1 = n1 + 1;
            elseif (B(1, i) == 1) && (B(2, i) > 0)
                n2 = n2 + 1;
            end
        end

        n3 = 0;  % n3ͳ��S(+)������
        n4 = 0;  % n4ͳ��I(+)������
        for i = 1 : n
            if (B(1, i) <= 0) && (B(2, i) > 0)
                n3 = n3 + 1;
            elseif (B(1, i) > 0) && (B(2, i) > 0)    % ��һ��������
                n4 = n4 + 1;
            end
        end

        % ----------׷�Ӽ�¼��ǰ����ڵ�����----------
        T = [T; t];    % ��������׷�ӵ�ǰ��t�������Ǽ����ã�
        I_negtive = [I_negtive; n1];
        I_positive = [I_positive; n2];
        Awareness_S = [Awareness_S; n3];
        Awareness_I = [Awareness_I; n4];

        nn = n1 + n2;    % ��ǰI�ڵ������


        % ----------�ж���һ����ʶ�������ʵ�ֵ----------

        % % ��ʶ��ǿ
        % % ����Ч��:
        % if nn > ic1 * N    % �����ǰ����Ⱦ���ڵ�������ic1*N
        %     if flag1 == 0
        %         count1 = count1 + 1;
        %         if rem(count1, 2) == 1    % rem(x,y):������x/y�����������count1������
        %             % ----------alpha���Ӿ޴�sigma_S��С----------
        %             % ����Ч��:
        %             alpha = 0.9;    % ��Ϣ������
        %             sigma_S = 0.1;
        %             sigma_I = 0.1;
        %             lambda = 0.1;    % ��Ϣ������
        %             epsilon = 2.5;    % ������������
        %         elseif  rem(count1, 2) == 0    % ���count1��ż��
        %             % ----------alpha����һ�㣬sigma_S���ӣ�sigma_I���ӣ�epsilon��С----------
        %             % ����Ч��:
        %             alpha = 0.6;    % ��Ϣ������
        %             sigma_S = 0.2;
        %             sigma_I = 0.25;
        %             lambda = 0.1;    % ��Ϣ������
        %             epsilon = 1.5;    % ������������
        %         end
        %     end
        %     flag1 = 1;
        % else    % �����ǰ����Ⱦ���ڵ�������ic1*N
        %     flag1 = 0;    % �ȴ��´ε�ǰ����Ⱦ���ڵ�������ic1*N�������޸Ĳ���
        % end
        
        % % ��ʶ����
        % % ����Ч��:
        % if nn <= ic2 * N    % �����ǰ����Ⱦ���ڵ�������ic2*N
        %     if flag2 == 0
        %         count2 = count2 + 1;
        %         % ----------ΪʲôҪ��count1----------
        %         if mod(count1, 2) == 1    % ���count1������
        %             % ----------sigma_I���ӣ�lambda���ӣ�epsilon��С----------
        %             % ����Ч��:
        %             alpha = 0.3;
        %             sigma_S = 0.15;
        %             sigma_I = 0.3;
        %             lambda = 0.15;
        %             epsilon = 1.5;
        %         elseif mod(count1, 2) == 0    % ���count1��ż��
        %             % ----------alpha��С��sigma_S���Ӿ޴�sigma_I���Ӿ޴�epsilon��С�޴�----------
        %             % ����Ч��:
        %             alpha = 0.2;
        %             sigma_S = 0.85;
        %             sigma_I = 0.95;
        %             lambda = 0.1;
        %             epsilon = 1.05;
        %         end
        %     end
        %     flag2 = 1;
        % else    % �����ǰ����Ⱦ���ڵ�������ic2*N
        %     flag2 = 0;    % �ȴ��´ε�ǰ����Ⱦ���ڵ�������ic2*N�������޸Ĳ���
        % end        
    end

    toc;

    % ----------�ѵ���ģ���600����ÿ������ڵ���������浽�ܾ�����----------
    % ÿһ����ÿһ��ģ��Ľ�����������ؿ����(ÿ������ô����)
    I_P = [I_P, I_positive];
    I_N = [I_N, I_negtive];
    AW_S = [AW_S, Awareness_S];
    AW_I = [AW_I, Awareness_I];
end

% ----------�޳�û�д����Ĵ���---------- 
% Z = zeros(maxt, 1);    % Z=(600,1)�����
% for i = 1 : size(I_P, 2)    % 1-�������޴�
%     if abs(I_P(1, i) - I_P(maxt, i)) < 5    % �������ʵ��I(+)�ڵ㴫�����ͳ�ʼʱ������5��
%         I_P(:, i) = Z;    % �������ϣ�ȫ����Ϊ��
%     end
% end

% Ӧ�û�����������ͽڵ�


% ----------ȥ��ȫ����----------

% I_P(:,sum(I_P,1)==0)=[];  %ȥ��I_P�е�ȫ����
% for i=1:size(I_N,2)
%     if abs(I_N(1,i)-I_N(maxt,i))<5
%         I_N(:,i)=Z;
%     end
% end
% I_N(:,sum(I_N,1)==0)=[];  %ȥ��I_N�е�ȫ����
% for i=1:size(AW_S,2)
%     if abs(AW_S(1,i)-AW_S(maxt,i))<5
%         AW_S(:,i)=Z;
%     end
% end
% AW_S(:,sum(AW_S,1)==0)=[];  %ȥ��I_N�е�ȫ����
% for i=1:size(AW_I,2)
%     if abs(AW_I(1,i)-AW_I(maxt,i))<5
%         AW_I(:,i)=Z;
%     end
% end
% AW_I(:,sum(AW_I,1)==0)=[];  %ȥ��I_N�е�ȫ����

mean_IN = mean(I_N')';    % times֮�������I(-)ȡƽ��
mean_IP = mean(I_P')';    % times֮�������I(+)ȡƽ��
mean_AW_S = mean(AW_S')';
mean_AW_I = mean(AW_I')';
AW_last = mean_AW_S(length(mean_AW_S)) + mean_AW_I(length(mean_AW_I));
II_last = mean_IN(length(mean_IN)) + mean_IP(length(mean_IP));

I = mean_IN + mean_IP;
A = mean_AW_S + mean_AW_I;

% plot(T, mean_IN,'b');
% hold on
% plot(T, mean_IP,'b');
% title('I(-)��I(+)')

plot(T, A./N,'r');
hold on
plot(T, I./N,'b');
title('I��A')
hold off