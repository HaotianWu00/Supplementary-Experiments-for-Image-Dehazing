clc;clear all; close all;
for i = 1:5
    img = imread('20.png');
    img = double(img) ./ 255;
    img1 = img(:,:,:) .^ i;
    imwrite(img1,['3\' num2str(i) '.png']);
end
