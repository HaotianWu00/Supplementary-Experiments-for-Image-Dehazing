function num = showHist(I,fignum)
    a = imhist(I(:,:,1));
    b = imhist(I(:,:,2));
    c = imhist(I(:,:,3));
%     for i = 1:256
%         if mod(i,2) == 1
%             a(i,1) = a(i,1) / 2;
%             b(i,1) = b(i,1) / 2;
%             c(i,1) = c(i,1) / 2;
%         end
%     end
    x = linspace(0,1,256);
    figure(fignum*2-1)
    imshow(I)
    figure(fignum*2)
    plot(x, a, 'Color','red')
    hold on
    plot(x,b,'Color','green')
    hold on
    plot(x,c,'Color','blue')
    hold off
end

