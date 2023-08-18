clear all;
close all;
clc;

imagedir = '.\p1\';
outputdir = '.\res2\';

roi_ratio = 2;

windowLoc = [300,54];
windowSize = [220,40];
% img2 = drawRectangleFrame(imagedir,outputdir,windowLoc,[30,40]);
x = windowLoc(1);
y = windowLoc(2);
width = windowSize(1);
height = windowSize(2);

imagepsearch = strcat(imagedir,'*.png')
imagelist = dir(imagepsearch);

len = length(imagelist);

for i = 1:len
    file_name{i}=imagelist(i).name;
    image = imread(strcat(imagedir,file_name{i}));
    
    [rows,cols,depth] = size(image);
    
    img_crop = imcrop(image,[x,y,width,height]);
    img_crop=imresize(img_crop,roi_ratio,'nearest');  %最近邻放大2倍
    
    star_x = size(image,1)-size(img_crop,1)+1;  %指定横轴起始位置
    star_y = size(image,2)-size(img_crop,2)+1;  %指定纵轴起始位置
    
%     image(star_x:end,star_y:end,:) = img_crop;  %按指定坐标位置开始将裁剪得图粘贴到image图上
    
    figure(1)
    set (gcf,'Position',[800,800,cols,rows]);
    imshow(image,'border','tight','initialmagnification','fit');
    hold on
%     rectangle('Position',[x,y,width,height],'LineWidth',2,'EdgeColor','b');%给原截取区域框出来
    hold on
    rectangle('Position',[200,280,300,150],'LineWidth',2,'EdgeColor','r');%给原截取区域框出来
    hold on    
%     rectangle('Position',[star_y,star_x,roi_ratio*width,roi_ratio*height],'LineWidth',2,'EdgeColor','b');%给新放置区域框出来
    
    %取出figue里面得图，转换为图片格式进行保存
    frame=getframe(gcf);
    result=frame2im(frame);       
    imwrite(result,strcat(outputdir,file_name{i}));
end

