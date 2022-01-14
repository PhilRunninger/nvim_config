import csv
from sklearn.cluster import KMeans
# import numpy as np
# import matplotlib.pyplot as plt

# opening the CSV file
with open('SplashGenPoints.csv', mode ='r')as file:
    csvFile = csv.reader(file)
    points = list(csvFile)

kmeans = KMeans(n_clusters=16)
y_km = kmeans.fit_predict(points)
clusters = kmeans.cluster_centers_

oldColorCodes = list(map(lambda x: "'#{:02x}{:02x}{:02x}'".format(int(x[0]),int(x[1]),int(x[2])), points))
newColorCodes = list(map(lambda x: "'#{:02x}{:02x}{:02x}'".format(round(x[0]),round(x[1]),round(x[2])), clusters))

print(','.join(newColorCodes) + ',')
print('')

for oldCode,i in zip(oldColorCodes, y_km):
    print("    call s:ChangeColor({:s}, {:s})".format(oldCode, newColorCodes[i]))
