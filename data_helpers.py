import pandas as pd
import numpy as np
import scipy.io as sio

def import_data(data, raw_data = False):
    required_length = len(data["FY"])
    for x in list(data.keys()):
        if len(data[x]) != required_length:
            # removes unnecessary data
            del data[x] 
        else:
            # cleans necessary data
            data[x] = data[x].transpose()[0] if raw_data else data[x][0] 
    return pd.DataFrame.from_dict(data)

def import_datas(datas, raw_data = False):
    return_df = None
    for data in datas:
        return_df = pd.concat([return_df, import_data(data, raw_data)])
    return return_df

def standard_deviation(expected_values, fitted_values):
    squared_errors = [(expected_values[i] - fitted_values[i]) ** 2 for i in range(len(expected_values))]
    return (sum(squared_errors)/len(squared_errors))**0.5