function [trainset trainlabels testset testlabels] = cbi_parsefeatures(PARSER)

cd(PARSER.feat_dir);
load(PARSER.filename);
shuffle_order = randperm(PARSER.NUM_IMAGES);
trainset = []; testset = []; trainlabels = []; testlabels = [];

NUM_DIFF = size( featbag{1,1}, 3);

% Create Training Set
count = 1;
for syniter = 1:2
    for imgiter = 1:PARSER.TRAIN_NUMBER
        if(NUM_DIFF == 2)
            curr_feature = [featbag{syniter, shuffle_order(imgiter)}(:,:,1) featbag{syniter, shuffle_order(imgiter)}(:,:,2)];
        else
            curr_feature = featbag{syniter, shuffle_order(imgiter)}(:,:,1);
        end
        
        if(PARSER.stackup)
            trainset = [trainset; curr_feature];
            trainlabels = [trainlabels; syniter.*ones(size(curr_feature, 1), 1)];
        else
            trainset(:,:,count) = curr_feature;
            trainlabels(:,:,count) = syniter.*ones(size(curr_feature, 1), 1);
        end
        count = count + 1;
    end
end

% Create Test Set
count = 1;
for syniter = 1:2
    for imgiter = PARSER.TRAIN_NUMBER+1:PARSER.NUM_IMAGES
        if(NUM_DIFF == 2)
            curr_feature = [featbag{syniter, shuffle_order(imgiter)}(:,:,1) featbag{syniter, shuffle_order(imgiter)}(:,:,2)];
        else
            curr_feature = featbag{syniter, shuffle_order(imgiter)}(:,:,1);
        end
        if(PARSER.stackup)
            testset = [testset; curr_feature];
            testlabels = [testlabels; syniter.*ones(size(curr_feature, 1), 1)];
        else
            testset(:,:,count) = curr_feature;
            testabels(:,:,count) = syniter.*ones(size(curr_feature, 1), 1);
        end
        count = count + 1;
    end
end