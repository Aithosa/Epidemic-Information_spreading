    % ----------��������----------
    adj = cell(N, 1);  %����һ��cell������Ϊ�ڽӱ�
    for i = 1 : N
        for j = i+1 : N
            if rand < p
                adj{i} = [adj{i}, j];
                adj{j} = [adj{j}, i];
                % A(i, j) = 1;
                % A(j, i) = 1;
            end
            
        end
    end