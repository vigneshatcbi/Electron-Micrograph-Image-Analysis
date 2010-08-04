function Im = cbi_mser(I, mint, maxt, stept)

if(nargin < 2)
    mint = .05;
    stept = .05;
    maxt = .95;
end

count = 1;
for iter = mint:stept:maxt
    Ibw(:,:,count) = im2bw(I, iter);
    count = count + 1;
end

Im = sum(Ibw, 3);
Im(Im>0) = 1;
Im = logical(Im);
Im = abs(Im-1);