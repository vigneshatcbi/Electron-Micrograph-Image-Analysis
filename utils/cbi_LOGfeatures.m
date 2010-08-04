function log_feature = cbi_LOGfeatures(LOG, patches)

NUM_PATCHES = size(patches, 3);
log_feature = zeros(NUM_PATCHES, size(LOG,1)*size(LOG,2), 2);

for patch_iter = 1:NUM_PATCHES
    count = 1;
    for scale_iter = 1:size(LOG,1)
        for orient_iter = 1:size(LOG,2)
            patches(:,:,patch_iter) = vrl_imsmooth(patches(:,:,patch_iter), 13, 5);
            filtResponse = imfilter(patches(:,:,patch_iter), LOG{scale_iter, orient_iter},'same');
            figure(1); subplot(211); imshow(patches(:,:,patch_iter)); subplot(212); imshow(filtResponse); title(num2str(scale_iter)); pause;
            log_feature(patch_iter, count, 1) = mean(filtResponse(:));
            log_feature(patch_iter, count, 2) = var(double(filtResponse(:)));
            count = count + 1;
        end
    end
end