clc;
clear;
close all;

InputPath = '.\image\';
FileName = dir(strcat(InputPath, '*.png'));

for k=1:length(FileName)
    tempFileName = FileName(k).name;
    ImPath = strcat(InputPath, tempFileName);
    haze=imread(ImPath);
    haze=double(haze)./255;
    dehaze=run_cnn(haze);
    imshow(dehaze);
    imwrite(dehaze, ['.\result\', tempFileName(1:end-4), '.png',]);
end