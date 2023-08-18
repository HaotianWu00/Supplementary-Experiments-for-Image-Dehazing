clear
close all
clc

image = imread('inputImages\forest_input.png');
image = double(image) ./ 255;
r = 11;
[h,w,z ] = size(image);

min_img = zeros(h,w);
for i = 1:h
    for j = 1:w
        temp = [image(i,j,1), image(i,j,2), image(i,j,3)];
        min_img(i,j) = min(temp);
    end
end

intensity = (image(:,:,1) + image(:,:,2) + image(:,:,3)) ./ 3;
sita = sum(sum((intensity(:,:) - (sum(sum(intensity)) / h / w)) .^ 2)) / h / w;

weight = zeros(h,w);
for i = 1:h
    for j = 1:w
        temp = 0;
        num = -1;
        for m = -1:1
            for n = -1:1
                if i+m > 0 && i+m <= h && j+n > 0 && j+n <= w
                    temp = temp + (intensity(i+m, j+n) - intensity(i,j)) ^ 2;
                    num = num + 1;
                end
            end
        end
        weight(i,j) = exp(-(temp / num) / 2 / sita);
    end
end

min_img = min_img .* weight;
depth = zeros(h,w);
for i = 1:h
    for j = 1:w
        num = 0;
        for m = -r:r
            for n = -r:r
                if i+m > 0 && i+m <= h && j+n > 0 && j+n <= w
                    num = num + 1;
                end
            end
        end
        temp = zeros(num,1);
        med = floor(num/2);
        num = 1;
        for m = -r:r
            for n = -r:r
                if i+m > 0 && i+m <= h && j+n > 0 && j+n <= w
                    temp(num,1) = min_img(i+m, j+n);
                    num = num + 1;
                end
            end
        end
        num = num - 1;
        temp = sort(temp);
        if mod(num, 2) == 1
            depth(i,j) = temp(med + 1, 1);
        else
            depth(i,j) = (temp(med, 1) + temp(med + 1, 1)) / 2;
        end
    end
end

figure(1)
imshow(depth)

t = exp(-1.8 .* depth);

for i = 1:h
    for j = 1:w
        if t(i,j) < 0.1
            t(i,j) = 0.1;
        end
    end
end


temp = zeros(1,h*w);
for i = 1:w
    temp(1,1+(i-1)*h:1+i*h-1) = t(:,i);
end
temp = sort(temp);
num = floor(h*w*0.001);
bar = temp(1,num);

A = 0;
num = 0;
for i = 1:h
    for j = 1:w
        if t(i,j) <= bar
            A = A + intensity(i,j);
            num = 1 + num;
        end
    end
end
A = A ./ num ;

res = (image - A) ./ t + A;

figure(2)
imshow(res )
imwrite(res,[num2str(r) '.png']);



