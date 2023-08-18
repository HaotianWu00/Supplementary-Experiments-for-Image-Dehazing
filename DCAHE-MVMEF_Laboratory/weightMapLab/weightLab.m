clc;clear all; close all;

for time = 1:2

    InputPath = '.\inputImages\';
    FileName = dir(strcat(InputPath, '*.png'));
    
        
    for ttt= 1:length(FileName)
    
        tempFileName = FileName(ttt).name;
        ImPath = strcat(InputPath, tempFileName);
        
        input = imread(ImPath);
        img_haze = double(input) / 255;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obtain the sequence of exposure image
        [H, W, C] = size(img_haze);
        I = zeros(H, W, 3, 5);
        
        imageInComb = zeros(H, W*3);
        imageInComb(:, 1:3:end) = img_haze(:, :, 1);
        imageInComb(:, 2:3:end) = img_haze(:, :, 2);
        imageInComb(:, 3:3:end) = img_haze(:, :, 3);
        imageOutComb = adapthisteq(imageInComb);
        imageOut = zeros(H, W, 3);
        imageOut(:, :, 1) = imageOutComb(:, 1:3:end);
        imageOut(:, :, 2) = imageOutComb(:, 2:3:end);
        imageOut(:, :, 3) = imageOutComb(:, 3:3:end);
        
        
        I(:,:,:,1) = imageOut;  
        
        for i = 2:5
            if ttt == 4
                I(:,:,:,i) = img_haze .^ double(i);
            else
                I(:,:,:,i) = I(:,:,:,1) .^ double(i);
            end
            
        end
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate the original weight map
        
%calculate the mean map
        I_k = zeros(H, W, 5);
        for i = 1:5
            I_k(:,:,i) = (I(:,:,1,i) + I(:,:,2,i) + I(:,:,3,i)) ./ 3;
        end
        
%calculate constract map
        LF = [0 1 0; 1 -4 1; 0 1 0];
        constractSeq = zeros(H, W, 5);
        for i = 1:5
            constractSeq(:,:,i) = abs(imfilter(I_k(:,:,i), LF,'replicate'));
        end
        
        
% calculate saturation map
        saturationSeq = zeros(H, W, 5);
        for i = 1:5
            min_map = zeros(H, W);
            for j = 1:H
                for k = 1:W
                    if I(j,k,1,i) <= I(j,k,2,i) && I(j,k,1,i) <= I(j,k,3,i)
                        min_map(j,k) = I(j,k,1,i);
                    elseif I(j,k,2,i) <= I(j,k,1,i) && I(j,k,2,i) <= I(j,k,3,i)
                        min_map(j,k) = I(j,k,2,i);
                    else
                        min_map(j,k) = I(j,k,3,i);
                    end
                end
            end
            saturationSeq(:,:,i) = 1 - (min_map ./ I_k(:,:,i));
            
        end
        
                
%calculate exposure map
        exposureMap = zeros(H, W, 5);
        for i = 1:5
            Ik_mean = sum(sum(I_k(:,:,i))) / W / H;
            exposureMap(:,:,i) = exp(-(I_k(:,:,i) - 1 + Ik_mean) .^ 2 / (2 * 0.5^2));
        end
        
                
%calculate the original weight map
        original_weight_map = zeros(H, W, 5);
        
        for i = 1:5
            if time == 2

                original_weight_map(:,:,i) = constractSeq(:,:,i) .* saturationSeq(:,:,i) .* exposureMap(:,:,i);

            elseif time == 1
                
                w_c = zeros(H,W);
                c_mean = sum(sum(constractSeq(:,:,i))) / H / W;
                for j = 1:H
                    for k = 1:W
                        w_c(j,k) = floor(c_mean - constractSeq(j,k,i)) * 2;%((i-1)*0.2 + 1)        
                    end
                end
                
                w_s = zeros(H,W);
                for j = 1:H
                    for k = 1:W
                        a = sort([saturationSeq(j,k,1), saturationSeq(j,k,2), saturationSeq(j,k,3), saturationSeq(j,k,4), saturationSeq(j,k,5)]);
                        min = a(1,5);
                        w_s(j,k) = ((-saturationSeq(j,k,i)) / (2-min))^3;
                    end
                end
            
                
                w_e = zeros(H,W);
                mean = sum(sum(exposureMap(:,:,i))) / H / W;
                for j = 1:H
                    for k = 1:W
                         w_e(j,k) = (mean - exposureMap(j,k,i) + 1) ^ (6-i);
                    end
                end
                original_weight_map(:,:,i) = (constractSeq(:,:,i).^ w_c) .* (saturationSeq(:,:,i).^w_s) .* (exposureMap(:,:,i).^w_e);

            end
                        
        end

        a  = zeros(H,W,3);
        c = original_weight_map(:,:,1)+original_weight_map(:,:,2)+original_weight_map(:,:,3)+original_weight_map(:,:,4)+original_weight_map(:,:,5);
        c = real(c);
        b = max(c);
        b = max(b);
        c = c ./b;
        b = sum(sum(c))/H/W;
        
        for i = 1:H
            for j = 1:W
                if c(i,j) > b && c(i,j) <= 0.8
                    c(i,j) = c(i,j) + 0.2;
                elseif c(i,j) >0.8
                    c(i,j) = 1;
                end
            end
        end

        a(:,:,1) = c;   
        a(:,:,2) = c;
        a(:,:,3) = c;
        
        
        for i = 1:H
            for j = 1:W
                if a(i,j,1) == 0
                    a(i,j,1) = 1;
                end
            end
        end

        figure(10), imshow(a)   

        if time == 2
            imwrite(a,['.\result\', tempFileName(1:end-4), '.png',])
        elseif time == 1
            imwrite(a,['.\result\', tempFileName(1:end-4), '_new.png',])
        end
           
    end
end