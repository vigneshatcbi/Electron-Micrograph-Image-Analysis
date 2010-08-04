clear; close all; clc;

% Set up parameter for feature extraction
NUM_IMAGES = 9;
SPLITINFO.TYPE = 'nonoverlap'; SPLITINFO.N = 31;
FILTERINFO.F = cbi_gabordictionary(4, 6, SPLITINFO.N, [0.05 0.4], 0); FILTERINFO.ID = 1;
for syniter = 1:1:2
    for imgiter = 1:NUM_IMAGES
        if(syniter==1)
             I = ( double(adapthisteq(imread(['con_synapse' num2str(imgiter) '.tif']))) );
        else
             I = ( double(adapthisteq(imread(['non_synapse' num2str(imgiter) '.tif']))) );
        end
        SPLITINFO.img = double(I);
        [imgbag featbag{syniter, imgiter} X] = cbi_bagimg(SPLITINFO, FILTERINFO);
    end
end
save('curr_features\gabwav.mat', 'featbag');

% PARSE FEATURES
PARSER.NUM_IMAGES = NUM_IMAGES; PARSER.TRAIN_NUMBER = round(.7*NUM_IMAGES); PARSER.TEST_NUMBER = NUM_IMAGES - PARSER.TRAIN_NUMBER;
PARSER.filename = 'gabwav.mat'; PARSER.feat_dir = [pwd '\curr_features\']; PARSER.stackup = false;
[trainset trainlabels testset testlabels] = cbi_parsefeatures(PARSER);

% Decisions at the image level ...
% NAIVE POLLING
if(PARSER.stackup)
    pred_labels = classify(testset, trainset, trainlabels);
    predlabels_I = mode( reshape(predlabels, NUM_PATCHES, PARSER.TEST_NUMBER) );
    testlabels_I = [ones(PARSER.TEST_NUMBER,1); 2.*ones(PARSER.TEST_NUMBER,1)];
    confusionmatrix(testlabels_I, predlabels_I);
else
    % BAG OF FEATURES
    no_clusters = 9;
    dictionary = create_dictionary(trainset, no_clusters);
    % EVALUATION OF THE DICTIONARY ... 
    for bag_iter = 1:size(trainset,3)
        trainbag_response(bag_iter, :) = evaluate_bag(trainset(:,:,bag_iter), dictionary);
    end
    trainbag_labels = [ones(PARSER.TRAIN_NUMBER,1); 2.*ones(PARSER.TRAIN_NUMBER,1)];
    for bag_iter = 1:size(testset,3)
        testbag_response(bag_iter, :) = evaluate_bag(testset(:,:,bag_iter), dictionary);
    end
    testbag_labels = [ones(PARSER.TEST_NUMBER,1); 2.*ones(PARSER.TEST_NUMBER,1)];
    predlabels_I = classify(testbag_response, trainbag_response, trainbag_labels);
    confusionmatrix(testbag_labels, trainbag_labels);
end