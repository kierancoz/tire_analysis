import scipy.io as sio
import numpy as np
import pandas as pd

# outputs - Rear & front cornering, long, combined data cleaned and classified

def main():
    cornering_variable_sweeps = {"load" : {"sweep" : np.array([-250, -200, -150, -100, -50]) / 0.224809, "label" : "FZ" },
                    "camber" : {"sweep" : np.array([0, 2, 4]), "label" : "IA"},
                    "pressure" : {"sweep" : np.array([8, 10, 12, 14]) * 6.89476, "label" : "P"},
                    "velocity" : {"sweep" : np.array([15, 25, 45]) * 1.60934, "label" : "V"}}

    output_directory = "tire_data/processed_data/"

    data_map = {"cornering_2021_rears": {"data_file_names" : ["tire_data/raw_data/RunData_10inch_Cornering_Matlab_SI_Round6/B1654run21.mat",
                "tire_data/raw_data/RunData_10inch_Cornering_Matlab_SI_Round6/B1654run22.mat"], "sweeps" : cornering_variable_sweeps}}

    for output_name, data_info in data_map.items():
        # load matlab file and convert to pandas df
        loaded_data = [sio.loadmat(file_name) for file_name in data_info["data_file_names"]]
        df = clean_data(loaded_data)

        # classify sweeps on data
        for variable, info in data_info["sweeps"].items():
            temp_nearest_func = lambda x: get_nearest_value(info["sweep"], x)
            df[variable] = df[info["label"]].apply(temp_nearest_func)

        # period of oscillation is ~ 10.5 data points, remove oscillation
        for target_var in ["FY", "FX", "FZ"]:
            df[target_var] = moving_average(df[target_var], 10)

        # export data back to matlab file
        sio.savemat(f'{output_directory}{output_name}.mat', df.to_dict("list"))
        
def clean_data(datas):
    return_df = None
    for data in datas:
        required_length = len(data["FY"])
        for x in list(data.keys()):
            if len(data[x]) != required_length:
                del data[x] # removes unnecessary data
            else:
                data[x] = data[x].transpose()[0] # cleans necessary data
        return_df = pd.concat([return_df, pd.DataFrame.from_dict(data)])
    return return_df

def get_nearest_value(possible_values, input_value):
    closest_value, distance = None, 0
    for value in possible_values:
        test_dist = abs(value - input_value)
        if not distance or test_dist < distance:
            distance = test_dist
            closest_value = value
    return closest_value

def moving_average(interval, window_size):
    window = np.ones(int(window_size))/float(window_size)
    return np.convolve(interval, window, 'same')

if __name__ == "__main__":
    main()