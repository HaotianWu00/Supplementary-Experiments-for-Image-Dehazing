clc;clear all; close all;

InputPath = '.\3\';
FileName = dir(strcat(InputPath, '*.png'));

for k=1:length(FileName)
    tempFileName = FileName(k).name;
    ImPath = strcat(InputPath, tempFileName);    
    
    I_hazy = double(imread(ImPath)) ./ 255;
    

    [H,W,C] = size(I_hazy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    edgeSize = 5;
    windowSize = 80;

    area1 = [80,270];
    area2 = [200,20];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    reSize = floor((W - 30) / 2); 
    ratio = reSize / (windowSize + 1);

    res = ones(H + 20 + reSize, W, 3);
    res(1:H,1:W,:) = I_hazy(:,:,:);
    
    areaA = zeros(windowSize + 1,windowSize + 1,3);
    k = -4;
    for i = area1(1) - edgeSize : area1(1) + windowSize + edgeSize
        l = 1;
        for j = area1(2) - edgeSize : area1(2) + windowSize + edgeSize            
            if i - area1(1) <= -1 ||  i - area1(1) - windowSize >= 1 
                res(i,j,1) = 1;
                res(i,j,2) = 0;
                res(i,j,3) = 0;
            elseif j - area1(2) <= -1 ||  j - area1(2) - windowSize >= 1 
                res(i,j,1) = 1;
                res(i,j,2) = 0;
                res(i,j,3) = 0;
            else                
                areaA(k,l,:) = res(i,j,:);
                l = l + 1;                
            end
        end
        k = k + 1;
    end
    areaB = zeros(windowSize + 1,windowSize + 1,3);
    k = -4;
    for i = area2(1) - edgeSize : area2(1) + windowSize + edgeSize
        l = 1;
        for j = area2(2) - edgeSize : area2(2) + windowSize + edgeSize
            if  i - area2(1) <= -1 || i - area2(1) - windowSize >= 1 
                res(i,j,1) = 0;
                res(i,j,2) = 0;
                res(i,j,3) = 1;
            elseif j - area2(2) <= -1 || j - area2(2) - windowSize >= 1  
                res(i,j,1) = 0;
                res(i,j,2) = 0;
                res(i,j,3) = 1;
            else
                areaB(k,l,:) = res(i,j,:);
                l = l + 1; 
            end
        end
        k = k + 1;
    end
    
    areaA = imresize(areaA, ratio,'nearest');
    areaB = imresize(areaB, ratio,'nearest');
    [height,width,color] = size(areaA);

    resA = zeros(width + 10, width + 10, 3);
    resB = zeros(width + 10, width + 10, 3);
    
    for i = 1:width + 10
        for j = 1:width + 10
            if i <= 5 || i >= width + 5
                resA(i,j,1) = 1;
                resA(i,j,2) = 0;
                resA(i,j,3) = 0;
            elseif j <= 5 || j >= width + 5
                resA(i,j,1) = 1;
                resA(i,j,2) = 0;
                resA(i,j,3) = 0;
            else
                resA(i,j,:) = areaA(i-5,j-5,:);
            end
        end
    end
                
    for i = 1:width + 10
        for j = 1:width + 10
            if i <= 5 || i >= width + 5
                resB(i,j,1) = 0;
                resB(i,j,2) = 0;
                resB(i,j,3) = 1;
            elseif j <= 5 || j >= width + 5
                resB(i,j,1) = 0;
                resB(i,j,2) = 0;
                resB(i,j,3) = 1;
            else
                resB(i,j,:) = areaB(i-5,j-5,:);
            end
        end
    end
    
    res(H+11:H+width+20,1:width + 10,:) = resA(:,:,:);
    res(H+11:H+width+20,W - width - 9:end,:) = resB(:,:,:);

    figure(1)
    imshow(res)

    imwrite(res, [ tempFileName(1:end-4), '.png',]);
end

