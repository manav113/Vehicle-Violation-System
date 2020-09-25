%% Vehicle Classification based on CNN

clear all
close all
clc

imds = imageDatastore('Vehicle_Class','IncludeSubfolders',true,'LabelSource','foldernames');
[imdsTrain1,imdsValidation1] = splitEachLabel(imds,0.8);

idx = randperm(numel(imdsTrain1.Files),10);

figure('name','Train Images');

for i = 1:10
    subplot(2,5,i)
    I = readimage(imdsTrain1,idx(i));
    imshow(I)
  
end

% Define layers

layers = [
    imageInputLayer([224 224 3])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

inputSize=layers(1).InputSize;


augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain1);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation1);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',50, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',5, ...
    'Verbose',false, ...
    'Plots','training-progress');
% Training 

trainedNet = trainNetwork(augimdsTrain,layers,options);

save('Vehicle_Class_CNN.mat','trainedNet');
