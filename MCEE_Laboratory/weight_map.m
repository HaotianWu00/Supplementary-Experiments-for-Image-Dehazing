function res = weight_map(input, sita)

intensity = input;
[h,w,z ] = size(intensity);

res = zeros(h,w);
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
        res(i,j) = exp(-(temp / num) / 2 / sita(i,j));
    end
end


end

