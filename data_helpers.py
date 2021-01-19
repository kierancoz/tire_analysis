import pandas as pd

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

