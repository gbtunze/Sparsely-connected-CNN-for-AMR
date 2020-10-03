% This fuction generates confusion matrix
% at various SNR values


% The path to a particural SNR value
imds = imageDatastore(fullfile('RadioML2018.01A\','SNR_XXX'),'IncludeSubfolders',true,'LabelSource','foldernames','FileExtensions',{'.mat'});


% Split dataset into 2 sub-sets of training 80% and testing 20%
[imdsTrain,imdsTest] = splitEachLabel(imds,0.8,'randomized');

% Read data of training 
imdsTrain.Labels = categorical(imdsTrain.Labels);
imdsTrain.ReadFcn = @readFcnMatFile;
% Read data of testing 
imdsTest.Labels = categorical(imdsTest.Labels);
imdsTest.ReadFcn = @readFcnMatFile;

YPredic = classify(trainednet,imdsTest);
YTest = imdsTest.Labels;

% Compared the prediction vs the groudtruth
accuracy = sum(YPredic == YTest)/numel(YTest)*100;

conf = confusionmat(YTest,YPredic);
classes = {'32PSK','16APSK','32QAM','FM','GMSK','32APSK','OQPSK','8ASK',...
    'BPSK','8PSK','AM-SSB-SC','4ASK','16PSK','64APSK','128QAM','128APSK',...
    'AM-DSB-SC','AM-SSB-WC','64QAM','QPSK','256QAM','AM-DSB-WC','OOK','16QAM'};

figure;
cm = confusionchart(conf,classes,'Normalization','row-normalized');
cm.FontName = 'Times New Roman';
cm.GridVisible = 'off';
cm.FontColor =[0 0 0];
colorbar = [0.6 0 0];
cm.DiagonalColor = colorbar;
cm.OffDiagonalColor = colorbar;

fig = gcf;
fig.PaperPositionMode = 'auto';

%save the confusion matrix plot with file name confusion_mat
print('confusion_mat','-depsc','-r600')