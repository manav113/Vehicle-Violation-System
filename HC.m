%% Helmet-Nohelmet classification based on AlexNet CNN

clear all
close all
clc

imds = imageDatastore('Class', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.80);
numTrainImages = numel(imdsTrain.Labels);
idx = randperm(numTrainImages);


figure('name','Train Images');

for i = 1:10
    subplot(2,5,i)
    I = readimage(imdsTrain,idx(i));
    imshow(I)
  
end

% Load a pretrained network

net = alexnet;

% analyzeNetwork(net)

inputSize = net.Layers(1).InputSize;

layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(imdsTrain.Labels));

layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',30,'BiasLearnRateFactor',40)
    softmaxLayer
    classificationLayer];

pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);

augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

layer = 'fc7';


options = trainingOptions('sgdm', ...
   'MaxEpochs',100, ...
    'Shuffle','every-epoch', ...
    'InitialLearnRate',3e-4, ...
    'ValidationFrequency',3, ... 
    'Verbose',false, ...
    'Plots','training-progress');

% Training the network

netTransfer = trainNetwork(augimdsTrain,layers,options);

save('Helmet_AlexNet_Train.mat','netTransfer');