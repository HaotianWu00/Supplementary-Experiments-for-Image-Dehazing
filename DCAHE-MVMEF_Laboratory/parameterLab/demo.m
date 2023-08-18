clc;clear all; close all;
% FADE example

r = [1,2,4,8];
s = [0.1,0.2,0.4];
fa = zeros(12,1);
num = 1;
for k = 1:4
    for j = 1:3
        InputPath = ['..\' num2str(r(k)) num2str(s(j)) '\'];
        FileName = dir(strcat(InputPath, '*.png'));
        res = 0;
        for i = 1:length(FileName)
            tempFileName = FileName(i).name;
            ImPath = strcat(InputPath, tempFileName);
            image = imread(ImPath); 
            density = FADE(image);
            entropy(image)
            res = res + density;
            imwrite(image,['res/' tempFileName '+' num2str(density) '.png'])
        end
        res = res / length(FileName);
        fa(num) = res;
        num = num + 1;
    end
end
