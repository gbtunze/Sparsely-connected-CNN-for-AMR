
% Read dataset of modulatation signals 

%The path to the dataset
imds = imageDatastore(fullfile('RadioML2018.01A\'),'IncludeSubfolders',true,'LabelSource','foldernames','FileExtensions',{'.mat'});

% Split dataset into 2 sub-sets of training 80% and testing 20%
[imdsTrain,imdsTest] = splitEachLabel(imds,0.8,'randomized');

% Read data of training 
imdsTrain.Labels = categorical(imdsTrain.Labels);
imdsTrain.ReadFcn = @readFcnMatFile;

% Read data of testing 
imdsTest.Labels = categorical(imdsTest.Labels);
imdsTest.ReadFcn = @readFcnMatFile;

% Set up training option
batchSize   = 64;
ValFre      = fix(length(imdsTrain.Files)/batchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',batchSize, ...
    'MaxEpochs',90, ...
    'Shuffle','every-epoch',...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',45,...
    'LearnRateDropFactor',0.1,...
    'ValidationData',imdsTest, ...
    'ValidationFrequency',ValFre, ...
    'ValidationPatience',Inf, ...
    'Verbose',true ,...
    'VerboseFrequency',ValFre,...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu');

% Start training
% save the trainednet 

%% Training
tic
trainNow = true;
if trainNow == true
  trainedNet = trainNetwork(imdsTrain,lgraph,options);
  fprintf('%s - Training the network\n', datestr(toc/86400,'HH:MM:SS'))
  timeFormat = 'yyyy-mm-dd-HH-MM-SS';
  now = datetime('now');
  Trained_file = sprintf('ModulationRec_%s.mat', datestr(now,timeFormat));
  save(Trained_file, 'trainedNet', 'lgraph');
else
 %load trainedModulationClassificationNetwork
end

% Measure the accuracy on the test set
YPredic = classify(trainedNet,imdsTest);
YTest = imdsTest.Labels;
% Compared the prediction vs the groudtruth
accuracy = sum(YPredic == YTest)/numel(YTest)*100;
%fprintf(accuracy);
disp(accuracy);

