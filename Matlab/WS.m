function B=WS_net()
%%% 从有N个节点，每个节点有2K个邻居节点的最近邻耦合网络图通过随机化重连生成WS小世界网路
%% B ——————返回生成网络的邻接矩阵
disp('该程序生成WS小世界网路：');
N=input('请输入最近邻耦合网络中节点的总数N：');
K=input('请输入最近邻耦合网络中每个节点要和单侧多少邻居节点连接 K：');
p=input('请输入随机化重连的概率p:');
if K>floor(N/2)
    disp('输入的K值不合法，请减小K值')
    return;
end
angle=0:2*pi/N:2*pi-2*pi/N;  %%生成最近邻耦合网络的各节点坐标
x=100*sin(angle);
y=100*cos(angle);
plot(x,y,'ro','MarkerEdgeColor','g','MarkerFaceColor','r','markersize',8);
hold on; 

B=zeros(N); %%生成N个元素的0矩阵
for i=1:N
    for j=i+1:i+K
        jj=j;
        if j>N
            jj=mod(j,N);
        end
      B(i,jj)=1; B(jj,i)=1;     %%生成最近邻耦合网络的邻接矩阵
    end
end

for i=1:N
    for j=i+1:i+K
        jj=j;
        if j>N
            jj=mod(j,N);
        end
        p1=rand(1,1);
        if p1<p              %% 生成的随机数小于p，则边进行随机化重连,否则，边不进行重连
            B(i,jj)=0;B(jj,i)=0;  %重连策略：先断开原来的边，再在未连的边中随机选择另一个节点，与原节点连接。
            B(i,i)=inf; a=find(B(i,:)==0);
            rand_data=randint(1,1,[1,length(a)]);
            jjj=a(rand_data);
            B(i,jjj)=1;B(jjj,i)=1;
            B(i,i)=0;
        end
    end
end

for i=1:N 
    for j=i+1:N
        if B(i,j)~=0
            plot([x(i),x(j)],[y(i),y(j)],'linewidth',1.2); 
            hold on;          %% 画出WS小世界网络图
        end
    end
end
axis equal;
hold off  
% save mydata2 B
save B.txt -ascii B

% [C,aver_C]=Clustering_Coefficient(A);
% [DeD,aver_DeD]=Degree_Distribution(A);
% [D,aver_D]=Aver_Path_Length(A);   
%  disp(['该随机图的平均路径长度为：',num2str(aver_D)]);  %%输出该网络的特征参数
%  disp(['该随机图的聚类系数为：',num2str(aver_C)]);
%  disp(['该随机图的平均度为：',num2str(aver_DeD)]);   
