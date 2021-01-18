import scipy.io as sio
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import pandas as pd
import numpy as np
import data_helpers

# take data and turn it into a pandas dataframe
data_files_names = ["rear_tire/RunData_10inch_Cornering_Matlab_SI_Round6/B1654run21.mat",
                "rear_tire/RunData_10inch_Cornering_Matlab_SI_Round6/B1654run22.mat"]     
   
datas = [sio.loadmat(file_name) for file_name in data_files_names]

df = data_helpers.clean_data(datas)

# create clasification columns based on sweeps
variable_sweeps = {"load" : {"sweep" : np.array([-250, -200, -150, -100, -50]) / 0.224809, "label" : "FZ" },
                    "camber" : {"sweep" : np.array([0, 2, 4]), "label" : "IA"},
                    "pressure" : {"sweep" : np.array([8, 10, 12, 14]) * 6.89476, "label" : "P"},
                    "velocity" : {"sweep" : np.array([15, 25, 45]) * 1.60934, "label" : "V"}}

for variable, info in variable_sweeps.items():
    temp_nearest_func = lambda x: data_helpers.get_nearest_value(info["sweep"], x)
    df[variable] = df[info["label"]].apply(temp_nearest_func)

# plot each classification as a different color on a slip angle vs lateral force graph
# for i, g in df.groupby(list(variable_sweeps.keys())):
#     plt.plot(g["SA"], g["FY"])
# plt.show()

# plot a specific set of conditions on a graph
conditions = df[(df["camber"] == variable_sweeps["camber"]["sweep"][0]) & (df["velocity"] == variable_sweeps["velocity"]["sweep"][0])]
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot_wireframe(conditions["SA"], conditions["FZ"], np.array([conditions["FY"], conditions["FY"]]))
plt.show()