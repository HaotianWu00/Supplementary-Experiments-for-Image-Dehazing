clear
close all
clc

image = imread('inputImages\forest_input.png');
image = double(image) ./ 255;
[h,w,z ] = size(image);
xx = im2gray(image);
r=7;
image(:,:,1) = image(:,:,1) ./ max(max(image(:,:,1)));
image(:,:,2) = image(:,:,2) ./ max(max(image(:,:,2)));
image(:,:,3) = image(:,:,3) ./ max(max(image(:,:,3)));


min_img(:,:) = min(image, [], 3);

min_map = min_filter(min_img,r);

tra = 1 - min_map;
tra = guidedfilter(xx, tra, 2,0.16);

figure(1)
imshow(tra)

imwrite(tra, '1.png')