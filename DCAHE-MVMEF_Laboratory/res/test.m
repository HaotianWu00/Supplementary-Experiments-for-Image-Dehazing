clear all;close all;clc;
for num = 1:5
a = imread(['0' num2str(num) '.png']);
[H,W,n] = size(a);
a = double(a) ./ 255;
mean = sum(sum(a)) / H / W;
for i=1:H
    for j = 1:W
        if a(i,j) > mean*2
            a(i,j) = 1;
%             a(i,j) = a(i,j) * 2;
%             if a(i,j) > 1
%                 a(i,j) = 1;
%             end
        end
    end
end
figure(1)
imshow(a)
imwrite(a,['11' num2str(num) num2str(num) '.png']);
end
