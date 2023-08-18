function res = a(image ,d)

res = zeros(3,1);
[h,w] = size(d);

temp = zeros(h*w,1);
num = 1;
for i = 1:h
    for j = 1:w
        temp(num) = d(i,j);
        num = num + 1;
    end
end

num = floor(h*w*0.9);
a = sort(temp);
bar = a(num);
    
for i = 1:3
    A = 0;
    num = 0;
    for k = 1:h
        for j = 1:w
            if d(k,j) >= bar
                A = A + image(k,j,i);
                num = 1 + num;
            end
        end
    end
    res(i) = A / num;
end


end

