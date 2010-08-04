function feat = cbi_texturefeat(img_patch, FILTER_BANK)

%% Convolves the Input Patch with the MM dictionary and returns
%% filtered responses of the patch with all filters in the filter bank
% INPUT:
% img_patch - Input Patch
% FILTER_BANK - Requried Filter Bank
% stage - #SCALES
% orientation - #ORIENTATIONS
% OUTPUT:
% feat - Computed Feature vector from the input patch
% feat \in R[#FILTERS*#STATISTICS]

A = fft2(img_patch);

N = size(img_patch,1);
if(size(img_patch,1)  ~= size(img_patch,2) )
    error('Patches must be square');
end

NUM_FILTERS = size(FILTER_BANK, 3);
feat = zeros(2, NUM_FILTERS);
z = zeros(1,2);
count = 1;
%% This function simply concatenates the mean and variance of the patches
for filt_iter = 1:NUM_FILTERS    
        D = abs(ifft2(A.*FILTER_BANK(:,:,filt_iter))); % Obtaining mean and variance in time domain
        feat(1,count) = mean(mean(D));
        feat(2,count) = sqrt(mean(mean((D-feat(1,count)*ones(N,N)).^2))); 
        count = count + 1;
end;