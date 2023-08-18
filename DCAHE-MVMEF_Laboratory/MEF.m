clc;clear all; close all;

ttt= 35;
input = imread('14.png');
img_haze = double(input) / 255;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obtain the sequence of exposure image
[H, W, C] = size(img_haze);
I = zeros(H, W, 3, 5);

% imageInComb = zeros(H, W*3);
% imageInComb(:, 1:3:end) = img_haze(:, :, 1);
% imageInComb(:, 2:3:end) = img_haze(:, :, 2);
% imageInComb(:, 3:3:end) = img_haze(:, :, 3);
% imageOutComb = adapthisteq(imageInComb);
% imageOut = zeros(H, W, 3);
% imageOut(:, :, 1) = imageOutComb(:, 1:3:end);
% imageOut(:, :, 2) = imageOutComb(:, 2:3:end);
% imageOut(:, :, 3) = imageOutComb(:, 3:3:end);

[I(:,:,:,1),a] = AHE2(img_haze,1,H,W);  %newImhist(img_haze);
% imwrite(I(:,:,:,1),['res/' num2str(ttt) '.png']);

for i = 2:5
    
       
    I(:,:,:,i) = I(:,:,:,1) .^ double(i);
end

figure(1)
subplot(2,3,1), imshow(I(:,:,:,1))
subplot(2,3,2), imshow(I(:,:,:,2))
subplot(2,3,3), imshow(I(:,:,:,3))
subplot(2,3,4), imshow(I(:,:,:,4))
subplot(2,3,5), imshow(I(:,:,:,5))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate the original weight map

%calculate the mean map
I_k = zeros(H, W, 5);
for i = 1:5
    I_k(:,:,i) = (I(:,:,1,i) + I(:,:,2,i) + I(:,:,3,i)) ./ 3;
end
figure(2)
subplot(2,3,1), imshow(I_k(:,:,1))
subplot(2,3,2), imshow(I_k(:,:,2))
subplot(2,3,3), imshow(I_k(:,:,3))
subplot(2,3,4), imshow(I_k(:,:,4))
subplot(2,3,5), imshow(I_k(:,:,5))

%calculate constract map
LF = [0 1 0; 1 -4 1; 0 1 0];
constractSeq = zeros(H, W, 5);
for i = 1:5
    constractSeq(:,:,i) = abs(imfilter(I_k(:,:,i), LF,'replicate'));
end

a = constractSeq(:,:,1)+constractSeq(:,:,2)+constractSeq(:,:,3)+constractSeq(:,:,4)+constractSeq(:,:,5);

for i = 1:H
    for j = 1:W
        if a(i,j) ~= 0
            a(i,j) = 1;
        end
    end
end
figure(10), imshow(a)


figure(3)
subplot(2,3,1), imshow(constractSeq(:,:,1))
subplot(2,3,2), imshow(constractSeq(:,:,2))
subplot(2,3,3), imshow(constractSeq(:,:,3))
subplot(2,3,4), imshow(constractSeq(:,:,4))
subplot(2,3,5), imshow(constractSeq(:,:,5))

nor = normalize(constractSeq);
figure(4)
subplot(2,3,1), imshow(nor(:,:,1))
subplot(2,3,2), imshow(nor(:,:,2))
subplot(2,3,3), imshow(nor(:,:,3))
subplot(2,3,4), imshow(nor(:,:,4))
subplot(2,3,5), imshow(nor(:,:,5))
subplot(2,3,6), imshow(nor(:,:,1)+nor(:,:,2)+nor(:,:,3)+nor(:,:,4)+nor(:,:,5))
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

figure(5)
subplot(2,3,1), imshow(saturationSeq(:,:,1))
subplot(2,3,2), imshow(saturationSeq(:,:,2))
subplot(2,3,3), imshow(saturationSeq(:,:,3))
subplot(2,3,4), imshow(saturationSeq(:,:,4))
subplot(2,3,5), imshow(saturationSeq(:,:,5))

nor = normalize(saturationSeq);
figure(6)
subplot(2,3,1), imshow(nor(:,:,1))
subplot(2,3,2), imshow(nor(:,:,2))
subplot(2,3,3), imshow(nor(:,:,3))
subplot(2,3,4), imshow(nor(:,:,4))
subplot(2,3,5), imshow(nor(:,:,5))
subplot(2,3,6), imshow(nor(:,:,1)+nor(:,:,2)+nor(:,:,3)+nor(:,:,4)+nor(:,:,5))

%calculate exposure map
exposureMap = zeros(H, W, 5);
for i = 1:5
    Ik_mean = sum(sum(I_k(:,:,i))) / W / H;
    exposureMap(:,:,i) = exp(-(I_k(:,:,i) - 1 + Ik_mean) .^ 2 / (2 * 0.5^2));
end

figure(7)
subplot(2,3,1), imshow(exposureMap(:,:,1))
subplot(2,3,2), imshow(exposureMap(:,:,2))
subplot(2,3,3), imshow(exposureMap(:,:,3))
subplot(2,3,4), imshow(exposureMap(:,:,4))
subplot(2,3,5), imshow(exposureMap(:,:,5))

nor = normalize(exposureMap);
figure(8)
subplot(2,3,1), imshow(nor(:,:,1))
subplot(2,3,2), imshow(nor(:,:,2))
subplot(2,3,3), imshow(nor(:,:,3))
subplot(2,3,4), imshow(nor(:,:,4))
subplot(2,3,5), imshow(nor(:,:,5))
subplot(2,3,6), imshow(nor(:,:,1)+nor(:,:,2)+nor(:,:,3)+nor(:,:,4)+nor(:,:,5))

%calculate the original weight map
original_weight_map = zeros(H, W, 5);

for i = 1:5
    Ik_mean = sum(sum(I_k(:,:,i))) / W / H;
    w_c = zeros(H,W);
    c_mean = sum(sum(constractSeq(:,:,i))) / H / W;
    for j = 1:H
        for k = 1:W
            w_c(j,k) = floor(c_mean - constractSeq(j,k,i)) * 2;%((i-1)*0.2 + 1)        
        end
    end
    min = zeros(H,W);
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
    original_weight_map(:,:,i) = (constractSeq(:,:,i).^ w_c) .* (saturationSeq(:,:,i).^w_s) .* (exposureMap(:,:,i).^w_e) + 1e-12;
end

% WW = original_weight_map(:,:,1)+original_weight_map(:,:,2)+original_weight_map(:,:,3)+original_weight_map(:,:,4)+original_weight_map(:,:,5);
Wk = zeros(H, W, 5);
% for i = 1:5
%     Wk(:,:,i) = original_weight_map(:,:,i) ./ WW(:,:);
% end
Wk = original_weight_map;
a = Wk(:,:,1)+Wk(:,:,2)+Wk(:,:,3)+Wk(:,:,4)+Wk(:,:,5);
for i = 1:H
    for j = 1:W
        if a(i,j) ~= 0
            a(i,j) = 1;
        end
    end
end
Wk = real(Wk);
a = Wk(:,:,1)+Wk(:,:,2)+Wk(:,:,3)+Wk(:,:,4)+Wk(:,:,5);
figure(15)
subplot(2,3,1), imshow(Wk(:,:,1))
subplot(2,3,2), imshow(Wk(:,:,2))
subplot(2,3,3), imshow(Wk(:,:,3))
subplot(2,3,4), imshow(Wk(:,:,4))
subplot(2,3,5), imshow(Wk(:,:,5))
subplot(2,3,6), imshow(Wk(:,:,1)+Wk(:,:,2)+Wk(:,:,3)+Wk(:,:,4)+Wk(:,:,5))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % obtain the original decision map
original_decision_map = zeros(H, W, 5);
for i = 1: 5
    original_decision_map(:,:,i) = I_k(:,:,i) - guidedfilter(I_k(:,:,i), I_k(:,:,i), 2, 0.8^2);
end

figure(6)
subplot(2,3,1), imshow(original_decision_map(:,:,1))
subplot(2,3,2), imshow(original_decision_map(:,:,2))
subplot(2,3,3), imshow(original_decision_map(:,:,3))
subplot(2,3,4), imshow(original_decision_map(:,:,4))
subplot(2,3,5), imshow(original_decision_map(:,:,5))
imwrite(original_decision_map(:,:,1),'.\res\01.png');
imwrite(original_decision_map(:,:,2),'.\res\02.png');
imwrite(original_decision_map(:,:,3),'.\res\03.png');
imwrite(original_decision_map(:,:,4),'.\res\04.png');
imwrite(original_decision_map(:,:,5),'.\res\05.png');

decision_min_map = zeros(H, W);
for i = 1:H
    for j = 1: W
        for k = 1:5
            if decision_min_map(i, j) >= original_decision_map(i,j,k)
                decision_min_map(i,j) = original_decision_map(i,j,k);
            end
        end
    end
end

decision_max_map = zeros(H, W);
for i = 1:H
    for j = 1: W
        for k = 1:5
            if decision_max_map(i, j) <= original_decision_map(i,j,k)
                decision_max_map(i,j) = original_decision_map(i,j,k);
            end
        end
    end
end

MaxMap = zeros(H,W,5);
for i = 1:5
    for j = 1:H
        for k = 1:W
            if original_decision_map(j,k,i) == decision_max_map(j,k)
                MaxMap(j,k,i) = 1;
            end
        end
    end
end
MaxSum = MaxMap(:,:,1)+MaxMap(:,:,2)+MaxMap(:,:,3)+MaxMap(:,:,4)+MaxMap(:,:,5);
figure(7)
subplot(2,3,1), imshow(MaxMap(:,:,1))
subplot(2,3,2), imshow(MaxMap(:,:,2))
subplot(2,3,3), imshow(MaxMap(:,:,3))
subplot(2,3,4), imshow(MaxMap(:,:,4))
subplot(2,3,5), imshow(MaxMap(:,:,5))
subplot(2,3,6), imshow(MaxSum)

MinMap = zeros(H,W,5);
for i = 1:5
    for j = 1:H
        for k = 1:W
            if original_decision_map(j,k,i) == decision_min_map(j,k)
                MinMap(j,k,i) = 1;
            end
        end
    end
end
MinSum = MinMap(:,:,1)+MinMap(:,:,2)+MinMap(:,:,3)+MinMap(:,:,4)+MinMap(:,:,5);
figure(8)
subplot(2,3,1), imshow(MinMap(:,:,1))
subplot(2,3,2), imshow(MinMap(:,:,2))
subplot(2,3,3), imshow(MinMap(:,:,3))
subplot(2,3,4), imshow(MinMap(:,:,4))
subplot(2,3,5), imshow(MinMap(:,:,5))
subplot(2,3,6), imshow(uint8(MinSum))

final_decision_map = zeros(H,W,5);
for i = 1:5
    final_decision_map(:,:,i) = abs(MaxMap(:,:,i) - MinMap(:,:,i));
    
end

AA = final_decision_map(:,:,1);

asda = (final_decision_map(:,:,1)+final_decision_map(:,:,2)+final_decision_map(:,:,3)+final_decision_map(:,:,4)+final_decision_map(:,:,5))./2;
figure(9)
subplot(2,3,1), imshow(final_decision_map(:,:,1))
subplot(2,3,2), imshow(final_decision_map(:,:,2))
subplot(2,3,3), imshow(final_decision_map(:,:,3))
subplot(2,3,4), imshow(final_decision_map(:,:,4))
subplot(2,3,5), imshow(final_decision_map(:,:,5))
subplot(2,3,6), imshow(asda)

final_weight_map = zeros(H,W,5);
for i =1:5
    final_weight_map(:,:,i) = (original_weight_map(:,:,i) .* final_decision_map(:,:,i));  
end

Wk = zeros(H, W, 5);
for i = 1:5
    Wk(:,:,i) = final_weight_map(:,:,i) ./ (final_weight_map(:,:,1)+final_weight_map(:,:,2)+final_weight_map(:,:,3)+final_weight_map(:,:,4)+final_weight_map(:,:,5));
end


figure(20)
subplot(2,3,1), imshow(Wk(:,:,1))
subplot(2,3,2), imshow(Wk(:,:,2))
subplot(2,3,3), imshow(Wk(:,:,3))
subplot(2,3,4), imshow(Wk(:,:,4))
subplot(2,3,5), imshow(Wk(:,:,5))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pyr = gaussian_pyramid(zeros(H,W,3));
nlev = length(pyr);

%multiresolution blending
for i = 1:5
    %construct pyramid from each input image
    pyrW = gaussian_pyramid(Wk(:,:,i));
    pyrI = laplacian_pyramid(I(:,:,:,i));
    
   % blend
    for l = 1:nlev
        w = repmat(pyrW{l},[1 1 3]);
        pyr{l} = pyr{l} + w.*pyrI{l};
    end
end

%reconstruct
R = reconstruct_laplacian_pyramid(pyr);
R = real(R);
c = R(:,:,1);
figure(11)
subplot(1,2,1), imshow(img_haze)
subplot(1,2,2), imshow(R)


imwrite(R, ['res/' num2str(ttt) '999.png']);



