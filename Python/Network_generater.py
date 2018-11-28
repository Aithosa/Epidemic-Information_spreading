
# coding: utf-8

# # Generate network

# In[1]:
import networkx as nx

import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import seaborn as sns


# In[2]:
ER = nx.random_graphs.erdos_renyi_graph(2000, 0.0075)   # n, p


# In[3]:
# WS = nx.random_graphs.watts_strogatz_graph(2000, 4, 0.3)    
# n - The number of nodes
# k - Each node is joined with its `k` nearest neighbors in a ring topology.
# p - The probability of rewiring each edge


# In[4]:
# BA = nx.random_graphs.barabasi_albert_graph(2000, 3)
# n - Number of nodes
# m - Number of edges to attach from a new node to existing nodes


# In[5]:
# BA_2000_3 = nx.to_numpy_matrix(BA)
# WS_2000_4_03 = nx.to_numpy_matrix(WS)
ER_2000_02 = nx.to_numpy_matrix(ER)


# In[6]:
# np.savetxt('BA_2000_2.csv', BA_2000_2, fmt = '%d', delimiter = ',')
# np.savetxt('WS_2000_4_03.csv', WS_2000_4_03, fmt = '%d', delimiter = ',')
np.savetxt('ER_2000_0003.csv', ER_2000_02, fmt = '%d', delimiter = ',')

