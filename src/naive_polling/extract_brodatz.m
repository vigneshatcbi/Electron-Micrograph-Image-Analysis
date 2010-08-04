% -----------------------------------------------------------------
% This program is used to extract the texture features from the 116
% brodatz album texture (49 128x128 images are obtained per class)
% -----------------------------------------------------------------
clear;
sz = 512;


% --------------- generate the Gabor FFT data ---------------------

stage = 4;
orientation = 6;
N = 128;
freq = [0.05 0.4];
flag = 0;

j = sqrt(-1);

for s = 1:stage,
    for n = 1:orientation,
        [Gr,Gi] = Gabor(N,[s n],freq,[stage orientation],flag);
        F = fft2(Gr+j*Gi);
        F(1,1) = 0;
        GW(N*(s-1)+1:N*s,N*(n-1)+1:N*n) = F;
    end;
end;

% -----------------------------------------------------------------

height = 7;
width = 7;
syn_names = {'non_synapses', 'con_synapses', 'rib_synapses', 'non_synapse', 'con_synapse', 'rib_synapse'};
for syn_iter = 1:3
    for i = 0:73,
        texture = imread([syn_names{syn_iter+3} num2str(i) '.tif']);
        texture = adapthisteq(texture);
        A = zeros(stage*orientation*2,height*width);
        for h = 1:height,
            for w = 1:width,
                %[i h w]
                img = texture((h-1)*64+1:(h-1)*64+128, (w-1)*64+1:(w-1)*64+128);
                F = Fea_Gabor_brodatz(img, GW, N, stage, orientation);
                A(:,(h-1)*width+w) = [F(:,1); F(:,2)];
            end;  
        end;
        save(['curr_features/' syn_names{syn_iter+3} num2str(i) '_feat.mat'], 'A'); 
    end;
end;

classify_synpases;