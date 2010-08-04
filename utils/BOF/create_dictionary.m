function dictionary = create_dictionary(input_features, no_clusters)
%% Function to create dictionary of features ...
% Performs a K-means clustering
% INPUT:
% input_features: is a N*d matrix containing a feature vector along each row
% no_clusters:    is the number of cluster centers requried
%
% OUTPUT
% dictionary: #C*d matrix containing the dictionary
% JV Revision(1) 07/29/2010

stacked_features = [];
if(size(input_features,3) > 1)
    for iter = 1:size(input_features,3)
        stacked_features = [stacked_features; input_features(:,:,iter)];
    end
else
    stacked_features = input_features;
end

[IDX, dictionary, SUMD] = kmeans(stacked_features, no_clusters, 'Replicates', 10);