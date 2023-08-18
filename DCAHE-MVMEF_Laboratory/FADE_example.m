% FADE example

%clear all; close all; clc; 
%  for i = 1:30
     i = 1;
image = imread(['res/' num2str(i) '.png']); 
density = FADE(image)
entropy(image)
imwrite(image,['res/' num2str(i) '+' num2str(density) '.png'])
%   end
%% For density and density map, please use below:
% [density, density_map] = FADE(image);

%% For other test images, please use below:
% image2 = imread('test_image2.jpg'); 
% density2 = FADE(image2)

% image3 = imread('test_image3.jpg'); 
% density3 = FADE(image3)

