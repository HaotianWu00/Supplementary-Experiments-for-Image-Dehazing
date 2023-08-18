clc;clear all;close all;
x = linspace(1,90,90);
data = readtable('VIF.xlsx','Range','A2:J91','ReadVariableNames',false);
y1 = table2array(data(:,1));
y2 = table2array(data(:,2));
y3 = table2array(data(:,3));
y4 = table2array(data(:,4));
y5 = table2array(data(:,5));
y6 = table2array(data(:,6));
y7 = table2array(data(:,7));
y8 = table2array(data(:,8));
y9 = table2array(data(:,9));
y10 = table2array(data(:,10));
figure(1)
l1=plot(x,y8,'Marker','v', 'LineWidth',1.5,'Color','#77AC30');
hold on
l2=plot(x,y4,'Marker','hexagram', 'LineWidth',1.5,'Color','m');
hold on
l3=plot(x,y9,'Marker','pentagram', 'LineWidth',4,'Color','r');
hold on
l4=plot(x,y1,'Marker','+', 'LineWidth',1.5,'Color','#D95319');
hold on
l5=plot(x,y2,'Marker','o', 'LineWidth',1.5,'Color','b');
hold on
l6=plot(x,y5,'Marker','x', 'LineWidth',1.5,'Color','#A2142F');
hold on
l7=plot(x,y7,'Marker','diamond', 'LineWidth',1.5,'Color','#7E2F8E');
hold on
l8=plot(x,y6,'Marker','square', 'LineWidth',1.5,'Color','#FBC116');
hold on
l9=plot(x,y3,'Marker','*', 'LineWidth',1.5,'Color','#08B593');
hold on
l10=plot(x,y10,'Marker','>', 'LineWidth',1.5,'Color','k');
set(gca,'child',[l3 l1 l2 l4 l5 l6 l7 l8 l9 l10])
ylim([0,1.4])
ylabel('PSNR');
xlabel('Image Sequences')
set(gca,'FontSize',30,'FontName','Times New Roman')
% legend({'NLP:0.5739','CEEF:0.5639','Ours:0.5409','AMEF:0.5248','BCCR:0.5139'...
%     'DCP:0.4978','MSCNN:0.4708','DehazeNet:0.4618','CAP:0.4154','None:0.3739'})
hold off