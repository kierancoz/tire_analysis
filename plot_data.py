import scipy.io as sio
from matplotlib import pyplot as plt
import pandas as pd


data = sio.loadmat("rear_tire/RawData_10inch_Cornering_Matlab_SI/B1654raw21.mat")
data2 = sio.loadmat("rear_tire/RawData_10inch_Cornering_Matlab_SI/B1654raw22.mat")

plt.plot(data["SA"], data["FY"])
plt.show()

# split data based on the following criteria:
    # FZ changes
    #