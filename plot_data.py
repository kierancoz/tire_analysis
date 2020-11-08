import scipy.io as sio
from matplotlib import pyplot as plt
import pandas as pd
import numpy as np

data = sio.loadmat("rear_tire/RunData_10inch_Cornering_Matlab_SI/B1654run21.mat")
data2 = sio.loadmat("rear_tire/RunData_10inch_Cornering_Matlab_SI/B1654run22.mat")

def clean_data(data):
    required_length = len(data["FY"])
    for x in list(data.keys()):
        if len(data[x]) != required_length:
            del data[x] # removes unnecessary data
        else:
            data[x] = data[x].transpose()[0] # cleans necessary data

clean_data(data)
clean_data(data2)
df = pd.concat([pd.DataFrame.from_dict(data), pd.DataFrame.from_dict(data2)])

print(df.shape)
print(df.head)

plt.plot(df["SA"], df["FY"])
#plt.show()