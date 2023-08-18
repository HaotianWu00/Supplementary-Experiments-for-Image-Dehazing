clear;close all; clc;
addpath(genpath('.'));

% This MatConvNet is compiled under Win7, you can also compile MatConvNet
% under Linux, Mac, and Windows, then run our "demo_MSCNNdehazing.m".

run(fullfile(fileparts(mfilename('fullpath')), './matlab/vl_setupnn.m')) ;

% if the input is very hazy, use large gamma to amend T. (0.8-1.5)
i = 12;
hazy_path = './testimgs/';
img = [num2str(i) '.png']; 
gamma = 1.1; % 
% img = 'newyork.png'; gamma = 1.0;
% img = 'IMG_0752.png'; gamma = 1.3;
% img = 'canyon.png'; gamma = 1.3;
imagename = [hazy_path img];


dehazedImageRGB = mscnndehazing(imagename, gamma);
imwrite(dehazedImageRGB,['result/' num2str(i) ' gamma' num2str(gamma) '.png' ]);
