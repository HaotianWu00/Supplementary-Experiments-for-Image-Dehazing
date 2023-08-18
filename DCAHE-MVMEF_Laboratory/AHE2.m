function [R, lambda] = AHE2(I,size, H,W)






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mincolchan = zeros(H,W);
for i = 1:H
    for j = 1:W
        if I(i,j,1) <= I(i,j,2) && I(i,j,1) <= I(i,j,3)
            mincolchan(i,j) = I(i,j,1);
        elseif I(i,j,2) <= I(i,j,1) && I(i,j,2) <= I(i,j,3)
            mincolchan(i,j) = I(i,j,2);
        elseif I(i,j,3) <= I(i,j,1) && I(i,j,3) <= I(i,j,2)
            mincolchan(i,j) = I(i,j,3);
        end
    end
end
figure(1)
imshow(mincolchan)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
darkchan = zeros(H,W);
for i = 1:H
    for j = 1:W
        darkchan(i,j) = mincolchan (i,j);
        for k = -size:size
            for h = -size:size
                if i + k > 0 && i + k <= H && j + h > 0 && j + h <= W
                    if mincolchan(i+k,j+h) <= darkchan(i,j)
                        darkchan(i,j) = mincolchan(i+k,j+h);
                    end
                end
            end
        end
    end
end
figure(2)
imshow(darkchan)
imwrite(darkchan,'1.png');
% darkchan = guidedfilter(darkchan,darkchan, 4, 0.2^2);
% figure(3)
% imshow(darkchan)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda = callambda(darkchan,H,W);
first = zeros(H,W);
second = first;
mean =  lambda;
for i = 1:H
    for j = 1:W
        if darkchan(i,j) >= mean
            first(i,j) = 1;
            second(i,j) = darkchan(i,j);
        else
            first(i,j) = darkchan(i,j);
            second(i,j) = 0;
        end
    end
end
figure(3)
imshow(first)
imwrite(first,'2.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4)
imshow(second)
imwrite(second,'3.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fir = ones(H,W,3);
sec = fir;

res = zeros(H,W,3);
for i = 1:H
    for j = 1:W
        if second(i,j) ~= 0 
            sec(i,j,:) = I(i,j,:);
        end
    end
end
showHist(sec,4);
imageInComb = zeros(H, W*3);
imageInComb(:, 1:3:end) = sec(:, :, 1);
imageInComb(:, 2:3:end) = sec(:, :, 2);
imageInComb(:, 3:3:end) = sec(:, :, 3);
imageOutComb = adapthisteq(imageInComb,'clipLimit',0.01);
imageOut = zeros(H, W, 3);
imageOut(:, :, 1) = imageOutComb(:, 1:3:end);
imageOut(:, :, 2) = imageOutComb(:, 2:3:end);
imageOut(:, :, 3) = imageOutComb(:, 3:3:end);

% imageOut(:,:,1) = ACE(uint8(sec(:,:,1).*255));
% imageOut(:,:,2) = ACE(uint8(sec(:,:,2).*255));
% imageOut(:,:,3) = ACE(uint8(sec(:,:,3).*255));
% imageOut = double(imageOut) ./ 255;

showHist(imageOut,5);
imwrite(imageOut,'4.png');
for i = 1:H
    for j = 1:W
        if second(i,j) ~= 0 
            res(i,j,:) = imageOut(i,j,:);
        end
    end
end


for i = 1:H
    for j = 1:W
        if second(i,j) == 0 
            fir(i,j,:) = I(i,j,:);
        end
    end
end
showHist(fir,6);
imageInComb = zeros(H, W*3);
imageInComb(:, 1:3:end) = fir(:, :, 1);
imageInComb(:, 2:3:end) = fir(:, :, 2);
imageInComb(:, 3:3:end) = fir(:, :, 3);
imageOutComb = adapthisteq(imageInComb,'clipLimit',0.01);
imageOut = zeros(H, W, 3);
imageOut(:, :, 1) = imageOutComb(:, 1:3:end);
imageOut(:, :, 2) = imageOutComb(:, 2:3:end);
imageOut(:, :, 3) = imageOutComb(:, 3:3:end);

% imageOut(:,:,1) = ACE(uint8(fir(:,:,1).*255));
% imageOut(:,:,2) = ACE(uint8(fir(:,:,2).*255));
% imageOut(:,:,3) = ACE(uint8(fir(:,:,3).*255));
% 
% imageOut = double(imageOut) ./ 255;
showHist(imageOut,7);
imwrite(imageOut,'5.png');



% imageOut(:,:,1) = ACE(uint8(thi(:,:,1).*255));
% imageOut(:,:,2) = ACE(uint8(thi(:,:,2).*255));
% imageOut(:,:,3) = ACE(uint8(thi(:,:,3).*255));
% imageOut = double(imageOut) ./ 255;

for i = 1:H
    for j = 1:W
        if second(i,j) ==0
            res(i,j,:) = imageOut(i,j,:);
        end
    end
end

% res(:,:,1) = guidedfilter(res(:,:,1), res(:,:,1), 4, 0.2^2);
% res(:,:,2) = guidedfilter(res(:,:,2), res(:,:,2), 4, 0.2^2);
% res(:,:,3) = guidedfilter(res(:,:,3), res(:,:,3), 4, 0.2^2);

showHist(res,10);
R = res;
imwrite(res,'6.png')
end


