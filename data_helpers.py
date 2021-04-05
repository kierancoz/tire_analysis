import pandas as pd
import numpy as np


def standard_deviation(expected_values, fitted_values):
    squared_errors = [(expected_values[i] - fitted_values[i]) ** 2 for i in range(len(expected_values))]
    return (sum(squared_errors)/len(squared_errors))**0.5