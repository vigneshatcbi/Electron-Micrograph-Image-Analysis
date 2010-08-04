function feat = cbi_textonfeat(img_patch, F)

%% Convolves the Input Patch with the texton dictionary and returns
%% filtered responses of the patch with all filters in the filter bank
% INPUT:
% img_patch - Input Patch
% FILTER_BANK - Requried Filter Bank
% OUTPUT:
% feat - Computed Feature vector from the input patch
% feat \in R[#FILTERS*#STATISTICS]

if( ( size(img_patch,1) ~= size(img_patch,2) ) || size(img_patch,3)>1 )
    error('Please Input GRAYSCALE SQUARE Patches');
end

[filt_size_x filtsize_y no_filters] = size(F);
img_patch = double(img_patch);
feat = zeros(2, no_filters);
N = size(img_patch,1);

for filter_iter = 1:no_filters
    D = imfilter(img_patch, F(:,:,filter_iter), 'replicate', 'conv');
    feat(1, filter_iter) = mean(D(:));
    feat(2, filter_iter) = sqrt(mean(mean(( D - feat(1, filter_iter) * ones(N,N) ).^2)));
end