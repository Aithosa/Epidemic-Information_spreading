function A = BA_net()
%%% �����е�m0���ڵ�����翪ʼ�����������������������ӵĻ�������BA�ޱ������
%% A �� ��������������ڽӾ���
m0 = input('δ����ǰ������ڵ����m0:  ');
m = input('ÿ��������½ڵ�ʱ�����ɵı���m�� ');
N = input('������������ģN�� ');
disp('��ʼ����ʱm0���ڵ�����������1��ʾ���ǹ�����2��ʾ������ȫͼ��3��ʾ�������һЩ��');
pp = input('��ʼ�������1��2��3�� ');
if m > m0
    disp('�������m���Ϸ�');
    return;
end

% x��y�������ǣ��ƺ���Ϊ����ͼ������
x = 100 * rand(1, m0);
y = 100 * rand(1, m0);

switch  pp
    case 1  
        A = zeros(m0);	% m0���Ĺ����ڵ�
    case 2
        A = ones(m0);	% m0���ڵ����ȫͼ�������Լ������Լ�������������1
        for i = 1:m0
            A(i, i) = 0;
        end
    case 3	% ���ﲻ�ȶ�������𣿶�̬����
        for i = 1:m0
            for j = i+1:m0
                p1 = rand(1, 1);	% ����һ�������
                if p1 > 0.5 
                    A(i, j) = 1; A(j, i) = 0;	% ����ͼ���Գ������ɵľ���ֻ�������ǿ�������
                end
            end
        end
    otherwise
        disp('�������pp���Ϸ�');
        return;          
end 

for k = m0 + 1:N
    M = size(A, 1);
    p = zeros(1, M);
    x0 = 100 * rand(1, 1); y0 = 100 * rand(1, 1);
    x(k) = x0; y(k) = y0;
    if length(find(A == 1)) == 0
        p(:) = 1 / M;
    else
		for i = 1:M
		 p(i) = length(find(A(i, :) == 1)) / length(find(A == 1));
		end
    end
    pp = cumsum(p);		%���ۼƸ���
    for i = 1:m		%���ö��ַ������еĽڵ������ѡ��m���ڵ����¼���Ľڵ�����
        random_data = rand(1, 1);
        aa = find(pp >= random_data); jj = aa(1); % �ڵ�jj��Ϊ�ö��ַ�ѡ��Ľڵ�
        A(k, jj) = 1; A(jj, k) = 1;
    end
end

% ��ͼ
plot(x, y, 'ro', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'r', 'markersize', 8);
hold on;
for i = 1:N 
    for j = i + 1:N
        if A(i, j) ~= 0
            plot([x(i), x(j)], [y(i), y(j)], 'linewidth', 1.2); 
            hold on;	%% ����BA�ޱ������ͼ
        end
    end
end
axis equal;
hold off;
save BA_large A
end