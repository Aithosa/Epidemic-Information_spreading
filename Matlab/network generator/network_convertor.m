% load("..\data\BA_2000_3")

N = length(A);  % 网络节点�?

% ---------- 转换为邻接表 ----------
adj = cell(N, 1);  %创建�?个cell数组作为邻接�?

for i = 1 : N
    neighbors = find(A(i, :) == 1);
    adj{i} = [neighbors];
end