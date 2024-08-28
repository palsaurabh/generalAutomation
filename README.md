# generalAutomation
Contains Scripts for day to day work automation
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import find_peaks

# Load data
data = pd.read_csv('market_data.csv', parse_dates=['Date'])

# Calculate rolling means to smooth the data (Simple Moving Average)
window_size = 5
data['SMA_High'] = data['High'].rolling(window=window_size).mean()
data['SMA_Low'] = data['Low'].rolling(window=window_size).mean()

# Detect local maxima and minima
peaks_high, _ = find_peaks(data['SMA_High'].dropna(), distance=window_size)
peaks_low, _ = find_peaks(-data['SMA_Low'].dropna(), distance=window_size)

# Extract peak values for regression
highs = data['SMA_High'].iloc[peaks_high]
lows = data['SMA_Low'].iloc[peaks_low]

# Perform linear regression to find the resistance and support lines
x_high = np.arange(len(highs))
x_low = np.arange(len(lows))

slope_high, intercept_high = np.polyfit(x_high, highs, 1)
slope_low, intercept_low = np.polyfit(x_low, lows, 1)

# Generate the support and resistance lines
data['Resistance'] = slope_high * np.arange(len(data)) + intercept_high
data['Support'] = slope_low * np.arange(len(data)) + intercept_low

# Plot the data
plt.figure(figsize=(14, 7))
plt.plot(data['Date'], data['High'], label='High Prices', alpha=0.5)
plt.plot(data['Date'], data['Low'], label='Low Prices', alpha=0.5)
plt.plot(data['Date'], data['Resistance'], label='Resistance Line (Upper)', linestyle='--', color='red')
plt.plot(data['Date'], data['Support'], label='Support Line (Lower)', linestyle='--', color='green')
plt.title('Trading Channel Detection')
plt.xlabel('Date')
plt.ylabel('Price')
plt.legend()
plt.grid(True)
plt.show()