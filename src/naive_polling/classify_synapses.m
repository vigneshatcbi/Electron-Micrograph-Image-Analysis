function classify_synpases()

clear all; close all; clc;


non_features = [];  con_features = [];  rib_features = [];

imshuff = randperm(74) - 1;
for i = 1:74
    load(['ahisteq_features/non_synapse' num2str(imshuff(i)) '_feat.mat']);
    %non_features(:,:,i+1) = A;
    % M = A(1:24,:); M = M ./ repmat( sqrt(sum(M.^2,1)), size(M,1), 1);    V = A(25:end,:); V = V ./ repmat( sqrt(sum(V.^2,1)), size(V,1), 1);    A = [M; V];
    non_features = [non_features A];
    load(['ahisteq_features/con_synapse' num2str(imshuff(i)) '_feat.mat']);
    %con_features(:,:,i+1) = A;
    % M = A(1:24,:); M = M ./ repmat( sqrt(sum(M.^2,1)), size(M,1), 1);    V = A(25:end,:); V = V ./ repmat( sqrt(sum(V.^2,1)), size(V,1), 1);    A = [M; V];
    con_features = [con_features A];
%     load(['/home/biostation/Desktop/texture_example/histeq_features/rib_synapse' num2str(i) '_feat.mat']);
%     %rib_features(:,:,i+1) = A;
%     rib_features = [rib_features A];
end

TRAIN_NUM = 50; TRAIN_END = TRAIN_NUM*49; TEST_BEGIN = TRAIN_END+1; TEST_SIZE = 3626-TRAIN_END;

% Randomizing the test order
shuffled = 1:3626;

% Train set is obtained by appending non_features and con_features randomly
% picked
train_set = [non_features(:,shuffled(1:TRAIN_END))'; con_features(:,shuffled(1:TRAIN_END))'];
% Train labels are assigned accordingly
train_labels = [ones(TRAIN_END,1); 2.*ones(TRAIN_END,1)]; 
% Test set is obtained by appending non_synapses and con_synapses randomly
test_set = [non_features(:,shuffled(TEST_BEGIN:end))'; con_features(:,shuffled(TEST_BEGIN:end))'];
% Test labels are assigned by the same ordering
test_labels = [ones(TEST_SIZE,1); 2.*ones(TEST_SIZE,1)];
class = classify(test_set, train_set, train_labels);
model = svmtrain(train_labels, train_set);
svmpredict(test_labels, test_set, model);

reshape_class = reshape(class, 49, []);
for iter = 1:size(reshape_class,2)
    img_class(iter,1) = mode(reshape_class(:,iter));
    img_sizes(iter,1) = numel(find(reshape_class(:,iter)==1));
    img_sizes(iter,2) = numel(find(reshape_class(:,iter)==2));
end
true_img_class = [ones(74-TRAIN_NUM,1); 2.*ones(74-TRAIN_NUM,1)];
CM = confMatrix( test_labels, class, 2 );
confMatrixShow(CM);

img_CM = confMatrix( true_img_class, img_class, 2 );
confMatrixShow(img_CM);

synconf = img_sizes(1:74-TRAIN_NUM,:)
nonconf = img_sizes(74-TRAIN_NUM+1:end,:)