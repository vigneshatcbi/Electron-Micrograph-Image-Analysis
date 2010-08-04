function accuracy = cbi_classify(varargin)

TRAIN_NUM = 30;
if(nargin < 1)
    load('HISTEQ_FEAT_SYNNON.mat');
else
    SYNfeatbag = varargin{1};
    NONfeatbag = varargin{2};
end

shuffle = randperm(74);
train_syn_set = []; train_syn_labels = [];
train_non_set = []; train_non_labels = [];
test_syn_set = [];  test_syn_labels = [];
test_non_set = [];  test_non_labels = [];
for iter = 1:TRAIN_NUM
    curr_features = [SYNfeatbag{shuffle(iter)}(:,:,1) SYNfeatbag{shuffle(iter)}(:,:,2)];
    train_syn_set = [train_syn_set; curr_features];
    train_syn_labels = [train_syn_labels; 1*ones(size(curr_features,1),1)];
    curr_features = [NONfeatbag{shuffle(iter)}(:,:,1) NONfeatbag{shuffle(iter)}(:,:,2)];
    train_non_set = [train_non_set; curr_features];
    train_non_labels = [train_non_labels; 2*ones(size(curr_features,1),1)];
end

for iter = TRAIN_NUM+1:74
    curr_features = [SYNfeatbag{shuffle(iter)}(:,:,1) SYNfeatbag{shuffle(iter)}(:,:,2)];
    test_syn_set = [test_syn_set; curr_features];
    test_syn_labels = [test_syn_labels; 1*ones(size(curr_features,1),1)];
    curr_features = [NONfeatbag{shuffle(iter)}(:,:,1) NONfeatbag{shuffle(iter)}(:,:,2)];
    test_non_set = [test_non_set; curr_features];    
    test_non_labels = [test_non_labels; 2*ones(size(curr_features,1),1)];
end

% Perform Classification
train_set = [train_syn_set; train_non_set];  train_labels = [train_syn_labels; train_non_labels];
test_set = [test_syn_set; test_non_set];     test_labels  = [test_syn_labels; test_non_labels]; 

pred_labels = classify(test_set, train_set, train_labels);

CM = confusionmat(test_labels, pred_labels);
da_accuracy = sum(diag(CM)) ./ sum(CM(:))

reshape_labels = mode( reshape(pred_labels, size(SYNfeatbag{shuffle(iter)},1), 2.*(74-TRAIN_NUM) ) )';
true_labels = [ones(74-TRAIN_NUM, 1); 2.*ones(74-TRAIN_NUM, 1)];
CM_finalda = confusionmat(reshape_labels, true_labels);
final_da_accuracy = (CM_finalda(1)+CM_finalda(4)) / sum(CM_finalda(:))

model = svmtrain(train_labels, train_set);
[predicted_label, svm_accuracy, prob_estimates] = svmpredict(test_labels, test_set, model);

reshape_labels = mode( reshape(pred_labels, size(SYNfeatbag{shuffle(iter)},1), 2.*(74-TRAIN_NUM) ) )';
true_labels = [ones(74-TRAIN_NUM, 1); 2.*ones(74-TRAIN_NUM, 1)];
CM_finalsvm = confusionmat(reshape_labels, true_labels);
final_svm_accuracy = (CM_finalsvm(1)+CM_finalsvm(4)) / sum(CM_finalsvm(:))

train_labels(train_labels == 2) = -1;
test_labels(test_labels == 2) = -1;

classifier = gentleBoost(train_set, train_labels, 10);
[pred_labels, Fx] = strongGentleClassifier(test_set, classifier);
CM = confusionmat(test_labels, pred_labels);
boost_accuracy = sum(diag(CM)) ./ sum(CM(:))

reshape_labels = mode( reshape(pred_labels, size(SYNfeatbag{shuffle(iter)},1), 2.*(74-TRAIN_NUM) ) )';
true_labels = [ones(74-TRAIN_NUM, 1); -1.*ones(74-TRAIN_NUM, 1)];
CM_finalboost = confusionmat(reshape_labels, true_labels);
final_boost_accuracy = (CM_finalboost(1)+CM_finalboost(4)) / sum(CM_finalboost(:))