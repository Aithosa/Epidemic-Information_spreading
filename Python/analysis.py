import networkx as nx
import numpy as np
import pandas as pd
import scipy.io as scio

dataFile = '../Matlab/data/BA_2000_3.mat'  
data = scio.loadmat(dataFile)
data['A'].shape

BA = nx.Graph(data['A'])
average_shortest_path_length = nx.average_shortest_path_length(BA)
print('average shortest path length: ', average_shortest_path_length)

#计算图的平均度
def average_degree(G):
    dict_vertex_degree = G.degree()    #提取出所有的度
    df_vertex_degree = pd.DataFrame(list(dict(dict_vertex_degree).items()), columns=['vertex','degree'])    #转换为dataframe
    aver_degree = df_vertex_degree['degree'].mean()    #求平均
    k_2 = df_vertex_degree['degree']**2
    aver_degree_square = k_2.mean()
    return aver_degree, aver_degree_square

degrees = average_degree(BA)
print("<k>：",degrees[0])

print("BA: lambd_c = ",degrees[0]/degrees[1])
print("WS/ER: lambd_c = ",1/degrees[0])