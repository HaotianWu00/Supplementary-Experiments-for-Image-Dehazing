function nor = normalize(I)
    [H,W,N] = size(I);
    sum(:,:) = I(:,:,1) + I(:,:,2) + I(:,:,3) + I(:,:,4) + I(:,:,5);
    nor = zeros(H,W,5);
    for i = 1:5
        nor(:,:,i) = I(:,:,i) ./ sum(:,:);
    end
end

