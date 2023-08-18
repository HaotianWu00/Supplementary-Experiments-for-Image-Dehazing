clc;clear all; close all;

InputPath = '.\source\';
FileName = dir(strcat(InputPath, '*.PNG'));
TextName = dir(strcat(InputPath, '*.txt'));
r = [2,4,8];
sig = [0.1,0.2,0.4];
den = zeros(12,1);
num = 1;
F = 0;
for i = 1:3
    for j = 1:3
        for k=1:length(FileName)
            tempFileName = FileName(k).name;
            tempTextName = TextName(k).name;
            ImPath = strcat(InputPath, tempFileName);
            TextPath = strcat(InputPath, tempTextName);
        
            temptext = importdata(TextPath);
            dsize = temptext(1);
            
            I_hazy = imread(ImPath);
            res = MVMEF(I_hazy,dsize,r(i),sig(j));
            imwrite(res, ['.\res1\', tempFileName(1:end-4), '.png',]);
            ll = FADE_deim(['.\res1\', tempFileName(1:end-4), '.png',]);
            F = F + real(ll);
        end
        den(num) = F / 30;
        num = num + 1;
    end
end
   
