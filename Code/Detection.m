%Author Andreas Löw

%Function to train and evaluate a CNN by Task "Object Detection"
function Detection()

clc;

% load labelling File
load('solar.mat');

%load CNN AlexNet/VGG-16
net = alexnet;

%define Training Parameters
optionsRCNN = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...  
    'MaxEpochs',100, ...
    'LearnRateDropFactor',0.2,...
    'LearnRateDropPeriod',8, ...
    'LearnRateSchedule','piecewise', ...
    'MiniBatchSize', 126);

   
%Train RcnnObjectDetector and Measure Training Time
tic
rcnn = trainRCNNObjectDetector(solar, net, optionsRCNN, 'NegativeOverlapRange', [0 0.3]);
toc

%save trained RCNN
% save rcnn;

%%Load Testing Data
testingImages = imageDatastore('solarTestDataOriginal75',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

testingFolder = testingImages.Files;

meanValue = 0;
countBboxes = 0;
classTime = 0;

%Loop to detect all Training Images and Evaluate them
for i=1:length(testingFolder)
    
    %load Testing Picture
    picPath = testingFolder{i};   
    testingPicture = imread(picPath);
    
    tic %measure Detection Time
    [bboxes,scores] = detect(rcnn, testingPicture);
    actTime = toc;
    classTime = classTime + actTime;
    
    if isempty(bboxes)
    figure
    imshow(testingPicture) 
    
    else
    I = insertObjectAnnotation(testingPicture, 'rectangle', bboxes, scores);
    %I = insertObjectAnnotation(testingPicture, 'rectangle', bboxes, scores*100,'TextBoxOpacity', 0.9,'FontSize',13, 'LineWidth',2);
    imshow(I) 
    end
    
    %Compute Mean Value
    for k=1:size(bboxes, 1)
        meanValue = meanValue + scores(k);
        countBboxes = countBboxes + 1;
    end
    
    %Save Plot 
    saveName = extractBetween(num2str(picPath),"solarTestDataOriginal75\", ".jpg");
    saveas(gcf,string(saveName)+".jpg");
end

%Compute Mean Value
meanValue = meanValue / countBboxes;

disp("Arithmetischer Mittelwer: " + meanValue*100 + "%");
disp("Klassifikationszeit: " + classTime);

end