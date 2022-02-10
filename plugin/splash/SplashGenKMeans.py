import sys
import csv
from sklearn.cluster import KMeans

with open('SplashGenPoints.csv', mode ='r')as file:
    csvFile = csv.reader(file)
    points = list(csvFile)

if len(sys.argv) == 1:
    k = 16
else:
    k = int(sys.argv[1])

kmeans = KMeans(n_clusters=k)
y_km = kmeans.fit_predict(points)
clusters = kmeans.cluster_centers_

oldColorCodes = list(map(lambda x: "'#{:02x}{:02x}{:02x}'".format(int(x[0]),int(x[1]),int(x[2])), points))
newColorCodes = list(map(lambda x: "'#{:02x}{:02x}{:02x}'".format(round(x[0]),round(x[1]),round(x[2])), clusters))

print("    let s:newColors = [" + ",".join(newColorCodes) + ", '#000000','#ffffff']")
for oldCode,i in zip(oldColorCodes, y_km.tolist()):
    print("    call s:ChangeColor({:s}, {:s})".format(oldCode, newColorCodes[i]))
