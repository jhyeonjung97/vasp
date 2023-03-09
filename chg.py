import os
import numpy as np
from sys import argv

data = [] 
length = []
number = int(argv[1])
filename = argv[2]

# for i in range(1,number+1):
#     chg = np.loadtxt("ACF%s.dat" % i, dtype=str)[:,4]
#     data.append(chg)

for file in os.listdir('./'):
    if file.startswith('ACF') and file.endswith('.dat'):
        chg = np.loadtxt(file, dtype=str)[:,4]
        length.append(len(chg))
        data.append(chg)

data.shape
data.ndim
reshape.data(-1,-1)
data.shape
data.ndim
# reshape.data(data.ndim,max(length))
# np.savetxt("%s.csv" % filename, np.transpose(data), delimiter =", ", fmt ='% s')