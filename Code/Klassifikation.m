%Author Andreas Löw

%Function to train and evaluate CNN by Task "Classification"
function Klassifikation()

clc;

%Load all Training images
trainingImages = imageDatastore('Trainingsdaten Resized VGG16\training alle',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');
  
%Load Cnn AlexNet/VGG16
net = alexnet;


%%Load Testing Images
validationImages = imageDatastore('Testdaten Resized AlexNet',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

%Delete last 3 Layers for Classification
layersTransfer = net.Layers(1:end-3);

%Rebuild last layers
numClasses = numel(categories(trainingImages.Labels));
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%Define Training Options
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...  
    'MaxEpochs',100, ...
    'Plots','training-progress', ...
    'MiniBatchSize', 126);


%Train Network with Training Images + Training Options
tic %measure Training Time
netTransfer = trainNetwork(trainingImages,layers,options);
toc

%Classify each image of Testing Folder
tic %measure Classification Time for all Testing Images
[predictedLabels,scores] = classify(netTransfer,validationImages);
toc

meanValue = 0;

%Show each classified image with Propabilty
for i=1:valDataCount(1)
    figure
    hold on
    I = readimage(validationImages,i);
    score = max(scores(i,:)) *100;
    label = predictedLabels(i);
    imshow(I);
    title(string(char(label)) + ' : ' + score + '%');
    
    %%Compute Mean Value
    meanValue = meanValue + score;
    
    %%Save Plot automated
    saveName = "Result VGG16 " + num2str(i) + ".png";
    saveas(gcf,saveName);
end

meanValue = meanValue / i;
disp("Arithmetischer Mittelwer: " + meanValue + "%");

end