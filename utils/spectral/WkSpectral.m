function w=WkSpectral(k,idx,DistanceMatrix)
% called by GapSpectral

for r =1:k
    % find points in cluster r
    pr = find(idx==r);
    D(r) = 0;
    for i=1:size(pr,1)
        for j=i:size(pr,1)
            D(r) = D(r)+DistanceMatrix(pr(i),pr(j));
        end
    end
    D(r) = D(r)/(2*size(pr,1)); %(2) in paper
end

w =  sum(D);
    
