%Author Andreas Löw

%Replace the absolute Path of Labelling File
function changePath()

clc;

%Load to be changed Table
load('solar.mat');

table = solar;
rowSize = size(table);
table.imageFilename

for i=1: rowSize(1)
    
    actString = table.imageFilename(i);
    %old Path
    oldStr = 'C:\Users\andi\Desktop\bachelorarbeit\deep learning\';      
    %new Path
    newStr = 'D:\Trainingdaten Detektion\'; 
    
    newStr = strrep(actString,oldStr,newStr);
    table.imageFilename(i) = newStr;
end

save table;
end