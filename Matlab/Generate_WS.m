function B=WS_net()
%%% ����N���ڵ㣬ÿ���ڵ���2K���ھӽڵ��������������ͼͨ���������������WSС������·
%% B ��������������������������ڽӾ���
disp('�ó�������WSС������·��');
N=input('�������������������нڵ������N��');
K=input('��������������������ÿ���ڵ�Ҫ�͵�������ھӽڵ����� K��');
p=input('����������������ĸ���p:');
if K>floor(N/2)
    disp('�����Kֵ���Ϸ������СKֵ')
    return;
end
angle=0:2*pi/N:2*pi-2*pi/N;  %%����������������ĸ��ڵ�����
x=100*sin(angle);
y=100*cos(angle);
plot(x,y,'ro','MarkerEdgeColor','g','MarkerFaceColor','r','markersize',8);
hold on; 

B=zeros(N); %%����N��Ԫ�ص�0����
for i=1:N
    for j=i+1:i+K
        jj=j;
        if j>N
            jj=mod(j,N);
        end
      B(i,jj)=1; B(jj,i)=1;     %%������������������ڽӾ���
    end
end

for i=1:N
    for j=i+1:i+K
        jj=j;
        if j>N
            jj=mod(j,N);
        end
        p1=rand(1,1);
        if p1<p              %% ���ɵ������С��p����߽������������,���򣬱߲���������
            B(i,jj)=0;B(jj,i)=0;  %�������ԣ��ȶϿ�ԭ���ıߣ�����δ���ı������ѡ����һ���ڵ㣬��ԭ�ڵ����ӡ�
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
            hold on;          %% ����WSС��������ͼ
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
%  disp(['�����ͼ��ƽ��·������Ϊ��',num2str(aver_D)]);  %%������������������
%  disp(['�����ͼ�ľ���ϵ��Ϊ��',num2str(aver_C)]);
%  disp(['�����ͼ��ƽ����Ϊ��',num2str(aver_DeD)]);   
