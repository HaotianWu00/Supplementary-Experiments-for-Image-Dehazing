% FADE example

%clear all; close all; clc; 

image = imread('../result/ny17_input_Proposed.png'); 
density = FADE(image)
entropy(image)
%% For density and density map, please use below:
% [density, density_map] = FADE(image);

%% For other test images, please use below:
% image2 = imread('test_image2.jpg'); 
% density2 = FADE(image2)

% image3 = imread('test_image3.jpg'); 
% density3 = FADE(image3)

