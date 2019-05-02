    % ----------网络生成----------
    adj = cell(N, 1);  %创建一个cell数组作为邻接表
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