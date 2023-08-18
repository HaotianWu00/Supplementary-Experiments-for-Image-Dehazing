function res = sita_filter(input, r)

[h,w] = size(input);
res = zeros(h,w);


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
        
        num = 1;
        for m = -r:r
            for n = -r:r
                if i+m > 0 && i+m <= h && j+n > 0 && j+n <= w
                    temp(num,1) = input(i+m, j+n);
                    num = num + 1;
                end
            end
        end
        num = num - 1;

        avg_t = sum(temp) / num;
        res(i,j) = sum((temp - avg_t) .^ 2) / num;
        
    end
end


end

