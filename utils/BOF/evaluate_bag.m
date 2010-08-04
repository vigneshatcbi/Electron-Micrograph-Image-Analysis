function bag_response = evaluate_bag(input_features, dictionary)
%% Evaluate Bad - Given a bag of features return histogram of centroids
% INPUT:
% input features: N*d matrix of bag of features
% dictionary: #C*d matrix of the dictionary
%
% OUTPUT:
% bag_response: Histogram of centroid distribution
% JV Revision(1) 07/29/2010

[NO_FEAT DIM] = size(input_features);
[NO_CENT DIM1] = size(dictionary);

if(DIM ~= DIM1)
    error('DIMENSIONS DO NOT MATCH');
end

distmat = mat_distance(input_features', dictionary');
[minval, minid] = min(distmat, [], 2);

bag_response = hist(minid, 1:NO_CENT);