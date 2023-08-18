function res = aaaa(input, name)

image = double(input) ./ 255;
[h,w,z ] = size(image);

r = 15;

min_img(:,:) = min(image, [], 3);

depth = min_filter(min_img, r);



t = exp(-  2.5 .* depth);

depth = guidedfilter(im2gray(image), t, 60, 0.0001);

for i = 1:h
    for j = 1:w
        if t(i,j) < 0.1
            t(i,j) = 0.1;
        elseif t(i,j) > 0.9
            t(i,j) = 0.9;
        end
    end
end

A = a(image, depth);
ax = sum(A) / 3 ;

res = (image - ax) ./ t + ax;


figure(2)
imshow(res)

end
