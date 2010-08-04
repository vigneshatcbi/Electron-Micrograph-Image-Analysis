clear; close all; clc;


% Script for testing the viability of an interest point detector for vesicles... 
for imgiter = 1:73
SYN = uint8( vrl_imsmooth(imread(['con_synapse' num2str(imgiter) '.tif']), 11, 7) );
NON = uint8( vrl_imsmooth(imread(['non_synapse' num2str(imgiter) '.tif']), 11, 7) );
I{1} = adapthisteq( SYN );
I{2} = adapthisteq( NON );

for var_iter = 9
    for iter = 1:2
        F = fspecial('log', [71 71], var_iter);    
        FR = imfilter(double(I{iter}), F, 'replicate', 'conv')*100;

        % Detect Interest Points and Keep K(15) strongest points
        bw = FR > imdilate(FR, [1 1 1; 1 0 1; 1 1 1]);
        bw(1,:) = 0; bw(:,1) = 0; bw(end,:)= 0; bw(:,end)= 0;
        [y{iter} x{iter}]  =find(bw);

        resmag{iter} = FR(sub2ind(size(FR), y{iter}, x{iter})); 
        K = 50;
        [sort_val sort_ind] = sort(resmag{iter}, 'descend');
        y{iter}(sort_ind(K+1:end)) = [];
        x{iter}(sort_ind(K+1:end)) = [];
        resmag{iter}(sort_ind(K+1:end)) = [];
    end
        % Plot Filter Response and Interest Points
        figure(1);
        subplot(221); imshow(uint8(I{1})); hold on; plot(x{1}, y{1}, 'r*'); hold off;
        subplot(223); imshow(uint8(I{2})); hold on; plot(x{2}, y{2}, 'r*'); hold off;
        subplot(222); hist(resmag{1});    
        M(imgiter,1) = mean(resmag{1}(:));   MD(imgiter,1) = var(resmag{1}(:));
        M(imgiter,2) = mean(resmag{2}(:));   MD(imgiter,2) = var(resmag{2}(:));
        tit_str = ['M:' num2str(M(imgiter,1)) '|||MD:' num2str(MD(imgiter,1))];
        title(tit_str); axis tight;
        subplot(224); hist(resmag{2});
        tit_str = ['M:' num2str(M(imgiter,2)) '|||MD:' num2str(MD(imgiter,2))];
        title(tit_str); axis tight;
end
end

save('curr_features\temp.mat','M', 'MD');