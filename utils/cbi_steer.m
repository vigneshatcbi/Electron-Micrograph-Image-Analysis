clear;
close all;
clc;

for iter = 0:9
I = histeq(imread(['synpatch' num2str(iter) '.tif']));

% [PYR, INDICES] = buildLpyr(double(I));
% figure(1); RANGE = showLpyr (PYR, INDICES); pause(.5);
% 
% [PYR, INDICES] = buildWpyr(double(I));
% figure(2); RANGE = showWpyr (PYR, INDICES); pause(.5);
% 
% [PYR, INDICES] = buildSpyr(double(I));
% figure(3); RANGE = showSpyr (PYR, INDICES); pause(.5);
[CA CB CC CD] = dwt2(I, 'db1');
figure; subplot(221); imagesc(CA); subplot(222); imagesc(CB); subplot(223); imagesc(CC); subplot(224); imagesc(CD);
CA_e = entropy2(CA);CB_e = entropy2(CB);CC_e = entropy2(CC);CD_e = entropy2(CD);
[CA_e CB_e CC_e CD_e]
end