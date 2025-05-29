import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.linear_model import LinearRegression
import sys

# Read the data from a file given as a command line argument
def read_data(file_path):
    data = np.loadtxt(file_path)
    return data[:, 0], data[:, 1], data[:, 2]

# Fit a straight line to the 3D data
def fit_line(x, y, z):
    # Stack X and Y as features for regression
    X = np.column_stack((x, y))
    model = LinearRegression()
    model.fit(X, z)
    z_pred = model.predict(X)
    return z_pred, model

# Plot the points and fitted line in 3D
def plot_3d(x, y, z, z_pred):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(x, y, z, color='blue', label='Data Points')
    ax.plot(x, y, z_pred, color='red', label='Fitted Line')
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.legend()
    plt.show()

# Main execution
if __name__ == "__main__":
    # Ensure a file path is provided
    if len(sys.argv) < 2:
        print("Usage: python script.py <file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    x, y, z = read_data(file_path)
    z_pred, model = fit_line(x, y, z)
    plot_3d(x, y, z, z_pred)

