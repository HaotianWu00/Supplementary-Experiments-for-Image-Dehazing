clear
close all
clc

InputPath = '.\inputImages\';
FileName = dir(strcat(InputPath, '*.PNG'));

for k=1:length(FileName)

    tempFileName = FileName(k).name;    
    ImPath = strcat(InputPath, tempFileName);        
    I_hazy = imread(ImPath);
    res =test1(I_hazy,  ['.\depth\' tempFileName]);
    imwrite(res, ['.\res1\' tempFileName]);
                
end