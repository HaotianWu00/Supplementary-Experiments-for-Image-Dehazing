clc;clear all;close all;

PSNR = zeros(100, 1);
num = 1;
MethodPath = '.\MSCNN\';
Path = '.\_HazeFree\';

PathA = 'HazeRD\';

InputPath1 = strcat(MethodPath, PathA);
InputPath2 = strcat(Path, PathA);
FileName1 = dir(strcat(InputPath1, '*.PNG'));
FileName2 = dir(strcat(InputPath2, '*.jpg'));

for k=1:length(FileName1)
    
    tempFileName1 = FileName1(k).name;
    tempFileName2 = FileName2(k).name;
    ImPath1 = strcat(InputPath1, tempFileName1);
    ImPath2 = strcat(InputPath2, tempFileName2);
    x = imread(ImPath1);
    y = imread(ImPath2);

    res = metrix_psnr(x,y);
    PSNR(num) = res;
    num = num + 1;
end

PathD = 'O-HAZE\';

InputPath1 = strcat(MethodPath, PathD);
InputPath2 = strcat(Path, PathD);
FileName1 = dir(strcat(InputPath1, '*.JPG'));
FileName2 = dir(strcat(InputPath2, '*.jpg'));

for k=1:length(FileName1)
    
    tempFileName1 = FileName1(k).name;
    tempFileName2 = FileName2(k).name;
    ImPath1 = strcat(InputPath1, tempFileName1);
    ImPath2 = strcat(InputPath2, tempFileName2);
    x = imread(ImPath1);
    y = imread(ImPath2);

    res = metrix_psnr(x,y);
    PSNR(num) = res;
    num = num + 1;
end

