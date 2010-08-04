function loc_of_anomaly = kolmogorov_anomaly(data)
loc_of_anomaly = 1;
while size(data,1) > 2
left_dist = CDM(data(1:floor(end/2),:),data);
right_dist = CDM(data(ceil(end/2):end,:),data);
if left_dist < right_dist
loc_of_anomaly = loc_of_anomaly + size(data,1) / 2;
data = data(ceil(end/2):end,:);
else
data = data(1:floor(end/2),:);
end
end