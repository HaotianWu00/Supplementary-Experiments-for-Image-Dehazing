clear all;close all;clc;

a = imread('11.png');
[H,W,n] = size(a);
a = double(a) ./ 255;
aa = AHE2(a,2,H,W);
bb = CP_AHE(a,H,W);
b = zeros(H,W,3);
b(:,:,1) = histeq(a(:,:,1));
b(:,:,2) = histeq(a(:,:,2));
b(:,:,3) = histeq(a(:,:,3));

c = zeros(H,W,3);
c(:,:,1) = adapthisteq(a(:,:,1));
c(:,:,2) = adapthisteq(a(:,:,2));
c(:,:,3) = adapthisteq(a(:,:,3));
imwrite(aa,'1.png');
imwrite(bb,'2.png');
imwrite(b,'3.png');
imwrite(c,'4.png');
figure(1)
subplot(2,2,1), imshow(b)
subplot(2,2,2), imshow(c)
subplot(2,2,3), imshow(aa)
subplot(2,2,4), imshow(bb)
d = histeq(im2gray(a));
e = adapthisteq(im2gray(a));
figure(2)
subplot(2,2,1), imshow(d)
subplot(2,2,2), imshow(e)
subplot(2,2,3), imshow(im2gray(aa))
subplot(2,2,4), imshow(im2gray(bb))

 showHist(aa,4);
 showHist(bb,5);
 showHist(b,6);
 showHist(c,7);